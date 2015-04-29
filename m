Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37622 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbbD2XG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Benjamin Larsson <benjamin@southpole.se>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alan Cox <alan@linux.intel.com>,
	Fabian Frederick <fabf@skynet.be>,
	Alan <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/27] r820t: fix identing
Date: Wed, 29 Apr 2015 20:05:49 -0300
Message-Id: <407ea2c2275d866d8ac081175c35ae978993897c.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/tuners/r820t.c:945 r820t_sysfreq_sel() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 71159a58860f..a7a8452e99d2 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -941,8 +941,8 @@ static int r820t_sysfreq_sel(struct r820t_priv *priv, u32 freq,
 		rc = r820t_write_reg_mask(priv, 0x10, 0x00, 0x04);
 		if (rc < 0)
 			return rc;
-	 }
-	 return 0;
+	}
+	return 0;
 }
 
 static int r820t_set_tv_standard(struct r820t_priv *priv,
-- 
2.1.0

