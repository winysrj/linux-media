Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3961 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3CKLrQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 41/42] go7007: update the README
Date: Mon, 11 Mar 2013 12:46:19 +0100
Message-Id: <779578e6af7577b14f5ad9f879ed2c61607c30fe.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/README |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/go7007/README b/drivers/staging/media/go7007/README
index aeba132..779fe3f 100644
--- a/drivers/staging/media/go7007/README
+++ b/drivers/staging/media/go7007/README
@@ -1,11 +1,5 @@
 Todo:
-	- checkpatch.pl cleanups
-	- sparse cleanups
-	- lots of little modules, should be merged together
-	  and added to the build.
-	- testing?
-	- handle churn in v4l layer.
-
-Please send patches to Greg Kroah-Hartman <greg@linuxfoundation.org> and Cc: Ross
-Cohen <rcohen@snurgle.org> as well.
-
+	- create an API for motion detection
+	- figure out how to distribute the firmware files
+	- let s2250-board use i2c subdevs as well instead of hardcoding
+	  support for the i2c devices.
-- 
1.7.10.4

