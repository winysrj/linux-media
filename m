Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42080 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752763AbZFIMAb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 08:00:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] se401: Fix unsafe use of sprintf with identical
	source/destination
To: linux-media@vger.kernel.org, mchehab@infradead.org
Date: Tue, 09 Jun 2009 13:56:35 +0100
Message-ID: <20090609125546.10098.31807.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090609125408.10098.45945.stgit@t61.ukuu.org.uk>
References: <20090609125408.10098.45945.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

Closes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=13435

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/video/se401.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index 5990ab3..08129a8 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -1244,17 +1244,18 @@ static int se401_init(struct usb_se401 *se401, int button)
 	int i=0, rc;
 	unsigned char cp[0x40];
 	char temp[200];
+	int slen;
 
 	/* led on */
 	se401_sndctrl(1, se401, SE401_REQ_LED_CONTROL, 1, NULL, 0);
 
 	/* get camera descriptor */
 	rc=se401_sndctrl(0, se401, SE401_REQ_GET_CAMERA_DESCRIPTOR, 0, cp, sizeof(cp));
-	if (cp[1]!=0x41) {
+	if (cp[1] != 0x41) {
 		err("Wrong descriptor type");
 		return 1;
 	}
-	sprintf (temp, "ExtraFeatures: %d", cp[3]);
+	slen = snprintf(temp, 200, "ExtraFeatures: %d", cp[3]);
 
 	se401->sizes=cp[4]+cp[5]*256;
 	se401->width=kmalloc(se401->sizes*sizeof(int), GFP_KERNEL);
@@ -1269,9 +1270,10 @@ static int se401_init(struct usb_se401 *se401, int button)
 		    se401->width[i]=cp[6+i*4+0]+cp[6+i*4+1]*256;
 		    se401->height[i]=cp[6+i*4+2]+cp[6+i*4+3]*256;
 	}
-	sprintf (temp, "%s Sizes:", temp);
+	slen += snprintf (temp + slen, 200 - slen, " Sizes:");
 	for (i=0; i<se401->sizes; i++) {
-		sprintf(temp, "%s %dx%d", temp, se401->width[i], se401->height[i]);
+		slen += snprintf(temp + slen, 200 - slen,
+			" %dx%d", se401->width[i], se401->height[i]);
 	}
 	dev_info(&se401->dev->dev, "%s\n", temp);
 	se401->maxframesize=se401->width[se401->sizes-1]*se401->height[se401->sizes-1]*3;

