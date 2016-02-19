Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58431 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423726AbcBSLwW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 06:52:22 -0500
Date: Fri, 19 Feb 2016 09:52:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR v4.6] VSP1 patches
Message-ID: <20160219095216.104eeccf@recife.lan>
In-Reply-To: <4317918.v13nm0kyWH@avalon>
References: <4317918.v13nm0kyWH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Em Wed, 10 Feb 2016 22:55:27 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> The following changes since commit 85e91f80cfc6c626f9afe1a4ca66447b8fd74315:
> 
>   Merge tag 'v4.5-rc3' into patchwork (2016-02-09 08:56:42 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/pinchartl/media.git vsp1/next
> 
> for you to fetch changes up to 94889923211c7d2fa9d46762c7636f43820a1692:
> 
>   v4l: vsp1: Configure device based on IP version (2016-02-10 15:38:11 +0200)

Thanks, patches reviewed, tested and merged.

However, as we mentioned on IRC, this driver doesn't pass at the
v4l2-compliance, as it doesn't implement the mandatory
VIDIOC_ENUM_FMT ioctl, causing it to not work properly with tools like
v4l2-ctl and qv4l2.

Please fix it on a later patch.

> Could you please merge this in a stable branch that will be sent to Linus as-
> is for v4.6 ? I have a series of DRM/KMS driver patches that depend on this 
> patch set and want to get them merged in v4.6 as well.
> 
> All patches have been previously sent to the linux-media mailing list, and 
> most included in the same pull request you've rejected for v4.5 as it 
> conflicted with your work-in-progress media controller changes.

You can pass the branch "vsp1" to Daniel for it to base the DRM/KMS driver
patches.

Regards,
Mauro
-- 
Thanks,
Mauro
