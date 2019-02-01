Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8CAC282DB
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E67320870
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="FPei/uzC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfBAM5J (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:57:09 -0500
Received: from mail-eopbgr770043.outbound.protection.outlook.com ([40.107.77.43]:42148
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbfBAM5I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 07:57:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRqafDk5OAPSlddCWXlcotCTMMad3HfXlz3jzSkvKGw=;
 b=FPei/uzC8vw5hcu/gdhgoG7PW1aGuYTs59McMKdnWH6I6TIZxHj+O3Qmatxw9iHtkDtdK5mCGFbrsw3BSF9AB5sgYu7FcguGzQ0dO7TiYs+dEYXImC+sidMsqG3YtTszIcjB9cSIIzBMtTCSdCIiFUdaP8110DpTEXUZHn0Ln+M=
Received: from MWHPR0201CA0001.namprd02.prod.outlook.com
 (2603:10b6:301:74::14) by BYAPR02MB5016.namprd02.prod.outlook.com
 (2603:10b6:a03:71::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.21; Fri, 1 Feb
 2019 12:57:03 +0000
Received: from BL2NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by MWHPR0201CA0001.outlook.office365.com
 (2603:10b6:301:74::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1580.17 via Frontend
 Transport; Fri, 1 Feb 2019 12:57:03 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT031.mail.protection.outlook.com (10.152.77.173) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1580.10
 via Frontend Transport; Fri, 1 Feb 2019 12:57:02 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gpYNR-0005Nt-OJ; Fri, 01 Feb 2019 04:57:01 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gpYNM-0000IW-JC; Fri, 01 Feb 2019 04:56:56 -0800
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x11CuqWX009715;
        Fri, 1 Feb 2019 04:56:53 -0800
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gpYNI-0000HA-EN; Fri, 01 Feb 2019 04:56:52 -0800
From:   Vishal Sagar <vishal.sagar@xilinx.com>
To:     <hyun.kwon@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <michals@xilinx.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <hans.verkuil@cisco.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dineshk@xilinx.com>,
        <sandipk@xilinx.com>
CC:     Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH v3 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Date:   Fri, 1 Feb 2019 18:26:05 +0530
Message-ID: <1549025766-135037-2-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
References: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(376002)(136003)(2980300002)(189003)(199004)(44832011)(9786002)(356004)(426003)(336012)(2906002)(6666004)(486006)(126002)(2616005)(446003)(476003)(11346002)(36756003)(63266004)(106466001)(47776003)(110136005)(316002)(16586007)(106002)(7416002)(7696005)(51416003)(76176011)(478600001)(305945005)(4326008)(86362001)(6636002)(2201001)(186003)(50466002)(26005)(14444005)(107886003)(50226002)(8676002)(36386004)(8936002)(77096007)(81166006)(48376002)(81156014)(921003)(107986001)(2101003)(83996005)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5016;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BL2NAM02FT031;1:oli9strgc7TTodFAkjKSb+sljzp5bsqJgBMmiaxSSOZzq6Lov8DHhiZ4lsYV4xzjTgmS1bl666ckf4W4AKukI3QumkzGLyXAwZYb1WvDOQGQO6My241R7M5y4nk8SR71LB7/G1D5yU+zy5eBMjIc2FYk0KIcV3aby0cEyyWLSbk=
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23ea2e7d-86d5-48e5-16a3-08d68844c2b4
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR02MB5016;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB5016;3:7XCcus+p/FOa3kLcumKiOqnq2w8Y8nOCC76R/toYXhZ/5UWBbagMMyTqLnlVcp7uOFT1obfpTMZFS33MTWBRqDi5YbQuTCXJGzTskJWKL6CQq2shJ0sytTG3/2aTXICmaC9oFZjbKB+7hWcBy8F2qSFCvH44cjH4mPpAWbo/obKSPEUHrCod5oRVEeQqymoAVR7qEFBXROg7vwYD5zVyrRyMpQHoVA7SPE36265JuH/B+Z13XBnfRo4FcUybcw3yQ9WdVUfklTHWeL7xZLQf1gNX1CAcd5epBe9tUjToAmHjbelPbZoxkcBzfbR47fGePYCmOWHn8l2ksp2706nC6DLWpwUBjjv/vze0ACLxaDV9SKGmpRM5dXeuhVfmwntE;25:k6Ttt/UhjZgLfzb3Fmm9Bm97krCGVzEiwjLJnwnAiQJ1VQ944vP8k/1ud60iq/l1ofrnPYy0fe47d377rZR/ogM6y80PC+ygmchWm6j90K66bPzKymXTm9ZtKvyUzFtz4KUZYpMEWrtlhhH6IyUnjWFPhFCQKfW5LXOGsrL0ua07D4l0/Qt0hAyWoqfdB5cgLkiwc+cpUg0T8tjDpfE4FJp/QhBD1hK2cz6++x9Qq9+f0kHP9J9oQMGokUxRo4b5YE5cESYksDQ5dEzf3txn3VSeoPa3gVZxx1s49jIyuAYvOTHH4XDRniCZkBW2PJ74+vK9FW1NFVzeoZtTyG2HCQ==
X-MS-TrafficTypeDiagnostic: BYAPR02MB5016:
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB5016;31:d3NbY//VyQ3UZEH50m0PTyPeNCPTbCFeY1FucxbonB/ffWPa2/qctSdGF4UWFz2RX7Isd3sLDiYzSk7TrwGm3XpXfalszjF7DYwvu83GZXgYM1VAM2bsElAL1qeAlbr9zPGLrHe2VteQfX5jArLjLIe14Dmtzcxbx96igr9sxhKD8O/fl0s2wnV4fcHF9Z+CyLhIPY1iiYiPS00kl2swaPJHOnneK/+XWz+jD7occUg=;20:TYwYnw5CBTT3G1MoxuIyMYc34McN9oRBcLDLoAyJpNBR4Ir1y7PyCkvovyCLAT8YNUMP3pkilv1ujvwA5hyEATitNTz8aAi6HpkNpZwj02PODtP9CQYXaZZEhGd74GtHORBxjuQXC7e6Y5MvADqDdcfQVp2Rt8DJmPZcjELk038L0mdmp67nCet0ZyLSE3M4EfpLal4tdJHh7+dBykhsjLqNsYQ3U1LFb5Qkj0Hi2u+vjNhyPJ9IUhG75bETASLKZdVyrUKpN7vXZRRgWt6LNGoQZFbFVMZ8L3O+unYpticB0uWFuvhZYC9C16s3ZRRPLVlwSyo55cxRoAdIwZqTUchYlRfRTa9J1TNEyaoglNy18c9VdmcSgJDzJjK+/xpieEPzSmsyyhnIGV8UoHVXaM71RYE10/boaSyv0vDFk1ibZr9kNFKJCak5Jb3DyNDnp/x7HdNBf0kdxvcT/amzSfxjT0WWKwcT5vPnQ6yjNRuwwMCvblXpDCBi95gqovkN
X-Microsoft-Antispam-PRVS: <BYAPR02MB501640470DD7FB1BF17D46CAF6920@BYAPR02MB5016.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB5016;4:+po9oJPJ368nP1ZaqAlB972f4qOq1DB8FJbyvuNiEnP8nRXCwd/Uz79oOwgJz32wQpcMHnq05MvExr0mtTccxt0JDmXho1+jWvx8MddgPQRsWzHxDqwHeCtDFAfRKoJb+jqj7NQZ7xvi5Rn6e+d5IfhYHPRq2VihSaphu0JSPBLgvis6PC44hoNnUglm2qnbqe3Q33X7fFkARkPXyO+zwEad7zTQrmXNoiDQoNRKkTh+vEhZxzMOrwyyXRZPU7/mBAQQ5WmDbSdnRa7FP/yMYxAGFTFdHuR+mmn/ieDgSgY=
X-Forefront-PRVS: 09352FD734
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR02MB5016;23:qEB4TbOt3yQDgc8gyTXuhRj6ovxmqPQj0CeUUrWfi?=
 =?us-ascii?Q?2aXQ1aiLM+fZNEZk2/T0SOofytBQZn1T7I4pRA1fZFZINzcA4Fzn1S9pzIwV?=
 =?us-ascii?Q?ChuJGF1nA77pZIuQJayp8UsSJhb7+WbCRPhbjvgGRnRk0XlJWPcsUfXGG1fY?=
 =?us-ascii?Q?cwT2Fy+iVMvEJK/znz4TA5ZlC7uND9nUqPkXAjQjAoUIpRHMnCQ/fghBlB6s?=
 =?us-ascii?Q?ml/FDPztwdqhUc7hASeW2R7ry7wyLsUFuWSqUohUcG5AVdii43RuHahaEK1t?=
 =?us-ascii?Q?c9bEgHza3Xo494bDf8bf/S7yqNIuQWZR4I4AZjJ+YsJpo30HLfgl4SV9bww1?=
 =?us-ascii?Q?t2fZP847owj2uMraFjcAmBt9yc3ShZZ8jE9C65BAQc7aDgIyso1NUlAfh+QA?=
 =?us-ascii?Q?o+pBaQIZXsUbpbFvXHmYNoVUQr+QAgVedaHxAYcYmau2O4NzY8aaouX5Jyq1?=
 =?us-ascii?Q?sWWGTCtGQvk9cUQWuD9w6V6oOqFHdkThLOglkm5kHxgwk6t2YAEIIyM2iHwS?=
 =?us-ascii?Q?MMacCFWMR6MrkwSMv0ldtHoOlPyNYx+0dJd4U0stdrtne9IYbhWOPRBQvNj+?=
 =?us-ascii?Q?lCkMfsngLwQ00dRIC/N/NHPfvyteRCbH/Ylhc8Ki0SnnQIekNJ9IKVrSm/Dw?=
 =?us-ascii?Q?88TvC/lQIiQoK5jAmxONvqOQXRTXkR+1h6xle1sfnPwWVUQn5EUDlTrHLBy2?=
 =?us-ascii?Q?9jyXbd+F3/jFgbkES5RAa7gJll5BTg82dccV3967ayAdM3ChWS8srjeinVP4?=
 =?us-ascii?Q?fzUsj8vwQ39VL5i+g2r9iYPzY//9jZJI9JUM9YodqoijQlTMMxxY0mQGfCc1?=
 =?us-ascii?Q?Hcc0JqasYae1iGhkYzTtC7bXD0jnI2p5HVV6hMNe2KsF9bHx8DPVA4onPI2g?=
 =?us-ascii?Q?htioWyJhcIuXGnfT0CvjGFPQXQfgRLRS77q5jaPKthlz0nvOV2IooXcApndy?=
 =?us-ascii?Q?OaQ7wmp8oD55YNlmiu/USgZNqt5i/knOYOrBlso4FVD4MVSZQoeRc7yf9cQ/?=
 =?us-ascii?Q?VlgRrCaGy709tYenlxlgs98yYI4lnB1VOyiuzMUYGicDWE6GwzNelJskrOnS?=
 =?us-ascii?Q?uXiCdZc+rE5Svk3oxJIS4QQ1BOZCLYQkRVfyz4yS5uvftcOIC2gk9hHlT0vu?=
 =?us-ascii?Q?KR7/HBYjOejWNDeFCAmfkarxf42lRpl2GLZeMIgu9feUPo9Uq0s9IdHQZ0b2?=
 =?us-ascii?Q?I2lgup9cwZWAIW+FUOEucC+ZCOGpzHH6gzTaLaG7lVLHYRF4Mg1eMVo0g=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: QH6i6H0CahAte1sludAQ3MQVUK01+NlZYW9QHnVJkqXWxSdyb37QCamsM38xKH6J08n8XI3ELf1JgAj0Pq7r7g14s9iu8k+lfZ1vYNepyGbljQEfuMjDsJCIJtUmXGNfojJgS9mPJ1V0WhgUTSs+3Vch5AB7epFCTGfqr5zZPEqoqdKzKTkMILDDgq6DD26yjkfhFeoSukaz0WFQOwWrfnH2dlAtYCWXgwMY08WlLRBigG05EdezSF3m5wpRP22N0zb+OaF/8XV58WxkQ+sE6zWTvTLHRtTo1l6Iwgi9Sub60rL2La2pgJ5a9olpdC1OBSpsf3VLXi+UCAyV3BMSZIdo9+XE8//rcxjFxAqKLIeBOVYIdaKNtTI5GujGBOzUfGt4oWit9VJN6q/UJPOh+k3u1oBzySG5CeqRBF2ffK0=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR02MB5016;6:SckLC3aYIISWkpibtzNvn4Yd7RL4mQLW5x7+tHea+BM6BMt7Xwx4EUXm6QMlyKvcjSCT7psU0bO70XktoLAiRJJeC1s/o5pEI4q170XCakyyWmWYG/M74+LUyeEpwt9Q/uiw8m3AJqdiz7jn3ZSaLFaaC/+ztfNb0QoPipCEuYsuobaHRrWpxb4vRrVPIIm6XGbvWES1zdsf5GXEJwo0MyrYXWOathaPBMStC+TyaOSVgbBoF1tmVLHs6jCgwfJDOVLaqj5sH+ugiNACbrddtvOeQdkoQiI1IoJSyDMqXhwVKpQZpHCZPSziHN9PJh5vkm+kqm3lYJqWuc7Q9OO3uGSgKez/Ds0i498gn3/LnI4u2CU6+CtrciuKR/LZH87TYsmSb6UuRNQZMvsMpaB6WjaLTa+I5/COxjlHLJ/M/A0iegMMpIPMVrdAbyIqHD+APajN+yIELHDMrJyoZ1gHTw==;5:HyIo7WmE4CLPlDZjd1dgeBUwzVQTpgK/9JRpaxOm68JjyN38witELfJnwAFepfRMzTAwK62WjKJh1PyNF4bdPn5TlU1XaNvZ7FU5e+Zep8AX16LxoHaHPUmbyq9lmBQ/uI79pbgebbMQ0JKJwlv0Idzcm1Dj/o3kB3VAGsIaDHwKdCosCcfOghL78M2nrtUlpFjkk92w2XEWB86qtS+jhg==;7:hBbbFFFPMXwkkdd7QjQFsNQACzGJxARkpiigfCbKYG+6gfyXvg6oP/4dX5iRevY4iu91fHxoJTpXKpx/Oy2m3UqWhjtq2hdjX8FXL2fgtROgqslaptA12FagZ+/UBDphoYOifkFGQPWFbTsRJ8hf+w==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2019 12:57:02.2827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ea2e7d-86d5-48e5-16a3-08d68844c2b4
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5016
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.

The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.

Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
---
v3
- removed interrupt parent as suggested by Rob
- removed dphy clock
- moved vfb to optional properties
- Added required and optional port properties section
- Added endpoint property section

v2
- updated the compatible string to latest version supported
- removed DPHY related parameters
- added CSI v2.0 related property (including VCX for supporting upto 16
  virtual channels).
- modified csi-pxl-format from string to unsigned int type where the value
  is as per the CSI specification
- Defined port 0 and port 1 as sink and source ports.
- Removed max-lanes property as suggested by Rob and Sakari

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 123 +++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
new file mode 100644
index 0000000..399f7fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
@@ -0,0 +1,123 @@
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
+- interrupts: Property with a value describing the interrupt number.
+- clocks: List of phandles to AXI Lite, Video and 200 MHz DPHY clocks.
+- clock-names: Must contain "lite_aclk" and "video_aclk" in the same order
+  as clocks listed in clocks property.
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
+
+
+Optional properties:
+--------------------
+- xlnx,vfb: This is present when Video Format Bridge is enabled.
+  Without this property the driver won't be loaded as IP won't be able to generate
+  media bus format compliant stream output.
+- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
+- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
+  only 4. This is present only if xlnx,en-csi-v2-0 is present.
+- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
+  Configuration Register.
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
+Required port properties:
+--------------------
+- reg: 0 - for sink port.
+       1 - for source port.
+
+Optional port properties:
+--------------------
+- xlnx,cfa-pattern: This goes in the sink port to indicate bayer pattern.
+  Valid values are "bggr", "rggb", "gbrg" and "grbg".
+
+Optional endpoint property:
+---------------------------
+- data-lanes: specifies MIPI CSI-2 data lanes as covered in video-interfaces.txt.
+  This should be in the sink port endpoint which connects to MIPI CSI2 source
+  like sensor. The possible values are:
+  1       - For 1 lane enabled in IP.
+  1 2     - For 2 lanes enabled in IP.
+  1 2 3   - For 3 lanes enabled in IP.
+  1 2 3 4 - For 4 lanes enabled in IP.
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
+		clock-names = "lite_aclk", "video_aclk";
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

