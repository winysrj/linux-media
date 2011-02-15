Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1BONdu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 08:33:50 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDXoHU008488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:33:50 -0500
Received: from pedra (vpn-239-107.phx2.redhat.com [10.3.239.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDXmOx005481
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:33:49 -0500
Date: Tue, 15 Feb 2011 11:33:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] tuner-core: Don't touch at standby during
 tuner_lookup
Message-ID: <20110215113336.51fd62f9@pedra>
In-Reply-To: <cover.1297776328.git.mchehab@redhat.com>
References: <cover.1297776328.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It makes no sense that tuner_lookup would touch at the standby
state. Remove it.

Thanks-to: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index a91a299..9363ed9 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -538,7 +538,6 @@ static void tuner_lookup(struct i2c_adapter *adap,
 			continue;
 
 		mode_mask = pos->mode_mask;
-		pos->standby = 1;
 		if (*radio == NULL && mode_mask == T_RADIO)
 			*radio = pos;
 		/* Note: currently TDA9887 is the only demod-only
-- 
1.7.1

