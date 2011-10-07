Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61187 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1JGVLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 17:11:43 -0400
Received: by wwf22 with SMTP id 22so6496509wwf.1
        for <linux-media@vger.kernel.org>; Fri, 07 Oct 2011 14:11:42 -0700 (PDT)
Message-ID: <4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
Subject: [PATCH] af9013 Extended monitoring in set_frontend.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Fri, 07 Oct 2011 22:11:34 +0100
In-Reply-To: <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	 <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	 <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	 <4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	 <CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	 <CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	 <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Try this patch, it should stop start up corruption on the same frontend.

It is a missing section of code that checks the frontend is ready to go.

However, it will not stop corruptions on frontend A.

af9013 Extended monitoring in set_front.

---
 drivers/media/dvb/frontends/af9013.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index b220a87..347c187 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -622,8 +622,9 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
 	struct dvb_frontend_parameters *params)
 {
 	struct af9013_state *state = fe->demodulator_priv;
-	int ret;
+	int ret, i;
 	u8 auto_mode; /* auto set TPS */
+	u8 v1, v2;
 
 	deb_info("%s: freq:%d bw:%d\n", __func__, params->frequency,
 		params->u.ofdm.bandwidth);
@@ -694,6 +695,19 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
 	if (ret)
 		goto error;
 
+	for (i = 0; i < 27; ++i) {
+		ret = af9013_read_reg(state, 0x9bc2, &v1);
+		if (ret)
+			break;
+		ret = af9013_read_reg(state, 0xd330, &v2);
+		if (ret)
+			break;
+		if (v1 == 0 && v2 > 0)
+				break;
+		msleep(40);
+	}
+
+
 error:
 	return ret;
 }
-- 
1.7.5.4


