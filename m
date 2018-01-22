Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51614 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750828AbeAVKAx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:00:53 -0500
Subject: Re: [PATCH v6 0/9] Renesas Capture Engine Unit (CEU) V4L2 driver
To: jacopo mondi <jacopo@jmondi.org>
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <6fcd22c1-19a5-e0b7-2b00-961e1cd1ebaa@xs4all.nl>
 <20180121174909.GP24926@w540>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2a18ce21-8efd-6182-f626-8f7c7bcaebee@xs4all.nl>
Date: Mon, 22 Jan 2018 11:00:50 +0100
MIME-Version: 1.0
In-Reply-To: <20180121174909.GP24926@w540>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/18 18:49, jacopo mondi wrote:
> Hi Hans,
> 
> On Fri, Jan 19, 2018 at 12:26:09PM +0100, Hans Verkuil wrote:
>> Hi Jacopo,
>>
>> On 01/16/18 22:44, Jacopo Mondi wrote:
>>> Hello,
>>>    new version of CEU after Hans' review.
>>>
>>> Added his Acked-by to most patches and closed review comments.
>>> Running v4l2-compliance, I noticed a new failure introduced by the way I now
>>> calculate the plane sizes in set/try_fmt.
>>>
>>> This is the function used to update per-plane bytesperline and sizeimage:
>>>
>>> static void ceu_update_plane_sizes(struct v4l2_plane_pix_format *plane,
>>> 				   unsigned int bpl, unsigned int szimage)
>>> {
>>> 	if (plane->bytesperline < bpl)
>>> 		plane->bytesperline = bpl;
>>> 	if (plane->sizeimage < szimage)
>>> 		plane->sizeimage = szimage;
>>> }
>>>
>>> I'm seeing a failure as v4l2-compliance requires buffers with both bytesperline
>>> and sizeimage set to MAX_INT . Hans, is this expected from v4l2-compliance?
>>> How should I handle this, if that has to be handled by the single drivers?
>>
>> I commented on this in my review of patch 3/9.
> 
> Fixed thank you.
> 
>>
>>>
>>> Apart from that, here it is the output of v4l2-compliance, with the last tests
>>> failing due to the above stated reason, and two errors in try/set format due to
>>> the fact the driver is not setting ycbcr encoding after it receives an invalid
>>
>> Which driver? The CEU driver or the sensor driver? I don't actually see where
>> it fails.
>>
> 
> Here it is:
> 
>                 fail: v4l2-test-formats.cpp(335): ycbcr_enc >= 0xff
>                 fail: v4l2-test-formats.cpp(451): testColorspace(pix_mp.pixelformat, pix_mp.colorspace, pix_mp.ycbcr_enc, pix_mp.quantization)
>                 fail: v4l2-test-formats.cpp(736): Video Capture Multiplanar is valid, but TRY_FMT failed to return a format
>                 test VIDIOC_TRY_FMT: FAIL
>                 fail: v4l2-test-formats.cpp(335): ycbcr_enc >= 0xff
>                 fail: v4l2-test-formats.cpp(451): testColorspace(pix_mp.pixelformat, pix_mp.colorspace, pix_mp.ycbcr_enc, pix_mp.quantization)
>                 fail: v4l2-test-formats.cpp(996): Video Capture Multiplanar is valid, but no S_FMT was implemented
>                 test VIDIOC_S_FMT: FAIL

Sorry, I was perhaps confusing. I meant that I couldn't see where in the code
ycbcr_enc was not overwritten by 0 (which should have happened). You will need
to debug a bit, I think. It could be a bug in the ceu driver or the sensor driver.

> 
> 
>>> format. I would set those, but I'm not sure what it the correct value and not
>>> all mainline drivers do that.
>>
>> In any case, the default for ycbcr_enc, xfer_func and quantization is 0.
>>
> 
> Thanks again. I do expect to be the sensor driver to set ycbcr_enc and
> quantization, but from a very trivial grep on media/i2c/ I see only a
> few drivers taking care of them (adv7511 and adv7842). What about the
> others? I assume v4l2-compliance would not fail on them as it does on
> ov7670, but I don't see where ycbr_enc (and others) are managed.

In most cases these values are initialized to 0 (either a memset or by
initializing the struct), which is typically all you need for sensor
drivers. HDMI drivers are more complicated which is why you see explicit
handling of these fields only there.

> 
> Overall, with this addressed, the other issue I mentioned on patch
> [3/9] on readbuffers clarified and frameinterval handled for ov722x, I
> hope we're done with this series. Thanks again your continued effort
> in reviews and guidance.

My pleasure!

Regards,

	Hans
