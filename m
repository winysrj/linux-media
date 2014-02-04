Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43544 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaBDJ5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 04:57:51 -0500
From: Amit Grover <amit.grover@samsung.com>
To: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	prabhakar.csengg@gmail.com, s.nawrocki@samsung.com,
	hans.verkuil@cisco.com, hverkuil@xs4all.nl, swaminath.p@samsung.com
Cc: jtp.park@samsung.com, Rrob@landley.net, andrew.smirnov@gmail.com,
	anatol.pomozov@gmail.com, jmccrohan@gmail.com, joe@perches.com,
	awalls@md.metrocast.net, arun.kk@samsung.com,
	amit.grover@samsung.com, austin.lobo@samsung.com
Subject: [PATCH v3 0/2] drivers/media: Add controls for Horizontal and Vertical
 MV Search Range
Date: Tue, 04 Feb 2014 15:29:57 +0530
Message-id: <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
In-reply-to: <52E0ED10.2020901@samsung.com>
References: <52E0ED10.2020901@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is v3 version for the patch:
s5p-mfc: Add Horizontal and Vertical search range for Video Macro Blocks
(https://lkml.org/lkml/2013/12/30/83)

Changes from v1:
1) Splitted the patch into V4L2 and MFC driver patches.
2) Incorporated review comments on v1.

Changes from v2:
1) Removed the range restrictions from drivers/media/v4l2-core/v4l2-ctrls.c.
2) Rebased the patch to git://linuxtv.org/mchehab/media-next.git.
3) Added [media] tag in title.

Amit Grover (2):
  [media] v4l2: Add settings for Horizontal and Vertical MV Search
    Range
  [media] s5p-mfc: Add Horizontal and Vertical MV Search Range

 Documentation/DocBook/media/v4l/controls.xml    |   20 +++++++++++++++++++
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
 drivers/media/v4l2-core/v4l2-ctrls.c            |    6 ++++++
 include/uapi/linux/v4l2-controls.h              |    2 ++
 7 files changed, 57 insertions(+), 6 deletions(-)

-- 
1.7.9.5

