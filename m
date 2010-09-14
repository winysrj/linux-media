Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16984 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab0INO3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 10:29:05 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8Q00AD3QWGA160@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Sep 2010 15:29:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8Q002Q3QWGZ7@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Sep 2010 15:29:04 +0100 (BST)
Received: from bssrvexch01.BS.local (bssrvexch01.bs.local [106.116.38.52])
	by linux.samsung.com (Postfix) with ESMTP id 87BFA27005F	for
 <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 16:25:38 +0200 (CEST)
Date: Tue, 14 Sep 2010 16:29:02 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RFC: Introduction of M2M capability and buffer types
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <ADF13DA15EB3FE4FBA487CCC7BEFDF3604CAE3BABC@bssrvexch01.BS.local>
Content-language: en-US
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

Mem2mem devices currently use V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT capabilities. One might expect that a capture device is a camera and an output device can display images. If I remember correct our discussion during the Helsinki v4l2 summit, Hans de Goede has pointed that such devices are listed in applications and can confuse users. The user expects a camera and he has to choose from a long list of devices. 

The solution to this would be the introduction of two new capability V4L2_CAP_VIDEO_M2M. Such devices would not be listed when user is expected to choose which webcam or TV tuner device to use.

Another thing about m2m devices is the naming of buffers: V4L2_BUF_TYPE_VIDEO_CAPTURE means the destination buffer and V4L2_BUF_TYPE_VIDEO_OUTPUT means source. This indeed is confusing, so I think the introduction of two new buffer types is justified. I would recommend V4L2_BUF_TYPE_M2M_SOURCE and V4L2_BUF_TYPE_M2M_DESTINATION to clearly state what is the buffer's purpose.

I would be grateful for your comments to this RFC.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

