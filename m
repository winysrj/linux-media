Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:29574 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbcGGKRA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 06:17:00 -0400
Message-ID: <1467886612.21382.18.camel@mtksdaap41>
Subject: Re: [PATCH v3 0/9] Add MT8173 Video Decoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Thu, 7 Jul 2016 18:16:52 +0800
In-Reply-To: <577D0576.2050706@xs4all.nl>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
	 <577D0576.2050706@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On Wed, 2016-07-06 at 15:19 +0200, Hans Verkuil wrote:
> Hi Tiffany,
> 
> I plan to review this patch series on Friday, but one obvious question is
> what the reason for these failures is:
> 
> > Input/Output configuration ioctls:
> >         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> >         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> >         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> >         test VIDIOC_G/S_EDID: OK (Not Supported)
> > 
> >         Control ioctls:
> >                 test VIDIOC_QUERYCTRL/MENU: OK
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(357): g_ctrl returned an error (11)
> >                 test VIDIOC_G/S_CTRL: FAIL
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(579): g_ext_ctrls returned an error (11)
> >                 test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
These fails are because VIDIOC_G_CTRL and VIDIOC_G_EXT_CTRLS return
V4L2_CID_MIN_BUFFERS_FOR_CAPTURE only when dirver in MTK_STATE_HEADER
state, or it will return EAGAIN.
This could help user space get correct value, not default value that may
changed base on media content.

> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-controls.cpp(721): subscribe event for control 'User Controls' failed
> >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
Driver do not support subscribe event for control 'User Controls' for
now.
Do we need to support this?

> >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> >                 Standard Controls: 2 Private Controls: 0
> > 
> >         Format ioctls:
> >                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >                 test VIDIOC_G/S_PARM: OK (Not Supported)
> >                 test VIDIOC_G_FBUF: OK (Not Supported)
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-formats.cpp(405): expected EINVAL, but got 11 when getting format for buftype 9
> >                 test VIDIOC_G_FMT: FAIL
This is because vidioc_vdec_g_fmt only succeed when context is in
MTK_STATE_HEADER state, or user space cannot get correct format data
using this function.

> >                 test VIDIOC_TRY_FMT: OK (Not Supported)
> >                 test VIDIOC_S_FMT: OK (Not Supported)
> >                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> > 
> >         Codec ioctls:
> >                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> >                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> >                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> > 
> >         Buffer ioctls:
> >                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(500): q.has_expbuf(node)
Our OUTPUT and CAPTURE queue support both VB2_DMABUF and VB2_MMAP, user
space can select which to use in runtime.
So our driver default support v4l2_m2m_ioctl_expbuf functionality.
In v4l2-compliance test, it will check v4l2_m2m_ioctl_expbuf only valid
when node->valid_memorytype is V4L2_MEMORY_MMAP.
So when go through node->valid_memorytype is V4L2_MEMORY_DMABUF, it
fail.


best regards,
Tiffany



> >                 test VIDIOC_EXPBUF: FAIL
> > 
> > 
> > Total: 38, Succeeded: 33, Failed: 5, Warnings: 0
> 
> If it is due to a bug in v4l2-compliance, then let me know and I'll fix it. If not,
> then it should be fixed in the driver.
> 
> Frankly, it was the presence of these failures that made me think this patch series
> wasn't final. Before a v4l2 driver can be accepted in the kernel, v4l2-compliance must pass.
> 
> Regards,
> 
> 	Hans


