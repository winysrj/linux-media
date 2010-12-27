Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:25376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0L0Q3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:29:44 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGTi36031919
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:29:44 -0500
Received: from gaivota (vpn-11-243.rdu.redhat.com [10.11.11.243])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNDpI028091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:29:41 -0500
Date: Mon, 27 Dec 2010 14:22:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/8] [media] radio-wl1273: Fix two warnings
Message-ID: <20101227142248.584002fb@gaivota>
In-Reply-To: <cover.1293466891.git.mchehab@redhat.com>
References: <cover.1293466891.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

drivers/media/radio/radio-wl1273.c: In function ‘wl1273_fm_upload_firmware_patch’:
drivers/media/radio/radio-wl1273.c:675:2: warning: ‘n’ may be used uninitialized in this function
drivers/media/radio/radio-wl1273.c:675:2: warning: ‘i’ may be used uninitialized in this function

Those vars are never initialized, and the debug message makes no sense, as it
will show just two random values.

Cc: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 1813790..dd6bd36 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -645,7 +645,7 @@ static int wl1273_fm_upload_firmware_patch(struct wl1273_device *radio)
 	const char *fw_name = "radio-wl1273-fw.bin";
 	struct device *dev = radio->dev;
 	__u8 *ptr;
-	int i, n, r;
+	int r;
 
 	dev_dbg(dev, "%s:\n", __func__);
 
@@ -672,7 +672,6 @@ static int wl1273_fm_upload_firmware_patch(struct wl1273_device *radio)
 	/* ignore possible error here */
 	wl1273_fm_write_cmd(core, WL1273_RESET, 0);
 
-	dev_dbg(dev, "n: %d, i: %d\n", n, i);
 	dev_dbg(dev, "%s - download OK, r: %d\n", __func__, r);
 out:
 	release_firmware(fw_p);
-- 
1.7.3.4


