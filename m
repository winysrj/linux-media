Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab3DQAnA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:43:00 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0h0gj031274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:43:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 22/31] [media] r820t: add a commented code for GPIO
Date: Tue, 16 Apr 2013 21:42:33 -0300
Message-Id: <1366159362-3773-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the code to set the GPIO for this tuner. This code is
currently unused, so it is kept there only for completeness.
With this patch there are just two things that got left from
the original driver:
- At standby, there's another mode, not used by rtl2832u.
  Not sure if it might be needed in the future, but I suspect
  it is not used at all;
- There is a "fast tune" mode. As nor DVB or V4L API supports
  it, it seems an overkill to implement it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index fa2e9ae..0125de8 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2055,6 +2055,14 @@ static int r820t_imr_callibrate(struct r820t_priv *priv)
 	return 0;
 }
 
+#if 0
+/* Not used, for now */
+static int r820t_gpio(struct r820t_priv *priv, bool enable)
+{
+	return r820t_write_reg_mask(priv, 0x0f, enable ? 1 : 0, 0x01);
+}
+#endif
+
 /*
  *  r820t frontend operations and tuner attach code
  *
-- 
1.8.1.4

