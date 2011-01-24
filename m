Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab1AXPXR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:23:17 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFNHdo016343
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:23:17 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARp027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:23:16 -0500
Date: Mon, 24 Jan 2011 13:18:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/13] [media] rc/keymaps: use KEY_CAMERA for snapshots
Message-ID: <20110124131836.04ec6d50@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On a few places, KEY_MHP were used for snapshots. However, KEY_CAMERA
is used for it on all the other keyboards that have a snapshot/Picture
button.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/digitv.c b/drivers/media/dvb/dvb-usb/digitv.c
index f2dbce7..f6344cd 100644
--- a/drivers/media/dvb/dvb-usb/digitv.c
+++ b/drivers/media/dvb/dvb-usb/digitv.c
@@ -176,7 +176,7 @@ static struct rc_map_table rc_map_digitv_table[] = {
 	{ 0xaf59, KEY_AUX },
 	{ 0x5f5a, KEY_DVD },
 	{ 0x6f5a, KEY_POWER },
-	{ 0x9f5a, KEY_MHP },     /* labelled 'Picture' */
+	{ 0x9f5a, KEY_CAMERA },     /* labelled 'Picture' */
 	{ 0xaf5a, KEY_AUDIO },
 	{ 0x5f65, KEY_INFO },
 	{ 0x6f65, KEY_F13 },     /* 16:9 */
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 357fea5..3d2cbe4 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -108,7 +108,7 @@ static struct rc_map_table avermedia_m135a[] = {
 	{ 0x0414, KEY_TEXT },
 	{ 0x0415, KEY_EPG },
 	{ 0x041a, KEY_TV2 },      /* PIP */
-	{ 0x041b, KEY_MHP },      /* Snapshot */
+	{ 0x041b, KEY_CAMERA },      /* Snapshot */
 
 	{ 0x0417, KEY_RECORD },
 	{ 0x0416, KEY_PLAYPAUSE },
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index e694e6e..8cd7f28 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -56,7 +56,7 @@ static struct rc_map_table avermedia_m733a_rm_k6[] = {
 	{ 0x0414, KEY_TEXT },
 	{ 0x0415, KEY_EPG },
 	{ 0x041a, KEY_TV2 },      /* PIP */
-	{ 0x041b, KEY_MHP },      /* Snapshot */
+	{ 0x041b, KEY_CAMERA },      /* Snapshot */
 
 	{ 0x0417, KEY_RECORD },
 	{ 0x0416, KEY_PLAYPAUSE },
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 97fc386..2f66e43 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -12,7 +12,8 @@
 
 #include <media/rc-map.h>
 
-/* From reading the following remotes:
+/*
+ * From reading the following remotes:
  * Zenith Universal 7 / TV Mode 807 / VCR Mode 837
  * Hauppauge (from NOVA-CI-s box product)
  * This is a "middle of the road" approach, differences are noted
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index afa4e92..1a0e590 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -24,7 +24,7 @@ static struct rc_map_table encore_enltv[] = {
 	{ 0x1e, KEY_TV },
 	{ 0x00, KEY_VIDEO },
 	{ 0x01, KEY_AUDIO },		/* music */
-	{ 0x02, KEY_MHP },		/* picture */
+	{ 0x02, KEY_CAMERA },		/* picture */
 
 	{ 0x1f, KEY_1 },
 	{ 0x03, KEY_2 },
diff --git a/drivers/media/rc/keymaps/rc-hauppauge-new.c b/drivers/media/rc/keymaps/rc-hauppauge-new.c
index bd11da4..b6a12fe 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge-new.c
@@ -48,7 +48,7 @@ static struct rc_map_table hauppauge_new[] = {
 	   "Multimedia Home Platform" -
 	   no "PICTURES" key in input.h
 	 */
-	{ 0x1a, KEY_MHP },
+	{ 0x1a, KEY_CAMERA },
 
 	{ 0x1b, KEY_EPG },		/* Guide */
 	{ 0x1c, KEY_TV },
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 3e6f077..ddae20e 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -27,7 +27,7 @@ static struct rc_map_table nebula[] = {
 	{ 0x0b, KEY_AUX },
 	{ 0x0c, KEY_DVD },
 	{ 0x0d, KEY_POWER },
-	{ 0x0e, KEY_MHP },	/* labelled 'Picture' */
+	{ 0x0e, KEY_CAMERA },	/* labelled 'Picture' */
 	{ 0x0f, KEY_AUDIO },
 	{ 0x10, KEY_INFO },
 	{ 0x11, KEY_F13 },	/* 16:9 */
diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
index dfc9b15..2ca825b 100644
--- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
+++ b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
@@ -51,7 +51,7 @@ static struct rc_map_table rc5_hauppauge_new[] = {
 	   "Multimedia Home Platform" -
 	   no "PICTURES" key in input.h
 	 */
-	{ 0x1e1a, KEY_MHP },
+	{ 0x1e1a, KEY_CAMERA },
 
 	{ 0x1e1b, KEY_EPG },		/* Guide */
 	{ 0x1e1c, KEY_TV },
-- 
1.7.1


