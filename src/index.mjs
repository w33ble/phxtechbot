import dotenv from 'dotenv';
import Client from 'emiirc';
import loginAndJoin from 'emiirc/src/plugins/login-join.mjs';
import reconnect from 'emiirc/src/plugins/reconnect.mjs';
import logger from './lib/logger.mjs';

dotenv.config();

const { NICK, USERNAME, PASSWORD, CHANNELS } = process.env;
const client = new Client('irc.freenode.net', 6667, {
  nick: NICK,
  username: USERNAME,
  pass: PASSWORD,
});

client.use(loginAndJoin(CHANNELS.split(',')));
client.use(reconnect());

// client.on('data', d => logger.log(`> ${d}`));

client.on('join', ({ room }) => {
  if (room === '#phxtech') logger.log('phxtech joined');
});

client.connect();

export default null;
