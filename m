Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F730C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39C1A2085A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551452630;
	bh=XkPme69z3wUiGU0WDXR43yjbm/S242JUrCZlWAPi/gY=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=gaYX3YsFIKoknnyd6F61pUY7kjgxBIe2c+k7YfN3g88UT7OOAHBTF1iaUNAe7zkUd
	 g+JN0g/p6qOu4JrC72r6Re8PpUq+crWeC0ebcSQBRr9yGTqDFZrGcsWyiYxIgK87FG
	 EtsoWaGTl+RacVuvf4NDdyuLSzcA9In1QQ0OHMOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfCAPDt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:03:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCAPDt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 10:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fWfguWhWAx0UCjN5UtA+Si57nYTV0ESGRMLSgO5psbw=; b=SNM6VnkWLqg/ZQmtrINKXGjb8
        erIcnxaN/JrhLJfgQn9S9D14zSZ6eZfTuedDsW4l1o5QdaNVjD9vG889mufpyClBVOQiHQAqmcYtD
        rUNLs9ufqin/sb7kS95vwl9ZqNu1jDucRWNIN98x0+VamliglC5MQV2VpizMUf6gapbvUh3Udw1w1
        bRYy2DdgjvRG8A3FHHz+X+ZCHtITZfz4RM8sizcIBEhp83IRo1HOsjNUoche6pNfVWih3ZGAFj/uO
        yHisHbDHczfqqrLL5gt2FqeRMntpI21sY1CT43H+FICAITC/WylZBnUgU8tz6UMjpvlTFv0kK9tbj
        zXtuj6qAw==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzjhT-0001u5-EO; Fri, 01 Mar 2019 15:03:47 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzjhQ-0002Hi-Mo; Fri, 01 Mar 2019 10:03:44 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Benoit Parrot <bparrot@ti.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] media: a few more typos at staging, pci, platform, radio and usb
Date:   Fri,  1 Mar 2019 10:03:44 -0500
Message-Id: <26b190053ec0db030697e2e19a8f8f13550b9ff7.1551452616.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Those typos were left over from codespell check, on
my first pass or belong to code added after the time I
ran it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/cx18/cx18-dvb.c          | 2 +-
 drivers/media/pci/saa7164/saa7164-dvb.c    | 2 +-
 drivers/media/platform/ti-vpe/vpdma.c      | 2 +-
 drivers/media/radio/wl128x/fmdrv_common.c  | 2 +-
 drivers/media/usb/au0828/au0828-dvb.c      | 2 +-
 drivers/staging/media/imx/imx7-mipi-csis.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
index 51ecbe350d0e..61452c50a9c3 100644
--- a/drivers/media/pci/cx18/cx18-dvb.c
+++ b/drivers/media/pci/cx18/cx18-dvb.c
@@ -458,7 +458,7 @@ void cx18_dvb_unregister(struct cx18_stream *stream)
 	dvb_unregister_adapter(dvb_adapter);
 }
 
-/* All the DVB attach calls go here, this function get's modified
+/* All the DVB attach calls go here, this function gets modified
  * for each new card. cx18_dvb_start_feed() will also need changes.
  */
 static int dvb_register(struct cx18_stream *stream)
diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index dfb118d7d1ec..3e73cb3c7e88 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -529,7 +529,7 @@ int saa7164_dvb_unregister(struct saa7164_port *port)
 	return 0;
 }
 
-/* All the DVB attach calls go here, this function get's modified
+/* All the DVB attach calls go here, this function gets modified
  * for each new card.
  */
 int saa7164_dvb_register(struct saa7164_port *port)
diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 1da2cb3aaf0c..78d716c93649 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -1008,7 +1008,7 @@ unsigned int vpdma_get_list_mask(struct vpdma_data *vpdma, int irq_num)
 }
 EXPORT_SYMBOL(vpdma_get_list_mask);
 
-/* clear previously occurred list interupts in the LIST_STAT register */
+/* clear previously occurred list interrupts in the LIST_STAT register */
 void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num,
 			   int list_num)
 {
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index e1c218b23d9e..3c8987af3772 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1047,7 +1047,7 @@ static void fm_irq_handle_intmsk_cmd_resp(struct fmdev *fmdev)
 		clear_bit(FM_INTTASK_RUNNING, &fmdev->flag);
 }
 
-/* Returns availability of RDS data in internel buffer */
+/* Returns availability of RDS data in internal buffer */
 int fmc_is_rds_data_available(struct fmdev *fmdev, struct file *file,
 				struct poll_table_struct *pts)
 {
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index d9093a3c57c5..6e43028112d1 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -566,7 +566,7 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	dvb->frontend = NULL;
 }
 
-/* All the DVB attach calls go here, this function get's modified
+/* All the DVB attach calls go here, this function gets modified
  * for each new card. No other function in this file needs
  * to change.
  */
diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index 75b904d36621..2ddcc42ab8ff 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -822,7 +822,7 @@ static int mipi_csis_parse_dt(struct platform_device *pdev,
 	if (IS_ERR(state->mrst))
 		return PTR_ERR(state->mrst);
 
-	/* Get MIPI CSI-2 bus configration from the endpoint node. */
+	/* Get MIPI CSI-2 bus configuration from the endpoint node. */
 	of_property_read_u32(node, "fsl,csis-hs-settle", &state->hs_settle);
 
 	return 0;
-- 
2.20.1

