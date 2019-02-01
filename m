Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD0BC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F91218AC
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:57:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="TcLqcN1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfBAM5N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:57:13 -0500
Received: from mail-eopbgr690042.outbound.protection.outlook.com ([40.107.69.42]:52288
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbfBAM5L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 07:57:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0T3dur86sxdu2CJu+qGoHACPHE3ytdU7iNy0O0U4nA=;
 b=TcLqcN1zRETYwq2sCehxfw9jRpJy3r0s5jgnLG51Yl4RpLtg/35jPXAl2nZNpQHDl+Q+Y45uDnBtskq/XexLTL9TSy+7qPjVFVsOjWBbFCiKdtnjycGhbfGZpSewBT43546N780wFmlmzhYDQpGvll8U/f4eiKea5z8E/ilvLJY=
Received: from MWHPR0201CA0066.namprd02.prod.outlook.com
 (2603:10b6:301:73::43) by SN1PR02MB2157.namprd02.prod.outlook.com
 (2a01:111:e400:7a48::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1580.20; Fri, 1 Feb
 2019 12:57:03 +0000
Received: from CY1NAM02FT040.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by MWHPR0201CA0066.outlook.office365.com
 (2603:10b6:301:73::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1580.20 via Frontend
 Transport; Fri, 1 Feb 2019 12:57:03 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT040.mail.protection.outlook.com (10.152.75.135) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1580.10
 via Frontend Transport; Fri, 1 Feb 2019 12:57:02 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gpYNR-0005Nu-Rh; Fri, 01 Feb 2019 04:57:01 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gpYNM-0000IW-MH; Fri, 01 Feb 2019 04:56:56 -0800
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x11CumD5009903;
        Fri, 1 Feb 2019 04:56:48 -0800
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gpYNE-0000HA-7d; Fri, 01 Feb 2019 04:56:48 -0800
From:   Vishal Sagar <vishal.sagar@xilinx.com>
To:     <hyun.kwon@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <michals@xilinx.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <hans.verkuil@cisco.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dineshk@xilinx.com>,
        <sandipk@xilinx.com>
CC:     Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH v3 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Date:   Fri, 1 Feb 2019 18:26:04 +0530
Message-ID: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(136003)(346002)(376002)(2980300002)(189003)(199004)(8676002)(2906002)(8936002)(81166006)(81156014)(106466001)(426003)(36756003)(44832011)(476003)(126002)(2616005)(336012)(7696005)(50226002)(486006)(51416003)(47776003)(478600001)(106002)(6636002)(305945005)(48376002)(50466002)(107886003)(110136005)(63266004)(77096007)(9786002)(36386004)(14444005)(4326008)(16586007)(186003)(316002)(86362001)(26005)(2201001)(6666004)(7416002)(356004)(921003)(107986001)(83996005)(2101003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR02MB2157;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CY1NAM02FT040;1:QM2c8FnDtsSL4CYTVzll7SYRLi0V+VoqyXRxAMmvanumSAKWKz8PCJYCtMpuombIkM0GnbZ4Y0BbfflkI8aqwSppOBAL/h4imzqP1gpmnEnQ7a1lkI1D9g4QzyHmXMKWMlIxjinFHUSDJrtOmd/okaib5nuzojn08xu7nore9F0=
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01530231-d3a7-48ba-f1f3-08d68844c2f9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN1PR02MB2157;
X-Microsoft-Exchange-Diagnostics: 1;SN1PR02MB2157;3:tG0Flr1nUyGRcBTFuO+DTzkNiAmSGw+RjENyx7v6vob9GXn5ouuYs81ZPyOx4hczFofZxPozLmRbFcuxuPgjLXgqPZ/dIXhv9BxaGpgtbNuftRIDhgEKtLsz/WL1LGGEYXvzSLJAYdSFBeFbGqFZg+/EVb0ACNqoiGUyJMY5zGaVF+YDw/OBqO+y2w1b1rjRcn1RETmGRDPJKpolgBxakdOfZfKjUVud8S7fGaxcn+FWiPMhSlbg7jp3wm2CavgyopehNzq0xFbYqoq0sMRE1oOenZ9fO0K0nk0GI47mYPAtTldyyu0yvTJxdY7PVffuMbM3OeOIaC45+T+Hu6l90jaGGgejTRsIQ+yzM+Ttdyd+lNFIKA1E5j4VG9Lvd91m;25:nQ46biTGhfHDLqdbLZQXtw2+wau2N/4k1Jd9dzQ8NCoWHO9eT4Ja1ZeAdBlAuMFlqmVkoQcb/yAenb028XSKjj9nxnzHZOn7mGE+QNcOUUB5KXjkZ11EhlpwqqTiJzVCzyR4EAenzminJDFtnQObEnudrs+goDPSqLH/UizdBKzr37YchvvmfECXxdQzvDoKxlOGB4CG71reaVpd/SkeVlWQLIoWgYrPfk+Y3xlQEPa64EeY9JJBLYXxZdZ8AgiTpjNhUoVH2bNRZL56WTLP4NjfQfzcOkZXBhpbuIdj0gUG0a+Bv2QNhPa9MKoTvU5cxx/wJpEE7cHfjq9ehvd9aw==
X-MS-TrafficTypeDiagnostic: SN1PR02MB2157:
X-Microsoft-Exchange-Diagnostics: 1;SN1PR02MB2157;31:SuScgByNlXU9vyrYaGKwVrqYDBT9AvewR0h+ZrnzmuaT3LJc5Hnm0+MCFErfSFpK1qhGat4ClGACQUdo5lDT56WjcgCvIHDVxV7H68EsBd7k8qopULVsyxwHYvDINNqDxgwhkTQNf9nOgTZ2KAiTtPUVGl2J1E9OROYzruFVWbGW4AIu+AJf7NA6oWLXrAB3vMdgvqwG492LwIzdHynfBvxo8sMlBSEwN251ktiJnfo=;20:KZ/FowrndAS4yU1CY3jGjoZMkcE4hBhaMF6NpXAgmgXeX2w917i2HtOx4NXtTMmvzNOuLume1nLL2jp6olRN4JPWfJded17Gsvpy73ASZxJ/ieYLGG7chYnTgp64by3VR3VBGFt5MYtrh9xhbnXVJOE4RcVOmc8bN79g0pTuknjeRqsrVZzNS/5WjOMQ8KkTghrLCkGyx9gX0khxrYpgnSB7LPHH4QS+A+/D4LKpGxMd77yNK1xTv6K0Hq9ZV8j3Dj0kQDmAqbWWj/6HFeNFAnSDHSlGZRxunD0ri81Nh7vE3ownU3SEQqWoND495nzgx/WVJ9TRu22lfvd+pDmeIHui7YYcooAIPxU3cvm/FYiExnHnzxz3f4zxWIIVNSF8LZh59Dbs70SMNIh4CxpOaneMVgmAyrGkmZ+2PCgJcEIs95rci8a4uQCBbSk1T69GxhHj9o2fwjlVs9d9J+NhEkPcOKrQmHYtPMY1InNUOun5fK7LfOu8mvz8oA89Opfd
X-Microsoft-Antispam-PRVS: <SN1PR02MB2157D088C4662DFA71E20BCBF6920@SN1PR02MB2157.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;SN1PR02MB2157;4:8i2stqGP258utnCp6Bt37RkWc60QFFDHuepWuP0PNzUygZJgxGInmo0C8hLqhVAb043Eavji1xYyQ8zLoRogJQtYOdJzAZUmfyfWRwxWrq2B9YlI3XJ2rT+6aDiFR58MlaaACRYp7zmw7jUsezNIEUnrcXLS65PzL6oMk8Qybt0NImwKOgtKu/R5O2SnOrHBHEo/iUt/omqTbwe7U1FCzLF+aYsc/doQcg2Wg/ofQcfzn9pqZwY5ZhIR9ab3mnWBuCx27hi6FEnqZ8+B5++30kfRY4A7OAva3KocO88u6ps=
X-Forefront-PRVS: 09352FD734
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN1PR02MB2157;23:HNOUdZPsPlA5umasrpfBKnFSMcYZbdJspJ0Gh5UWo?=
 =?us-ascii?Q?oG4nHFzlHPr1+2FmfFKXwZFObJd2J69buGi0xu3m7nDN6/IssivPeqe5Ptm3?=
 =?us-ascii?Q?RVXZIcTBmdeplIDqgD85EzuW5+5I+ThE1SVgeS2PHEG1yBdDimyaeKQfb/09?=
 =?us-ascii?Q?eByED0+6nXIdw/HWHCoWdnglse5JwOT758uBMU+op5zxXQ1EFlpLmtlPcOuW?=
 =?us-ascii?Q?seZWlPmJRQtDBWtnRCATJh6BlYG9jtXvxJkGZT6CQ9P1QzYGHmgFUI2KpZ6T?=
 =?us-ascii?Q?0agB0QmRHcaK06Ox5Za0sQB4xI6K1AD1k47C+Mdp0H+Efj3cM/CSX18vIwpN?=
 =?us-ascii?Q?gvdEXIsN2ELzsQzWFNIYlk0YcfpIHzE5LRjzLn7ZYgbKyDqzGnCh8ktGZm+q?=
 =?us-ascii?Q?iFqJBvchzyl7UdZ9QkC6sBi5GW4qqm8sKufPp0JkQ1/Yj00SVbIwsCD+SCu6?=
 =?us-ascii?Q?HA6OykQoXNMGri67je+fhktaoQV3RBOdi0aFu5y5lXfe/fCjn7z9X313/WoI?=
 =?us-ascii?Q?jOA9FnhOL668OrFtQN+9gtvN8APFwMZg28yH91xV1h5OBecIoS64brmk+7+l?=
 =?us-ascii?Q?5g24Gq/UICWU+lCjjkJWwJF+XH1tCESekVNq3tLFKNq3+aXRnY/nTlROeiXi?=
 =?us-ascii?Q?lNj0Q/dqXRJl96Act0mCnB14rG+v8Sdgvn0Zi+xy0sMvl65AllkSlSuC+5LU?=
 =?us-ascii?Q?U5aPxDgercsTjxQPXBNRGGi+mL8AkUVO02Uf7e1N6nSzPLa0AVo2tDhLNLCt?=
 =?us-ascii?Q?iOh9L4qnZTBYEAzpHfRaQgFYg8Oj6C3x6Lvc2PefSLqDaM+fE0wjU21Vh95P?=
 =?us-ascii?Q?71YtDjlX3sgELOjISRrFmi6D0qj7VCVoUGhEOzxfzblr/68t0n+Zw0ycxHov?=
 =?us-ascii?Q?pnnsVQ1QB8sP8QmIyWq7lpPAnsFiynZGu6c5Z1P/Jr0nOdQVDmExtQvQhGvc?=
 =?us-ascii?Q?RXb5fJ3FbH8gZ0ro/4IyVGyX0CpxFQ9NCAvDjzqBhYvxUAIcse4KDIz659I+?=
 =?us-ascii?Q?5aer/Wn6HvjRsTco5SlSKEdelHbTMa2UUU/I0/Hwnrjd0BY5aF3jZpbR99+G?=
 =?us-ascii?Q?pzbn74Mk1k1mu4wktZqKayWjNLapp7qmFgbIKQI5SGwqEup2SJKiMJBLuoIk?=
 =?us-ascii?Q?GlnZJzY0xz+LYNrZo/xP7wffcpn8ld6Bn6ql1UjQ7+hdwktHfvbknS5U848E?=
 =?us-ascii?Q?u3S22nB0wE8sAk=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: VD1lim5EAfILQpJ2OhW29HsniY0E2AZHVryROCz9j8A1UxKSQ1Ey8ua0T94XJyDV7vemgiy6f70S+bLMMyVupWIBUjAHQUh5uv/eNEkgeRZsB0xuxsecCcexeBYpLZ1N4pMzUMQMyqjSm0pnb8gOhvnKn9VC1lc8xEUIQRipCNdeKBb2ZwXZ8cuETtIGLoLLeRCk8B5RfcX4u7LjeOUsD25nGVLw1/AujGaXWBuni30QD9zNgvr8vANipJZyUBR6NsXy7vsa271HEkuMu5WjggXs2X8dxlEmH+mlIDecqXhrMitIbwSRCNlRloNCYVfCKVv7UL7iDmkZ1oKspuagMMVths86JELY3KVXoja8WG3LRBkhURg3x6UPsLvrhL75hOx0N2i8ZyC7AHbo9NzV/hX1QT50rvFNCtB5p18XpE8=
X-Microsoft-Exchange-Diagnostics: 1;SN1PR02MB2157;6:O1Q7v2Rdw3UaPVuZOERXGh0IhNpAVBfBD9EXwV4yk9TexdCQPTuQp7HUF/jgPXJYbYMjoC9EEUmxfc0CeqcS+aMr3FjyfEzd/S2aX5p5FZn3av2+Msqqe6x51rRkC6M33pVgBIbV6Fsnm+UMh3a2+370fUWVbhpoGFPenDzDGeGE7K2J670g886OY1+lNQSFvqDQsaCeYWcKorjtvrDsnaC/2toQOmaH5Dmf/V0aLVNETegO1ZMxUq87gs/OZRymYHhg2Lhd9gIEM4R++3+lT+EC0EwAoSkXKGrMDWS7yFcXKtcWrtBi1QZvSkX9ny0gl5h7YKlNV4iGlGZAVbXU9I9WUNl+JCJm6I6seKLQJnFFjfnwxDoCFaess82xpXOUFXc/WIiO9cARuThcow+yPVMgftoG9ES7gnY9bFEdXOvXRVMlZsqUWH+le+XeN6K4Oh3P8Ugr99Pa469GvYaADA==;5:QhABjBezQt6dJTB1S5L2c++FI9LZY5JpruGt1kVZfPzF6aHjC8Fl+/xeLHRbOSc+Z0hndqmtj1pSih5v8e0daupsVc1BjaruFvlG0gdTPK2oCVvBCIjsXMyWXkLW9AW2zr5zVwNMbfbVY2c1UeM6WLmZ+MwH/gGUutAxLWG9gEVx63Zj1A2Lmlu5Gx7Q1f3CiLC/bLsFAUcFEyZtgSTLuw==;7:CcBB4sus8SjwrHPOdlAj0CQtXijC4DKJ0GNAKyp940p2W/tEE8Ff1yGkjZsVKloqcj2sgiTyAR1fVokO8zrPKFydnBoZTwTGkXQIc32zrnjpRCZVOB61O6T9Jc+F5DYCJu0nMbubcCnUmObMVDIeBw==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2019 12:57:02.3101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01530231-d3a7-48ba-f1f3-08d68844c2f9
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR02MB2157
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Xilinx MIPI CSI-2 Receiver Subsystem
------------------------------------

The Xilinx MIPI CSI-2 Receiver Subsystem Soft IP consists of a DPHY which
gets the data, an optional I2C, a CSI-2 Receiver which parses the data and
converts it into AXIS data.
This stream output maybe connected to a Xilinx Video Format Bridge.
The maximum number of lanes supported is fixed in the design.
The number of active lanes can be programmed.
For e.g. the design may set maximum lanes as 4 but if the camera sensor has
only 1 lane then the active lanes shall be set as 1.

The pixel format set in design acts as a filter allowing only the selected
data type or RAW8 data packets. The D-PHY register access can be gated in
the design. The base address of the DPHY depends on whether the internal
Xilinx I2C controller is enabled or not in design.

The device driver registers the MIPI CSI2 Rx Subsystem as a V4L2 sub device
having 2 pads. The sink pad is connected to the MIPI camera sensor and
output pad is connected to the video node.
Refer to xlnx,csi2rxss.txt for device tree node details.

This driver helps configure the number of active lanes to be set, setting
and handling interrupts and IP core enable. It logs the number of events
occurring according to their type between streaming ON and OFF.
It generates a v4l2 event for each short packet data received.
The application can then dequeue this event and get the requisite data
from the event structure.

It adds new V4L2 controls which are used to get the event counter values
and reset the subsystem.

The Xilinx CSI-2 Rx Subsystem outputs an AXI4 Stream data which can be
used for image processing. This data follows the video formats mentioned
in Xilinx UG934 when the Video Format Bridge.

v3
- 1/2
  - removed interrupt parent as suggested by Rob
  - removed dphy clock
  - moved vfb to optional properties
  - Added required and optional port properties section
  - Added endpoint property section
- 2/2
 - Fixed comments given by Hyun.
 - Removed DPHY 200 MHz clock. This will be controlled by DPHY driver
 - Minor code formatting
 - en_csi_v20 and vfb members removed from struct and made local to dt parsing
 - lock description updated
 - changed to ratelimited type for all dev prints in irq handler
 - Removed YUV 422 10bpc media format

v2
- 1/2
  - updated the compatible string to latest version supported
  - removed DPHY related parameters
  - added CSI v2.0 related property (including VCX for supporting upto 16
    virtual channels).
  - modified csi-pxl-format from string to unsigned int type where the value
    is as per the CSI specification
  - Defined port 0 and port 1 as sink and source ports.
  - Removed max-lanes property as suggested by Rob and Sakari

- 2/2
  - Fixed comments given by Hyun and Sakari.
  - Made all bitmask using BIT() and GENMASK()
  - Removed unused definitions
  - Removed DPHY access. This will be done by separate DPHY PHY driver.
  - Added support for CSI v2.0 for YUV 422 10bpc, RAW16, RAW20 and extra
    virtual channels
  - Fixed the ports as sink and source
  - Now use the v4l2fwnode API to get number of data-lanes
  - Added clock framework support
  - Removed the close() function
  - updated the set format function
  - Support only VFB enabled config

Vishal Sagar (2):
  media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
  media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem driver

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        |  123 ++
 drivers/media/platform/xilinx/Kconfig              |   10 +
 drivers/media/platform/xilinx/Makefile             |    1 +
 drivers/media/platform/xilinx/xilinx-csi2rxss.c    | 1554 ++++++++++++++++++++
 include/uapi/linux/xilinx-v4l2-controls.h          |   14 +
 include/uapi/linux/xilinx-v4l2-events.h            |   25 +
 6 files changed, 1727 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
 create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
 create mode 100644 include/uapi/linux/xilinx-v4l2-events.h

-- 
2.7.4

