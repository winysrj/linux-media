Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:62885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0L3Niq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 08:38:46 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUDckZj017697
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 08:38:46 -0500
Received: from gaivota (vpn-8-93.rdu.redhat.com [10.11.8.93])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUDcVPe021334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 08:38:42 -0500
Date: Thu, 30 Dec 2010 11:38:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] staging/lirc: Update lirc TODO files
Message-ID: <20101230113824.6eee5438@gaivota>
In-Reply-To: <7c674be189d9726c1f06be1d07cb06a740bd4b6d.1293716127.git.mchehab@redhat.com>
References: <7c674be189d9726c1f06be1d07cb06a740bd4b6d.1293716127.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 drivers/staging/lirc/TODO.lirc_i2c
 create mode 100644 drivers/staging/lirc/TODO.lirc_zilog

diff --git a/drivers/staging/lirc/TODO.lirc_i2c b/drivers/staging/lirc/TODO.lirc_i2c
deleted file mode 100644
index 1f0a6ff..0000000
--- a/drivers/staging/lirc/TODO.lirc_i2c
+++ /dev/null
@@ -1,3 +0,0 @@
-lirc_i2c provides support for some drivers that have already a RC
-driver under drivers/media/video. It should be integrated into those
-drivers, in special with drivers/media/video/ir-kbd-i2c.c.
diff --git a/drivers/staging/lirc/TODO.lirc_zilog b/drivers/staging/lirc/TODO.lirc_zilog
new file mode 100644
index 0000000..1b8a049
--- /dev/null
+++ b/drivers/staging/lirc/TODO.lirc_zilog
@@ -0,0 +1,13 @@
+The binding between hdpvr and lirc_zilog is currently disabled,
+due to an OOPS reported a few years ago when both the hdpvr and cx18 
+drivers were loaded in his system. More details can be seen at:
+	http://www.mail-archive.com/linux-media@vger.kernel.org/msg09163.html
+More tests need to be done, in order to fix the reported issue.
+
+There's a conflict between ir-kbd-i2c: Both provide support for RX events.
+Such conflict needs to be fixed, before moving it out of staging.
+
+The way I2C probe works, it will try to register the driver twice, one
+for RX and another for TX. The logic needs to be fixed to avoid such
+issue.
+
-- 
1.7.3.4

