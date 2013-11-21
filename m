Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53814 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3KUDip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Nov 2013 22:38:45 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so105119bkz.39
        for <linux-media@vger.kernel.org>; Wed, 20 Nov 2013 19:38:44 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Nov 2013 11:38:44 +0800
Message-ID: <CAPgLHd8kj=RF2N0oxkPjriLf=BSR58MX8rM5KPiiUWE0YE-1Cg@mail.gmail.com>
Subject: [PATCH] [media] cx88: use correct pci drvdata type in cx88_audio_finidev()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, hans.verkuil@cisco.com,
	sachin.kamat@linaro.org, gregkh@linuxfoundation.org,
	michael.opdenacker@free-electrons.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

We had set the pci drvdata in cx88_audio_initdev() as a type of
struct snd_card, so cx88_audio_finidev() should used it as the
same type too.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/pci/cx88/cx88-alsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 400eb1c..d014206e 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -931,9 +931,9 @@ error:
  */
 static void cx88_audio_finidev(struct pci_dev *pci)
 {
-	struct cx88_audio_dev *card = pci_get_drvdata(pci);
+	struct snd_card *card = pci_get_drvdata(pci);
 
-	snd_card_free((void *)card);
+	snd_card_free(card);
 
 	devno--;
 }

