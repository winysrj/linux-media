Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43978 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941755AbcIHME0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 19/47] [media] v4l2-ctrls.h: Fix some c:type references
Date: Thu,  8 Sep 2016 09:03:41 -0300
Message-Id: <ecc2194ed8d4d76890fb3c518fc7d825d001b562.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the uAPI is using c:type, let's use it here too.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-ctrls.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index ff2847705dac..86702037cf5d 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -973,9 +973,9 @@ extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
  * v4l2_ctrl_replace - Function to be used as a callback to
  *	&struct v4l2_subscribed_event_ops replace\(\)
  *
- * @old: pointer to :ref:`struct v4l2_event <v4l2-event>` with the reported
+ * @old: pointer to struct &v4l2_event with the reported
  *	 event;
- * @new: pointer to :ref:`struct v4l2_event <v4l2-event>` with the modified
+ * @new: pointer to struct &v4l2_event with the modified
  *	 event;
  */
 void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
@@ -984,9 +984,9 @@ void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
  * v4l2_ctrl_merge - Function to be used as a callback to
  *	&struct v4l2_subscribed_event_ops merge(\)
  *
- * @old: pointer to :ref:`struct v4l2_event <v4l2-event>` with the reported
+ * @old: pointer to struct &v4l2_event with the reported
  *	 event;
- * @new: pointer to :ref:`struct v4l2_event <v4l2-event>` with the merged
+ * @new: pointer to struct &v4l2_event with the merged
  *	 event;
  */
 void v4l2_ctrl_merge(const struct v4l2_event *old, struct v4l2_event *new);
-- 
2.7.4


