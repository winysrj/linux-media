Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89E7C43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 590EC20815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ao2.it header.i=@ao2.it header.b="ZqEFO5A+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfACSkw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 13:40:52 -0500
Received: from mail.ao2.it ([92.243.12.208]:58429 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfACSkw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 13:40:52 -0500
X-Greylist: delayed 2383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2019 13:40:51 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ao2.it; s=20180927;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=ZimGhC4qxCEHzopW7Xfvqjl0RmpAcEZF+FCuV4ji0g0=;
        b=ZqEFO5A+vpaWIs6uu4dxrdl1vW1a3ZVxMfWYs7q1ne5sS5KVd9foyHuX7GnmuD1fFaEsswiWMh2/zaa9BgaDerLQKL1cNFwZZB3ZryBsR43903xKuyTi2PGTcpCKyzi3MoRzXxo3wV+USRz2EkkW0ZE0kpApTRYF+4EAyBamGDVab58NjYtZIWSSAVJn2+raxDtTNYfAv0NsC8BPpjPfUaNxdUHl294zvYsl77zIGVKTmClfjIfNGagqIjAx9l36SARNwpbXP4y84QAirtEDooyWClaTUakdlYAp44iFZGAXMkVKXR35EBdW6f2VxCZ+/D6BpS/LgE1h+rJL4Zxc8A==;
Received: from localhost ([::1] helo=jcn)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Hp-0002wL-WB; Thu, 03 Jan 2019 19:00:06 +0100
Received: from ao2 by jcn with local (Exim 4.92-RC3)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Io-0003Cy-NA; Thu, 03 Jan 2019 19:01:06 +0100
From:   Antonio Ospite <ao2@ao2.it>
To:     linux-media@vger.kernel.org
Cc:     Antonio Ospite <ao2@ao2.it>
Subject: [RFC PATCH 1/5] v4l2-ctl: list controls with menus when OptAll is specified
Date:   Thu,  3 Jan 2019 19:00:58 +0100
Message-Id: <20190103180102.12282-2-ao2@ao2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190103180102.12282-1-ao2@ao2.it>
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
 <20190103180102.12282-1-ao2@ao2.it>
MIME-Version: 1.0
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When calling "v4l2-ctl --all" the user may expect the most comprehensive
output, so also print the menus when listing controls.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 utils/v4l2-ctl/v4l2-ctl.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 8c52c7be..a65262f6 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -1255,7 +1255,7 @@ int main(int argc, char **argv)
 		options[OptGetPriority] = 1;
 		options[OptGetSelection] = 1;
 		options[OptGetOutputSelection] = 1;
-		options[OptListCtrls] = 1;
+		options[OptListCtrlsMenus] = 1;
 		options[OptSilent] = 1;
 	}
 
-- 
2.20.1

