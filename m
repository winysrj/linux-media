Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D491FC282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 17:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6DB02087F
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 17:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="Z48YP7rA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfA3Ru2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 12:50:28 -0500
Received: from mx1.ucr.edu ([138.23.248.2]:64351 "EHLO mx1.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfA3Ru1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 12:50:27 -0500
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2019 12:50:27 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1548870626; x=1580406626;
  h=from:to:cc:subject:date:message-id;
  bh=sD3YsFFxFFf5mI1/Slp1q9iWxdDGyH2Fo/moTt7ef6w=;
  b=Z48YP7rAti2cRuCKhEbEPmWTpYEZtdaeneDLEtrxYV3h4eNWyuX3duW8
   rcYrFBgF51YSZMFDFliz9/Yf8nVvXXSg7yQ2uYqmykc/5v6fZqkEj3Ih1
   a1E9RbEyhzz3bOfQ89Lv6lBkHLb80YvK4WxM7t/+XxX/zVLtcXMhuzMe+
   aTp2mWoKIpEsoKFDcec26LgFD9cII4cSdL+0LiJbYfTqudv3j305I67Qk
   4KAVexRScvmPwudG6Wp5rhuI6qkNxHBLiqVAsYNUfolebtmkipFaR8afs
   CDhBI01Wyw1NVmbVJ8LXydBtcBuGiKiWFyDqeCrt/7Svu1dv2dg61/nDU
   A==;
IronPort-PHdr: =?us-ascii?q?9a23=3AwKvaRRxYULnwXzLXCy+O+j09IxM/srCxBDY+r6Qd?=
 =?us-ascii?q?1OIWIJqq85mqBkHD//Il1AaPAd2Lraocw8Pt8InYEVQa5piAtH1QOLdtbDQizf?=
 =?us-ascii?q?ssogo7HcSeAlf6JvO5JwYzHcBFSUM3tyrjaRsdF8nxfUDdrWOv5jAOBBr/KRB1?=
 =?us-ascii?q?JuPoEYLOksi7ze+/94HQbglSmDaxfa55IQmrownWqsQYm5ZpJLwryhvOrHtIeu?=
 =?us-ascii?q?BWyn1tKFmOgRvy5dq+8YB6/ShItP0v68BPUaPhf6QlVrNYFygpM3o05MLwqxbO?=
 =?us-ascii?q?SxaE62YGXWUXlhpIBBXF7A3/U5zsvCb2qvZx1S+HNsDtU7s6RSqt4LtqSB/wiS?=
 =?us-ascii?q?cIKTg58H3MisdtiK5XuQ+tqwBjz4LRZoyVMft+frjGfdMbQ2pBUdtaWTJYDIih?=
 =?us-ascii?q?YYsPDvQOPeJFoILgo1cDoweyCQyqCejyyDFHm2X20LU63eo/DA/I0g8uEdUVvX?=
 =?us-ascii?q?jIsNn4LrseXPqpwKXUyzjIcvNY2S366IjNah0uo/CMXLNwccrMzkkkCgTIj1WR?=
 =?us-ascii?q?qIzlJTyV1/gBv3SV4ud7SOKgl3QnpxtvrTey28chk4/EjZ8WxFDc7Sh13po5KN?=
 =?us-ascii?q?miREN4YdOoCoVcuzyaOodsX88vR2NltD4nxrAHvZO3ZjYGxZonyhLFdfCKcpKE?=
 =?us-ascii?q?7xDsWeuXPDx2nmhqeKiliBa36UWgz+r8WdSq31tStSpFl8XMtmgK1xzO9siLUv?=
 =?us-ascii?q?t98Vml2TaIzw3T7/tLIUEwlabCM54hzaM8moMdsUjeGiL7ml/6jKCRdkUj9eio?=
 =?us-ascii?q?7/robq/6qZ+bMo94kgD+MqIwlcyjGek0LBQCUmyB9em/1LDv51P1TKhKg/Esj6?=
 =?us-ascii?q?XUtJLXKdwepqGjAg9V1ogj6wy4DzejyNkZnXgGLFJfdxKGk4TlJ1/DLevlDfij?=
 =?us-ascii?q?mVSgiilkyO3bPrH5GJXCMmDDkKv9fbZ680NczAszzdZC55NbE70BJez8VVLwtN?=
 =?us-ascii?q?PCFRI5LQO0zPj9CNln1YMRR3iPAqmHP6PWq1OI4fgvI+bfLKEPvzOoGvk35+Pp?=
 =?us-ascii?q?xSsoi18UfPHxhrMKY2r+E/h7dRbKKUHwi8sMRD9Z9jE1S/bn3RjdCTM=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AkAAC831FcgMXXVdFkHAEBAQQBAQcEA?=
 =?us-ascii?q?QGBUQcBAQsBAYM6Sg+MHV+LZwaKZBhthViCc4UOgXsBCgEBLIRAgwkiNAkNAQM?=
 =?us-ascii?q?BAQIBAQIBEwEBCQ0JCCcxQgEOAYFoKYJfNlKBFQEFATVbgkcBgXQNoEs8jBczi?=
 =?us-ascii?q?GMBB4FLCQEIh22EQYEPgQeDboR/g1SCQwKBLAEBAY91kTMBBgIBgWOBQo8BJIM?=
 =?us-ascii?q?yhnWICwEtmw4CBAIEBQIFDyGBJYIOTSWBbAqBRIJRjiweM4EHhkiFa4JNAQ?=
X-IPAS-Result: =?us-ascii?q?A2AkAAC831FcgMXXVdFkHAEBAQQBAQcEAQGBUQcBAQsBAYM?=
 =?us-ascii?q?6Sg+MHV+LZwaKZBhthViCc4UOgXsBCgEBLIRAgwkiNAkNAQMBAQIBAQIBEwEBC?=
 =?us-ascii?q?Q0JCCcxQgEOAYFoKYJfNlKBFQEFATVbgkcBgXQNoEs8jBcziGMBB4FLCQEIh22?=
 =?us-ascii?q?EQYEPgQeDboR/g1SCQwKBLAEBAY91kTMBBgIBgWOBQo8BJIMyhnWICwEtmw4CB?=
 =?us-ascii?q?AIEBQIFDyGBJYIOTSWBbAqBRIJRjiweM4EHhkiFa4JNAQ?=
X-IronPort-AV: E=Sophos;i="5.56,541,1539673200"; 
   d="scan'208";a="1052575847"
Received: from mail-pg1-f197.google.com ([209.85.215.197])
  by smtp1.ucr.edu with ESMTP/TLS/AES128-GCM-SHA256; 30 Jan 2019 09:33:47 -0800
Received: by mail-pg1-f197.google.com with SMTP id p4so168598pgj.21
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 09:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GtM9J7PYJtxRl5BZuKcAvjHRXIRqsfAVBpYWSsT6ylE=;
        b=DzdzhPxKDM5jKNIV6yYjF6Hqqymrs1vBAMAW+E1aHuQ6wDW+uPwuQ9bPoFwR/RIuB0
         75i5oglEhVKXA09ru/wLvoM0cITMj+Iz/x9iFFxA6G1jLIlA+4YdDPUAr6+7DlOYWIk5
         JecgN3TViEWNRRgAHRp1Wvg100Sa/UT+jBsupig9gbBz0D9ar+9m0UW6pD+h4/CCgZdZ
         eAI6ZSALzACLtCmjMFmz7zfvOjKUg2ng/+XDBOCSjW+Xu5t0qzKp6xJyva1P/7TLwaOK
         4NEHZDehuuLqGe9dld5EM28Vu3CuYpV3pf0Xn3VqhnPvEq7PzMdT7AKGmH/VRDum+5eh
         V3JA==
X-Gm-Message-State: AJcUukcCjqVOmzEurqQzgymtbu0YAk0wfHNgAUPjN3u7pUBy9oWrsvpK
        6SYe30Do+VKqrRQcPvRmYWb2/UwYDdMHBM6cLnhk46aCkvbOb2EfyIrOK5ZowA8vx0MBa51BtRM
        lV42xaYnfsnjbLZRYtLJoa5Kj
X-Received: by 2002:a17:902:7e0d:: with SMTP id b13mr31671337plm.154.1548869626534;
        Wed, 30 Jan 2019 09:33:46 -0800 (PST)
X-Google-Smtp-Source: ALg8bN7aw1Nz1H93FMudfOy5NE53BPL9EwY5HYqHDs8E/VMwVrjm5xUaIJqekqsExzUDQEqM1xFAxA==
X-Received: by 2002:a17:902:7e0d:: with SMTP id b13mr31671312plm.154.1548869626143;
        Wed, 30 Jan 2019 09:33:46 -0800 (PST)
Received: from Yizhuo.cs.ucr.edu (yizhuo.cs.ucr.edu. [169.235.26.74])
        by smtp.googlemail.com with ESMTPSA id x27sm6729222pfe.178.2019.01.30.09.33.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 09:33:45 -0800 (PST)
From:   Yizhuo <yzhai003@ucr.edu>
Cc:     csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, Yizhuo <yzhai003@ucr.edu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ts2020: Variable "utmp" in function ts2020_set_tuner_rf() could be uninitialized
Date:   Wed, 30 Jan 2019 09:33:30 -0800
Message-Id: <20190130173331.4672-1-yzhai003@ucr.edu>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In function ts2020_set_tuner_rf(), local variable "utmp" could
be uninitialized if function regmap_read() returns -EINVAL.
However, this value is used in if statement and written to
the register, which is potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
---
 drivers/media/dvb-frontends/ts2020.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 931e5c98da8a..e351039f2eae 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -177,9 +177,12 @@ static int ts2020_set_tuner_rf(struct dvb_frontend *fe)
 {
 	struct ts2020_priv *dev = fe->tuner_priv;
 	int ret;
-	unsigned int utmp;
+	unsigned int utmp = 0;
 
 	ret = regmap_read(dev->regmap, 0x3d, &utmp);
+	if (ret)
+		return ret;
+
 	utmp &= 0x7f;
 	if (utmp < 0x16)
 		utmp = 0xa1;
-- 
2.17.1

