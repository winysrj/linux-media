Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28087 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1IEPZ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 11:25:29 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCHv5 5/5] libmediactl: get rid of memset via using calloc
Date: Mon,  5 Sep 2011 18:24:07 +0300
Message-Id: <c6fb27f616b6e6b0b99e690109ba6a2466ba980d.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <201109051657.21646.laurent.pinchart@ideasonboard.com>
 <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code snippet
	x = malloc(sizeof(*x));
	memset(x, 0, sizeof(*x));
could be easily changed to
	x = calloc(1, sizeof(*x));

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 src/media.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/media.c b/src/media.c
index 6c03369..38ebaac 100644
--- a/src/media.c
+++ b/src/media.c
@@ -415,12 +415,11 @@ struct media_device *media_open(const char *name, int verbose)
 	struct media_private *priv;
 	int ret;
 
-	media = malloc(sizeof(*media));
+	media = calloc(1, sizeof(*media));
 	if (media == NULL) {
 		printf("%s: unable to allocate memory\n", __func__);
 		return NULL;
 	}
-	memset(media, 0, sizeof(*media));
 
 	if (verbose)
 		printf("Opening media device %s\n", name);
@@ -431,13 +430,12 @@ struct media_device *media_open(const char *name, int verbose)
 		return NULL;
 	}
 
-	priv = malloc(sizeof(*priv));
+	priv = calloc(1, sizeof(*priv));
 	if (priv == NULL) {
 		printf("%s: unable to allocate memory\n", __func__);
 		media_close(media);
 		return NULL;
 	}
-	memset(priv, 0, sizeof(*priv));
 
 	/* Fill the private structure */
 	priv->media = media;
-- 
1.7.5.4

