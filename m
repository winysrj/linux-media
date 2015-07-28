Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64645 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbbG1IDr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 04:03:47 -0400
Date: Tue, 28 Jul 2015 10:03:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: HDMI and Composite capture on Lager, for kernel 4.1, version 5
In-Reply-To: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1507281000320.18223@axis700.grange>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 23 Jul 2015, William Towle wrote:

>   Version 5. Some successful upstreaming and some further modification
> means this obsoletes version 4, as seen at:
> 	http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/92832
> 
>   This version of the patch series contains a fix for probing the
> ADV7611/ADV7612 chips, a reduced (and renamed) "chip info and formats"
> patch intended to pave the way for better ADV7612 support, and updates
> to rcar_vin_try_fmt() in line with the latest feedback.
> 
> Cheers,
>   Wills.
> 
> To follow:
> 	[PATCH 01/13] ARM: shmobile: lager dts: Add entries for VIN HDMI
> 	[PATCH 02/13] ARM: shmobile: lager dts: specify default-input for
> 	[PATCH 03/13] media: adv7604: fix probe of ADV7611/7612
> 	[PATCH 04/13] media: adv7604: reduce support to first (digital)
> 	[PATCH 05/13] v4l: subdev: Add pad config allocator and init
> 	[PATCH 06/13] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
> 	[PATCH 07/13] media: soc_camera pad-aware driver initialisation
> 	[PATCH 08/13] media: rcar_vin: Use correct pad number in try_fmt
> 	[PATCH 09/13] media: soc_camera: soc_scale_crop: Use correct pad
> 	[PATCH 10/13] media: soc_camera: Fill std field in enum_input
> 	[PATCH 11/13] media: soc_camera: Fix error reporting in expbuf
> 	[PATCH 12/13] media: rcar_vin: fill in bus_info field
> 	[PATCH 13/13] media: rcar_vin: Reject videobufs that are too small

Since Hans would like to pull these patches urgently: for patches #6, 7 
(in its updated version 6 of yesterday 27.07.2015), and 8-13:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
