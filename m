Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33000 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946154AbcBTBBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 20:01:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR v4.6] VSP1 patches
Date: Sat, 20 Feb 2016 03:01:40 +0200
Message-ID: <1705142.Ib2LSJfThZ@avalon>
In-Reply-To: <20160219095216.104eeccf@recife.lan>
References: <4317918.v13nm0kyWH@avalon> <20160219095216.104eeccf@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 19 February 2016 09:52:16 Mauro Carvalho Chehab wrote:
> Em Wed, 10 Feb 2016 22:55:27 +0200 Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > The following changes since commit 
85e91f80cfc6c626f9afe1a4ca66447b8fd74315:
> >   Merge tag 'v4.5-rc3' into patchwork (2016-02-09 08:56:42 -0200)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/media.git vsp1/next
> > 
> > for you to fetch changes up to 94889923211c7d2fa9d46762c7636f43820a1692:
> >   v4l: vsp1: Configure device based on IP version (2016-02-10 15:38:11
> >   +0200)
> 
> Thanks, patches reviewed, tested and merged.
>
> However, as we mentioned on IRC, this driver doesn't pass at the
> v4l2-compliance, as it doesn't implement the mandatory
> VIDIOC_ENUM_FMT ioctl, causing it to not work properly with tools like
> v4l2-ctl and qv4l2.
> 
> Please fix it on a later patch.

Given that the pixel formats supported by the driver don't depend on subdev 
pad configuration, ENUM_FMT could make sense. I'll see what I can do.

> > Could you please merge this in a stable branch that will be sent to Linus
> > as- is for v4.6 ? I have a series of DRM/KMS driver patches that depend
> > on this patch set and want to get them merged in v4.6 as well.
> > 
> > All patches have been previously sent to the linux-media mailing list, and
> > most included in the same pull request you've rejected for v4.5 as it
> > conflicted with your work-in-progress media controller changes.
> 
> You can pass the branch "vsp1" to Daniel for it to base the DRM/KMS driver
> patches.

Thank you.

-- 
Regards,

Laurent Pinchart

