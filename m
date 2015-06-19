Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:49051 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbbFSMHk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 08:07:40 -0400
Message-ID: <558405F6.2040003@xs4all.nl>
Date: Fri, 19 Jun 2015 14:07:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: HDMI and Composite capture on Lager, for kernel 4.1, version
 3
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 03:59 PM, William Towle wrote:
>   Version 3. Obsoletes version 2, as seen at:
> 	http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/91668
> 
>   Key changes in this version: this has some reworking of the adv7604
> driver probe and soc_camera initialisation functions. In addition,
> we give rcar_vin.c a dependency on CONFIG_MEDIA_CONTROLLER in line with
> the drivers used with it.

I'm not sure if I've asked this before, but shouldn't soc-camera be extended
with support for the DV_TIMINGS ioctls in order to control the adv7604?

It's peculiar that that is not included in this patch series...

Regards,

	Hans

> 
> Cheers,
>   Wills.
> 
> To follow:
> 	[PATCH 01/15] ARM: shmobile: lager dts: Add entries for VIN HDMI
> 	[PATCH 02/15] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888
> 	[PATCH 03/15] media: adv7180: add of match table
> 	[PATCH 04/15] media: adv7604: chip info and formats for ADV7612
> 	[PATCH 05/15] media: adv7604: document support for ADV7612 dual HDMI
> 	[PATCH 06/15] media: adv7604: ability to read default input port
> 	[PATCH 07/15] ARM: shmobile: lager dts: specify default-input for
> 	[PATCH 08/15] v4l: subdev: Add pad config allocator and init
> 	[PATCH 09/15] media: soc_camera pad-aware driver initialisation
> 	[PATCH 10/15] media: rcar_vin: Use correct pad number in try_fmt
> 	[PATCH 11/15] media: soc_camera: soc_scale_crop: Use correct pad
> 	[PATCH 12/15] media: soc_camera: Fill std field in enum_input
> 	[PATCH 13/15] media: soc_camera: Fix error reporting in expbuf
> 	[PATCH 14/15] media: soc_camera: fill in bus_info field
> 	[PATCH 15/15] media: rcar_vin: Reject videobufs that are too small
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
