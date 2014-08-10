Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1044 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaHJL60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/19] cx23885: drop unused clip fields from struct cx23885_fh
Date: Sun, 10 Aug 2014 13:57:48 +0200
Message-Id: <1407671876-39386-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no overlay support, so drop these unused fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index aba1e6a..a88e951 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -145,11 +145,6 @@ struct cx23885_fh {
 	struct cx23885_dev         *dev;
 	u32                        resources;
 
-	/* video overlay */
-	struct v4l2_window         win;
-	struct v4l2_clip           *clips;
-	unsigned int               nclips;
-
 	/* video capture */
 	struct cx23885_fmt         *fmt;
 	unsigned int               width, height;
-- 
2.0.1

