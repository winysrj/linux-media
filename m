Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:49261 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbbCYJzp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 05:55:45 -0400
Date: Wed, 25 Mar 2015 09:55:36 +0000 (GMT)
From: William Towle <william.towle@codethink.co.uk>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, koji.matsuoka.xm@renesas.com
Subject: Re: [Linux-kernel] RFC: supporting adv7604.c under
 soc_camera/rcar_vin
In-Reply-To: <alpine.DEB.2.02.1503040911560.4552@xk120.dyn.ducie.codethink.co.uk>
Message-ID: <alpine.DEB.2.02.1503250951520.4424@xk120.dyn.ducie.codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <alpine.DEB.2.02.1503040911560.4552@xk120.dyn.ducie.codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again all,

   Previously I promised to comment further on progress with our work
supporting HDMI input on Lager. After studying commit 4c28078 "[media]
rcar_vin: Add scaling support" on Hans' subdev2 branch, I have come to
the conclusion that the following is actually reasonable behaviour when
no attempt to determine the resolution of the live stream (a non-VGA
720x576 in our case) has been made:

> with
> our modifications to adv7604.c we have seen a) recovery of a 640x480
> image which is cropped rather than scaled, and/or b) recovery of a
> 2048x2048 image with the stream content in the top left corner.

   With our latest patchset, frame capture is essentially working and I
believe a solution is close, but the scaling changes introduce
behaviour that seems to be a regression for this particular test case
- see final point below. We have:

   1. ported code to subdev2 tree (with backward-compatibility for legacy
driver removed)
   2. adjusted adv7604.c to detect the ADV7612, adding calls to
get_fmt/set_fmt/enum_mbus_code pad ops to suit
   3. removed our attempt to query the driver's maximum resolution - the
scaling patch above configures the pre-clip/post-clip rectangles
sensibly without it
   4. modified our attempt to query the live resolution by doing this in
adv7604_fill_format() ... by reinstating adv761x_get_vid_info() as a
lightweight means of recovering the resolution, then using
query_dv_timings to update properly if state->timings is inconsistent
with its results; this leads to the need for:
   5. reverting the following, as not updating 'pix' with the (possibly
updated) resolution set_fmt returns leads to userland requesting an
inappropriately sized output buffer:
 	[commit 4c28078, static int rcar_vin_try_fmt(...)]
 	-       pix->width = mf.width;
 	-       pix->height = mf.height;
 	+       /* Adjust only if VIN cannot scale */
 	+       if (pix->width > mf.width * 2)
 	+               pix->width = mf.width * 2;
 	+       if (pix->height > mf.height * 3)
 	+               pix->height = mf.height * 3;

   Does this seem reasonable, or are there better ways of implementing
any of the above steps?

Cheers,
   Wills.
