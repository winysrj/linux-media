Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57608 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1JIChp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 22:37:45 -0400
Received: by wyg34 with SMTP id 34so4947103wyg.19
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 19:37:44 -0700 (PDT)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>, linux-media@vger.kernel.org
Subject: [PATCH 0/2] Add support to ITU-R BT.656 video data format
Date: Sun,  9 Oct 2011 04:37:31 +0200
Message-Id: <1318127853-1879-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch-set aims to add support to the ISP CCDC driver to process interlaced
video data in ITU-R BT.656 format.

The patch-set contains the following patches:

[PATCH 1/2] omap3isp: video: Decouple buffer obtaining and set ISP entities format
[PATCH 2/2] omap3isp: ccdc: Add support to ITU-R BT.656 video data format

The first patch decouples next frame buffer obtaining from the last frame buffer
releasing. This change is needed by the second patch that moves most of the CCDC
buffer management logic to the VD1 interrupt handler.

This patch-set is a proof-of-concept and was only compile tested since I
don't have the hardware to test right now. It is a forward porting, on top
of Laurent's omap3isp-omap3isp-yuv tree, of the changes we made to the ISP
driver to get interlaced video working.

Also, the patch will brake other configurations since the resizer and previewer
also make use of omap3isp_video_buffer() function that now has a different semantic.

I'm posting even when the patch-set is not in a merge-able state so you can review
what we were doing and make comments.

These are not all our changes since we also modified the ISP to forward the
[G | S]_FMT and [G | S]_STD V4L2 ioctl commands to the TVP5151 and to only
copy the active lines, but those changes are not relevant with the ghosting
effect. With these changes we could get the 25 fps but with some sort of
artifacts on the images.

I hope that together we can find a solution to this issue.

Thanks a lot.
