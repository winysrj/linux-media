Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020Ab0JGB6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 21:58:03 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o971w25R013894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 6 Oct 2010 21:58:02 -0400
Received: from pedra (vpn-225-141.phx2.redhat.com [10.3.225.141])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o971uuB7028164
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 6 Oct 2010 21:58:01 -0400
Date: Wed, 6 Oct 2010 22:56:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] V4L/DVB: tm6000: Fix warnings due to a small array size
Message-ID: <20101006225647.3713c328@pedra>
In-Reply-To: <ecc736735ecf922d7f31d34417f7c42f8ec9eb67.1286416568.git.mchehab@redhat.com>
References: <ecc736735ecf922d7f31d34417f7c42f8ec9eb67.1286416568.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

drivers/staging/tm6000/tm6000-stds.c:101: warning: excess elements in array initializer
drivers/staging/tm6000/tm6000-stds.c:101: warning: (near initialization for ‘tv_stds[0].common’)
drivers/staging/tm6000/tm6000-stds.c:160: warning: excess elements in array initializer
drivers/staging/tm6000/tm6000-stds.c:160: warning: (near initialization for ‘tv_stds[1].common’)
drivers/staging/tm6000/tm6000-stds.c:219: warning: excess elements in array initializer
drivers/staging/tm6000/tm6000-stds.c:219: warning: (near initialization for ‘tv_stds[2].common’)
drivers/staging/tm6000/tm6000-stds.c:336: warning: excess elements in array initializer
drivers/staging/tm6000/tm6000-stds.c:336: warning: (near initialization for ‘tv_stds[4].common’)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index f6aa753..fe22f42 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -32,7 +32,7 @@ struct tm6000_std_tv_settings {
 	v4l2_std_id id;
 	struct tm6000_reg_settings sif[12];
 	struct tm6000_reg_settings nosif[12];
-	struct tm6000_reg_settings common[25];
+	struct tm6000_reg_settings common[26];
 };
 
 struct tm6000_std_settings {
-- 
1.7.1

