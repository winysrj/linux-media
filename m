Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DC5C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 19:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449B62133D
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 19:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="dG7Nldub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfB0TQd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 14:16:33 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:35521 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727169AbfB0TQd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 14:16:33 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E0F3C44AA5;
        Wed, 27 Feb 2019 19:16:31 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.20.153])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 88ADB44AFA;
        Wed, 27 Feb 2019 19:16:26 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.3);
        Wed, 27 Feb 2019 19:16:31 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Invention-Fearful: 6fb81f3c0cc017a4_1551294987105_2558100825
X-MC-Loop-Signature: 1551294987105:4176022785
X-MC-Ingress-Time: 1551294987105
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id 0BB777FF24;
        Wed, 27 Feb 2019 11:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=+aDOGNQ5Np5BnUJzdLiI+WgLRG0=; b=dG7Nldub41X
        PewFKhSfrDwURVSzhpEa+vWhxYu2b0opAuentgkPtfXHxOpUEY5d/Coi/WncZXbm
        COLj6NxR77Yi0zRbN4mTBBDUIIvb4LbX0Y8WMAR97A6hJ7dbpFJXo9A0crWNyX4Y
        4e2Y2q5MD9b3yaRUaliG4WAMRrYgnLHM=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id B2BB17FF22;
        Wed, 27 Feb 2019 11:16:20 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v4 3/4] pvrusb2: Add i2c client demod/tuner support
Date:   Wed, 27 Feb 2019 13:16:05 -0600
Message-Id: <1551294966-12564-4-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551294966-12564-1-git-send-email-brad@nextdimension.cc>
References: <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
 <1551294966-12564-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrvddugdduvdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedt
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Cleanup code has been added to init in case of failure,
as well as to frontend exit.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes

 drivers/media/usb/pvrusb2/pvrusb2-dvb.c | 11 +++++++++++
 drivers/media/usb/pvrusb2/pvrusb2-dvb.h |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-dvb.c b/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
index cb5586b..8e1735f 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
@@ -404,6 +404,9 @@ static int pvr2_dvb_frontend_init(struct pvr2_dvb_adapter *adap)
 fail_frontend0:
 	dvb_frontend_detach(adap->fe[0]);
 	adap->fe[0] = NULL;
+	dvb_module_release(adap->i2c_client_tuner);
+	dvb_module_release(adap->i2c_client_demod[1]);
+	dvb_module_release(adap->i2c_client_demod[0]);
 
 	return ret;
 }
@@ -420,6 +423,14 @@ static int pvr2_dvb_frontend_exit(struct pvr2_dvb_adapter *adap)
 		dvb_frontend_detach(adap->fe[0]);
 		adap->fe[0] = NULL;
 	}
+
+	dvb_module_release(adap->i2c_client_tuner);
+	adap->i2c_client_tuner = NULL;
+	dvb_module_release(adap->i2c_client_demod[1]);
+	adap->i2c_client_demod[1] = NULL;
+	dvb_module_release(adap->i2c_client_demod[0]);
+	adap->i2c_client_demod[0] = NULL;
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-dvb.h b/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
index 91bff57..c0b27f5 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
@@ -20,6 +20,9 @@ struct pvr2_dvb_adapter {
 	struct dvb_net		dvb_net;
 	struct dvb_frontend	*fe[2];
 
+	struct i2c_client	*i2c_client_demod[2];
+	struct i2c_client	*i2c_client_tuner;
+
 	int			feedcount;
 	int			max_feed_count;
 
-- 
2.7.4

