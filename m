Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60514 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0D1HFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 03:05:36 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L1K00FJFRP4KQ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Apr 2010 08:05:28 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1K000EGRP40Z@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Apr 2010 08:05:28 +0100 (BST)
Date: Wed, 28 Apr 2010 09:05:20 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v4 0/3] Fix DQBUF behavior for recoverable streaming errors
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1272438323-4790-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is the fourth version of a series that introduces a V4L2_BUF_FLAG_ERROR
flag for recoverable stream errors. It allows applications to gracefully recover
in case of such errors instead of losing the buffer or having to guess
its index.

Changes since v3:
- fixed a typo in docs
- removed a comment which no longer relevant

Contents:
[PATCH v4 1/3] v4l: Add a new ERROR flag for DQBUF after recoverable streaming errors
[PATCH 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
[PATCH v4 3/3] v4l: Add documentation for the new error flag

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
