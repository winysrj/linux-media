Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <stefan.gehrer@gmx.de>) id 1KvFyG-00010l-G0
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 19:40:45 +0100
Message-ID: <4908ADFD.6040502@gmx.de>
Date: Wed, 29 Oct 2008 19:39:57 +0100
From: Stefan Gehrer <stefan.gehrer@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Key map for new remote control that came with Terratec
 Cinergy T USB XXS
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

I recently bought a Terratec Cinergy T USB XXS device
and found that the remote control doesn't work correctly
with kernel 2.7.27, so I had to make the below key table
to get it to work.
In function dib0700_rc_query() in file dib0700_devices.c,
I then activate this keymap with

     if(dvb_usb_dib0700_ir_proto == 1)
         keymap = xxs_new_rc_keys;

Something like this is necessary as otherwise key codes
overlap with the key table already in the driver.
But if other remotes also have dvb_usb_dib0700_ir_proto
equal to one this is obviously a problem.
Please advise me if you need any further information
for getting support for that remote into the driver.

And one small problem my approach currently has:
I see neither key repeats nor a key release, so there
is no way to register long presses. So maybe some more
changes are required for proper support.

Best regards
Stefan Gehrer

static struct dvb_usb_rc_key xxs_new_rc_keys[] = {
     { 0x0f, 0x7e, KEY_POWER },
     { 0x07, 0x7c, KEY_1 },
     { 0x08, 0x40, KEY_2 },
     { 0x03, 0x7d, KEY_3 },
     { 0x0c, 0x41, KEY_4 },
     { 0x04, 0x43, KEY_5 },
     { 0x0b, 0x7f, KEY_6 },
     { 0x01, 0x7d, KEY_7 },
     { 0x0e, 0x41, KEY_8 },
     { 0x06, 0x43, KEY_9 },
     { 0x02, 0x42, KEY_0 },
     { 0x0f, 0x71, KEY_HOME },
     { 0x07, 0x73, KEY_MENU }, /* DVD Menu */
     { 0x08, 0x4f, KEY_SUBTITLE },
     { 0x03, 0x72, KEY_TEXT }, /* Teletext */
     { 0x0c, 0x4e, KEY_DELETE },
     { 0x04, 0x4c, KEY_TV },
     { 0x0b, 0x70, KEY_DVD },
     { 0x0e, 0x4e, KEY_VIDEO },
     { 0x06, 0x4c, KEY_AUDIO }, /* Music */
     { 0x09, 0x700, KEY_SCREEN }, /* Pic */
     { 0x00, 0x7d, KEY_UP },
     { 0x0f, 0x41, KEY_LEFT },
     { 0x07, 0x43, KEY_OK },
     { 0x08, 0x7f, KEY_RIGHT },
     { 0x03, 0x42, KEY_DOWN },
     { 0x0a, 0x40, KEY_EPG },
     { 0x04, 0x7c, KEY_INFO },
     { 0x0d, 0x71, KEY_BACK },
     { 0x02, 0x7d, KEY_VOLUMEUP },
     { 0x05, 0x43, KEY_VOLUMEDOWN },
     { 0x02, 0x4d, KEY_PLAY },
     { 0x0d, 0x41, KEY_MUTE },
     { 0x09, 0x40, KEY_CHANNELUP },
     { 0x0a, 0x7f, KEY_CHANNELDOWN },
     { 0x0b, 0x40, KEY_RED },
     { 0x01, 0x42, KEY_GREEN },
     { 0x0e, 0x7e, KEY_YELLOW },
     { 0x06, 0x7c, KEY_BLUE },
     { 0x01, 0x4d, KEY_RECORD },
     { 0x01, 0x72, KEY_STOP },
     { 0x00, 0x4d, KEY_PAUSE },
     { 0x03, 0x4d, KEY_LAST },
     { 0x05, 0x73, KEY_REWIND },
     { 0x0a, 0x4f, KEY_FASTFORWARD },
     { 0x02, 0x72, KEY_NEXT }
};

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
