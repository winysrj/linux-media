Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3607 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbZB0HVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 02:21:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Conversion of vino driver for SGI to not use the legacy decoder API
Date: Fri, 27 Feb 2009 08:19:17 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
References: <20090226214742.6576f30b@pedra.chehab.org>
In-Reply-To: <20090226214742.6576f30b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902270819.17862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 February 2009 01:47:42 Mauro Carvalho Chehab wrote:
> After the conversion of Zoran driver to V4L2, now almost all drivers are
> using the new API. However, there are is one remaining driver using the
> video_decoder.h API (based on V4L1 API) for message exchange between the
> bridge driver and the i2c sensor: the vino driver.
>
> This driver adds support for the Indy webcam and for a capture hardware
> on SGI. Does someone have those hardware? If so, are you interested on
> helping to convert those drivers to fully use V4L2 API?
>
> The SGI driver is located at:
> 	drivers/media/video/vino.c
>
> Due to vino, those two drivers are also using the old API:
> 	drivers/media/video/indycam.c
> 	drivers/media/video/saa7191.c
>
> It shouldn't be hard to convert those files to use the proper APIs, but
> AFAIK none of the current active developers has any hardware for testing
> it.

The conversion has already been done in my v4l-dvb-vino tree. I'm trying to 
convince the original vino author to boot up his Indy and test it, but he 
is not very interested in doing that. I'll ask him a few more times, but we 
may have to just merge my code untested. Or perhaps just drop it.

Jean, I remember you mentioning that you wouldn't mind if the i2c-algo-sgi 
code could be dropped which is only used by vino. How important is that to 
you? Perhaps we are flogging a dead horse here and we should just let this 
driver die.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
