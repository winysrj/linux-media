Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:60566 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754761AbbCDKUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2015 05:20:19 -0500
Message-ID: <54F6DC4F.6040504@xs4all.nl>
Date: Wed, 04 Mar 2015 11:19:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>
CC: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [Linux-kernel] RFC: supporting adv7604.c under soc_camera/rcar_vin
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <alpine.DEB.2.02.1503040911560.4552@xk120.dyn.ducie.codethink.co.uk>
In-Reply-To: <alpine.DEB.2.02.1503040911560.4552@xk120.dyn.ducie.codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/15 10:51, William Towle wrote:
> 
> Hi all,
> 
>   I would like to develop a point in my previous discussion based on
> new findings:
> 
> On Thu, 29 Jan 2015, William Towle wrote:
>> 3. Our third problem concerns detecting the resolution of the stream.
>> Our code works with the obsoleted driver (adv761x.c) in place, but with
>> our modifications to adv7604.c we have seen a) recovery of a 640x480
>> image which is cropped rather than scaled, and/or b) recovery of a
>> 2048x2048 image with the stream content in the top left corner.
> 
>   We have since ported this code from 3.17 to 3.19 (Hans' "subdev2"
> branch) and removed the unnecessary backward compatibility sections.
> Some of the the behaviour is somewhat different in the port, but
> I'll discuss that separately. Here I intend to discuss a possible bug
> in adv7604.c.
> 
>   In our 3.17-based submission, we had shim code in soc_camera/rcar_vin
> in order to emulate the old driver (originally serving to "test drive"
> the new driver in an older kernel). For a test case with gstreamer
> capturing a single frame it was sufficient at the time a) to override
> the driver's default resolution with something larger when first probed
> [emulating adv761x.c defaulting to the maximum supported resolution],
> and b) to have a query_dv_timings() call ensuring rcar_vin_try_fmt()
> works with the resolution of the live stream [subsequent queries to the
> driver stop returning the default resolution after that, also as per
> adv761x.c].
> 
>   I am currently investigating an enhancement to that solution in
> which the enum_dv_timings op is used to recover the maximum supported
> resolution of the new driver, and we hit a line in the driver which
> exits the corresponding function. It reads:
>     if (timings->pad >= state->source_pad)
>             return -EINVAL;
>   It suffices to comment out this line, but clearly this is not ideal.
> Depending on the intended semantics, should it be filtering out all pad
> IDs not matching the active one, or all pad IDs that are not valid
> input sources? Unfortunately the lager board's adv7180 chip is too
> simple to make a sensible comparison case (that we can also run tests
> on) here.

The adv7604 code is not ideal, although the pad test is valid (you shouldn't
be able to ask timings for pads that do not exist).

Perfect code would:

1) check if the requested pad is active (hooked up), and return -EINVAL if not.
2) check if the pad is digital or analog and return a different list of
timings accordingly (the max frequency is different between the two). See
the adv7842.c driver how that should be done.

But in the meantime, why not just set timings->pad to 0 in rcar_vin? Or
get it from platform data or something like that.

>   Please advise. Comments would also be welcome regarding whether the
> shims describe changes that should live in the driver or elsewhere in
> soc_camera/rcar_vin in an acceptable solution.

I'm not entirely sure what it is you are referring to. As you know I am
working to get rid of the duplicated video ops that are also available as
pad ops. No shims required since everything will be converted.

Regards,

	Hans
