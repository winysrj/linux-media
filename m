Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab3DQAm5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:57 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gv7O024296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 07/31] [media] rtl820t: Add a debug msg when PLL gets locked
Date: Tue, 16 Apr 2013 21:42:18 -0300
Message-Id: <1366159362-3773-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	[ 2255.342797] r820t 3-001a: generic_set_freq: PLL locked on frequency 725476191 Hz, gain=45

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 5cd8256..1821cf1 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1215,6 +1215,12 @@ static int generic_set_freq(struct dvb_frontend *fe,
 		goto err;
 
 	rc = r820t_sysfreq_sel(priv, freq, type, std, delsys);
+	if (rc < 0)
+		goto err;
+
+	tuner_dbg("%s: PLL locked on frequency %d Hz, gain=%d\n",
+		  __func__, freq, r820t_read_gain(priv));
+
 err:
 
 	if (rc < 0)
-- 
1.8.1.4

