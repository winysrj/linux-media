Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1FAS0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 14:26:07 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p51IQ7At000672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 1 Jun 2011 14:26:07 -0400
Received: from pedra (vpn2-11-228.ams2.redhat.com [10.36.11.228])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p51IQ5wi020552
	for <linux-media@vger.kernel.org>; Wed, 1 Jun 2011 14:26:06 -0400
Date: Wed, 1 Jun 2011 15:25:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] soc_camera: preserve const attribute
Message-ID: <20110601152508.2ed9710b@pedra>
In-Reply-To: <76df01eacd5fa41b607426a8cb091fb21ae35554.1306951494.git.mchehab@redhat.com>
References: <76df01eacd5fa41b607426a8cb091fb21ae35554.1306951494.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

drivers/media/video/soc_camera.c: In function ‘soc_camera_video_start’:
drivers/media/video/soc_camera.c:1515: warning: initialization discards qualifiers from pointer target type

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 3988643..4e4d412 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1512,7 +1512,7 @@ static int video_dev_create(struct soc_camera_device *icd)
  */
 static int soc_camera_video_start(struct soc_camera_device *icd)
 {
-	struct device_type *type = icd->vdev->dev.type;
+	const struct device_type *type = icd->vdev->dev.type;
 	int ret;
 
 	if (!icd->dev.parent)
-- 
1.7.1

