Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:34228 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbcEDQVx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 12:21:53 -0400
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH v2 2/2] solo6x10: Simplify solo_enum_ext_input
Date: Wed,  4 May 2016 13:21:21 -0300
Message-Id: <1462378881-16625-2-git-send-email-ismael@iodev.co.uk>
In-Reply-To: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
References: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Additionally, now it specifies which channels it's showing.

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2.c | 34 ++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 721ff53..953d6bf 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -386,26 +386,24 @@ static int solo_querycap(struct file *file, void  *priv,
 static int solo_enum_ext_input(struct solo_dev *solo_dev,
 			       struct v4l2_input *input)
 {
-	static const char * const dispnames_1[] = { "4UP" };
-	static const char * const dispnames_2[] = { "4UP-1", "4UP-2" };
-	static const char * const dispnames_5[] = {
-		"4UP-1", "4UP-2", "4UP-3", "4UP-4", "16UP"
-	};
-	const char * const *dispnames;
-
-	if (input->index >= (solo_dev->nr_chans + solo_dev->nr_ext))
-		return -EINVAL;
-
-	if (solo_dev->nr_ext == 5)
-		dispnames = dispnames_5;
-	else if (solo_dev->nr_ext == 2)
-		dispnames = dispnames_2;
-	else
-		dispnames = dispnames_1;
+	int ext = input->index - solo_dev->nr_chans;
+	unsigned int nup, first;
 
-	snprintf(input->name, sizeof(input->name), "Multi %s",
-		 dispnames[input->index - solo_dev->nr_chans]);
+	if (ext >= solo_dev->nr_ext)
+		return -EINVAL;
 
+	nup   = (ext == 4) ? 16 : 4;
+	first = (ext & 3) << 2; /* first channel in the n-up */
+	snprintf(input->name, sizeof(input->name),
+		 "Multi %d-up (cameras %d-%d)",
+		 nup, first + 1, first + nup);
+	/* Possible outputs:
+	 *  Multi 4-up (cameras 1-4)
+	 *  Multi 4-up (cameras 5-8)
+	 *  Multi 4-up (cameras 9-12)
+	 *  Multi 4-up (cameras 13-16)
+	 *  Multi 16-up (cameras 1-16)
+	 */
 	return 0;
 }
 
-- 
2.8.0

