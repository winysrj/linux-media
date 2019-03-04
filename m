Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C77C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68DA120823
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfCDUaL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:30:11 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:55397 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfCDUaL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 15:30:11 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MO9vD-1gcViX2feL-00OXfP; Mon, 04 Mar 2019 21:30:04 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: staging: davinci_vpfe: disallow building with COMPILE_TEST
Date:   Mon,  4 Mar 2019 21:29:44 +0100
Message-Id: <20190304203003.1862052-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:4c01V9w91qzHHbFccpQVbOJQYftH7MrRuBv6+LwmYEj9BS8INWB
 m+T9va+Fhp5T1pSG0D1lpQJ2kVh4AiLcAp4h0b9XBNe8zEoUX/0RWXR42MWohCET9NHfya8
 KGiDOPd2xmH8Lx3WVPJf9TZFEmBG8xyLV9J0wR1mMMfLsHfHJr6lNq7OW4ZpEC933xxdFZi
 yzH0nUrc8KhwG/B8DYQXA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vxuy1xkf1dk=:tJJpdk/VtQ/BWUDAQLtAfo
 wnffDZufoo7SokJvFeAySPMcM9srF1tWPHIAZ7CYMyPhA60Srgi6FKmukV6SZgKKYnhEPkwya
 c1II9kXUAjeiMTjzEAjj4JWmby5zIMP19R2+GxVWU2q1l5SZwz1n7IVczAOIYQyyrphhi9SES
 45wf9+3JueLnNkXXCbquJb5iDDLK0b9rNUCiW3w/zuBLgqA5ZzjEKCZ/LQFN2XyAlY3f7hlG4
 fQl2O2iQy4tCsbncp/DTE2XbgNdWWK9QY6YCWQQqOn24PmTv0ATpND87oczCal0QJKxotIYk6
 kXeoVC4jA4nZ33LUEos2EfM3I1u2O+ppev9stWbrq0mGPBh3VPSjJaR67ZJ6tiTAOhFk4It1D
 51rMxUU5VQa20SC6rEC+f6BELWJpLXet2cm3Pf+hbbYEbyTQvi5KcqnaW35KISbCiprR2mjOS
 p82jNDcdw9U/kPcEiE9ayteTblzlBEFyuuglCqIo92kRUSgKwTytxfw8YZCnHBB402FUStuhF
 ECfxz2iwzNVX68vabB79ndOLvG9sKOPrVrMYoBeMwFW9yIGJD4p67O7xC9ObU4HIqV9n7D4ga
 zRuNfHqN7tSicXDmg2o/rbkuTg6iQCFNyAutyiHRhw7lIczo+HjhqJ576Ap/ULBIv7rs5mINh
 rqYgQ1WQBVgQGqWZVWyE699yoqJOtiATl3/dlvcf9ZUG/pvtgiz16Shl7Z/KedV6Ik2qRmdhT
 yg0uqT8hffyhWgedXsmL1Kh9FMPH3YRRS7X8Lg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The driver should really call dm365_isif_setup_pinmux() through a callback,
but it runs platform specific code by itself, which never actually compiled:

/git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: implicit declaration of function 'davinci_cfg_reg' [-Werror,-Wimplicit-function-declaration]
        davinci_cfg_reg(DM365_VIN_CAM_WEN);
        ^
/git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: this function declaration is not a prototype [-Werror,-Wstrict-prototypes]
/git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:18: error: use of undeclared identifier 'DM365_VIN_CAM_WEN'
        davinci_cfg_reg(DM365_VIN_CAM_WEN);
                        ^
/git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2029:18: error: use of undeclared identifier 'DM365_VIN_CAM_VD'
        davinci_cfg_reg(DM365_VIN_CAM_VD);
                        ^
/git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2030:18: error: use of undeclared identifier 'DM365_VIN_CAM_HD'
        davinci_cfg_reg(DM365_VIN_CAM_HD);
                        ^
/git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2031:18: error: use of undeclared identifier 'DM365_VIN_YIN4_7_EN'
        davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
                        ^
/git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2032:18: error: use of undeclared identifier 'DM365_VIN_YIN0_3_EN'
        davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
                        ^
7 errors generated.

Fixes: 4907c73deefe ("media: staging: davinci_vpfe: allow building with COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/davinci_vpfe/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
index aea449a8dbf8..84ac6b9e1767 100644
--- a/drivers/staging/media/davinci_vpfe/Kconfig
+++ b/drivers/staging/media/davinci_vpfe/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_DM365_VPFE
 	tristate "DM365 VPFE Media Controller Capture Driver"
 	depends on VIDEO_V4L2
-	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF) || COMPILE_TEST
+	depends on (ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF)
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on VIDEO_DAVINCI_VPBE_DISPLAY
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.20.0

