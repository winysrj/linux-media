Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:44248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab1GKB76 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:58 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xwun023483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:58 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKf030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:57 -0400
Date: Sun, 10 Jul 2011 22:59:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 16/21] [media] drxk: Print detected configuration
Message-ID: <20110710225902.5aa28fee@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

DRX-K configuration is interesting when writing/testing
new devices. Add an info line showing the discovered info.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 91f3296..0d288a7 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -905,6 +905,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	u16 sioPdrOhwCfg = 0;
 	u32 sioTopJtagidLo = 0;
 	int status;
+	const char *spin = "";
 
 	dprintk(1, "\n");
 
@@ -954,12 +955,15 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	switch ((sioTopJtagidLo >> 29) & 0xF) {
 	case 0:
 		state->m_deviceSpin = DRXK_SPIN_A1;
+		spin = "A1";
 		break;
 	case 2:
 		state->m_deviceSpin = DRXK_SPIN_A2;
+		spin = "A2";
 		break;
 	case 3:
 		state->m_deviceSpin = DRXK_SPIN_A3;
+		spin = "A3";
 		break;
 	default:
 		state->m_deviceSpin = DRXK_SPIN_UNKNOWN;
@@ -1079,6 +1083,12 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 		goto error2;
 	}
 
+	printk(KERN_INFO
+	       "drxk: detected a drx-39%02xk, spin %s, xtal %d.%03d MHz\n",
+	       ((sioTopJtagidLo >> 12) & 0xFF), spin,
+	       state->m_oscClockFreq / 1000,
+	       state->m_oscClockFreq % 1000);
+
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
-- 
1.7.1


