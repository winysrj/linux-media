Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaIXW17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 07/18] [media] radio-sf16fmr2: declare some structs as static
Date: Wed, 24 Sep 2014 19:27:07 -0300
Message-Id: <d1a2f5374a7b3441b0103a0639eda18fb351031e.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/radio/radio-sf16fmr2.c:308:19: warning: symbol 'fmr2_isa_driver' was not declared. Should it be static?
drivers/media/radio/radio-sf16fmr2.c:316:19: warning: symbol 'fmr2_pnp_driver' was not declared. Should it be static?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 93d864eb8306..b8d61cbc18cb 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -305,7 +305,7 @@ static void fmr2_pnp_remove(struct pnp_dev *pdev)
 	pnp_set_drvdata(pdev, NULL);
 }
 
-struct isa_driver fmr2_isa_driver = {
+static struct isa_driver fmr2_isa_driver = {
 	.match		= fmr2_isa_match,
 	.remove		= fmr2_isa_remove,
 	.driver		= {
@@ -313,7 +313,7 @@ struct isa_driver fmr2_isa_driver = {
 	},
 };
 
-struct pnp_driver fmr2_pnp_driver = {
+static struct pnp_driver fmr2_pnp_driver = {
 	.name		= "radio-sf16fmr2",
 	.id_table	= fmr2_pnp_ids,
 	.probe		= fmr2_pnp_probe,
-- 
1.9.3

