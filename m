Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34340 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214Ab2EVPeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 11:34:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4F00DWDKLAZA20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 16:34:22 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4F00H0CKKWJM@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 May 2012 16:34:08 +0100 (BST)
Date: Tue, 22 May 2012 17:33:53 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 0/2] s5p-mfc: added encoder support for end of stream handling
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, m.szyprowski@samsung.com,
	k.debski@samsung.com, a.hajda@samsung.com
Message-id: <1337700835-13634-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those patches add end of stream handling for s5p-mfc encoder.

The first patch was sent already to the list as RFC, but the discussion ended
without any decision.
This patch adds new v4l2_buffer flag V4L2_BUF_FLAG_EOS. Below short
description of this change.

s5p_mfc is a mem-to-mem MPEG/H263/H264 encoder and it requires that the last
incoming frame must be processed differently, it means the information about
the end of the stream driver should receive NOT LATER than the last
V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer. Common practice
of sending empty buffer to indicate end-of-stream do not work in such case.
Setting V4L2_BUF_FLAG_EOS flag for the last V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
buffer seems to be the most straightforward solution here.

V4L2_BUF_FLAG_EOS flag should be used by application if driver requires it
and it should be set only on V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffers.

The second patch implements end-of-stream handling in s5p-mfc.

Comments are welcome
Andrzej Hajda
