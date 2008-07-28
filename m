Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SJx01r028093
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 15:59:00 -0400
Received: from smtp5.pp.htv.fi (smtp5.pp.htv.fi [213.243.153.39])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SJwmaW025098
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 15:58:48 -0400
Date: Mon, 28 Jul 2008 22:58:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Message-ID: <20080728195805.GA7713@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [2.6 patch] DVB_DRX397XD: remove FW_LOADER select
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Also for the new DVB_DRX397XD driver the FW_LOADER select and the 
corresponding dependency on HOTPLUG can be removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
16b93b65909268a6236971de1dbc882bc90b62bf 
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 574dffe..7dbb4a2 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -135,9 +135,8 @@ config DVB_CX22702
 
 config DVB_DRX397XD
 	tristate "Micronas DRX3975D/DRX3977D based"
-	depends on DVB_CORE && I2C && HOTPLUG
+	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	select FW_LOADER
 	help
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
