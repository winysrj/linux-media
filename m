Return-path: <linux-media-owner@vger.kernel.org>
Received: from sneak2.sneakemail.com ([38.113.6.65]:58438 "HELO
	sneak2.sneakemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753475Ab0DLUVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 16:21:55 -0400
Message-ID: <17821-1271103314-44442@sneakemail.com>
From: dngtk92hx9@snkmail.com
Date: Mon, 12 Apr 2010 20:15:13 +0000
To: linux-media@vger.kernel.org
Subject: nxt2004 broken in latest kernel release
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a pair of K-World ATSC 115 cards for my mythtv setup.  They've worked without any problems for the last 2 years.  My system uses Archlinux.  Roughly a month ago, an upgrade to kernel 2.6.32.10 caused problems in which nxt200x doesn't initialize properly some of the time (no firmware getting downloaded), and thus there's no /dev/dvb directory getting created.  I believe each card succeeds randomly about 1/3 of the time, so that came out to about 9 reboots to get both cards initialized properly.  After that it worked fine.

However, when I upgraded to 2.6.33.2 a couple of days ago, I got the same error messages, but the probability of getting a success firmware download is like 1 in 10.  I haven't succeeded in getting both cards initialized at the same time.  Furthermore, even though I can get one of the cards to initialize (seeing /dev/dvb/adapter0), it doesn't function.  Tuner says locked but never returns a picture in mythtv.

Here's the information when I do a lspci:

03:06.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
03:07.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)

This is the error from dmesg when init fails on a card:

nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err == -5)
Unknown/Unsupported NXT chip: 00 00 00 00 00
saa7133[0]/dvb: frontend initialization failed

Here's the message from a "successful" init (from error log since dmesg gets spammed with errors after it):

Apr 10 13:00:19 ruyi kernel: nxt200x: NXT2004 Detected
Apr 10 13:00:19 ruyi kernel: nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
Apr 10 13:00:19 ruyi kernel: saa7134 0000:03:06.0: firmware: requesting dvb-fe-nxt2004.fw
Apr 10 13:00:19 ruyi kernel: nxt2004: Waiting for firmware upload(2)...
Apr 10 13:00:19 ruyi kernel: nxt2004: Firmware upload complete
Apr 10 13:00:19 ruyi kernel: nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err == -5)
Apr 10 13:00:19 ruyi kernel: nxt200x: nxt200x_writebytes: i2c write error (addr 0x0a, err == -5)
Apr 10 13:00:19 ruyi kernel: nxt200x: nxt200x_writebytes: i2c write error (addr 0x0a, err == -5)
Apr 10 13:00:19 ruyi kernel: nxt200x: nxt200x_writebytes: i2c write error (addr 0x0a, err == -5)
Apr 10 13:00:19 ruyi kernel: nxt200x: nxt200x_writebytes: i2c write error (addr 0x0a, err == -5)
Apr 10 13:00:19 ruyi kernel: nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err == -5)
Apr 10 13:00:19 ruyi kernel: nxt200x: Error writing multireg register 0x80

Then when I tried to tune to a channel it just spams the following error in dmesg forever while no picture gets shown:

nxt200x: i2c_readbytes: i2c read error (addr 0x61, err == -5)
nxt200x: Timeout waiting for nxt2004 to init.
nxt200x: i2c_writebytes: i2c write error (addr 0x61, err == -5)
nxt200x: error writing to tuner

Please let me know if you want any additional logs.  thanks

Ben
