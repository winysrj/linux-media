Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:62024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab1GFSEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:33 -0400
Date: Wed, 6 Jul 2011 15:04:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFCv3 08/17] [media] siano: bad parameter is -EINVAL and not
 -EFAULT
Message-ID: <20110706150400.4aaee7a1@pedra>
In-Reply-To: <cover.1309974026.git.mchehab@redhat.com>
References: <cover.1309974026.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index 78765ed..7331e84 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -1147,7 +1147,7 @@ static int smscore_validate_client(struct smscore_device_t *coredev,
 
 	if (!client) {
 		sms_err("bad parameter.");
-		return -EFAULT;
+		return -EINVAL;
 	}
 	registered_client = smscore_find_client(coredev, data_type, id);
 	if (registered_client == client)
-- 
1.7.1


