Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2516.carrierzone.com ([64.29.147.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxdreas@launchnet.com>) id 1Jj9u1-0002e1-07
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 11:14:07 +0200
Received: from hal9001 (208-201-228-169.adsl.dynamic.launchnet.com
	[208.201.228.169] (may be forged)) (authenticated bits=0)
	by mail2516.carrierzone.com (8.13.6.20060614/8.13.1) with ESMTP id
	m389Dn53001139
	for <linux-dvb@linuxtv.org>; Tue, 8 Apr 2008 09:13:55 GMT
From: Andreas <linuxdreas@launchnet.com>
To: linux-dvb@linuxtv.org
Date: Tue, 8 Apr 2008 02:13:26 -0700
References: <200803292240.25719.janne-dvb@grunau.be>
	<200803302017.49799.janne-dvb@grunau.be>
	<200804081030.04745.janne-dvb@grunau.be>
In-Reply-To: <200804081030.04745.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804080213.26671.linuxdreas@launchnet.com>
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Am Dienstag, 08. April 2008 01:30:04 schrieb Janne Grunau:
> ping.

pong

> Any interest in this change? Anything speaking against merging this
> except the potential duplication of udev functinality?

Janne, I have no clue at all how a udev rule can be written that reflects =

the structure of adapter[n]/frontend[n]. And if Google is any indicator, =

this is either not possible or it is a lost art. Speaking as a user of =

mythtv & subsequently the linux dvb drivers, I would like to see this patch =

integrated rather sooner than later.

Thanks for creating the patch!

-- =

Gru=DF
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
