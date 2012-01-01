Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBOd9002849
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 8/9] [media] dvb: deprecate the usage of ops->info.type
Date: Sun,  1 Jan 2012 18:11:17 -0200
Message-Id: <1325448678-13001-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mark info.type as deprecated inside the header, recommending
the usage of DTV_ENUM_DELSYS DVBv5 command instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/dvb/frontend.xml |    4 ++++
 include/linux/dvb/frontend.h                 |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 28d7ea5..aeaed59 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -63,6 +63,10 @@ transmission. The fontend types are given by fe_type_t type, defined as:</para>
 <para>Newer formats like DVB-S2, ISDB-T, ISDB-S and DVB-T2 are not described at the above, as they're
 supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> ioctl's, using the <link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> parameter.
 </para>
+
+<para>The usage of this field is deprecated, as it doesn't report all supported standards, and
+will provide an incomplete information for frontends that support multiple delivery systems.
+Please use <link linkend="DTV_ENUM_DELSYS">DTV_ENUM_DELSYS</link> instead.</para>
 </section>
 
 <section id="fe-caps-t">
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 7e7cb64..cb4428a 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -72,7 +72,7 @@ typedef enum fe_caps {
 
 struct dvb_frontend_info {
 	char       name[128];
-	fe_type_t  type;
+	fe_type_t  type;			/* DEPRECATED. Use DTV_ENUM_DELSYS instead */
 	__u32      frequency_min;
 	__u32      frequency_max;
 	__u32      frequency_stepsize;
-- 
1.7.8.352.g876a6

