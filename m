Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38757 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1K1MRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 07:17:09 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVD006ICE4JHW@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Nov 2011 12:17:07 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVD0022YE4JPC@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Nov 2011 12:17:07 +0000 (GMT)
Date: Mon, 28 Nov 2011 13:17:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] s5p-fimc: Add support for alpha component
 configuration
In-reply-to: <201111281242.17246.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4ED37BC2.60205@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com>
 <1322235572-22016-3-git-send-email-s.nawrocki@samsung.com>
 <201111281242.17246.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2011 12:42 PM, Hans Verkuil wrote:
> On Friday 25 November 2011 16:39:32 Sylwester Nawrocki wrote:
>> On Exynos SoCs the FIMC IP allows to configure globally the alpha
>> component of all pixels for V4L2_PIX_FMT_RGB32, V4L2_PIX_FMT_RGB555
>> and V4L2_PIX_FMT_RGB444 image formats. This patch adds a v4l2 control
>> in order to let the applications control the alpha component value.
>>
>> The alpha value range depends on the pixel format, for RGB32 it's
>> 0..255 (8-bits), for RGB555 - 0..1 (1-bit) and for RGB444 - 0..15
>> (4-bits). The v4l2 control range is always 0..255 and the alpha
>> component data width is determined by currently set format on the
>> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE buffer queue. The applications
>> need to match the alpha channel data width and the pixel format
>> since the driver will ignore the alpha component bits that are not
>> applicable to the configured pixel format.
> 
> Will the driver ignore the least significant bits or the most significant 
> bits?

Most significant bits will be ignored, i.e. depending on fourcc the valid
alpha bits are:

V4L2_PIX_FMT_RGB555 - [0]
V4L2_PIX_FMT_RGB444 - [3:0]
V4L2_PIX_FMT_RGB32  - [7:0]

--

Regards,
Sylwester

