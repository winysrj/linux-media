Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbFXKtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: [PATCH 3/7] [media] use CONFIG_PM_SLEEP for suspend/resume
Date: Wed, 24 Jun 2015 07:49:07 -0300
Message-Id: <565e229d31527f166090d0368a3c348755838899.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using CONFIG_PM_SLEEP suppress the warnings when the driver is
compiled without PM sleep functions:

drivers/media/rc/st_rc.c:338:12: warning: ‘st_rc_suspend’ defined but not used [-Wunused-function]
drivers/media/rc/st_rc.c:359:12: warning: ‘st_rc_resume’ defined but not used [-Wunused-function]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 979b40561b3a..37d040158dff 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -334,7 +334,7 @@ err:
 	return ret;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int st_rc_suspend(struct device *dev)
 {
 	struct st_rc_device *rc_dev = dev_get_drvdata(dev);
-- 
2.4.3

