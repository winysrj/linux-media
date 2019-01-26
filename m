Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B2AC282C7
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 11:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE1D218F0
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 11:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548501167;
	bh=rYvelscqA7kJ05APlxeXzEuk9mpaLxjjNzAotrx16IE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=0Ye7ajrMdGJiNHfANQ2+/2tP+4XmOZi1Bz6YQ1atbTUCf7MOAXE3lx1kQjdLdiGBD
	 k95/No0dXasp62yMXy+72Yf2MKScoL8snXqhQpdDhIkViae1oIGWK/s/qUE9102rcH
	 UcSWy6jDybQvBdQrR0nEMa5loIUObi2BZ5pO4lns=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfAZLMq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 26 Jan 2019 06:12:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfAZLMq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Jan 2019 06:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FJKum3GJtQIvHBxioIJqV6AyPnxFB83YWnRJG5/xPnw=; b=KogQy9A10FlLXi0k2fLCIJht+
        4LZdBc8ferZn1Jr0w5UP8FRr0XtyVglVtRa2xlD/MsU/6x9DocJhz9VOz9xtwFSmmo+PbuIcBcKnG
        bbn0zsGKNg8+pr+Kvgp6dDeqNuA/g44zvSYgvSoqF0MxoodaEnOD1qPR3K+45IPS9sMfWTiu5/eT1
        78GZXccDOY4CnzIF3pNV+FqBbtz5rt5OfuvFW6chf+dEvr4ZTedJOQHltfCg8VCnU/KGMP7lOmcls
        yvKK9XTRUtA6t43zlT+FoZycCVeJl+z8PDRm9t9QTnmj5icWHxuaKH5RkyyBlSr0IOvb3ocjsoDIh
        p8S+wTsTw==;
Received: from 177.157.109.120.dynamic.adsl.gvt.net.br ([177.157.109.120] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gnLtF-0005KX-Gz; Sat, 26 Jan 2019 11:12:45 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gnLtC-0005tJ-6d; Sat, 26 Jan 2019 09:12:42 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: vicodec>: get_next_header is static
Date:   Sat, 26 Jan 2019 09:12:41 -0200
Message-Id: <a8c649a5d1aa0c0b6056423a9a4b3a8a0a42a8b7.1548501159.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

drivers/media/platform/vicodec/vicodec-core.c:drivers/media/platform/vicodec/vicodec-core.c:210:23:  warning: symbol 'get_next_header' was not declared. Should it be static?
drivers/media/platform/vicodec/vicodec-core.c:210:23: warning: no previous prototype for 'get_next_header' [-Wmissing-prototypes]
 enum vb2_buffer_state get_next_header(struct vicodec_ctx *ctx, u8 **pp, u32 sz)
                       ^~~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 28c3a3d57783..3703b587e25e 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -207,7 +207,8 @@ static int device_process(struct vicodec_ctx *ctx,
 /*
  * mem2mem callbacks
  */
-enum vb2_buffer_state get_next_header(struct vicodec_ctx *ctx, u8 **pp, u32 sz)
+static enum vb2_buffer_state get_next_header(struct vicodec_ctx *ctx,
+					     u8 **pp, u32 sz)
 {
 	static const u8 magic[] = {
 		0x4f, 0x4f, 0x4f, 0x4f, 0xff, 0xff, 0xff, 0xff
-- 
2.20.1

