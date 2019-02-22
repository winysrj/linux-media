Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF05C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 06:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDD4320818
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 06:32:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EXSdRSjb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfBVGcx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 01:32:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48886 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfBVGcx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 01:32:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1M6TWV5161797;
        Fri, 22 Feb 2019 06:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=avdhkUNvfDmQU3WoAT6csgqKDjZK4cuwgpwjfHEbLZA=;
 b=EXSdRSjb8JXDYeLuecGrVfex/JgQ0X985YQqck8cDDlqVfq6lBNhe0DDS0AmY7FnRIE9
 qVC7QW8cclvf9vfctgM4UtFTUcNGkGtY+Ph7hrhdKthv+9KWajKTkoTNYaYXSxJqudp8
 uhDBPQdUPdpnMqT9jpMC9zS42KWb7PMMSKObEnhcOPY+Yqab023tkbxVEPwcO/yp/xua
 VvBnx5E/0F8ymcoAwtMTEZ+8c73CTdl/BYl7lmVG+mATNwXCFuNRalC5nyxLIVpzH4Zx
 2KkqjdYRox9kNP6b584b163o7YiOB9k1HuTHNalnczfPppPUXjwRvzsqoGx732LMG5nU kQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qp81emmu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 06:32:43 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1M6WbgA005599
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 06:32:37 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1M6Wav1004081;
        Fri, 22 Feb 2019 06:32:36 GMT
Received: from kadam (/197.157.0.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 22:32:35 -0800
Date:   Fri, 22 Feb 2019 09:32:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Rui Miguel Silva <rmfrfs@gmail.com>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: staging/imx7: Fix an error code in mipi_csis_clk_get()
Message-ID: <20190222063226.GA12101@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9174 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220044
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

We accidentally return IS_ERR(), which is 1, instead of the PTR_ERR()
which is the negative error code.

Fixes: 7807063b862b ("media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/media/imx/imx7-mipi-csis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index f4674de09e83..4ac0be9e4487 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -491,7 +491,7 @@ static int mipi_csis_clk_get(struct csi_state *state)
 
 	state->wrap_clk = devm_clk_get(dev, "wrap");
 	if (IS_ERR(state->wrap_clk))
-		return IS_ERR(state->wrap_clk);
+		return PTR_ERR(state->wrap_clk);
 
 	/* Set clock rate */
 	ret = clk_set_rate(state->wrap_clk, state->clk_frequency);
-- 
2.17.1

