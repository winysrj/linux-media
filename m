Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab1FAS0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 14:26:10 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p51IQAhU028481
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 1 Jun 2011 14:26:10 -0400
Received: from pedra (vpn2-11-228.ams2.redhat.com [10.36.11.228])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p51IQ5wj020552
	for <linux-media@vger.kernel.org>; Wed, 1 Jun 2011 14:26:08 -0400
Date: Wed, 1 Jun 2011 15:25:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] uvc_entity: initialize return value
Message-ID: <20110601152510.4cc7f02a@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

drivers/media/video/uvc/uvc_entity.c: In function ‘uvc_mc_register_entities’:
drivers/media/video/uvc/uvc_entity.c:33: warning: ‘ret’ may be used uninitialized in this function

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/uvc/uvc_entity.c b/drivers/media/video/uvc/uvc_entity.c
index ede7852..c3ab0c8 100644
--- a/drivers/media/video/uvc/uvc_entity.c
+++ b/drivers/media/video/uvc/uvc_entity.c
@@ -30,7 +30,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 	struct uvc_entity *remote;
 	unsigned int i;
 	u8 remote_pad;
-	int ret;
+	int ret = 0;
 
 	for (i = 0; i < entity->num_pads; ++i) {
 		struct media_entity *source;
-- 
1.7.1


