Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:36572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab0L0QXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 11:23:21 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNKW2000393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:23:20 -0500
Received: from gaivota (vpn-11-243.rdu.redhat.com [10.11.11.243])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRGNDpC028091
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 11:23:18 -0500
Date: Mon, 27 Dec 2010 14:22:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 8/8] [media] streamzap: Fix a compilation warning when
 compiled builtin
Message-ID: <20101227142242.295a3ddf@gaivota>
In-Reply-To: <cover.1293466891.git.mchehab@redhat.com>
References: <cover.1293466891.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

drivers/media/rc/streamzap.c: In function ‘streamzap_probe’:
drivers/media/rc/streamzap.c:460:2: warning: statement with no effect

Cc: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 7f82f55..6e2911c 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -73,7 +73,7 @@ MODULE_DEVICE_TABLE(usb, streamzap_table);
 #ifdef CONFIG_IR_RC5_SZ_DECODER_MODULE
 #define load_rc5_sz_decode()    request_module("ir-rc5-sz-decoder")
 #else
-#define load_rc5_sz_decode()    0
+#define load_rc5_sz_decode()    {}
 #endif
 
 enum StreamzapDecoderState {
-- 
1.7.3.4

