Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <JuergenUrban@gmx.de>) id 1MIROV-000636-Je
	for linux-dvb@linuxtv.org; Sun, 21 Jun 2009 20:03:56 +0200
From: Juergen Urban <JuergenUrban@gmx.de>
To: LinuxTv <linux-dvb@linuxtv.org>
Date: Sun, 21 Jun 2009 20:02:55 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906212002.55867.JuergenUrban@gmx.de>
Subject: [linux-dvb] @Sky Pilot, Neotion Pilot, Checksum hacking
Reply-To: linux-media@vger.kernel.org
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

Hello,

I didn't find a DVB-S driver for the Neotion Pilot (aka @Sky Pilot with 
@SkyChip, USB v1.0), so I decided to write it on my own. In my german blog 
http://satfreak.blog.de/ I write something about the reverse engineering 
process. Now I've a problem with the 1-byte-checksum calculation. Each message 
which I send to the device has a checksum (last byte). I don't know how to 
calculate the checksum.
Did someone know how to reverse engineer a 1-byte-checksum?
Did someone see these type of messages before?
Did someone detect any algorithm in the checksum values?

Here are examples:

static unsigned char ep03_msg109[] = {
	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
	0x01, 0xd0, 0x1e, 0x01, 0x00,
	0xca /* Checksum */
};

static unsigned char ep03_msg110[] = {
	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
	0x01, 0xd0, 0x1f, 0x01, 0x00,
	0xcb /* Checksum */
};

In the above example the checksum is incremented by one and there is also one 
byte incremented by one in the payload (0x1e -> 0x1f and 0xca -> 0xcb). this 
seems to be a simple addition.

static unsigned char ep03_msg111[] = {
	0x81, 0x05, 0x01, 0x00, 0x02, 0x01, 0x06, 0x00,
	0x01, 0xd0, 0x20, 0x01, 0x00,
	0xf4 /* Checksum */
};

In the next example the byte is further incremented, but the checksum changes 
much more (0x1f -> 0x20 and 0xcb -> 0xf4).

The device doesn't respond to a message with the wrong checksum. I used this 
to try all values until I found the correct one, but this needs some seconds. 
This behaviour will not be acceptable within a DVB driver.

Much more examples are in my test code which currently uses libusb-1.0:
http://www.pastie.org/519407

Best regards
Juergen Urban

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
