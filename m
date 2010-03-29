Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22263 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0C2Hgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 03:36:52 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L0100EOX95DRD@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 08:36:50 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0100MUK95DJ4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 08:36:49 +0100 (BST)
Date: Mon, 29 Mar 2010 09:36:45 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v3 0/2] Mem-to-mem device framework
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hvaibhav@ti.com
Message-id: <1269848207-2325-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is the third version of the mem-to-mem memory device framework.
It addresses previous comments and issues raised in Norway as well.

It is rather independent from videobuf so I believe it can be merged separately.

Changes in v3:
- streamon, streamoff now have to be called for both queues separately
- added automatic rescheduling of an instance after finish (if ready)
- tweaked up locking
- addressed Andy Walls' comments

We have been using v2 for three different devices on an embedded system.
I did some additional testing of v3 on a 4-core SMP as well.

The series contains:

[PATCH v3 1/2] v4l: Add memory-to-memory device helper framework for videobuf.
[PATCH v3 2/2] v4l: Add a mem-to-mem videobuf framework test device.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center

