Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3EFC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D653F2070D
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 21:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfCMVKz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:10:55 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:54921 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfCMVKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 17:10:55 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mw9Dg-1gnkgq23iW-00sAMA; Wed, 13 Mar 2019 22:10:44 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ioannis Valasakis <code@wizofe.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: davinci_vpfe: fix large stack usage with clang
Date:   Wed, 13 Mar 2019 22:10:29 +0100
Message-Id: <20190313211042.4131426-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lkFtZ02KwH1msqPwqlwjI46jemgyHH4J05FGQBctqc9zB0J5Fpf
 ueQ1nCWMGBXusl6ENO51MeoDfU1x+klPcSsfb6ob4hotfYvu34ODl8XcmT69yLjtT7dz9nE
 Uyl35RDH2FXDUsQmxaLDtwDKXxaOMDcbOjXjR8IcAkGDUPArpWLW6A0V8JIzsezlsxa+jEl
 2IdrDcKmAWOsex4E9LGfA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pwev2Tadjn0=:kXoQG77WPUw0wtSKyiRJyx
 UBeXoUaPnJEfItRBtPix+6f4HYQyF/L5Mi3rEPaXkZDDPaVkwNsbC8hxKlVGbfWL2ycgdIIJ7
 hascc3qSaM9r8J1e1Bx13GfrfSVQkM54TrYYxOfEVc3hdEgNak1s9tTdNh8wZz+3TdI1/jAYj
 byYmZJvpMcx1pNmKzvyypHZUQVdZWsmOVlyZ9YW7Oo0rbOFGEv/reNMO6p7b33YE4tIoetfAA
 0r9oyLf/eN4chRMVDORNIt3sSznvvAf4s9LIDNMdBkspQ23L9DBRdbsTTArLfy97K6VPm3KER
 rUmAIZJP01U5ATPuNP09T7ARsty5/M5Zr9/Ut7ecayuI/VAJK7eQwiQwqr5fW5OyMhyo6GdAg
 PU3Lt7rCetSCVituhBCzNPP7TvpCzleXAgdUBmDgHKThRkyOSQmu25eg5oLGTIuqqfdLBAOxR
 /W2nNKhHatwe7A3WVSn0aKWJ1vaoX/syS0H0zZjyS0uW0+B5LoCFVH25pWte6n8ZYNSSLxUpX
 RZj6HCDPq8dSm8IHlBvq7I4EPSNasC9013H2nxXK972SuwHDN5O+GusAlbWGRtvBjGO4HH1Lm
 uKUrQH6r2gZ8Rwr9xtp9/Gzc27OJVGnqoWHV6gFdJKPKkXwRjwIjfLneG2aJMCMRL1zFsbJ9e
 DFkQxfKYBY7ll7bt6yWBJLKB961NcRRCtWJj20GrbBovImUx6VvZiJX4Wudq0ci6Nw/B8U4RN
 y15fgjUGpqVaDTgKd6S/hml8y9TKhYi67TsnCg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

clang is unable to optimize the isif_ioctl() in the same way that
gcc does, as it fails to prove that the local copy of
the 'struct vpfe_isif_raw_config' argument is unnecessary:

drivers/staging/media/davinci_vpfe/dm365_isif.c:622:13: error: stack frame size of 1344 bytes in function 'isif_ioctl' [-Werror,-Wframe-larger-than=]

Marking it as 'const' while passing the data down clearly shows us that
the copy is never modified, and we can skip copying it entirely, which
reduces the stack usage to just eight bytes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../staging/media/davinci_vpfe/dm365_isif.c   | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 0a6d038fcec9..46fd8184fc77 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -433,9 +433,9 @@ static int isif_get_params(struct v4l2_subdev *sd, void *params)
 	return 0;
 }
 
-static int isif_validate_df_csc_params(struct vpfe_isif_df_csc *df_csc)
+static int isif_validate_df_csc_params(const struct vpfe_isif_df_csc *df_csc)
 {
-	struct vpfe_isif_color_space_conv *csc;
+	const struct vpfe_isif_color_space_conv *csc;
 	int err = -EINVAL;
 	int i;
 
@@ -481,7 +481,7 @@ static int isif_validate_df_csc_params(struct vpfe_isif_df_csc *df_csc)
 #define DM365_ISIF_MAX_DFCMEM0		0x1fff
 #define DM365_ISIF_MAX_DFCMEM1		0x1fff
 
-static int isif_validate_dfc_params(struct vpfe_isif_dfc *dfc)
+static int isif_validate_dfc_params(const struct vpfe_isif_dfc *dfc)
 {
 	int err = -EINVAL;
 	int i;
@@ -532,7 +532,7 @@ static int isif_validate_dfc_params(struct vpfe_isif_dfc *dfc)
 #define DM365_ISIF_MAX_CLVSV			0x1fff
 #define DM365_ISIF_MAX_HEIGHT_BLACK_REGION	0x1fff
 
-static int isif_validate_bclamp_params(struct vpfe_isif_black_clamp *bclamp)
+static int isif_validate_bclamp_params(const struct vpfe_isif_black_clamp *bclamp)
 {
 	int err = -EINVAL;
 
@@ -580,7 +580,7 @@ static int isif_validate_bclamp_params(struct vpfe_isif_black_clamp *bclamp)
 }
 
 static int
-isif_validate_raw_params(struct vpfe_isif_raw_config *params)
+isif_validate_raw_params(const struct vpfe_isif_raw_config *params)
 {
 	int ret;
 
@@ -593,20 +593,18 @@ isif_validate_raw_params(struct vpfe_isif_raw_config *params)
 	return isif_validate_bclamp_params(&params->bclamp);
 }
 
-static int isif_set_params(struct v4l2_subdev *sd, void *params)
+static int isif_set_params(struct v4l2_subdev *sd, const struct vpfe_isif_raw_config *params)
 {
 	struct vpfe_isif_device *isif = v4l2_get_subdevdata(sd);
-	struct vpfe_isif_raw_config isif_raw_params;
 	int ret = -EINVAL;
 
 	/* only raw module parameters can be set through the IOCTL */
 	if (isif->formats[ISIF_PAD_SINK].code != MEDIA_BUS_FMT_SGRBG12_1X12)
 		return ret;
 
-	memcpy(&isif_raw_params, params, sizeof(isif_raw_params));
-	if (!isif_validate_raw_params(&isif_raw_params)) {
-		memcpy(&isif->isif_cfg.bayer.config_params, &isif_raw_params,
-			sizeof(isif_raw_params));
+	if (!isif_validate_raw_params(params)) {
+		memcpy(&isif->isif_cfg.bayer.config_params, params,
+			sizeof(*params));
 		ret = 0;
 	}
 	return ret;
-- 
2.20.0

