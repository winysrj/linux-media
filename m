Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:45945 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbZK0XT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 18:19:27 -0500
Subject: Re: Compile error saa7134 - compro videomate S350
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <8049.95935.qm@web110610.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>
	 <1259025174.5511.24.camel@pc07.localdom.local>
	 <990417.69725.qm@web110607.mail.gq1.yahoo.com>
	 <1259107698.2535.10.camel@localhost>
	 <623705.13034.qm@web110608.mail.gq1.yahoo.com>
	 <1259172867.3335.7.camel@pc07.localdom.local>
	 <214960.24182.qm@web110609.mail.gq1.yahoo.com>
	 <1259360050.6061.22.camel@pc07.localdom.local>
	 <8049.95935.qm@web110610.mail.gq1.yahoo.com>
Content-Type: text/plain
Date: Sat, 28 Nov 2009 00:14:47 +0100
Message-Id: <1259363687.6061.45.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dominic,

Am Freitag, den 27.11.2009, 14:59 -0800 schrieb Dominic Fernandes:
> hi,
> 
> where does  "options saa7134 alsa=0" need to be declared?  Is it in /etc/modprobe.d/options.conf ?  If so, it didn't work - "FATAL: saa7134-alsa is in use"

yes, you can only unload saa7134-alsa after you close all apps using it.

It is very distribution depending and I'm not aware of all, where to put
options.

If it doesn't work for options.conf, it should still work with a
recently deprecated declared /etc/modprobe.conf file you have to create
as a work around for all distros.

You must issue a "depmod -a" after that and reboot, if you don't know
how to unload saa7134-alsa by closing all apps using it.

A "modprobe -vr saa7134-alsa saa7134-dvb" and then load it with
"modprobe -v saa7134 card=169 gpio_tracking=1" should still reveal
something configured in the system overriding your command line with
card=169.

I'm not on latest here ...

Cheers,
Hermann


