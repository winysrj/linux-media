Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab2AMNul (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 08:50:41 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0DDoebe008739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 13 Jan 2012 08:50:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb-core: preserve the delivery system at cache clear
Date: Fri, 13 Jan 2012 11:50:36 -0200
Message-Id: <1326462636-8869-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <4F101940.2020408@gmail.com>
References: <4F101940.2020408@gmail.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The changeset 240ab508aa is incomplete, as the first thing that
happens at cache clear is to do a memset with 0 to the cache.

So, the delivery system needs to be explicitly preserved there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

If Kaffeine doesn't call FE_SET_PROPERTY for non-DVB-S2, this should
fix the current issue.

 drivers/media/dvb/dvb-core/dvb_frontend.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 2ad7faf..f5fa7aa 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -904,8 +904,11 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int i;
+	u32 delsys;
 
+	delsys = c->delivery_system;
 	memset(c, 0, sizeof(struct dtv_frontend_properties));
+	c->delivery_system = delsys;
 
 	c->state = DTV_CLEAR;
 
-- 
1.7.8

