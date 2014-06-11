Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52836 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaFKLVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:21:38 -0400
Message-ID: <1402485696.4107.107.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:21:36 +0200
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Hi all,
> 
> This patch set adds video capture support for the Freescale i.MX6 SOC.
>
> It is a from-scratch standardized driver that works with community
> v4l2 utilities, such as v4l2-ctl, v4l2-cap, and the v4l2src gstreamer
> plugin. It uses the latest v4l2 interfaces (subdev, videobuf2).
> Please see Documentation/video4linux/mx6_camera.txt for it's full list
> of features!

That's quite a series to digest! I'll quickly go over the points that
jumped at me and then look at the core code (especially 08/43 and 39/43)
in detail.

> The first 38 patches:
> 
> - prepare the ipu-v3 driver for video capture support. The current driver
>   contains only video display functionality to support the imx DRM drivers.
>   At some point ipu-v3 should be moved out from under staging/imx-drm since
>   it will no longer only support DRM.

The move out of staging is now merged into drm-next with
c1a6e9fe82b46159af8cc4cf34fb51ee47862f05.
After this is merged into mainline, there should be no need to push i.MX
capture support through staging. It would be helpful if you could rebase
on top of that.

> - Adds the device tree nodes and OF graph bindings for video capture support
>   on sabrelite, sabresd, and sabreauto reference platforms.

I disagree with the way you organized the device tree, I'll comment in
the relevant patches.

> The new i.MX6 capture host interface driver is at patch 39.
> 
> To support the sensors found on the sabrelite, sabresd, and sabreauto,
> three patches add sensor subdev's for parallel OV5642, MIPI CSI-2 OV5640,
> and the ADV7180 decoder chip, beginning at patch 40.

Please don't introduce i.MX6-only sensor drivers. Those should live
under drivers/media/i2c and not be i.MX specific.

regards
Philipp

