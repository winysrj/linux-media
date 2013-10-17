Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58755 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3JQNKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 09:10:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/6] v4l: omap4iss: Add support for OMAP4 camera interface - Core
Date: Thu, 17 Oct 2013 15:10:32 +0200
Message-ID: <22658506.hDujbKj41r@avalon>
In-Reply-To: <20131017094857.3e97b9b1@samsung.com>
References: <1380758133-16866-1-git-send-email-laurent.pinchart@ideasonboard.com> <1380758133-16866-2-git-send-email-laurent.pinchart@ideasonboard.com> <20131017094857.3e97b9b1@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 17 October 2013 09:48:57 Mauro Carvalho Chehab wrote:
> Em Thu,  3 Oct 2013 01:55:28 +0200 Laurent Pinchart escreveu:
> > From: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> > 
> > This adds a very simplistic driver to utilize the CSI2A interface inside
> > the ISS subsystem in OMAP4, and dump the data to memory.
> > 
> > Check Documentation/video4linux/omap4_camera.txt for details.
> > 
> > This commit adds the driver core, registers definitions and
> > documentation.
> > 
> > Signed-off-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> > 
> > [Port the driver to v3.12-rc3, including the following changes
> > - Don't include plat/ headers
> > - Don't use cpu_is_omap44xx() macro
> > - Don't depend on EXPERIMENTAL
> > - Fix s_crop operation prototype
> > - Update link_notify prototype
> > - Rename media_entity_remote_source to media_entity_remote_pad]
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Checkpatch has a few compliants on the version that it is on your pull
> request:

[snip]

> WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...
>  to printk(KERN_ERR ... #1240: FILE:
> drivers/staging/media/omap4iss/iss.c:1126:
> +		printk(KERN_ERR "%s: Media device registration failed (%d)\n",

No, I won't rewrite the driver as a net device ;-)

[snip]

> The 80-cols warnings above seem just bogus, as fixing them on this specific
> case would produce a worse to read code, but the other warnings make some
> sense on my eyes.
> 
> Care to address them or to justify why to not address them?
> 
> Also, both Hans and Sakari's comments on this patch seem pertinent.
> 
> Could you please either add some extra patches to this series addressing
> the pointed issues or to send another git pull request considering
> those?

I plan to fix all that in extra patches (I believe that keeping the driver 
history is interesting, so I'd like to avoid squashing the fixes into these 
patches) for v3.14 (the v3.13 merge window is just too close).

Given that the driver goes to staging first, would it be a problem to take it 
as-is for v3.13 if I commit to fix the problems in the very near future ? I've 
been made aware of quite a lot of interest on the OMAP4 ISS lately, and I'd 
like to get the driver to mainline without much delay to let people contribute 
(if they can and want obviously).

-- 
Regards,

Laurent Pinchart

