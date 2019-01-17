Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D148AC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFAF20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbfAQQSG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:18:06 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39573 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728812AbfAQQSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:18:06 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kAMkgeAhPNR5ykAMmgTv10; Thu, 17 Jan 2019 17:18:05 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 4/8] tw9910.h: remove obsolete soc_camera.h include.
Date:   Thu, 17 Jan 2019 17:17:58 +0100
Message-Id: <20190117161802.5740-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
References: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNXVrFOTWLJKQxd/CmlGj4OfRj1lc0E0SZWeAKQVbsOP5Be0+ePytfdnAu94IDQqeF2rm5ofTyfB53f7u0nnqFiSPZcf1qK1DH7C2W2mlVbwoek6SAcy
 HeLx4ckB8FZP/w0OMW3/pS7oIqhdHjoS8FsgbEY5b3pqytVq9jucFtM82tXxQ5YaK26w9IXkNBuy69ApCieWIqjVjAcdGSAlzkL2QqGfr9DhEOf4IyZLqTlX
 5/Alh2c7N/4Xp0p4cZ2nf999H0CQgW3ZW1fzRQQtwlgcKEalOQxmTksyfjjvefltSPSYLCtPxcgdLNy0GYchPLOwwZ/iLRkhG2Ycmt0NXlVSZdeNiH21qiLY
 DEIhc2rbLbdmgyPPUQy9GsDumMipYQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

This include isn't use anymore, so drop it.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 include/media/i2c/tw9910.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/i2c/tw9910.h b/include/media/i2c/tw9910.h
index bec8f7bce745..2f93799d5a21 100644
--- a/include/media/i2c/tw9910.h
+++ b/include/media/i2c/tw9910.h
@@ -16,8 +16,6 @@
 #ifndef __TW9910_H__
 #define __TW9910_H__
 
-#include <media/soc_camera.h>
-
 /**
  * tw9910_mpout_pin - MPOUT (multi-purpose output) pin functions
  */
-- 
2.20.1

