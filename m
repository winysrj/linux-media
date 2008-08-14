Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web62002.mail.re1.yahoo.com ([69.147.74.225])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <mpapet@yahoo.com>) id 1KTeiA-000486-C7
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 17:26:03 +0200
Date: Thu, 14 Aug 2008 08:25:26 -0700 (PDT)
From: Michael Papet <mpapet@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <673435.42598.qm@web62002.mail.re1.yahoo.com>
Subject: [linux-dvb] Cx18 hvr-1600 Update
Reply-To: mpapet@yahoo.com
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

Hi,

I'm one of the troubled cx18/hvr-1600 owners with an update.  After some fiddling around, I've come up with a way to get the card to load every time in Debian Etch and a 2.6.25 kernel.

1. blacklist cx18
2. If my modprobe-fu were better then I'm pretty sure there's a more elegant way of doing this.  /etc/rc.local contains the following stanzas.  The order is very important.

modprobe tveeprom
modprobe compat_ioctl32
modprobe firmware_class
modprobe dvb-core
modprobe cx18

At this time, US OTA HDTV is perfect.  Audio on regular TV has some very annoying white noise mixed in with the audio with a perfect picture.  Any suggestions about where to begin addressing the noise issue are welcome.



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
