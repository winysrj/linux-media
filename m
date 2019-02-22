Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E59C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 06:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54C4420818
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 06:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="krueJRwn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfBVGgz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 01:36:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:52978 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbfBVGgz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 01:36:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1M6TNkY161734;
        Fri, 22 Feb 2019 06:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=GriNJ7JkujBKJ3eGuJBBqNjkl2XIKzDiD8wsBl7EeuM=;
 b=krueJRwnhd53jYTeBVJ4klqZ8JcP9qIrRE/2Jsji7liJUDS7/Q0i9ViRS+SPcg3hhdZ0
 Ax+9AGGiZ3PiSyB1h7Mrf+4nmDNBSCBKD9JXSKT2qZsWi617tX/g36AAS6/xATUMByDK
 1lYwbdzTBNyRI5P3vSALbtLsOKknUPGqdzq6ganxD8Lc/vmSURaQyWLdBdfL65ln5UtA
 6V0lX+3AJxeaCmu/yAIgAqR9O3FfSjS+pX5/lZMNJpby7ae28sWkf6Sb8RkO9hDQF4GS
 jUgBDF3lQ8usmtrTnOZ7o6dZTOKp1a2T+hDbGgNHujYb5FcCy9w4MO2dUAPCC4uyiEyw HQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qp81emn9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 06:36:51 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1M6aolj016800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 06:36:51 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1M6aont008868;
        Fri, 22 Feb 2019 06:36:50 GMT
Received: from kadam (/197.157.0.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 22:36:50 -0800
Date:   Fri, 22 Feb 2019 09:36:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andy Walls <awalls@md.metrocast.net>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: ivtv: update *pos correctly in ivtv_read_pos()
Message-ID: <20190222063641.GB12250@kadam>
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

We had intended to update *pos, but the current code is a no-op.

Fixes: 1a0adaf37c30 ("V4L/DVB (5345): ivtv driver for Conexant cx23416/cx23415 MPEG encoder/decoder")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/pci/ivtv/ivtv-fileops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-fileops.c b/drivers/media/pci/ivtv/ivtv-fileops.c
index 6196daae4b3e..043ac0ae9ed0 100644
--- a/drivers/media/pci/ivtv/ivtv-fileops.c
+++ b/drivers/media/pci/ivtv/ivtv-fileops.c
@@ -420,7 +420,7 @@ static ssize_t ivtv_read_pos(struct ivtv_stream *s, char __user *ubuf, size_t co
 
 	IVTV_DEBUG_HI_FILE("read %zd from %s, got %zd\n", count, s->name, rc);
 	if (rc > 0)
-		pos += rc;
+		*pos += rc;
 	return rc;
 }
 
-- 
2.17.1

