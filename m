Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [PATCH 06/18] [media] radio-sf16fmi: declare pnp_attached as static
Date: Wed, 24 Sep 2014 19:27:06 -0300
Message-Id: <27ad09aa540b12ac409acaa05cbd92908d496f21.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/radio/radio-sf16fmi.c:59:6: warning: symbol 'pnp_attached' was not declared. Should it be static?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index bcd0946c84a5..28a89466cddc 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -56,7 +56,7 @@ struct fmi
 
 static struct fmi fmi_card;
 static struct pnp_dev *dev;
-bool pnp_attached;
+static bool pnp_attached;
 
 #define RSF16_MINFREQ (87U * 16000)
 #define RSF16_MAXFREQ (108U * 16000)
-- 
1.9.3

