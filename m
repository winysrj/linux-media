Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44341 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbcEGP1n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2016 11:27:43 -0400
Date: Sat, 7 May 2016 12:27:37 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 0/2] Prepare for cdev fixes
Message-ID: <20160507122737.08c78599@recife.lan>
In-Reply-To: <cover.1462633500.git.mchehab@osg.samsung.com>
References: <cover.1462633500.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 7 May 2016 12:12:07 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Those two patches are needed by Shuah's patch that fix use-after free troubles: 
> 	https://patchwork.linuxtv.org/patch/34201/
> 
> Those two patches were already sent  back on March, 23 but specially the second
> patch  would need more review.
> 
> So, resend it, in order to get some acks. My plan is to test them together with Shuah's
> patch on this Monday, and apply them as soon as possible, for the Kernel 4.7 merge
> window. Those patches should be c/c to stable, in order to fix for older Kernels.
> 
> Mauro Carvalho Chehab (2):
>   [media] media-devnode: fix namespace mess
>   [media] media-device: dynamically allocate struct media_devnode

In order to make easier for everyone to test, I applied the three
patches (Shuah's one, plus the two above) on this branch:
	https://git.linuxtv.org//mchehab/experimental.git/log/?h=media_cdev_fix

Shuah,

Please notice that some rebase was needed, as there were some other
patches fixing other stuff related with the MC that got applied
earlier.


> 
>  drivers/media/media-device.c           |  44 +++++++++----
>  drivers/media/media-devnode.c          | 115 +++++++++++++++++----------------
>  drivers/media/usb/au0828/au0828-core.c |   4 +-
>  drivers/media/usb/uvc/uvc_driver.c     |   2 +-
>  include/media/media-device.h           |   5 +-
>  include/media/media-devnode.h          |  27 +++++---
>  6 files changed, 113 insertions(+), 84 deletions(-)
> 


-- 
Thanks,
Mauro
