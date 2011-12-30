Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Wlp009177
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 88/94] [media] dvb-core: don't use fe_bandwidth_t on driver
Date: Fri, 30 Dec 2011 13:08:25 -0200
Message-Id: <1325257711-12274-89-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that everybody is talking DVBv5 API dialect, using this
DVBv3 macro internally is not ok.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/bt8xx/dst_common.h    |    2 +-
 drivers/media/dvb/frontends/dib3000mc.c |    2 +-
 drivers/media/dvb/frontends/dib7000m.c  |    2 +-
 drivers/media/dvb/frontends/tda10048.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst_common.h b/drivers/media/dvb/bt8xx/dst_common.h
index d88cf2a..d70d98f 100644
--- a/drivers/media/dvb/bt8xx/dst_common.h
+++ b/drivers/media/dvb/bt8xx/dst_common.h
@@ -124,7 +124,7 @@ struct dst_state {
 	u16 decode_snr;
 	unsigned long cur_jiff;
 	u8 k22;
-	fe_bandwidth_t bandwidth;
+	u32 bandwidth;
 	u32 dst_hw_cap;
 	u8 dst_fw_version;
 	fe_sec_mini_cmd_t minicmd;
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index 8130028..d98a010 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -40,7 +40,7 @@ struct dib3000mc_state {
 
 	u32 timf;
 
-	fe_bandwidth_t current_bandwidth;
+	u32 current_bandwidth;
 
 	u16 dev_id;
 
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index eb90c4f..b6a25a2 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -38,7 +38,7 @@ struct dib7000m_state {
 	u16 wbd_ref;
 
 	u8 current_band;
-	fe_bandwidth_t current_bandwidth;
+	u32 current_bandwidth;
 	struct dibx000_agc_config *current_agc;
 	u32 timf;
 	u32 timf_default;
diff --git a/drivers/media/dvb/frontends/tda10048.c b/drivers/media/dvb/frontends/tda10048.c
index 80de9f6..dfd1d5a 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -153,7 +153,7 @@ struct tda10048_state {
 	u32 pll_pfactor;
 	u32 sample_freq;
 
-	enum fe_bandwidth bandwidth;
+	u32 bandwidth;
 };
 
 static struct init_tab {
-- 
1.7.8.352.g876a6

