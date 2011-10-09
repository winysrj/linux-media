Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53624 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1JIRU5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 13:20:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: [PATCH 0/2] Add support to ITU-R BT.656 video data format
Date: Sun, 9 Oct 2011 19:12:46 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>, linux-media@vger.kernel.org
References: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
MIME-Version: 1.0
Message-Id: <201110091912.47482.laurent.pinchart@ideasonboard.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thanks for the patches.

On Sunday 09 October 2011 04:37:31 Javier Martinez Canillas wrote:
> This patch-set aims to add support to the ISP CCDC driver to process
> interlaced video data in ITU-R BT.656 format.
> 
> The patch-set contains the following patches:
> 
> [PATCH 1/2] omap3isp: video: Decouple buffer obtaining and set ISP entities
> format [PATCH 2/2] omap3isp: ccdc: Add support to ITU-R BT.656 video data
> format
> 
> The first patch decouples next frame buffer obtaining from the last frame
> buffer releasing. This change is needed by the second patch that moves
> most of the CCDC buffer management logic to the VD1 interrupt handler.
> 
> This patch-set is a proof-of-concept and was only compile tested since I
> don't have the hardware to test right now. It is a forward porting, on top
> of Laurent's omap3isp-omap3isp-yuv tree, of the changes we made to the ISP
> driver to get interlaced video working.
> 
> Also, the patch will brake other configurations since the resizer and
> previewer also make use of omap3isp_video_buffer() function that now has a
> different semantic.

That's an issue you need to address :-)

> I'm posting even when the patch-set is not in a merge-able state so you can
> review what we were doing and make comments.

You should split your patches differently. Even if we ignore the above issue, 
your first patch will break the CCDC. In order to ease bissection patches 
should be self-contained and not introduce regressions if possible.

Please see my comments to the second patch.

> These are not all our changes since we also modified the ISP to forward the
> [G | S]_FMT and [G | S]_STD V4L2 ioctl commands to the TVP5151 and to only
> copy the active lines, but those changes are not relevant with the ghosting
> effect. With these changes we could get the 25 fps but with some sort of
> artifacts on the images.

-- 
Regards,

Laurent Pinchart
