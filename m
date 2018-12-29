Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D57AC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3B621871
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="c18QMNRZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbeL2Rvl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:41 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:3688 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727682AbeL2Rvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:38 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BEF7D5026BF;
        Sat, 29 Dec 2018 17:51:37 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.30.62])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 7C097502A58;
        Sat, 29 Dec 2018 17:51:37 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:37 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Chief-Grain: 011d243b528d894e_1546105897637_230605451
X-MC-Loop-Signature: 1546105897637:1802276361
X-MC-Ingress-Time: 1546105897636
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id 23F0F805D7;
        Sat, 29 Dec 2018 09:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=aKdB+DSMa7+voXtdCTUe8jZHwxU=; b=c18QMNRZhaJ
        qFQyVyqmqtjiklqVhCg3ocT8lxVLrhf1SBLfREizbmMMNpKSYE+Ddo00R7BhbVwn
        Pz4uMrQ4y6jegmQnVneUEW88aEmwfL6AryIOhPCUL9R5y76HazFKQPnSnzS67myM
        MIurkCAGdZKTRcjUD1nvW9CseKCU94Nc=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id 9F9D9805E8;
        Sat, 29 Dec 2018 09:51:36 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 13/13] lgdt3306a: Add CNR v5 stat
Date:   Sat, 29 Dec 2018 11:51:22 -0600
Message-Id: <1546105882-15693-14-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrtdekgddutdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpeel
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The CNR is already calculated, so populate DVBv5 CNR stat
during read_status.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index cee9c83..8b24748 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -855,6 +855,7 @@ static int lgdt3306a_fe_sleep(struct dvb_frontend *fe)
 static int lgdt3306a_init(struct dvb_frontend *fe)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 val;
 	int ret;
 
@@ -1006,6 +1007,9 @@ static int lgdt3306a_init(struct dvb_frontend *fe)
 	ret = lgdt3306a_sleep(state);
 	lg_chkerr(ret);
 
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 fail:
 	return ret;
 }
@@ -1606,6 +1610,7 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe,
 				 enum fe_status *status)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u16 strength = 0;
 	int ret = 0;
 
@@ -1646,6 +1651,15 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe,
 		default:
 			ret = -EINVAL;
 		}
+
+		if (*status & FE_HAS_SYNC) {
+			c->cnr.len = 1;
+			c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+			c->cnr.stat[0].svalue = lgdt3306a_calculate_snr_x100(state) * 10;
+		} else {
+			c->cnr.len = 1;
+			c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		}
 	}
 	return ret;
 }
-- 
2.7.4

