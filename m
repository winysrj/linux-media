Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23671 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0CIOts (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 09:49:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZ000EGFRUXQV50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Mar 2010 14:49:45 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZ0007Z9RUXJL@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Mar 2010 14:49:45 +0000 (GMT)
Date: Tue, 09 Mar 2010 15:49:40 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH/RFC v2 0/3] Multi-plane video buffer support for V4L2 API and
 videobuf
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Message-id: <1268146183-2018-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this version differs only slightly from the previous one, it fixes some
memory allocation/freeing-related problems of the previous patchset.

As was the case with v1, it is still intended for demonstration/discussion/testing
purposes only.


Changes since v2:
- simplified videobuf_buffer allocation
- fixed some videobuf_buffer memory leaks (missing kfrees)


The series contains:

[PATCH v2 1/3] v4l: Add support for multi-plane buffers to V4L2 API.
[PATCH v2 2/3] v4l: videobuf: Add support for multi-plane buffers.
[PATCH v2 3/3] v4l: vivi: add 2- and 3-planar YCbCr422

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
