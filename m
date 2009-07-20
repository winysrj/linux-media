Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]
	helo=mail.internode.on.net)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <SRS0+pH7c+45+clarkson.id.au=rodd@internode.on.net>)
	id 1MSk3P-00032x-FC
	for linux-dvb@linuxtv.org; Mon, 20 Jul 2009 06:00:44 +0200
Received: from [192.168.1.5] (unverified [118.208.162.180])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	2508305-1927428
	for <linux-dvb@linuxtv.org>; Mon, 20 Jul 2009 13:30:29 +0930 (CST)
From: Rodd Clarkson <rodd@clarkson.id.au>
To: linux-dvb@linuxtv.org
Date: Mon, 20 Jul 2009 14:00:28 +1000
Message-Id: <1248062429.4416.33.camel@moose.localdomain>
Mime-Version: 1.0
Subject: [linux-dvb] Hauppauge Okemo-B / Siano Mobile Digital MDTV Receiver
 and sms1xxx-nova-b-dvbt-01.fw
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

Hi All

I recently acquired a Dell Studio XPS 16 laptop that comes equiped with
a TV tuner card which I would like to get working with Linux.

As a reference point, I'm using Fedora 11 and I live in Australia.

Looking in dmesg, it wants to load sms1xxx-nova-b-dvbt-01.fw, but I
don't have the file in  /lib/firmware

I've searched for it on google, but apart from some kernel patches (that
seem to help better identify the right firmware for the card) the only
page that seems to help (and it's in German, which I don't speak) is
this:

http://www.der-schnorz.de/?p=92

This page suggests renaming the sms1xxx-hcw-55xxx-dvbt-01.fw, which I've
tried, but with which I'm not having a lot of luck.

Initially in MythTV it detected the channels, but it never tuned into
channels and now won't even detect the channels.

Looking at the kernel source for Fedora 11, there's
driver/media/dvd/siano, but again, I don't think this is actual firmware
for the card.

I guess what I'm getting to is:

Is this card supported at this stage?
Where do I get the correct firmware from?

The www.siano-ms.com site seems to suggest they support Linux, but
there's no download pages and no search which makes finding firmware
hard.


Rodd


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
