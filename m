Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from killer.cirr.com ([192.67.63.5] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <afc@shibaya.lonestar.org>) id 1LMDpu-0002C0-Fk
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 04:51:36 +0100
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>) id 1LMDoj-00045F-Fi
	for linux-dvb@linuxtv.org; Sun, 11 Jan 2009 22:50:21 -0500
Date: Sun, 11 Jan 2009 22:50:21 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-dvb@linuxtv.org
Message-ID: <20090112035021.GA13897@shibaya.lonestar.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] OnAir creator seems to be recognized,
	but what device is what?
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

Hello again,

I've been trying to make the OnAir creator work.  So far it hasn't been
easy but I'm making some progress.  Pvrusb2 told me in the log file that
a firmware file was missing, so I went looking for it by name.  After
a convoluted procedure extracting windows-centric files and renaming the
proper one to v4l-cx2341x-enc.fw I put it in /lib/modules and did away with
the missing firware message.  Dvbusb2 seems to recognize the device ok.
In fact it seems to create

/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/net0

And I also see /dev/video0

But what do those devices represent?  Is /dev/video0 the analog tuner?
is /dev/dvb/adapter0/dvr0 the digital tuner?  What are the others?
I have been trying to configure mythtv but have no idea what to tell it
about this device.  The mythtv docs say that if you  have a card with 2
tuners, define it as a DVB.  But, mythtv-setup identifies it correcly
(by name) as an analog card /dev/video0, if I set it up as a DVB it claims
it is a DVICO or Air2PC or...  It does not seem to know about the /dev/dvb
devices.  Do I need to configure the OnAir Creator as 1 or 2 devices?

Can someone tell me a quick and easy way to test the device? maybe with
mplayer?  I have an analog camera connected to the composite input, so
even if I don't get any channels with the rabbit ears and loop antenna,
that should work as a test.

I have posted the higher level questions to the mythtv mailing list, but
no answers yet.  Any hints would be welcome.

A.


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
