Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:43924 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbZCETqG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 14:46:06 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, mike@compulab.co.il
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 0/4] pxa_camera: Redesign DMA handling
Date: Thu,  5 Mar 2009 20:45:47 +0100
Message-Id: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset, formerly known as "pxa_camera: Redesign DMA handling", attempts
so simplify the code for all DMA related parts of pxa_camera host driver.

As asked for by Guennadi and Mike, the original patch was split up into 4
patches :
 - one to address the YUV planar format hole (page alignment)
 - one to redesign the DMA
 - one for code style change
 - one for lately discovered overrun issue

A decision about enforcing a size for pxa_camera_set_fmt() to be a multiple of 8
was not done yet. Meanwhile, the patchset doesn't make any hypothesis about the
image size, and even a weird size like 223 x 111 will work. If such a decision
was to be taken, patch 1 would have to amended.

Powermanagment with suspend to RAM, then resume in the middle of a capture does
work.

As Mike noticed, YUV planar format overlay was not tested after these changes.

Robert Jarzmik (4):
  pxa_camera: remove YUV planar formats hole
  pxa_camera: Redesign DMA handling
  pxa_camera: Coding style sweeping
  pxa_camera: Fix overrun condition on last buffer

 drivers/media/video/pxa_camera.c |  474 ++++++++++++++++++++++----------------
 1 files changed, 277 insertions(+), 197 deletions(-)

