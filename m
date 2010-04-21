Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60281 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0DUMM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 08:12:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L18006HP78E1M70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 13:12:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L18005GO77RES@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 13:11:51 +0100 (BST)
Date: Wed, 21 Apr 2010 13:39:42 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v3 0/3] Fix DQBUF behavior for recoverable streaming errors
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1271849985-368-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is the third version of a series that introduces a V4L2_BUF_FLAG_ERROR
flag for recoverable stream errors. It allows applications to gracefully recover
in case of such errors instead of losing the buffer or having to guess
its index.

Changes since v2:
- replaced the second patch of the series with Hans' version

This series contains:
[PATCH v3 1/3] v4l: Add a new ERROR flag for DQBUF after recoverable streaming errors
[PATCH v3 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
[PATCH v3 3/3] v4l: Add documentation for the new error flag

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
