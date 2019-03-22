Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF9FC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 14:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82E621900
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 14:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfCVOer (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:34:47 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:45333 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbfCVOer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 10:34:47 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MCKO4-1hGeds0802-009NoR; Fri, 22 Mar 2019 15:34:34 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Wenwen Wang <wang6495@umn.edu>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: davinci-isif: avoid uninitialized variable use
Date:   Fri, 22 Mar 2019 15:34:22 +0100
Message-Id: <20190322143431.1235295-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gWJLB09DU6mBS0YO7lWkZjIeBdL/QA0QBAycFVPj99/UjNQlJ2F
 JvaNabZuw522vpYWlISa17jvyfjzEZlkEYkIm6go6C9pyh84ond0U48+AREkoNULLrRH8YF
 YPL/Gu717BbllllXU9RjrLtgaFBV0/wTXZ2KM96SBH5I1rrJwkT4ficg4E/RdzsJETDUTXU
 cRzCSLgaCCUqygHhjHpWg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0BRdmWIO31I=:jlkRu8gFJiDS6D+V9NjMeQ
 pqCagyf4GbdoakItMLgRcWcjObKfpMbKtGlMhF9S2UTwNU69SQcc/kJ3N3ovIqutQs2E6V1HW
 JBF1ut7l44t/wQkFW08jkc2hkh1/RhEHmDElgNzAG3w8kW4Gb94MeWX45s2GR0Dd7v8KDyiuk
 k1t5ZAtlpM2eZoaAmFfnayggT1QzrIRvx2BRZAfv9IrwU9KSgXSHoHq4O3b2+7wYlrx8jn6zY
 NrRxssle7LKGq75wqE5hkIwrvccVD4qpU3O02ZhqgTEaISfo+qQB6SqA7W/Chjq+EDP8Aq8FT
 AxeuXoJUe0LXS2UeFNlHTSKifrIQPUklcTGpvTAUEzUIPtkwBwmkayYjXWzcxE4itVuH5ZOba
 6hUzqz92EspfUwEIeksfbM+FtKJeAsMSgZBw975jGYE7/NYs5gqsk+d2A5NFyhntEmx/fhfQ6
 KpWL+h4uoUSP9ahkHKNBCDMhdzhjhw4OMfOhVtziQBQVSyAU5/6hl5NiyhzmGovYFx4Cl/GiX
 dztouBecJRM+RFpFYyPFXq40AEn8B+ZEiPOxbRe6MacpowDY71mAsFq+PliQf1PJCYy3Cris1
 ghCwP2VbKnvp5HRCZmUObg+pDD6wpIYeoZBY2kjDULFdUvRyYWFFXAGIjQQ+HLf/JWLPkhc+m
 T52I9f/932kyzAMjbr8coqLQDQ8yHtzxURDt2PCTZgd7OpNhZeh55ET+QNGkq+iX/C6qaSi+j
 PloBjhMQfwlMuRUuPAclU0m8wP3lhzZofsDjDg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

clang warns about a possible variable use that gcc never
complained about:

drivers/media/platform/davinci/isif.c:982:32: error: variable 'frame_size' is uninitialized when used here
      [-Werror,-Wuninitialized]
                dm365_vpss_set_pg_frame_size(frame_size);
                                             ^~~~~~~~~~
drivers/media/platform/davinci/isif.c:887:2: note: variable 'frame_size' is declared here
        struct vpss_pg_frame_size frame_size;
        ^
1 error generated.

There is no initialization for this variable at all, and there
has never been one in the mainline kernel, so we really should
not put that stack data into an mmio register.

On the other hand, I suspect that gcc checks the condition
more closely and notices that the global
isif_cfg.bayer.config_params.test_pat_gen flag is initialized
to zero and never written to from any code path, so anything
depending on it can be eliminated.

To shut up the clang warning, just remove the dead code manually,
it has probably never been used because any attempt to do so
would have resulted in undefined behavior.

Fixes: 63e3ab142fa3 ("V4L/DVB: V4L - vpfe capture - source for ISIF driver on DM365")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/davinci/isif.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index 47cecd10eb9f..2dee9af6d413 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -884,9 +884,7 @@ static int isif_set_hw_if_params(struct vpfe_hw_if_param *params)
 static int isif_config_ycbcr(void)
 {
 	struct isif_ycbcr_config *params = &isif_cfg.ycbcr;
-	struct vpss_pg_frame_size frame_size;
 	u32 modeset = 0, ccdcfg = 0;
-	struct vpss_sync_pol sync;
 
 	dev_dbg(isif_cfg.dev, "\nStarting isif_config_ycbcr...");
 
@@ -974,13 +972,6 @@ static int isif_config_ycbcr(void)
 		/* two fields are interleaved in memory */
 		regw(0x00000249, SDOFST);
 
-	/* Setup test pattern if enabled */
-	if (isif_cfg.bayer.config_params.test_pat_gen) {
-		sync.ccdpg_hdpol = params->hd_pol;
-		sync.ccdpg_vdpol = params->vd_pol;
-		dm365_vpss_set_sync_pol(sync);
-		dm365_vpss_set_pg_frame_size(frame_size);
-	}
 	return 0;
 }
 
-- 
2.20.0

