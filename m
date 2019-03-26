Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CD4C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 05:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B736C20811
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 05:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KBfmK+Z8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfCZFMX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 01:12:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35828 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfCZFMX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 01:12:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2Q5Ax2R182888;
        Tue, 26 Mar 2019 05:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=475doXYJMMNDwqhOCPPOZVnVqxPWylYYtGxOJCPAGpU=;
 b=KBfmK+Z8GnHdrFxuXIQWKKOZHQyBYm3OLjaHI1JVMKFmFW9jAM92Yq25NDZAjTxo1LfT
 MWehUsT+uebs49EM59KOKpNg9Q48IsqDeYwIHbgLAZWlFqHGlYHsiRegiNjlt8HPg8/v
 kfW2BFzZiXA2mbBhkpOR6aomW6W0KipPjopuZ1qkQi0V/JXYWI51EbXq7iJcqJau2HpV
 wKM+F6/5ti8V6yAPeZ72jrouYXb9a98eR+MOX1+BRrxltDyq369YyeRnfXm8aoR8eyTe
 BGoZHt4gUuIeKHFWWVtGEqgNNc+OGU0aUZD8pbK/Uxf7+uNtJ2i7AdDmrM1PQGyUdSsI 7w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2re6g1004a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Mar 2019 05:12:19 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2Q5CHB3029368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Mar 2019 05:12:18 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2Q5CHOA007804;
        Tue, 26 Mar 2019 05:12:17 GMT
Received: from kadam (/197.157.0.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Mar 2019 22:12:16 -0700
Date:   Tue, 26 Mar 2019 08:12:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Manjunatha Halli <manjunatha_halli@ti.com>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] wl128x: prevent two potential buffer overflows
Message-ID: <20190326051207.GC20038@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9206 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903260038
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Smatch marks skb->data as untrusted so it warns that "evt_hdr->dlen"
can copy up to 255 bytes and we only have room for two bytes.  Even
if this comes from the firmware and we trust it, the new policy
generally is just to fix it as kernel hardenning.

I can't test this code so I tried to be very conservative.  I considered
not allowing "evt_hdr->dlen == 1" because it doesn't initialize the
whole variable but in the end I decided to allow it and manually
initialized "asic_id" and "asic_ver" to zero.

Fixes: e8454ff7b9a4 ("[media] drivers:media:radio: wl128x: FM Driver Common sources")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 1614809f7d35..a1fcb80a2191 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -489,7 +489,8 @@ int fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 		return -EIO;
 	}
 	/* Send response data to caller */
-	if (response != NULL && response_len != NULL && evt_hdr->dlen) {
+	if (response != NULL && response_len != NULL && evt_hdr->dlen &&
+	    evt_hdr->dlen <= payload_len) {
 		/* Skip header info and copy only response data */
 		skb_pull(skb, sizeof(struct fm_event_msg_hdr));
 		memcpy(response, skb->data, evt_hdr->dlen);
@@ -583,6 +584,8 @@ static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
 		return;
 
 	fm_evt_hdr = (void *)skb->data;
+	if (fm_evt_hdr->dlen > sizeof(fmdev->irq_info.flag))
+		return;
 
 	/* Skip header info and copy only response data */
 	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
@@ -1309,7 +1312,7 @@ static int load_default_rx_configuration(struct fmdev *fmdev)
 static int fm_power_up(struct fmdev *fmdev, u8 mode)
 {
 	u16 payload;
-	__be16 asic_id, asic_ver;
+	__be16 asic_id = 0, asic_ver = 0;
 	int resp_len, ret;
 	u8 fw_name[50];
 
-- 
2.17.1

