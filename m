Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28370 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751174AbeEUIzP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:15 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 07/36] media-request: Add a sanity check for the media request state
Date: Mon, 21 May 2018 11:54:32 +0300
Message-Id: <20180521085501.16861-8-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a sanity check for the number of the media request states equals the
number of status strings for debug purposes. This necessitates a new
entry in the request state enumeration, called NR_OF_MEDIA_REQUEST_STATE.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-request.c | 2 ++
 include/media/media-request.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
index 03e74d72241a0..ef4a436f220a3 100644
--- a/drivers/media/media-request.c
+++ b/drivers/media/media-request.c
@@ -28,6 +28,8 @@ static const char * const request_state[] = {
 static const char *
 media_request_state_str(enum media_request_state state)
 {
+	BUILD_BUG_ON(NR_OF_MEDIA_REQUEST_STATE != ARRAY_SIZE(request_state));
+
 	if (WARN_ON(state >= ARRAY_SIZE(request_state)))
 		return "invalid";
 	return request_state[state];
diff --git a/include/media/media-request.h b/include/media/media-request.h
index 42cc6e7f6e532..7a2df18a069ce 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -31,6 +31,8 @@
  * @MEDIA_REQUEST_STATE_UPDATING:	The request is being updated, i.e.
  *					request objects are being added,
  *					modified or removed
+ * @NR_OF_MEDIA_REQUEST_STATE:		The number of media request states, used
+ *					internally for sanity check purposes
  */
 enum media_request_state {
 	MEDIA_REQUEST_STATE_IDLE,
@@ -39,6 +41,7 @@ enum media_request_state {
 	MEDIA_REQUEST_STATE_COMPLETE,
 	MEDIA_REQUEST_STATE_CLEANING,
 	MEDIA_REQUEST_STATE_UPDATING,
+	NR_OF_MEDIA_REQUEST_STATE,
 };
 
 struct media_request_object;
-- 
2.11.0
