Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:33023 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbbBKOXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 09:23:44 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [media] si470x: fixup wait_for_completion_timeout return handling
Date: Wed, 11 Feb 2015 09:19:01 -0500
Message-Id: <1423664341-7327-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

return type of wait_for_completion_timeout is unsigned long not int. A
appropriately named variable of type unsigned long is added and the
assignments fixed up.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was only compile tested with 

Patch is against 3.19.0 (localversion-next is -next-20150211)

 drivers/media/radio/si470x/radio-si470x-common.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 909c3f9..1d827ad 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -208,6 +208,7 @@ static int si470x_set_band(struct si470x_device *radio, int band)
 static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 {
 	int retval;
+	unsigned long time_left;
 	bool timed_out = false;
 
 	/* start tuning */
@@ -219,9 +220,9 @@ static int si470x_set_chan(struct si470x_device *radio, unsigned short chan)
 
 	/* wait till tune operation has completed */
 	reinit_completion(&radio->completion);
-	retval = wait_for_completion_timeout(&radio->completion,
-			msecs_to_jiffies(tune_timeout));
-	if (!retval)
+	time_left = wait_for_completion_timeout(&radio->completion,
+						msecs_to_jiffies(tune_timeout));
+	if (time_left == 0)
 		timed_out = true;
 
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
@@ -301,6 +302,7 @@ static int si470x_set_seek(struct si470x_device *radio,
 	int band, retval;
 	unsigned int freq;
 	bool timed_out = false;
+	unsigned long time_left;
 
 	/* set band */
 	if (seek->rangelow || seek->rangehigh) {
@@ -342,9 +344,9 @@ static int si470x_set_seek(struct si470x_device *radio,
 
 	/* wait till tune operation has completed */
 	reinit_completion(&radio->completion);
-	retval = wait_for_completion_timeout(&radio->completion,
-			msecs_to_jiffies(seek_timeout));
-	if (!retval)
+	time_left = wait_for_completion_timeout(&radio->completion,
+						msecs_to_jiffies(seek_timeout));
+	if (time_left == 0)
 		timed_out = true;
 
 	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
-- 
1.7.10.4

