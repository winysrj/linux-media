Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JqyEf-0007zS-NM
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 00:23:42 +0200
Received: from mail-in-02-z2.arcor-online.net (mail-in-02-z2.arcor-online.net
	[151.189.8.14])
	by mail-in-03.arcor-online.net (Postfix) with ESMTP id 6C8ED2CACC6
	for <linux-dvb@linuxtv.org>; Wed, 30 Apr 2008 00:23:36 +0200 (CEST)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mail-in-02-z2.arcor-online.net (Postfix) with ESMTP id 5E9701137B5
	for <linux-dvb@linuxtv.org>; Wed, 30 Apr 2008 00:23:36 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id DD0B636E868
	for <linux-dvb@linuxtv.org>; Wed, 30 Apr 2008 00:23:35 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <2d842fa80804291436t4464065bycb5b8d3b6b8dc19f@mail.gmail.com>
References: <2d842fa80804282201h5665c596q4048d1f58fdaab5f@mail.gmail.com>
	<1209499089.3456.34.camel@pc10.localdom.local>
	<2d842fa80804291436t4464065bycb5b8d3b6b8dc19f@mail.gmail.com>
Date: Wed, 30 Apr 2008 00:22:03 +0200
Message-Id: <1209507723.3456.90.camel@pc10.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] saa7146_vv.ko and dvb-ttpci.ko undefined
	with	kernel 2.6.23.17
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


Am Dienstag, den 29.04.2008, 23:36 +0200 schrieb Stone:
> Thanks for the confirmation.  Would you happen to know which file to
> edit so that I can add such missing dependencies (ie;
> videobuf-dma-sg)?  It seems like it should be a one line fix.  I would
> build "all" but my machine is so slow, it really drags on.  There must
> be an easier way.
> 

[snip]
>         If you enable for example saa7134 support under video you should get the
>         missing videobuf* modules too until the build dependencies are working
>         for saa7146 again?

Either try that or go a little back before saa7146 is moved
to /media/video from /media/common.

It might be also already fixed or will be soon.
The build system is quickly moving due to get some tuner bugs away
before the 2.6.26 merge window is closed.

Cheers,
Hermann






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
