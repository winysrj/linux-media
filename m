Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab0FEAV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:26 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o550LQJj010679
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:26 -0400
Received: from pedra (vpn-10-9.rdu.redhat.com [10.11.10.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o550LI7m015252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:24 -0400
Date: Fri, 4 Jun 2010 21:21:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] tm6000: Avoid OOPS when loading tm6000-alsa module
Message-ID: <20100604212109.7fa8b874@pedra>
In-Reply-To: <cover.1275696910.git.mchehab@redhat.com>
References: <cover.1275696910.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 55a0925..8520434 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -39,7 +39,7 @@
  ****************************************************************************/
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
-static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;       /* ID for this card */
+
 static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(enable, bool, NULL, 0444);
@@ -316,7 +316,7 @@ int tm6000_audio_init(struct tm6000_core *dev)
 	if (!enable[devnr])
 		return -ENOENT;
 
-	rc = snd_card_create(index[devnr], id[devnr], THIS_MODULE, 0, &card);
+	rc = snd_card_create(index[devnr], "tm6000", THIS_MODULE, 0, &card);
 	if (rc < 0) {
 		snd_printk(KERN_ERR "cannot create card instance %d\n", devnr);
 		return rc;
-- 
1.7.1


