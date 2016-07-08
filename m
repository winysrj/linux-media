Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34208 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191AbcGHLor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 07:44:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 0/9] Add MT8173 Video Decoder Driver
To: tiffany lin <tiffany.lin@mediatek.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
 <577D0576.2050706@xs4all.nl> <1467886612.21382.18.camel@mtksdaap41>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com,
	Kamil Debski <k.debski@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <e2952cc2-3abd-894e-9481-b91a45cf7891@xs4all.nl>
Date: Fri, 8 Jul 2016 13:44:41 +0200
MIME-Version: 1.0
In-Reply-To: <1467886612.21382.18.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2016 12:16 PM, tiffany lin wrote:
> Hi Hans,
> 
> 
> On Wed, 2016-07-06 at 15:19 +0200, Hans Verkuil wrote:
>> Hi Tiffany,
>>
>> I plan to review this patch series on Friday, but one obvious question is
>> what the reason for these failures is:
>>
>>> Input/Output configuration ioctls:
>>>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>>         test VIDIOC_G/S_EDID: OK (Not Supported)
>>>
>>>         Control ioctls:
>>>                 test VIDIOC_QUERYCTRL/MENU: OK
>>>                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(357): g_ctrl returned an error (11)
>>>                 test VIDIOC_G/S_CTRL: FAIL
>>>                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(579): g_ext_ctrls returned an error (11)
>>>                 test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
> These fails are because VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS return
> V4L2_CID_MIN_BUFFERS_FOR_CAPTURE only when dirver in MTK_STATE_HEADER
> state, or it will return EAGAIN.
> This could help user space get correct value, not default value that may
> changed base on media content.

OK, I really don't like this. I also looked what the s5p-mfc-dec driver does (the only other
driver currently implementing this), and that returns -EINVAL.

My proposal would be to change this. If this information isn't known yet, why not
just return 0 as the value? The doc would have to be updated and (preferably) also
the s5p-mfc-dec driver. I've added Samsung devs to the Cc list, let me know what you
think.

> 
>>>                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(721): subscribe event for control 'User Controls' failed
>>>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
> Driver do not support subscribe event for control 'User Controls' for
> now.
> Do we need to support this?

I don't see why this would fail. It's OK to subscribe to such controls, although
you'll never get an event.

>>>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>>                 Standard Controls: 2 Private Controls: 0
>>>
>>>         Format ioctls:
>>>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>>>                 test VIDIOC_G_FBUF: OK (Not Supported)
>>>                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-formats.cpp(405): expected EINVAL, but got 11 when getting format for buftype 9
>>>                 test VIDIOC_G_FMT: FAIL
> This is because vidioc_vdec_g_fmt only succeed when context is in
> MTK_STATE_HEADER state, or user space cannot get correct format data
> using this function.

Comparing this to s5p-mfc-dec I see that -EINVAL is returned in that case.

I am not opposed to using EAGAIN in s5p-mfc-dec as well. Marek, Kamil, what is
your opinion?

> 
>>>                 test VIDIOC_TRY_FMT: OK (Not Supported)
>>>                 test VIDIOC_S_FMT: OK (Not Supported)
>>>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>>
>>>         Codec ioctls:
>>>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>>
>>>         Buffer ioctls:
>>>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>>                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(500): q.has_expbuf(node)
> Our OUTPUT and CAPTURE queue support both VB2_DMABUF and VB2_MMAP, user
> space can select which to use in runtime.
> So our driver default support v4l2_m2m_ioctl_expbuf functionality.
> In v4l2-compliance test, it will check v4l2_m2m_ioctl_expbuf only valid
> when node->valid_memorytype is V4L2_MEMORY_MMAP.
> So when go through node->valid_memorytype is V4L2_MEMORY_DMABUF, it
> fail.

valid_memorytype should have both MMAP and DMABUF flags.

But v4l-utils-1.6.0 is way too old to be certain it isn't some v4l2-compliance bug
that has since been fixed.

Regards,

	Hans

> 
> 
> best regards,
> Tiffany
> 
> 
> 
>>>                 test VIDIOC_EXPBUF: FAIL
>>>
>>>
>>> Total: 38, Succeeded: 33, Failed: 5, Warnings: 0
>>
>> If it is due to a bug in v4l2-compliance, then let me know and I'll fix it. If not,
>> then it should be fixed in the driver.
>>
>> Frankly, it was the presence of these failures that made me think this patch series
>> wasn't final. Before a v4l2 driver can be accepted in the kernel, v4l2-compliance must pass.
>>
>> Regards,
>>
>> 	Hans
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
