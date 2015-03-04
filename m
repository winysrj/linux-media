Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:55881 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409AbbCDJvJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 04:51:09 -0500
Date: Wed, 4 Mar 2015 09:51:04 +0000 (GMT)
From: William Towle <william.towle@codethink.co.uk>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Linux-kernel] RFC: supporting adv7604.c under
 soc_camera/rcar_vin
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Message-ID: <alpine.DEB.2.02.1503040911560.4552@xk120.dyn.ducie.codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi all,

   I would like to develop a point in my previous discussion based on
new findings:

On Thu, 29 Jan 2015, William Towle wrote:
> 3. Our third problem concerns detecting the resolution of the stream.
> Our code works with the obsoleted driver (adv761x.c) in place, but with
> our modifications to adv7604.c we have seen a) recovery of a 640x480
> image which is cropped rather than scaled, and/or b) recovery of a
> 2048x2048 image with the stream content in the top left corner.

   We have since ported this code from 3.17 to 3.19 (Hans' "subdev2"
branch) and removed the unnecessary backward compatibility sections.
Some of the the behaviour is somewhat different in the port, but
I'll discuss that separately. Here I intend to discuss a possible bug
in adv7604.c.

   In our 3.17-based submission, we had shim code in soc_camera/rcar_vin
in order to emulate the old driver (originally serving to "test drive"
the new driver in an older kernel). For a test case with gstreamer
capturing a single frame it was sufficient at the time a) to override
the driver's default resolution with something larger when first probed
[emulating adv761x.c defaulting to the maximum supported resolution],
and b) to have a query_dv_timings() call ensuring rcar_vin_try_fmt()
works with the resolution of the live stream [subsequent queries to the
driver stop returning the default resolution after that, also as per
adv761x.c].

   I am currently investigating an enhancement to that solution in
which the enum_dv_timings op is used to recover the maximum supported
resolution of the new driver, and we hit a line in the driver which
exits the corresponding function. It reads:
 	if (timings->pad >= state->source_pad)
 	        return -EINVAL;
   It suffices to comment out this line, but clearly this is not ideal.
Depending on the intended semantics, should it be filtering out all pad
IDs not matching the active one, or all pad IDs that are not valid
input sources? Unfortunately the lager board's adv7180 chip is too
simple to make a sensible comparison case (that we can also run tests
on) here.

   Please advise. Comments would also be welcome regarding whether the
shims describe changes that should live in the driver or elsewhere in
soc_camera/rcar_vin in an acceptable solution.

Cheers,
   Wills.
