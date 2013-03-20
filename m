Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:7070 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3CTD0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 23:26:39 -0400
Message-ID: <51492C51.3080407@asianux.com>
Date: Wed, 20 Mar 2013 11:26:09 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>, dhowells@redhat.com
CC: Greg KH <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] drivers/staging/media/go7007: using strlcpy instead of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


  for NUL terminated string, need always set '\0' in the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/staging/media/go7007/snd-go7007.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
index 5af29ff..6f6271e 100644
--- a/drivers/staging/media/go7007/snd-go7007.c
+++ b/drivers/staging/media/go7007/snd-go7007.c
@@ -267,9 +267,9 @@ int go7007_snd_init(struct go7007 *go)
 		kfree(gosnd);
 		return ret;
 	}
-	strncpy(gosnd->card->driver, "go7007", sizeof(gosnd->card->driver));
-	strncpy(gosnd->card->shortname, go->name, sizeof(gosnd->card->driver));
-	strncpy(gosnd->card->longname, gosnd->card->shortname,
+	strlcpy(gosnd->card->driver, "go7007", sizeof(gosnd->card->driver));
+	strlcpy(gosnd->card->shortname, go->name, sizeof(gosnd->card->driver));
+	strlcpy(gosnd->card->longname, gosnd->card->shortname,
 			sizeof(gosnd->card->longname));
 
 	gosnd->pcm->private_data = go;
-- 
1.7.7.6
