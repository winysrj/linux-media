Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36066 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755380AbcJUOA0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:00:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 4/4] mtk-mdp: fix compilation warnings if !DEBUG
Date: Fri, 21 Oct 2016 11:59:19 -0200
Message-Id: <5a24855fda4d91a58f119c2d70177017e06fc6f0.1477058332.git.mchehab@s-opensource.com>
In-Reply-To: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
References: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
In-Reply-To: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
References: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mtk_mdp_dbg() is empty if !DEBUG. This causes the following
warnings:

	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c: In function ‘mtk_mdp_try_fmt_mplane’:
	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c:231:52: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
	        org_w, org_h, pix_mp->width, pix_mp->height);
                                                    ^
	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c: In function ‘mtk_mdp_m2m_start_streaming’:
	drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c:414:21: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
	        ctx->id, ret);
	                     ^

With could actually make the code to do something wrong. So,
add an empty block to make it be parsed ok.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
index 2e979f97d1df..848569d4ab90 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.h
@@ -250,7 +250,7 @@ extern int mtk_mdp_dbg_level;
 
 #else
 
-#define mtk_mdp_dbg(level, fmt, args...)
+#define mtk_mdp_dbg(level, fmt, args...) {}
 #define mtk_mdp_err(fmt, args...)
 #define mtk_mdp_dbg_enter()
 #define mtk_mdp_dbg_leave()
-- 
2.7.4

