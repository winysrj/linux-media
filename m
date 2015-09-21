Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58671 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031AbbIUJgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 05:36:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ricardo.ribalda@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/2] v4l2-ctrls: arrays are also considered compound controls
Date: Mon, 21 Sep 2015 11:36:41 +0200
Message-Id: <1442828202-25578-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442828202-25578-1-git-send-email-hverkuil@xs4all.nl>
References: <1442828202-25578-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Array controls weren't skipped when only V4L2_CTRL_FLAG_NEXT_CTRL was
provided (so no V4L2_CTRL_FLAG_NEXT_COMPOUND was set). This is wrong
since arrays are also considered compound controls (i.e. with more than
one value), and applications that do not know about arrays will not
be able to handle such controls.

Fix the test to include arrays.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: <stable@vger.kernel.org>      # for v3.17 and up
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc..d5de70e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2498,7 +2498,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 			/* We found a control with the given ID, so just get
 			   the next valid one in the list. */
 			list_for_each_entry_continue(ref, &hdl->ctrl_refs, node) {
-				is_compound =
+				is_compound = ref->ctrl->is_array ||
 					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
 				if (id < ref->ctrl->id &&
 				    (is_compound & mask) == match)
@@ -2512,7 +2512,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 			   is one, otherwise the first 'if' above would have
 			   been true. */
 			list_for_each_entry(ref, &hdl->ctrl_refs, node) {
-				is_compound =
+				is_compound = ref->ctrl->is_array ||
 					ref->ctrl->type >= V4L2_CTRL_COMPOUND_TYPES;
 				if (id < ref->ctrl->id &&
 				    (is_compound & mask) == match)
-- 
2.5.3

