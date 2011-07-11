Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:13354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab1GKCAC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 22:00:02 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B2028d018193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:02 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKh030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:01 -0400
Date: Sun, 10 Jul 2011 22:59:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 18/21] [media] drxk: Fix driver removal
Message-ID: <20110710225903.2e34373b@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index aaef8e3..7ea73df 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6431,6 +6431,18 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	if (init_drxk(state) < 0)
 		goto error;
 	*fe_t = &state->t_frontend;
+
+#ifdef CONFIG_MEDIA_ATTACH
+	/*
+	 * HACK: As this function initializes both DVB-T and DVB-C fe symbols,
+	 * and calling it twice would create the state twice, leading into
+	 * memory leaks, the right way is to call it only once. However, dvb
+	 * release functions will call symbol_put twice. So, the solution is to
+	 * artificially increment the usage count, in order to allow the
+	 * driver to be released.
+	 */
+	symbol_get(drxk_attach);
+#endif
 	return &state->c_frontend;
 
 error:
-- 
1.7.1


