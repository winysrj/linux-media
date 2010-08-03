Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19222 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0HCOSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 10:18:45 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L6K0068YYF77M@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Aug 2010 15:18:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6K00LEOYF7RO@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Aug 2010 15:18:43 +0100 (BST)
Date: Tue, 03 Aug 2010 16:18:23 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v6 0/3] Multi-planar video format and buffer support for the
 V4L2 API
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1280845106-5761-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this is a very minor update to the last series, after Hans' suggestions:

- changed enum values for new types
- rephrased a couple of items in kerneldocs for new structs
- driver-returned errors take priority over EBUSY on format struct
  conversion

[PATCH v6 1/3] v4l: Add multi-planar API definitions to the V4L2 API
[PATCH v6 2/3] v4l: Add multi-planar ioctl handling code
[PATCH v6 3/3] v4l: Add compat functions for the multi-planar API

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
