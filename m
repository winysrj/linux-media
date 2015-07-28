Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58855 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945AbbG1JUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 05:20:20 -0400
Message-ID: <55B7494B.40209@xs4all.nl>
Date: Tue, 28 Jul 2015 11:20:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: HDMI and Composite capture on Lager, for kernel 4.1, version
 5
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On 07/23/2015 02:21 PM, William Towle wrote:
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

I've merged patches 3-13 (patches 10 and 11 are marked superseded since I'm
using versions I posted as part of another patch series).

But you need to repost patches 1 and 2 with a CC to linux-sh@vger.kernel.org
so Simon Horman can either pull them in or Ack them and then I'll merge these
patches. It probably makes more sense that Simon merges them since I believe
these two patches are independent of the others.

Regards,

	Hans

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

