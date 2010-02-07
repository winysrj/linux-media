Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:50865 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab0BGSKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 13:10:20 -0500
Received: by fxm3 with SMTP id 3so6559399fxm.39
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2010 10:10:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265556597.2424.26.camel@brian.bconsult.de>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <4B6C88AD.4010708@redhat.com>
	 <1265409155.2692.61.camel@brian.bconsult.de>
	 <1265411523.4064.23.camel@localhost>
	 <1265413149.2063.20.camel@brian.bconsult.de>
	 <1265415910.2558.17.camel@localhost>
	 <1265446554.1733.36.camel@brian.bconsult.de>
	 <1265515083.2666.139.camel@localhost>
	 <1265553812.3063.22.camel@palomino.walls.org>
	 <1265556597.2424.26.camel@brian.bconsult.de>
Date: Sun, 7 Feb 2010 19:10:18 +0100
Message-ID: <846899811002071010w4e0e7b7frd423e6574b26e3f0@mail.gmail.com>
Subject: Re: "However, if you don't want to lose your freedom, you had better
	not follow him." (Re: Videotext application crashes the kernel due to
	DVB-demux patch)
From: HoP <jpetrous@gmail.com>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Andy Walls <awalls@radix.net>,
	Francesco Lavra <francescolavra@interfree.it>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chicken,

>
> However I am still alone with the other problem I always stressed:
>
> When using alevt-dvb (I attached my overworked version 1.7.0 in earlier
> mails - please do have a look at it!) the application hangs when you
> decide to switch to a channel that is part of a new transponder.
> The program hangs then. That means the way alevt-dvb is dealing with the
> PMT (program map table) is highly incomplete.
> It needs a reset function to read the new PMT when the transponder is
> being changed...
>

If you tell me which application is managing channel zaping function
then we can try to find way how to signal that to alevt-dvb.

> I do not know how to program that simple reset function. But I know that
> thsi is the definite key to resolve the issue.
> PMT reading, PMT opening, PMT parsing.......
> Everything is already inside of the source code of alevt-dvb.
>

In case, if more then one DVB application is running, one is something
like "master" (which do frontend operation, ie. channel change)
and rest are slaves. So master has to signal channel/transponder change
to the all slaves. Typically, it is done by some custom specific way.
For example master can open some well-known unix socket
where all slaves are connecting and where, in case of channel change,
is sent (by master) some info about such event.

Cheers

/Honza
