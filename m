Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:27575 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab1AQDpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 22:45:51 -0500
Received: from epmmp2 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LF500E39EF26UA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jan 2011 12:45:02 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LF500FTSEF3DB@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jan 2011 12:45:03 +0900 (KST)
Date: Mon, 17 Jan 2011 12:44:54 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: How to set global alpha to V4L2_BUF_TYPE_CAPTURE ?
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, 'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <003801cbb5f8$ec278180$c4768480$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hello,

How to set global alpha to V4L2_BUF_TYPE_CAPTURE ?

Samsung SoC S5PC210 has Camera interface and Video post processor named FIMC
which can set the alpha value to V4L2_BUF_TYPE_CAPTURE. 
For example during color space conversion from YUV422 to ARGB8888, 
FIMC can set the alpha value to V4L2_BUF_TYPE_CAPTURE.

I tried to find an available command to set it but I couldn't found it.
But there is fmt.win.global_alpha for Video Overlay Interface.
So in my opinion VIDIOC_S_FMT is also suitable for V4L2_BUF_TYPE_CAPTURE*.
How about using fmt.pix.priv in struct v4l2_format 
and fmt.pix_mp.reserved[0] in struct v4l2_format ?

I welcome your opinion.

Best regards,


