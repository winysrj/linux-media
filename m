Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39084 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756127AbcIKN00 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 09:26:26 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/26] [media]: constify local structures
Date: Sun, 11 Sep 2016 15:05:55 +0200
Message-Id: <1473599168-30561-14-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For structure types defined in the same file or local header files, find
top-level static structure declarations that have the following
properties:
1. Never reassigned.
2. Address never taken
3. Not passed to a top-level macro call
4. No pointer or array-typed field passed to a function or stored in a
variable.
Declare structures having all of these properties as const.

Done using Coccinelle.
Based on a suggestion by Joe Perches <joe@perches.com>.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch seems too long for a commit log, but is in the cover
letter.

 drivers/media/i2c/tvp514x.c                |    2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c |   18 +++++++++---------
 drivers/media/pci/ngene/ngene-cards.c      |   14 +++++++-------
 drivers/media/pci/smipcie/smipcie-main.c   |    8 ++++----
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 7cdd948..43a9252 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -977,7 +977,7 @@ static const struct v4l2_subdev_ops tvp514x_ops = {
 	.pad = &tvp514x_pad_ops,
 };
 
-static struct tvp514x_decoder tvp514x_dev = {
+static const struct tvp514x_decoder tvp514x_dev = {
 	.streaming = 0,
 	.fmt_list = tvp514x_fmt_list,
 	.num_fmts = ARRAY_SIZE(tvp514x_fmt_list),
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 47def73..18e3a4d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1643,53 +1643,53 @@ fail:
 /******************************************************************************/
 /******************************************************************************/
 
-static struct ddb_info ddb_none = {
+static const struct ddb_info ddb_none = {
 	.type     = DDB_NONE,
 	.name     = "Digital Devices PCIe bridge",
 };
 
-static struct ddb_info ddb_octopus = {
+static const struct ddb_info ddb_octopus = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus DVB adapter",
 	.port_num = 4,
 };
 
-static struct ddb_info ddb_octopus_le = {
+static const struct ddb_info ddb_octopus_le = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus LE DVB adapter",
 	.port_num = 2,
 };
 
-static struct ddb_info ddb_octopus_mini = {
+static const struct ddb_info ddb_octopus_mini = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus Mini",
 	.port_num = 4,
 };
 
-static struct ddb_info ddb_v6 = {
+static const struct ddb_info ddb_v6 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V6 DVB adapter",
 	.port_num = 3,
 };
-static struct ddb_info ddb_v6_5 = {
+static const struct ddb_info ddb_v6_5 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
 	.port_num = 4,
 };
 
-static struct ddb_info ddb_dvbct = {
+static const struct ddb_info ddb_dvbct = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
 	.port_num = 3,
 };
 
-static struct ddb_info ddb_satixS2v3 = {
+static const struct ddb_info ddb_satixS2v3 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
 	.port_num = 3,
 };
 
-static struct ddb_info ddb_octopusv3 = {
+static const struct ddb_info ddb_octopusv3 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus V3 DVB adapter",
 	.port_num = 4,
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 4e783a6..423e8c8 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -613,7 +613,7 @@ static struct stv6110x_config tuner_cineS2_1 = {
 	.clk_div = 1,
 };
 
-static struct ngene_info ngene_info_cineS2 = {
+static const struct ngene_info ngene_info_cineS2 = {
 	.type		= NGENE_SIDEWINDER,
 	.name		= "Linux4Media cineS2 DVB-S2 Twin Tuner",
 	.io_type	= {NGENE_IO_TSIN, NGENE_IO_TSIN},
@@ -627,7 +627,7 @@ static struct ngene_info ngene_info_cineS2 = {
 	.msi_supported	= true,
 };
 
-static struct ngene_info ngene_info_satixS2 = {
+static const struct ngene_info ngene_info_satixS2 = {
 	.type		= NGENE_SIDEWINDER,
 	.name		= "Mystique SaTiX-S2 Dual",
 	.io_type	= {NGENE_IO_TSIN, NGENE_IO_TSIN},
@@ -641,7 +641,7 @@ static struct ngene_info ngene_info_satixS2 = {
 	.msi_supported	= true,
 };
 
-static struct ngene_info ngene_info_satixS2v2 = {
+static const struct ngene_info ngene_info_satixS2v2 = {
 	.type		= NGENE_SIDEWINDER,
 	.name		= "Mystique SaTiX-S2 Dual (v2)",
 	.io_type	= {NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN,
@@ -656,7 +656,7 @@ static struct ngene_info ngene_info_satixS2v2 = {
 	.msi_supported	= true,
 };
 
-static struct ngene_info ngene_info_cineS2v5 = {
+static const struct ngene_info ngene_info_cineS2v5 = {
 	.type		= NGENE_SIDEWINDER,
 	.name		= "Linux4Media cineS2 DVB-S2 Twin Tuner (v5)",
 	.io_type	= {NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN,
@@ -672,7 +672,7 @@ static struct ngene_info ngene_info_cineS2v5 = {
 };
 
 
-static struct ngene_info ngene_info_duoFlex = {
+static const struct ngene_info ngene_info_duoFlex = {
 	.type           = NGENE_SIDEWINDER,
 	.name           = "Digital Devices DuoFlex PCIe or miniPCIe",
 	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN,
@@ -687,7 +687,7 @@ static struct ngene_info ngene_info_duoFlex = {
 	.msi_supported	= true,
 };
 
-static struct ngene_info ngene_info_m780 = {
+static const struct ngene_info ngene_info_m780 = {
 	.type           = NGENE_APP,
 	.name           = "Aver M780 ATSC/QAM-B",
 
@@ -727,7 +727,7 @@ static struct drxd_config fe_terratec_dvbt_1 = {
 	.osc_deviation  = osc_deviation,
 };
 
-static struct ngene_info ngene_info_terratec = {
+static const struct ngene_info ngene_info_terratec = {
 	.type           = NGENE_TERRATEC,
 	.name           = "Terratec Integra/Cinergy2400i Dual DVB-T",
 	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN},
diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
index 83981d61..6dbe3b4 100644
--- a/drivers/media/pci/smipcie/smipcie-main.c
+++ b/drivers/media/pci/smipcie/smipcie-main.c
@@ -1060,7 +1060,7 @@ static void smi_remove(struct pci_dev *pdev)
 }
 
 /* DVBSky cards */
-static struct smi_cfg_info dvbsky_s950_cfg = {
+static const struct smi_cfg_info dvbsky_s950_cfg = {
 	.type = SMI_DVBSKY_S950,
 	.name = "DVBSky S950 V3",
 	.ts_0 = SMI_TS_NULL,
@@ -1070,7 +1070,7 @@ static struct smi_cfg_info dvbsky_s950_cfg = {
 	.rc_map = RC_MAP_DVBSKY,
 };
 
-static struct smi_cfg_info dvbsky_s952_cfg = {
+static const struct smi_cfg_info dvbsky_s952_cfg = {
 	.type = SMI_DVBSKY_S952,
 	.name = "DVBSky S952 V3",
 	.ts_0 = SMI_TS_DMA_BOTH,
@@ -1080,7 +1080,7 @@ static struct smi_cfg_info dvbsky_s952_cfg = {
 	.rc_map = RC_MAP_DVBSKY,
 };
 
-static struct smi_cfg_info dvbsky_t9580_cfg = {
+static const struct smi_cfg_info dvbsky_t9580_cfg = {
 	.type = SMI_DVBSKY_T9580,
 	.name = "DVBSky T9580 V3",
 	.ts_0 = SMI_TS_DMA_BOTH,
@@ -1090,7 +1090,7 @@ static struct smi_cfg_info dvbsky_t9580_cfg = {
 	.rc_map = RC_MAP_DVBSKY,
 };
 
-static struct smi_cfg_info technotrend_s2_4200_cfg = {
+static const struct smi_cfg_info technotrend_s2_4200_cfg = {
 	.type = SMI_TECHNOTREND_S2_4200,
 	.name = "TechnoTrend TT-budget S2-4200 Twin",
 	.ts_0 = SMI_TS_DMA_BOTH,

