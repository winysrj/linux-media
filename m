Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195A1C00319
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEF44218A4
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="EbGZ65d0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfB0S2N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:28:13 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:7758 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726389AbfB0S2L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 13:28:11 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 75CF73E44C2;
        Wed, 27 Feb 2019 18:28:10 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.24.101])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id DD0FC3E352D;
        Wed, 27 Feb 2019 18:28:09 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.3);
        Wed, 27 Feb 2019 18:28:10 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Abaft-Skirt: 26d53c7c19fc6626_1551292090079_3366494230
X-MC-Loop-Signature: 1551292090079:1074128272
X-MC-Ingress-Time: 1551292090078
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id 2E9B57FEFA;
        Wed, 27 Feb 2019 10:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=V8sENwBvGnydSSoY5uJr9MBFHIY=; b=EbGZ65d01EJ
        QLLDjz4K/HvJcYk7bsKnArpNBMyHWShOAa0nAoC143z17SAl2lBcePk2pqKdJA3h
        vZoImPpu0U13sRvHIjAHHsWpiaQTFHW6hfDPemKgxMElDqMHrjbfANq29WumryR7
        nFvq/99I+ylv3kFkBwkwtFjQft6sWGNg=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id 204AA7FF0A;
        Wed, 27 Feb 2019 10:28:07 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 12/12] lgdt3306a: Add CNR v5 stat
Date:   Wed, 27 Feb 2019 12:27:46 -0600
Message-Id: <1551292066-29574-13-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551292066-29574-1-git-send-email-brad@nextdimension.cc>
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
 <1551292066-29574-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrvddugdduudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpeduvd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The CNR is already calculated, so populate DVBv5 CNR stat
during read_status.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes

 drivers/media/dvb-frontends/lgdt3306a.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 99c6289..ceaf617 100644
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

