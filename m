Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56397 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1DDLwV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:21 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrf001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:20 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdL009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 5/9] vb2_poll: don't start DMA, leave that to the first read().
Date: Mon,  4 Apr 2011 13:51:50 +0200
Message-Id: <aa6ba599252cedcbb977fa151a5af70860384bf1.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
References: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The vb2_poll function would start read DMA if called without any streaming
in progress. This unfortunately does not work if the application just wants
to poll for exceptions. This information of what the application is polling
for is sadly unavailable in the driver.

Andy Walls suggested to just return POLLIN | POLLRDNORM and let the first
call to read start the DMA. This initial read() call will return EAGAIN
since no actual data is available yet, but it does start the DMA.

Application are supposed to handle EAGAIN. MythTV does handle this correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6698c77..2dea57a 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1372,20 +1372,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
-			ret = __vb2_init_fileio(q, 1);
-			if (ret)
-				return POLLERR;
-		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
-			ret = __vb2_init_fileio(q, 0);
-			if (ret)
-				return POLLERR;
-			/*
-			 * Write to OUTPUT queue can be done immediately.
-			 */
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
+			return POLLIN | POLLRDNORM;
+		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
 			return POLLOUT | POLLWRNORM;
-		}
 	}
 
 	/*
-- 
1.7.1

