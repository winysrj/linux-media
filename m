Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:45451 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbbJNN6E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2015 09:58:04 -0400
From: Antonio Ospite <ao2@ao2.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ao2@ao2.it>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	"# for v3 . 17 and up" <stable@vger.kernel.org>
Subject: [PATCH] [media] media/v4l2-ctrls: fix setting autocluster to manual with VIDIOC_S_CTRL
Date: Wed, 14 Oct 2015 15:57:32 +0200
Message-Id: <1444831052-17729-1-git-send-email-ao2@ao2.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 5d0360a4f027576e5419d4a7c711c9ca0f1be8ca it's not possible
anymore to set auto clusters from auto to manual using VIDIOC_S_CTRL.

For example, setting autogain to manual with gspca/ov534 driver and this
sequence of commands does not work:

  v4l2-ctl --set-ctrl=gain_automatic=1
  v4l2-ctl --list-ctrls | grep gain_automatic
  # The following does not work
  v4l2-ctl --set-ctrl=gain_automatic=0
  v4l2-ctl --list-ctrls | grep gain_automatic

Changing the value using VIDIOC_S_EXT_CTRLS (like qv4l2 does) works
fine.

The apparent cause by looking at the changes in 5d0360a and comparing
with the code path for VIDIOC_S_EXT_CTRLS seems to be that the code in
v4l2-ctrls.c::set_ctrl() is not calling user_to_new() anymore after
calling update_from_auto_cluster(master).

However the root cause of the problem is that calling
update_from_auto_cluster(master) overrides also the _master_ control
state calling cur_to_new() while it was supposed to only update the
volatile controls.

Calling user_to_new() after update_from_auto_cluster(master) was just
masking the original bug by restoring the correct new value of the
master control before making the changes permanent.

Fix the original bug by making update_from_auto_cluster() not override
the new master control value.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: <stable@vger.kernel.org>      # for v3.17 and up
---

Hi,

I did check the patch with scripts/checkpatch.pl but it gives an error,
I think it's a false positive.

Ciao ciao,
   Antonio

 drivers/media/v4l2-core/v4l2-ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc..19fc06e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3043,7 +3043,7 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
 {
 	int i;
 
-	for (i = 0; i < master->ncontrols; i++)
+	for (i = 1; i < master->ncontrols; i++)
 		cur_to_new(master->cluster[i]);
 	if (!call_op(master, g_volatile_ctrl))
 		for (i = 1; i < master->ncontrols; i++)
-- 
2.6.1

