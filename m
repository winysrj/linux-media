Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:54320 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaAHMBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 07:01:16 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ300K0S0227Q60@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 07:01:14 -0500 (EST)
Date: Wed, 08 Jan 2014 10:01:10 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: cron job: media_tree daily build: ERRORS
Message-id: <20140108100110.7e8bebcc@samsung.com>
In-reply-to: <52CD3C15.80501@xs4all.nl>
References: <20140108033307.C683A2A009A@tschai.lan>
 <52CD32E2.5030805@xs4all.nl> <52CD3C15.80501@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 08 Jan 2014 12:52:53 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 01/08/2014 12:13 PM, Hans Verkuil wrote:
> > Hi Mauro,
> > 
> > The daily build fails when building v4l-utils:
> > 
> > apps: ERRORS
> > ../../lib/include/descriptors/vct.h:28:37: fatal error: descriptors/atsc_header.h: No such file or directory
> > make[3]: *** [libdvbv5_la-dvb-file.lo] Error 1
> > make[2]: *** [all-recursive] Error 1
> > make[1]: *** [all-recursive] Error 1
> > make: *** [all] Error 2
> > 
> > Apparently you forgot to push a header...
> 
> Ah, it compiles again. Thanks!

It was actually due to some rejected patches. Anyway, it is now fixed.

Regards,
Mauro
