Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:35543 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab0IMMOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 08:14:07 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L8O00416PZGQ840@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Sep 2010 21:14:04 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L8O003X6PZGVD@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Sep 2010 21:14:04 +0900 (KST)
Date: Mon, 13 Sep 2010 21:14:04 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: how can deal with the stream in only on-the-fly-output available HW
 block??
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Message-id: <023401cb533d$2819c8c0$784d5a40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,
 
What if some SoC's specific HW block supports only on-the-fly mode for
stream output??
In this case, what is the suitable buf_type??
I'm faced with such problem.
 
As explanation for my situation briefly, the processor I deal with now has 3
Multimedia H/W blocks, and the problem-one in the 3 blocks do the work for
sensor-interfacing and pre-processing.
It supports CCD or CMOS for input, and DMA or On-The-Fly for output.
Exactly, it has two cases - DMA mode using memory bus & On-The-Fly mode
connected with any other multimedia blocks.
Also, it use only one format "Bayer RGB" in case of mode the DMA and
On-The-Fly mode both.
 
So, when the device operates in the On-The-Fly mode, is it alright the
driver's current type is  V4L2_BUF_TYPE_VIDEO_CAPTURE? or something else?
or if setting buf_type is wrong itself, what v4l2 API flow is right for
driver or userspace??

the v4l2 buf_type enumeratinos is defined here, but I have no idea about
suitable enum value in this case, also except for any other under enums too.

V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
V4L2_BUF_TYPE_VIDEO_OUTPUT         = 2,
V4L2_BUF_TYPE_VIDEO_OVERLAY        = 3,
V4L2_BUF_TYPE_VBI_CAPTURE          = 4,
V4L2_BUF_TYPE_VBI_OUTPUT           = 5,
V4L2_BUF_TYPE_SLICED_VBI_CAPTURE   = 6,
V4L2_BUF_TYPE_SLICED_VBI_OUTPUT    = 7,
V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
V4L2_BUF_TYPE_PRIVATE              = 0x80,

I'll thanks for any idea or answer.
 
Regards,
HeungJun, Kim


