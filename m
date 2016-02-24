Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45836 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbcBXIbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 03:31:03 -0500
Subject: Re: [PATCH v5 0/8] Add MT8173 Video Encoder Driver and VPU Driver
To: tiffany lin <tiffany.lin@mediatek.com>
References: <1456215081-16858-1-git-send-email-tiffany.lin@mediatek.com>
 <56CC1CAB.1060409@xs4all.nl> <1456302223.15077.8.camel@mtksdaap41>
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
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56CD6A37.2040700@xs4all.nl>
Date: Wed, 24 Feb 2016 09:30:47 +0100
MIME-Version: 1.0
In-Reply-To: <1456302223.15077.8.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

On 02/24/16 09:23, tiffany lin wrote:
> Hi Hans,
> 
> On Tue, 2016-02-23 at 09:47 +0100, Hans Verkuil wrote:
>> On 02/23/16 09:11, Tiffany Lin wrote:
>>> ==============
>>>  Introduction
>>> ==============
>>>
>>> The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
>>> Mediatek Video Codec is able to handle video encoding of in a range of formats.
>>>
>>> This patch series also include VPU driver. Mediatek Video Codec driver rely on VPU driver to load,
>>> communicate with VPU.
>>>
>>> Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI.
>>> MTK IOMMU[1] and MTK SMI[2] have not yet been merged, but we wanted to start discussion about the driver
>>> earlier so it could be merged sooner.
>>>
>>> [1]https://patchwork.kernel.org/patch/8335461/
>>> [2]https://patchwork.kernel.org/patch/7596181/
>>
>> <snip>
>>
>>> v4l2-compliance test output:
>>> localhost ~ # /usr/bin/v4l2-compliance -d /dev/video1
>>> Driver Info:
>>>         Driver name   : mtk-vcodec-enc
>>>         Card type     : platform:mt8173
>>>         Bus info      : platform:mt8173
>>>         Driver version: 4.4.0
>>>         Capabilities  : 0x84204000
>>>                 Video Memory-to-Memory Multiplanar
>>>                 Streaming
>>>                 Extended Pix Format
>>>                 Device Capabilities
>>>         Device Caps   : 0x04204000
>>>                 Video Memory-to-Memory Multiplanar
>>>                 Streaming
>>>                 Extended Pix Format
>>>
>>> Compliance test for device /dev/video1 (not using libv4l2):
>>>
>>> Required ioctls:
>>>         test VIDIOC_QUERYCAP: OK
>>>
>>> Allow for multiple opens:
>>>         test second video open: OK
>>>         test VIDIOC_QUERYCAP: OK
>>>         test VIDIOC_G/S_PRIORITY: OK
>>>
>>> Debug ioctls:
>>>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>>         test VIDIOC_LOG_STATUS: OK (Not Supported)
>>>
>>> Input ioctls:
>>>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>>>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>>         Inputs: 0 Audio Inputs: 0 Tuners: 0
>>>
>>> Output ioctls:
>>>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>>         Outputs: 0 Audio Outputs: 0 Modulators: 0
>>>
>>> Input/Output configuration ioctls:
>>>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>>         test VIDIOC_G/S_EDID: OK (Not Supported)
>>>
>>>         Control ioctls:
>>>                 test VIDIOC_QUERYCTRL/MENU: OK
>>>                 test VIDIOC_G/S_CTRL: OK
>>>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>>>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>>>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>>                 Standard Controls: 12 Private Controls: 0
>>>
>>>         Format ioctls:
>>>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>>                 test VIDIOC_G/S_PARM: OK
>>>                 test VIDIOC_G_FBUF: OK (Not Supported)
>>>                 test VIDIOC_G_FMT: OK
>>>                 test VIDIOC_TRY_FMT: OK
>>>                 test VIDIOC_S_FMT: OK
>>>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>>
>>>         Codec ioctls:
>>>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>>
>>>         Buffer ioctls:
>>>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>>                 test VIDIOC_EXPBUF: OK
>>>
>>> Total: 38, Succeeded: 38, Failed: 0, Warnings: 0
>>
>> Nice!
>>
>> Can you try 'v4l2-compliance -s'? Note that this may not work since I know
>> that v4l2-compliance doesn't work all that well with codecs, but I am
>> curious what the output is when you try streaming.
>>
>> Don't bother trying to chase down reported failures, those are likely from
>> v4l2-compliance itself. It is something I would like to improve, but -ENOTIME.
>>
> 
> When I try to run 'v4l2-compliance -d /dev/video1 -s, I got follow
> output.
> I use v4.4-rc5 kernel and v4l-utils 1.6 version.

Can you compile v4l2-compliance straight from the v4l-utils.git master branch?
Version 1.6 is too old, and for proper compliance testing you should always use
the master branch. It probably won't matter for this -s test, but for the
regular test (without -s) it does make a difference.

If nothing else, using the master branch will make it easier for me to match up
the line numbers that v4l2-compliance reports to the actual source.

Thanks!

	Hans

> 
> Streaming ioctls:
>         test read/write: OK (Not Supported)
> fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(332): buf.querybuf(node, i) fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(868): testQueryBuf(node, cur_fmt.type, q.g_buffers())
>         test MMAP: FAIL
> fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(923): ret && ret != ENOTTY
> 
> fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(988): setupUserPtr(node, q)
>         test USERPTR: FAIL
>         test DMABUF: Cannot test, specify --expbuf-device
> 
> best regards,
> Tiffany
> 
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
