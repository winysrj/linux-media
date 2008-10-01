Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yellowplantain@gmail.com>) id 1KkzqB-0004tK-G6
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 13:26:00 +0200
Received: by rv-out-0506.google.com with SMTP id b25so439212rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 01 Oct 2008 04:25:52 -0700 (PDT)
Message-ID: <48E35E38.9040909@gmail.com>
Date: Wed, 01 Oct 2008 20:55:44 +0930
From: Plantain <yellowplantain@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Support for Leadtek DTV1000S ?
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

Hey,

I've luckily come across a Leadtek DTV1000S that I'd like to get working
under Linux!

>From reading the Leadtek specifications
(http://leadtek.com/eng/tv_tuner/specification.asp?pronameid=382&lineid=6&act=2),
I now understand it has contained within it the following chips;
NXP 18271
TDA10048
SAA7130
>From what I can see, all of these chips are supported by one driver or
another in some shape or form, but I've still been unable to get my card
to work.

I'm guessing I have two issues here, 1) Card not being identified by
saa7134 driver, and 2) No firmware for the tda10048
As for 1), I'm not sure how best to find the correct card= to feed into
the modprobe (i2c_scan doesn't seem to do anything useful), although I
remember there used to be a bash script that would try every value and
then check for the existence of /dev/dvb/? If anyone has a copy of that
script, I'd greatly appreciate if you could point me towards it!

2) seems a little trickier, I've found that the Windows XP 64-bit driver
install at the link below has .sys files within it, which should contain
the necessary firmware? If anyone has experience extracting the
firmware, I'd be most appreciative! Driver:
http://leadtek.com/eng/tv_tuner/download.asp?downlineid=207&pronameid=382&lineid=6&act=3

I'm keen to help get this card working, so if anyone is especially
curious I can offer you ssh to Linux/rdp to Windows.

Cheers,

~Plantain~

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
