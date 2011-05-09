Return-path: <mchehab@gaivota>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:51308 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550Ab1EITyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:16 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 15/16] tm6000: remove unsued exports
Date: Mon,  9 May 2011 21:54:03 +0200
Message-Id: <1304970844-20955-15-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

remove unsued exports


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 57fd874..d7eb2e2 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -686,7 +686,6 @@ int tm6000_set_audio_rinput(struct tm6000_core *dev)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tm6000_set_audio_input);
 
 void tm6010_set_mute_sif(struct tm6000_core *dev, u8 mute)
 {
@@ -749,7 +748,6 @@ int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(tm6000_tvaudio_set_mute);
 
 void tm6010_set_volume_sif(struct tm6000_core *dev, int vol)
 {
@@ -807,7 +805,6 @@ void tm6000_set_volume(struct tm6000_core *dev, int vol)
 		break;
 	}
 }
-EXPORT_SYMBOL_GPL(tm6000_set_volume);
 
 static LIST_HEAD(tm6000_devlist);
 static DEFINE_MUTEX(tm6000_devlist_mutex);
-- 
1.7.4.2

