Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEF3C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 07:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D2720828
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 07:28:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQkY8FD6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfCFH17 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 02:27:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44622 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728951AbfCFH17 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 02:27:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x267NIeh054600;
        Wed, 6 Mar 2019 07:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=ynkGJvoi8AO00hqbPoEBEHPIvgfIeB6SFayeTy6Sh3E=;
 b=eQkY8FD6ZJ5c0QEAWCFlZAgYVhwYE6k8tZIss9Hx/W/my/IMpuQVP2Xggp6oZXLwMv/x
 o6ToHZi6AFxIDJCEt/UzvpusNB8bNC9xGih1G5m6UFukHVv6nqRcZtlCPY0U2ojMX/ek
 J/RZmRHni4rH4KO+032pmIt7C6AGHkJYhh0c04LCHqVtuGfwEIWfHGvBkHAQXJ2l7i+K
 rvTMchlTmB/0xp+c7bK0O6TcLDJ/n6MrBYGOwa8gC4kD5/53J13XteXBYY2/PWr9etD7
 4WqSYw2b+cdAPysIEWIK+cI9Qkr62hIYWQ4p21NIDIvNrRyXuQJT+FWb3St8A96ItSqJ bw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2qyfbea9bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Mar 2019 07:27:56 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x267RtPq008323
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Mar 2019 07:27:55 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x267RqcC002785;
        Wed, 6 Mar 2019 07:27:52 GMT
Received: from kadam (/41.202.241.15)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Mar 2019 23:27:51 -0800
Date:   Wed, 6 Mar 2019 10:27:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: wl128x: Fix an error code in fm_download_firmware()
Message-ID: <20190306072743.GB2625@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9186 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903060051
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

We forgot to set "ret" on this error path.

Fixes: e8454ff7b9a4 ("[media] drivers:media:radio: wl128x: FM Driver Common sources")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 3c8987af3772..1614809f7d35 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -1268,8 +1268,9 @@ static int fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
 
 		switch (action->type) {
 		case ACTION_SEND_COMMAND:	/* Send */
-			if (fmc_send_cmd(fmdev, 0, 0, action->data,
-						action->size, NULL, NULL))
+			ret = fmc_send_cmd(fmdev, 0, 0, action->data,
+					   action->size, NULL, NULL);
+			if (ret)
 				goto rel_fw;
 
 			cmd_cnt++;
-- 
2.17.1

