Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:65202 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbbBAPvr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2015 10:51:47 -0500
Date: Sun, 1 Feb 2015 16:51:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: supporting adv7604.c under soc_camera/rcar_vin
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1502011650260.14164@axis700.grange>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wills,

A general comment: please, don't prefix patch titles with "WmT," this 
isn't the way authors or submitters are credited for their work in the 
Linux kernel.

Thanks
Guennadi

On Thu, 29 Jan 2015, William Towle wrote:

>   The following constitutes parts of our rcar_vin development branch
> beyond the update to our hotfixes published earlier this month.
> Similarly, these patches are intended to the mainline 3.18 kernel.
> Further development is required, but we would like to highlight the
> following issues and discuss them before completing the work.
> 
> 1. Our internal review has noted that our use of v4l2_subdev_has_op()
> is not yet ideal (but but does suffice for the purposes of generating
> images as-is). These tests are intended to detect whether or not a
> camera whose driver is aware of the pad API is present or not, and
> ensure we interact with subdevices accordingly. We think we should be
> iterating around all camera(s), and testing each subdevice link in
> turn. Is this sound, or is there a better way?
> 
> 2. Our second problem regards the supported formats list in adv7604.c,
> which needs further attention. We believe that having entries that go
> on to be rejected by rcar_vin_get_formats() may trigger a failure to
> initialise cleanly. Workaround code is marked "Ian Hack"; we intend to
> remove this and the list entries that cause this issue.
> 
> 3. Our third problem concerns detecting the resolution of the stream.
> Our code works with the obsoleted driver (adv761x.c) in place, but with
> our modifications to adv7604.c we have seen a) recovery of a 640x480
> image which is cropped rather than scaled, and/or b) recovery of a
> 2048x2048 image with the stream content in the top left corner. We
> think we understand the former problem, but the latter seems to be
> caused by full initialisation of the 'struct v4l2_subdev_format
> sd_format' variable, and we only have a partial solution [included
> as patch 4/8] so far. Of particular concern here is that potential
> consequences of changes in this particular patch are not clear.
> 
> 
>   Any advice would be appreciated, particularly regarding the first and
> last point above.
> 
> Cheers,
>   Wills.
> 
>   Associated patches:
> 	[PATCH 1/8] Add ability to read default input port from DT
> 	[PATCH 2/8] adv7604.c: formats, default colourspace, and IRQs
> 	[PATCH 3/8] WmT: document "adi,adv7612"
> 	[PATCH 4/8] WmT: m-5mols_core style pad handling for adv7604
> 	[PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
> 	[PATCH 6/8] WmT: adv7604 driver compatibility
> 	[PATCH 7/8] WmT: rcar_vin new ADV7612 support
> 	[PATCH 8/8] WmT: dts/i vin0/adv7612 (HDMI)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
