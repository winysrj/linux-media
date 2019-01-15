Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BF1C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 19:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF6A20675
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 19:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UgyNrL0C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389514AbfAOT4N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 14:56:13 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51832 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389473AbfAOT4N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 14:56:13 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0FJrUGG143921;
        Tue, 15 Jan 2019 19:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=12gIIwdVxjtMghIO+nb4w8VTGux81FGF16+uJY9jj2E=;
 b=UgyNrL0CpHDvwT8P0fm9yXeY7KeI4HFY1yic632PwAKhO6qteejnMr43ZrM25BdzM+Jc
 r4Om2JA4UBOMFLPy6UmsRH028L02LCpPRsbvj0cRYvgM+Pc/EP3jlbpW3rLd0R05eFds
 HVU2u3xwBkgy58Lz/rfkzRG2j8SD8h+jUBVcHoiS8c+pkzzCI/8iPKlu26yIbl7Yxk0R
 PNcshYUoojKJlkzL1odS4/OtepPQSLMDX1ig3Z6yze8YIEPUTOus/H+C3d6zRoavYTUN
 BfaeWk1dq/kHixccjq4PjU73QzrEJBLWJxOwfKVLw5DzmQkkQpeDvtTIhK6h04BrRPf9 eQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pybjnnygq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jan 2019 19:55:08 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0FJt7SC014227
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jan 2019 19:55:07 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0FJt6MS009010;
        Tue, 15 Jan 2019 19:55:06 GMT
Received: from kadam (/197.157.34.180)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Jan 2019 11:55:05 -0800
Date:   Tue, 15 Jan 2019 22:54:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sangwook Lee <sangwook.lee@linaro.org>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: s5k4ecgx: delete a bogus error message
Message-ID: <20190115195454.GC1074@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9137 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901150159
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This function prints an error message on success.  I don't have the
hardware, I just noticed this while reading the code.

Fixes: 8b99312b7214 ("[media] Add v4l2 subdev driver for S5K4ECGX sensor")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/i2c/s5k4ecgx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 79aa2740edc4..79c1894c2c83 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -263,8 +263,6 @@ static int s5k4ecgx_read(struct i2c_client *client, u32 addr, u16 *val)
 		ret = s5k4ecgx_i2c_write(client, REG_CMDRD_ADDRL, low);
 	if (!ret)
 		ret = s5k4ecgx_i2c_read(client, REG_CMDBUF0_ADDR, val);
-	if (!ret)
-		dev_err(&client->dev, "Failed to execute read command\n");
 
 	return ret;
 }
-- 
2.17.1

