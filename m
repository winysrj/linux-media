Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC5CC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 09:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 769832087E
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 09:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yJXaErzK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfCYJGz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 05:06:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfCYJGz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 05:06:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2P93ooJ174359;
        Mon, 25 Mar 2019 09:06:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=tcUOz38CHAyh1zhyScSlBPE5IT3rCmUdRz4pftL3T4Y=;
 b=yJXaErzKwgEQrpwOBNmAzVaB7t/zPsmn0+ZpKsf5eqQgsXesrjJKRMA1EgTivVgBi3wA
 mihGsxOihgtdnJVvvtlelJ1hOp7Hc/jFWVttm1k1Y+qooCORKmaTqYCKhFwVEVvvr035
 kFsJwocKHT765YkR/aoTYJyTLAKGEXOcEWiw48pFMvSV+qfpoLVwP+xvXHxvLyXNOiVV
 vasnflfDZ3cmieGS7OdQIp/Yd5H2xokrnq9gAVDL3gBxZeQr19lh6DBEzZuBhM2qiSzU
 LEpkS1+Rs71bLaYJ+ntYYg1Ugpm51QNT4SxNprYcIUHffMwpftkAlLt7H3if4fMs6r9S 0Q== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2re6g0truy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 09:06:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2P96e4w023330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Mar 2019 09:06:40 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2P96b5h007419;
        Mon, 25 Mar 2019 09:06:37 GMT
Received: from kadam (/197.157.34.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 Mar 2019 02:06:36 -0700
Date:   Mon, 25 Mar 2019 12:06:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] media: v4l2-ctrl: potential shift wrapping bugs
Message-ID: <20190325090626.GC16023@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9205 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903250069
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This code generates a static checker warning:

    drivers/media/v4l2-core/v4l2-ctrls.c:2921 v4l2_querymenu()
    warn: should '(1 << i)' be a 64 bit type?

The problem is that "ctrl->menu_skip_mask" is a u64 and we're only
testing the lower 32 bits.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b79d3bbd8350..cee78485df02 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1599,7 +1599,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 		if (ptr.p_s32[idx] < ctrl->minimum || ptr.p_s32[idx] > ctrl->maximum)
 			return -ERANGE;
-		if (ctrl->menu_skip_mask & (1 << ptr.p_s32[idx]))
+		if (ctrl->menu_skip_mask & (1ULL << ptr.p_s32[idx]))
 			return -EINVAL;
 		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
 		    ctrl->qmenu[ptr.p_s32[idx]][0] == '\0')
@@ -2918,7 +2918,7 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
 		return -EINVAL;
 
 	/* Use mask to see if this menu item should be skipped */
-	if (ctrl->menu_skip_mask & (1 << i))
+	if (ctrl->menu_skip_mask & (1ULL << i))
 		return -EINVAL;
 	/* Empty menu items should also be skipped */
 	if (ctrl->type == V4L2_CTRL_TYPE_MENU) {
-- 
2.17.1

