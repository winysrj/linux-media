Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B2CC43444
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B59F22063F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546976805;
	bh=Pj7xUyr21aO2DiDEGWnit6EfZcycdTdIu8PyslAMju8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NuOgM/+Hli827S/3pGwyy5LINqow9uNYvWFyMugdXAnMGmf7IKVwWlICI0yarMkT8
	 w5Olxd9rfBD1nBy7d69BZuf0jXVvlb6T3xKdH3vjs8JmrtcS3877ieuDxFRb71DncQ
	 VdUNJ/9E1mXgnMzB1UgJNYLrfasVrogj1oDOaR7M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbfAHTdA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:33:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731516AbfAHTdA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 14:33:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9396420663;
        Tue,  8 Jan 2019 19:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975979;
        bh=Pj7xUyr21aO2DiDEGWnit6EfZcycdTdIu8PyslAMju8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+sABZhs7aknlJpEAU9Vqvu5/cXtqVCMgeiMPgUtgUDP7yF8mUl/4VwP63iE1dKtO
         52hQl8ML7kYEaEbT0dtIZ8rE1Dzo/FwA4YPqrUx6lH9AUHJdQe0Qdvo9DDQVTihzTy
         eUB2eMW8Fq9qVv7+VnqGn5l4CyIFv+oi+/Zbz/YM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 21/53] media: firewire: Fix app_info parameter type in avc_ca{,_app}_info
Date:   Tue,  8 Jan 2019 14:31:49 -0500
Message-Id: <20190108193222.123316-21-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108193222.123316-1-sashal@kernel.org>
References: <20190108193222.123316-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit b2e9a4eda11fd2cb1e6714e9ad3f455c402568ff ]

Clang warns:

drivers/media/firewire/firedtv-avc.c:999:45: warning: implicit
conversion from 'int' to 'char' changes value from 159 to -97
[-Wconstant-conversion]
        app_info[0] = (EN50221_TAG_APP_INFO >> 16) & 0xff;
                    ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
drivers/media/firewire/firedtv-avc.c:1000:45: warning: implicit
conversion from 'int' to 'char' changes value from 128 to -128
[-Wconstant-conversion]
        app_info[1] = (EN50221_TAG_APP_INFO >>  8) & 0xff;
                    ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
drivers/media/firewire/firedtv-avc.c:1040:44: warning: implicit
conversion from 'int' to 'char' changes value from 159 to -97
[-Wconstant-conversion]
        app_info[0] = (EN50221_TAG_CA_INFO >> 16) & 0xff;
                    ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
drivers/media/firewire/firedtv-avc.c:1041:44: warning: implicit
conversion from 'int' to 'char' changes value from 128 to -128
[-Wconstant-conversion]
        app_info[1] = (EN50221_TAG_CA_INFO >>  8) & 0xff;
                    ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
4 warnings generated.

Change app_info's type to unsigned char to match the type of the
member msg in struct ca_msg, which is the only thing passed into the
app_info parameter in this function.

Link: https://github.com/ClangBuiltLinux/linux/issues/105

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/firewire/firedtv-avc.c | 6 ++++--
 drivers/media/firewire/firedtv.h     | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
index 5bde6c209cd7..b243e4a52f10 100644
--- a/drivers/media/firewire/firedtv-avc.c
+++ b/drivers/media/firewire/firedtv-avc.c
@@ -968,7 +968,8 @@ static int get_ca_object_length(struct avc_response_frame *r)
 	return r->operand[7];
 }
 
-int avc_ca_app_info(struct firedtv *fdtv, char *app_info, unsigned int *len)
+int avc_ca_app_info(struct firedtv *fdtv, unsigned char *app_info,
+		    unsigned int *len)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
@@ -1009,7 +1010,8 @@ int avc_ca_app_info(struct firedtv *fdtv, char *app_info, unsigned int *len)
 	return ret;
 }
 
-int avc_ca_info(struct firedtv *fdtv, char *app_info, unsigned int *len)
+int avc_ca_info(struct firedtv *fdtv, unsigned char *app_info,
+		unsigned int *len)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
diff --git a/drivers/media/firewire/firedtv.h b/drivers/media/firewire/firedtv.h
index 345d1eda8c05..5b18a08c6285 100644
--- a/drivers/media/firewire/firedtv.h
+++ b/drivers/media/firewire/firedtv.h
@@ -124,8 +124,10 @@ int avc_lnb_control(struct firedtv *fdtv, char voltage, char burst,
 		    struct dvb_diseqc_master_cmd *diseqcmd);
 void avc_remote_ctrl_work(struct work_struct *work);
 int avc_register_remote_control(struct firedtv *fdtv);
-int avc_ca_app_info(struct firedtv *fdtv, char *app_info, unsigned int *len);
-int avc_ca_info(struct firedtv *fdtv, char *app_info, unsigned int *len);
+int avc_ca_app_info(struct firedtv *fdtv, unsigned char *app_info,
+		    unsigned int *len);
+int avc_ca_info(struct firedtv *fdtv, unsigned char *app_info,
+		unsigned int *len);
 int avc_ca_reset(struct firedtv *fdtv);
 int avc_ca_pmt(struct firedtv *fdtv, char *app_info, int length);
 int avc_ca_get_time_date(struct firedtv *fdtv, int *interval);
-- 
2.19.1

