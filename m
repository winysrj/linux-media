Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0732BC282C2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 17:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFD9F218A2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 17:52:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="Bwqx4LWj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbfAYRww (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 12:52:52 -0500
Received: from mail-eopbgr810050.outbound.protection.outlook.com ([40.107.81.50]:26800
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729253AbfAYRwv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 12:52:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7E6mH8kFCznMMHMThuf5FJCzFDIxDGmParUFsND6vVc=;
 b=Bwqx4LWjQg/jKmsMvDydRR5NMFlUhwG5NnIHRRRjdCj3fnUM0jf55PUeGRdazZbUtHnY73IHsFksyybnBURHtcFqNEdMI1w50m+qLSX9sizNNaF6vBVc6aWSFzobt8G9rn76MLr2c3UzRNsLQnlb+0B3rXzD0Rxkw4AxS9qoE1I=
Received: from BYAPR02CA0056.namprd02.prod.outlook.com (2603:10b6:a03:54::33)
 by CY4PR0201MB3506.namprd02.prod.outlook.com (2603:10b6:910:95::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.17; Fri, 25 Jan
 2019 17:52:48 +0000
Received: from CY1NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by BYAPR02CA0056.outlook.office365.com
 (2603:10b6:a03:54::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.18 via Frontend
 Transport; Fri, 25 Jan 2019 17:52:48 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT020.mail.protection.outlook.com (10.152.75.191) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1580.10
 via Frontend Transport; Fri, 25 Jan 2019 17:52:46 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gn5eo-0006wW-Gn; Fri, 25 Jan 2019 09:52:46 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gn5ej-0005u0-D9; Fri, 25 Jan 2019 09:52:41 -0800
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x0PHqd4k030470;
        Fri, 25 Jan 2019 09:52:39 -0800
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gn5eg-0005s2-Ms; Fri, 25 Jan 2019 09:52:39 -0800
From:   Vishal Sagar <vishal.sagar@xilinx.com>
To:     <hyun.kwon@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <michal.simek@xilinx.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <hans.verkuil@cisco.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dineshk@xilinx.com>,
        <sandipk@xilinx.com>, Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Date:   Fri, 25 Jan 2019 23:22:56 +0530
Message-ID: <1548438777-11203-2-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
References: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39860400002)(136003)(2980300002)(189003)(199004)(2906002)(16586007)(86362001)(54906003)(316002)(2201001)(110136005)(6666004)(356004)(36756003)(14444005)(9786002)(305945005)(81156014)(8936002)(7416002)(8676002)(81166006)(106002)(63266004)(50466002)(478600001)(50226002)(107886003)(4326008)(106466001)(11346002)(47776003)(186003)(77096007)(26005)(76176011)(126002)(486006)(51416003)(7696005)(476003)(2616005)(48376002)(336012)(36386004)(426003)(446003)(44832011)(921003)(107986001)(83996005)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0201MB3506;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CY1NAM02FT020;1:KaaB45ds2XeX6jwmLO71DbLSz/eRVo2/8tzlYQJI374vQBwaE3VJC3cMn+6tqoUC89nIOQ/9Z8uxtvpYL01pVMDP41Cq3PZn7ZNF1LSfzgafIsYsCi2qek8C+LtKuaDwGBLExMFvbnIcgdGE7i1S44gRF40lyfEZB6rmX+izFHM=
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4d857a6-a540-4426-b310-08d682edeac8
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:CY4PR0201MB3506;
X-Microsoft-Exchange-Diagnostics: 1;CY4PR0201MB3506;3:7AyOJw8veXjMCVTqoNnehQJTvd7z240nwcxwCGu+FZkjvrYZjDNkOeb+Vcl7aajPOiyQAILuv3rLy5maiZvE+WRoiA4dXTftRksOo75MU3WZPWpJ7XtUlpqMXuOZb4+5cU4QUr5t/jtqJm6sen+mUEQHzPKdGzsLWW2B+xKHTdG4pRFhbFVCa1Kqh5H/PlF1NAILskJyXcWItNPn+3KmGPv3KP1Y7w5JeMAqZn8vSfIEp0P0jRvh0kmh627MUOeCGaXS4husuZAX6MA0S3M+h/zPgDnZlKpgMWpLDRLDV2e2bL7QfVnRX9bw0F23jfVRiZVkUADpJUpZJySBEMORwDUYMlcwPXUweJ5RvV7OSVpWd9DkXQ47f/TMskbA7+gO;25:tTt/dNQcwUAjhu3I+q1tjbN0Ky1hhVYqZURX2NYkCLr6xjhzpBSjWuxlBBG+a3dZfqlV9i5dCxeevBV9CcUELkA4DeRJE+T6IbQGuYk7Q4kHM0eUEqEKRwwQ9GKnVlcCe57yBnDjH3mifvIoe4m0SZfksX/jJd+kvMouvDyVT8yS0MEYrKzGGhFqnS8vJrRC45N95kTM/wX9hl59+vIW+G0iDf4QT/AcQtrPMvMsCQKw08vBLoGG8DB7KqVjJ6120uUaLlxWnOAsxidly79k8lF8PVPBSsylTxztsQR0UOoUzzzz+JkNMyT2i3xsBVEPV1OieZBtrNT0LjY3LrroPA==
X-MS-TrafficTypeDiagnostic: CY4PR0201MB3506:
X-Microsoft-Exchange-Diagnostics: 1;CY4PR0201MB3506;31:k9zIkQQpDUcQyYE+DncWxJ4/BIE5qvHEUnuRIetUADCK13LcohRwrDl9GKnLMhbSU4LSxyXmtqy0HarKySE36HoQ+NNMlOt+7evbQpiqtfxSn1ghCepOHvh1PHFdJDaOQYwPNXR/TQGk9n/gzBPxemkrCV3xSRPNglSYJ2+Ow/bPp0xnkUkncKAjPoSdEEXP/tWMwX9X1nML6I8QkNstqaOpau2wLUhRuwYrROJw+M8=;20:ictRnBiJtbP8O3fIQb7VTQl2L58uyEw+OrZD9xXTQwdPnB1x8OgGDzSXlJrYGE2hX0BbABnzcTdth55jVU0hI5VsrDA0lxuV23aV6fiOGn7qpneeODbo+EHbJR+7cqnEndNrIWiuGCsX3kGT4uVumhhAGGaeVx3VWkFdFqM5I3D2lI2MIgs1zsTkyV1Oa97pkAXmoAUtE+8oF/qcsKOSvn3aGI2pwhtEKdQSgrlXqxI2IQSrXzquTc/QaEkvQXfnuR/ix2kG70bSLkMKruMFs8GBMq91xVgudoqO3jHkuireIeY5chUxMpnfjqVzp2Aw6R1HN4OJ4V32VmhW1OHFlemZSqphqw+KOPtRi9gaFVzTqO01QCoEezsNdHIUC4wQEfRHgbtN2bovJPBbCRy71G2BB0RVFZPRhyvi//6QUTf4KWRYsGtlaHurb87z9iLovI7GGxXEO8OHUb0weEsIxjLKUxpt9UTZMH1WXgHagNFCUKYvhUoFFHwIYOyzbrjo
X-Microsoft-Antispam-PRVS: <CY4PR0201MB3506843E36320CE012484955F69B0@CY4PR0201MB3506.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;CY4PR0201MB3506;4:t5p1KMke9TOXQxOG/9wcVMTxT4F/59weiUwhfbNQIkTBR35sp6Is7dbQgbFgW04EfbLDG1ZjoY/GB95KEXf5vJgtx4/waBudGRpE8RIhLaJFzioXct4ZiXdl6NxHLXQtSsRR3pwd66WexocSZXs0msyc+jRaJoIrqhxL4c7hatssZIMxyxGvs2rSPbq3ZHv8QUTY8XPW/tIKUUNU+iRlUFGMMP9B+8H66dhPBWtGny1GwioatvLe8nwq9hDzl86y8iQXtuddQjwxWEGysSUZg3+3SqxPf27v0C+CmDeqEVI=
X-Forefront-PRVS: 0928072091
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;CY4PR0201MB3506;23:nyyYYkG6wSdHg9P+NKMnFji1KFTc/KGxc9WOk29?=
 =?us-ascii?Q?g6kuL+AXFrWJFtLNTbjZRYT6YanLLEXmn0TJrLYE7ngSMm8L90Iuf4dxYLjr?=
 =?us-ascii?Q?pMj+xIpx+zh/LFFgaGRJnE2lxMMM2qYHqc8bDMEEFXMP/lRasPmUQ0eVgO71?=
 =?us-ascii?Q?zIBxe718BKF3M6ogyBgwVUd/jDNGT6+cofPaScd0PMAHYrRGimAC3wxhhCrl?=
 =?us-ascii?Q?x9xpvW/FsilrhIrquArqvfnecMdwnn0DJTMuLfJMtZKMKPDwcKz9yzqCQtUx?=
 =?us-ascii?Q?eGXGjbjzl4Ri8DI4fObcHBxgzOk7D3wUOMQRSEiOTkSQn7Am4gJ3udMc6RXc?=
 =?us-ascii?Q?mz1WXkFyThSiWKzPbAmEu+1/b37iWjuYxhhyHW3hG01S7yCTvexLir0aWhPu?=
 =?us-ascii?Q?9rVPxculS55Q6Rp5OUdZLYfkfzvMzMUj37uOb/K8f+R2v7nTtKhFWaRUH2rZ?=
 =?us-ascii?Q?IvrRgs6bec5pqNV6sRYuzEZOa/eM6GK1+dZg1ENFIbU1y1KgHah/WtYgzSLU?=
 =?us-ascii?Q?NWks1TsX1qRgUMUNrP9qdaG8Mu4mf0tkpwSJOanoNrx++/fEeU/hECCciUkd?=
 =?us-ascii?Q?dqJornSifS9gxAYD0wT2bciVVwMKUUM3DpiHoyisxA6mLB9+ZVeahp00v3ad?=
 =?us-ascii?Q?s/KgVSCWNATxPV/ETaGOe65bGciEdOiJUc8R39L41PpgQUbiBXVal1DU74TN?=
 =?us-ascii?Q?0UFacavffCsS+7uddJTgmDyXW1SXXti7xXLayeT+TY6MmirljtBf83GdTY1c?=
 =?us-ascii?Q?eB84qfSU9IEqGnKWtOs77u1xNRQbpM36jfa9wHJaQp0jhn2r3vopJB1qdUob?=
 =?us-ascii?Q?homo+iQIh6YFX7xBP7Ze8I0MIERQu1x7nOD/nDJRM/1kVPrztVoAaCx2R88j?=
 =?us-ascii?Q?zpDbyKYvcRxijSN3Kowo88oZSPOtcs2SsETglifsjc/w2Kidz32WOKOO7fln?=
 =?us-ascii?Q?WysVH1ouavOjbV0EeMBZyqT7Acg2hDA61hds9AgFVQ4IU781Z5uop7SX6zOi?=
 =?us-ascii?Q?j8wqEo29ztVhJL4F1Jfk83FBWSSlorvkVfMqYbQgfDiDoARhcY9ZkI2HmWb5?=
 =?us-ascii?Q?82Ex0cg9DBw8mg6djK33I9G1tKotznbZ1XleV4dhGA6VSpan6LGMmJbOsWI/?=
 =?us-ascii?Q?kcV2SLcU2B41gw1Fe3M7CBZ0xJifZx8edCqRaqRZXAfRHBNS0AAaGmNeGOUj?=
 =?us-ascii?Q?BLQU06QGi8qgcvG8TCignw+ciLlQWOsQ/tqOj1lZYlJfzAVRRBEO+2t59eQ?=
 =?us-ascii?Q?=3D=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 9deARe5lVu/OWhn1F8VRHpKPikeIsRI8v4Ic+PqYB4VGYHZFvG5cGX3hRN849F5Z1Sh/ud05SYN4WCGpISdqJ1LbPiWmdqdr2gSTpQlYjEFmP73k/yCCUccVVxvMmuASoQWK4ilOf0tkl0DeNFGRzxCg+lJJzqXqM7KwHtanfySY7b0Gka4hBFM9/npxK0NIFNVE9AgkjmwSXFNDlc0Fl12v524U/HgtJ8OXjO46gR6Jhfv4DkhFb7fA9gFyuN+pZK68ze4NHW0+q/wGUaWe2x7Qbz9QFeqKQa+0IzpihfSbiq8NmYXcDYSpCwMD0PgZuboWhtYutpw7IwBD6HCYMgjESLbmOrvZmLDXrxoPnhvSHrP4BhS6lqZajbT6J+xsEXjFTwj7C31UTZ/8gpCLPXIi5SpAcWoJqbw22svnbs8=
X-Microsoft-Exchange-Diagnostics: 1;CY4PR0201MB3506;6:Ks9/FMB1YIiBd7FMCRFWiWkw+Fbz7fUCq2/Gk8yA+wu1xdTxnKaZnizW80gvzeE1yhHejI08JD+wU0eIDUcNQIhHKgvFBnBc+BFXprXjRKvOhxNL920C5IKrEb2aXuePSY0oKqTJyDtJDlhkPj8G6UrmvjkZdjlMb6PxXDZ4GCMIAyYHH/iDwibzSFsDkTcQVWRhC2qno39DlSXj3GWv/CSoZzz2N3DKz4ySgeWpxMPfQ9qxkcoLraSW8M9BkkQsQIFtqFcbozFl8byioLA9u7buWye2L/ncvbPA9ypKFOmXRL7FhUAUIrsa/qY58/+figuo4bu7JYWmUGShl1kRWAthdfGr2pOs2SgSJeOJ/CDoXu6dnRggWdubzlMHmHJdez1p9kxYyIdGg0BkPFiYEHLYqwrQCBTGIarf9TLtduFQ+im5s9cZskclScldr5dGhOG9EtTTfXjhveBCQ19x6Q==;5:Bf3MYcQPJEbDk1RIeO07XP4qkQMY4HGY0ZGmnoguerf0LZiTNQgpyKvMdM2OPgtfpGjpM0jx0UYDha/QqyaIA6mPUKo7rLhBBR+h/lcgaVA/YBw4svavznOCJmQfI7Pdt8wacREGsgZ4cfsg6w6Kiv9yMrjBFnbF+c+bYxQVGmV9u8K4qtc60YP8SkQugo+gfrwXsiSHgnGwj2+HHDlxwA==;7:vPoVY6q3vcs5OIppQedSzKtfUfA/XXIwGiQq1SrPvD4z0AKOlKVu2VKGCgYpAwEad63R7BJZgIFX++ekTmDLEc1cYOKqhrFvhMkyiEQiT7qQfxVpDDVljBRoQfAqipfhMFi2h4g1+9mdRUYWnumNEA==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2019 17:52:46.9112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d857a6-a540-4426-b310-08d682edeac8
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0201MB3506
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.

The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.

Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
---
v2
- updated the compatible string to latest version supported
- removed DPHY related parameters
- added CSI v2.0 related property (including VCX for supporting upto 16
  virtual channels).
- modified csi-pxl-format from string to unsigned int type where the value
  is as per the CSI specification
- Defined port 0 and port 1 as sink and source ports.
- Removed max-lanes property as suggested by Rob and Sakari

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 105 +++++++++++++++++++++
 1 file changed, 105 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
new file mode 100644
index 0000000..98781cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
@@ -0,0 +1,105 @@
+Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
+--------------------------------------------------------
+
+The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traffic
+from compliant camera sensors and send the output as AXI4 Stream video data
+for image processing.
+
+The subsystem consists of a MIPI DPHY in slave mode which captures the
+data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
+packet data. The Video Format Bridge (VFB) converts this data to AXI4 Stream
+video data.
+
+For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Subsystem.
+
+Required properties:
+--------------------
+- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
+- reg: Physical base address and length of the registers set for the device.
+- interrupt-parent: specifies the phandle to the parent interrupt controller
+- interrupts: Property with a value describing the interrupt number.
+- clocks: List of phandles to AXI Lite, Video and 200 MHz DPHY clocks.
+- clock-names: Must contain "lite_aclk", "video_aclk" and "dphy_clk_200M" in
+  the same order as clocks listed in clocks property.
+- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw design.
+  Packets other than this data type (except for RAW8 and User defined data
+  types) will be filtered out. Possible values are as below -
+  0x1E - YUV4228B
+  0x1F - YUV42210B
+  0x20 - RGB444
+  0x21 - RGB555
+  0x22 - RGB565
+  0x23 - RGB666
+  0x24 - RGB888
+  0x28 - RAW6
+  0x29 - RAW7
+  0x2A - RAW8
+  0x2B - RAW10
+  0x2C - RAW12
+  0x2D - RAW14
+  0x2E - RAW16
+  0x2F - RAW20
+- xlnx,vfb: This is present when Video Format Bridge is enabled.
+
+Optional properties:
+--------------------
+- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
+- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
+  only 4. This is present only if xlnx,en-csi-v2-0 is present.
+- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
+  Configuration Register.
+- xlnx,cfa-pattern: This goes in the sink port to indicate bayer pattern.
+  Valid values are "bggr", "rggb", "gbrg" and "grbg".
+
+Ports
+-----
+The device node shall contain two 'port' child nodes as defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+The port@0 is sink port and shall connect to CSI2 source like camera.
+It must have the data-lanes property. It may have the xlnx,cfa-pattern
+property to indicate bayer pattern of source.
+
+The port@1 is source port could be connected to any video processing IP
+which can work with AXI4 Stream data.
+
+Both ports must have remote-endpoints.
+
+Example:
+
+	csiss_1: csiss@a0020000 {
+		compatible = "xlnx,mipi-csi2-rx-subsystem-4.0";
+		reg = <0x0 0xa0020000 0x0 0x10000>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 95 4>;
+		xlnx,csi-pxl-format = <0x2a>;
+		xlnx,vfb;
+		xlnx,en-active-lanes;
+		xlnx,en-csi-v2-0;
+		xlnx,en-vcx;
+		clock-names = "lite_aclk", "dphy_clk_200M", "video_aclk";
+		clocks = <&misc_clk_0>, <&misc_clk_1>, <&misc_clk_2>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				/* Sink port */
+				reg = <0>;
+				xlnx,cfa-pattern = "bggr"
+				csiss_in: endpoint {
+					data-lanes = <1 2 3 4>;
+					/* MIPI CSI2 Camera handle */
+					remote-endpoint = <&camera_out>;
+				};
+			};
+			port@1 {
+				/* Source port */
+				reg = <1>;
+				csiss_out: endpoint {
+					remote-endpoint = <&vproc_in>;
+				};
+			};
+		};
+	};
-- 
2.7.4

