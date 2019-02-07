Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B50C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A816A2147C
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfBGJNn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:13:43 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:55532 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfBGJNm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 04:13:42 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud9.xs4all.net with ESMTPA
        id rfkYgHeo6RO5ZrfkagrP4N; Thu, 07 Feb 2019 10:13:40 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6/6] pxa_camera: fix smatch warning
Date:   Thu,  7 Feb 2019 10:13:38 +0100
Message-Id: <20190207091338.55705-7-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAjd/7ltqEPSxaBb9dbLcekKaGTns7bLf0arAdM6etvugChb7Cwt41l1ho9UHofXm/ORxKFn//31Cpi41SRvi2NGHGUnVF0c8EW+5JyyjkhbwTr/bo5x
 3Wj5TNqIrlGBCf3NY6XnuQdmjhystB1yegIy3mMXL5Cn23q3VFm0Z0aSGtzK2cNmmv96Sdvgv5gB0SvA8GSRGKo2rKizXO/ndmFUJCiT4FCx5aBmLQGAgjJw
 meAiiX5Vz3UbZ5kQTKx8OHjpzp3nwptH5NJA3vYcfGjx90+GSol5zaG4JW2FcVqsPayIXo+UNbuJKuvUab8Xcitw8Ib+N2FMJ/vb5LrB8AQOffZVum5W3giY
 6X3+mqJjdPwykfCKHEYFfRmGXuF5CjMHM7r2bJEPn2wG0QgtqqB27bBM7RcPsEzRl3WV906I
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

drivers/media/platform/pxa_camera.c:2400 pxa_camera_probe() error: we previously assumed 'pcdev->pdata' could be null (see line 2397)

First check if platform data is provided, then check if DT data is provided,
and if neither is provided just return with -ENODEV.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/pxa_camera.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 5f930560eb30..3cf3c6390cc8 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2394,15 +2394,17 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->res = res;
 
 	pcdev->pdata = pdev->dev.platform_data;
-	if (pdev->dev.of_node && !pcdev->pdata) {
-		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
-	} else {
+	if (pcdev->pdata) {
 		pcdev->platform_flags = pcdev->pdata->flags;
 		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
 		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
 		pcdev->asd.match.i2c.adapter_id =
 			pcdev->pdata->sensor_i2c_adapter_id;
 		pcdev->asd.match.i2c.address = pcdev->pdata->sensor_i2c_address;
+	} else if (pdev->dev.of_node) {
+		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
+	} else {
+		return -ENODEV;
 	}
 	if (err < 0)
 		return err;
-- 
2.20.1

