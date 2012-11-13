Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:19560 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2KMNxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 08:53:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/2] omap_vout: Fix overlay support
Date: Tue, 13 Nov 2012 14:53:09 +0100
Cc: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <1352814459-8215-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1352814459-8215-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211131453.09958.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 13 November 2012 14:47:37 Laurent Pinchart wrote:
> Hi everybody,
> 
> Commit 4b20259fa642d6f7a2dabef0b3adc14ca9dadbde ("v4l2-dev: improve ioctl
> validity checks") broke overlay support in the omap_vout driver. This patch
> series fix it.
> 
> Tested on a Beagleboard-xM with a YUYV overlay and the omap3-isp-live
> application from http://git.ideasonboard.org/omap3-isp-live.git.

For this series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Is there an active maintainer for the omap_vout driver who can take this patch
> in his/her tree ?
> 
> Laurent Pinchart (2):
>   omap_vout: Drop overlay format enumeration
>   omap_vout: Use the output overlay ioctl operations
> 
>  drivers/media/platform/omap/omap_vout.c |   22 +++-------------------
>  1 files changed, 3 insertions(+), 19 deletions(-)
> 
> 
