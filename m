Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940C2C282C6
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 02:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D72A21902
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 02:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="OmBArykc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfAZCPX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 21:15:23 -0500
Received: from mail-eopbgr790087.outbound.protection.outlook.com ([40.107.79.87]:39584
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725550AbfAZCPW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 21:15:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zfncg5DKZ7KzbCy0rEtBkGn8SNdHaEEA0QFkh3Ar60=;
 b=OmBArykco6LqHinhl+aZlODCneCpm8Q25V7qfkmRkPDrPrUOrO2Cy3/17w1HY2FWNaPJdby6dMFr5USuYbE1QArJSJRlgZqRIjWMo/UKwvkAD5ri+woxrI5XHuFSWHOrHyG6ii0TcCkyd9K5kcfLW9h5C2s8YDPEgrCUW5rUOSs=
Received: from MWHPR0201CA0053.namprd02.prod.outlook.com
 (2603:10b6:301:73::30) by SN6PR02MB4336.namprd02.prod.outlook.com
 (2603:10b6:805:a4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.17; Sat, 26 Jan
 2019 02:15:13 +0000
Received: from BL2NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by MWHPR0201CA0053.outlook.office365.com
 (2603:10b6:301:73::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1558.18 via Frontend
 Transport; Sat, 26 Jan 2019 02:15:12 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT013.mail.protection.outlook.com (10.152.77.19) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1580.10
 via Frontend Transport; Sat, 26 Jan 2019 02:15:11 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:57538 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gnDV0-0002Y9-PD; Fri, 25 Jan 2019 18:15:10 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gnDUv-0003Pa-Lf; Fri, 25 Jan 2019 18:15:05 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x0Q2F3kn018381;
        Fri, 25 Jan 2019 18:15:03 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gnDUt-0003L9-85; Fri, 25 Jan 2019 18:15:03 -0800
Date:   Fri, 25 Jan 2019 18:14:57 -0800
From:   Hyun Kwon <hyun.kwon@xilinx.com>
To:     Vishal Sagar <vishal.sagar@xilinx.com>
CC:     Hyun Kwon <hyunk@xilinx.com>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>
Subject: Re: [PATCH v2 2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx
 Subsystem driver
Message-ID: <20190126021457.GB2412@smtp.xilinx.com>
References: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
 <1548438777-11203-3-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1548438777-11203-3-git-send-email-vishal.sagar@xilinx.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(136003)(39860400002)(2980300002)(199004)(54534003)(51914003)(45074003)(189003)(81166006)(16586007)(316002)(126002)(47776003)(336012)(476003)(76176011)(76506005)(106466001)(50466002)(63266004)(114624004)(58126008)(106002)(57986006)(8936002)(446003)(486006)(107886003)(11346002)(2906002)(8676002)(54906003)(426003)(6246003)(53946003)(6636002)(44832011)(81156014)(7416002)(186003)(1076003)(4326008)(478600001)(2486003)(23676004)(30864003)(77096007)(6862004)(14444005)(305945005)(26005)(356004)(36386004)(229853002)(9786002)(6666004)(33656002)(18370500001)(107986001)(5001870100001)(559001)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4336;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;BL2NAM02FT013;1:/7AURMJWJ/RfvcW8A9t6CKGWkSW2jKQiuEz++vvrPdZNWMwrateNfql2ytQXbJQrc0vncHH3NGletHytgGEQA3rSa4dCKYKKuYtwPzIFtyrokPgV+NrspNWvg6zFYYjFyiFYgZnreWxdt5yHpGD4gFIC0/cv5dz9tCbAYFyYWQc=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 656ae3ac-2a44-4c08-db4f-08d683341a18
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR02MB4336;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4336;3:3HK6E4mV0Nma6REHuri8Uw/o4YjSsudwr9syqauQH/RpQo7zJ0iJXZ1y9baEabcz15K2864mbKY/CSAscLR/Ef0lfXrHbsyh5htGijrOCH3wMgUTXxaFRokuilWOXF15xAHR9ePVDNbjly2ztEtVjBqZhbZyg/ky/AgESgDEjbw7m5bU/MUZkTbSwq0BvisUIyNckDhl9Zt5DtBkbVtSSWEulDuqS5fABePUX8ApUln0fyEaII+Q8a1U01dVuk8/f0FaPk1WPR/li/C+wCrVDG8A5cAOchboVvxtKX/4C9T19owpyuW/39EeaaDAX64gTeXgPRX+OJgHZ/8pUNe7+KHhFaBSm/VA4Fo6cFoL/iGTtpr61Lp0VGD4T20GYFOp;25:sDzOvpRxLibbTvhZzJi9Ko9J6DPzSQ8h5Iy8t+Ph7Zt8t+m2OU7cBBJ0H+up5vGNQ6GMO0bL5WL74kPFFDGKE7KKZ/b40vefSknHbNoa9WGIhzjzgiVSKhu01FsR9sExYRywSxhYEQqy8veEehowiNlVTrp4jX4c13HpifEP9ZVE9TvFxSoT91PKjLF3LINByC+hxsk+Lei6jkezhYodirZSuPkvxmvcf8eGkqJCjWX8iBIeEZOXPpdz98wNnVD+ghXSZYqx9DcVn4VbEQ+tbW01DfQ4+f8DzoPyVGQ9cfRpj1ShPNvX3AcRXRnKMmA/JY6yRjFPj3DIVxPL4rL/qw==
X-MS-TrafficTypeDiagnostic: SN6PR02MB4336:
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4336;31:I1Cev/agdyWDwzHo51XyKKHVsI5awecZQRp40yYA4H81AOaRZ7fDyB4SZIJQVOjq9Gxvr0b0gHGBxUzioja1JRCVjkVlrwPA4CRcIJNLxBZMy3BCZrHhIODrBn27pK6qX4z4kRcNx/n8is+DrMfqJqDVB555uLXF3Hz1gf0pxJlP8zhIdnONo0t6y0gb37/cpeiPXy89KdYOLqAqx7F9KHyMZM1VlDqdk1GVsU2S+N4=;20:v5P+YHQhQ1wZOkIq4y4TGutrEwNnN6oBOKDjFweh/5X9AJaXhfbSK+ZKZTbA5E+HqqHqjTfUwK9PtmDCVj7tNP7ShUPjdfCvCuv6LRyYB8hi+YVTYrn3aX8c1VEB4ksBfPaK9tyifnEupIQhz8fCa77y7jL4ud25xItIXanNywSYp6HdOnh1tEn2CK+ZiuUUFk0UgyeTrDrTOi0mDnJ/KJhZsYaAxC55viNW5U2IjEJI0ZD8cGNd4ElW1FUk7d0zoDNyOzly2kf/8m7kATtC2WjaIgqzqxgpCOMkw5U7lmv7YoYAZFH5ss9QqhMfMovbyx6M784vvPId3K3PznUom9ob6OdSsBMp5ID2VLPY1TDq9OFFeFUTdxDvzkZj0K++ltFbzRUVf1DQqFQYlHnjxNnQFGLel4+6E4QTiIGQV9mYmPsk22fqUbTDuWu3eO2Tcmziu8EoIh7TGVXlsHISS8Eg8kQr53ZblIuAD4n0Xo3NpkDepEgMD7HX5gA4tbYk
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <SN6PR02MB43365986F88EFFE8A5D400EAD6940@SN6PR02MB4336.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4336;4:SQ+UAzMpKiiIuVfzM+RgGkBdhnfAGCAMkUNYb7bBphAwIh7P6XUHqzLYxVUrOBcTqFLbMHonAt6EV48BD286YU0S/sDom+DO2tVV4g/JhWtOuUtlJwEXVVthIPOcEfARWZS6OP60nu9bNTbXa4jbfTkXq1gaJZL1pK2ZhCXD/sF6SQgwGZWlK/0IjufwQFeXFtZ/Su9mf7qoKHWZiTbo3FffSo7iyGam2d0UffJh+LYndH4PaxnIZ2qNsEr4Bt0o7m6F1jHTLMjvRH83ruflYkffZ7z8eeef5JUNitrFlYS1TdiwPc7LMiwpHLt1mpRj
X-Forefront-PRVS: 0929F1BAED
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtTTjZQUjAyTUI0MzM2OzIzOkZ2M1ZIUFYxcXRJd3AyeUwrS3ZUaDgxenpR?=
 =?utf-8?B?OVp4VnVPR0dKUWVqSzNqeEdOZjd0djJVeDN3OEY1U1lzUms3djZldE5iL1pO?=
 =?utf-8?B?MmxrRkZXU0VqdTU0TDBEM3F2TUx6Nks3bXV4UHR4VHR5VWQ0M1V3aTRZZ1VI?=
 =?utf-8?B?T3NoNCtNYWpMTWp5RWNPQmI1dVFvMmN5N1FDSDkxVFo4YWh1R0JONVRqT21R?=
 =?utf-8?B?YUVhNW5mUXROQldhVkQwdWN4RUdxRGxCWmdDcTJBNFJFYXBSU2Z0dnpETWE5?=
 =?utf-8?B?ZDNSbXo4Z0YxWFVaY092b0xIYWd1R2RSeEZEZGxERS9YOHdPM3c4SEJhZmo0?=
 =?utf-8?B?KzQrdExYeWllQ2FsbGNiYnk2bEwwUU90bkdKY21GdTJDcml5TWdTZHcvM2NZ?=
 =?utf-8?B?dDFHWU05WXZLWjZxbjVMRGNycGpudnRFZkNRMTZqWnFlQ0luMmMzMlRrTVI0?=
 =?utf-8?B?YXkyaktIQ1ZaU0xWMWN4SjVmbllaMVFvWVEzbjBJV2Z5aEwwUlJXKzlFTVFY?=
 =?utf-8?B?eElZeEZvQ1pQK2hpTFIwWG1TK3EvUDhrVTVuNmF5dDhPUkRnbDVuU2xiWUZJ?=
 =?utf-8?B?emhxb0NVVGppUDFSSk5iSjBlWVRMd01uV1RrL0NENU9aaHhFd1R6aU85NjF0?=
 =?utf-8?B?cThCb3pxYXZEQUErd0owWUZLUE93WU14cWMzMG5MRjUwbm1RNXMzNGlzRmZL?=
 =?utf-8?B?dktsU0JlalBzRkxyWllwSjllSm1kK0gvRy9IQytOMGV1eEtNYUYvaG9BZWNZ?=
 =?utf-8?B?R0x3Z3dsc3lJL3BLcTZuNHdXYjB6M2w4ZXRQdnh6OFhGcGFZSlhiREJ5TmFH?=
 =?utf-8?B?TWhWMjhPTDZGcWNSSmp1ZGZhMno5OU5hTEduRHNBN2VIOTdNZU5FcHBrUUpW?=
 =?utf-8?B?ZGZCcCtQYVdYd1FCTENyZ2d4eXZDaWdMYk1rR0ZHeElLZkFyTEp0MkhJQk1R?=
 =?utf-8?B?TVhyUzVPdzNYUlNBaHVZdTUwWTd0UzZaWk1udi9CNlhNenBsRm5udVBjWU96?=
 =?utf-8?B?OGhBT2g5R29Id2pyUkREL0VWTDVPdmNkZGJFWmRBWklMck5RMjJDTy9QMlFo?=
 =?utf-8?B?WVNZV1h4L3JtN0RZZkFwWDUxN3VmRExyNmxSV2MrVUFrNGhkY0VLUlpibkdE?=
 =?utf-8?B?YkFUbWt4dUdBVzVwaTRBVC9uUjhMSi9yUzd2REpMdTlML3R0ZmtRTkU1RkJ4?=
 =?utf-8?B?WjJNZEsrazVSdlJQL1hBbjZPb3ZJRUt3UUZmaG9IeEFwcUkzS0lPS2NhbmJs?=
 =?utf-8?B?MUxpdEh4ZTNvd3EyQlZMMHd6RHMyNXp1M1ovaFJyN0QydGU3WjRtcmZ4WWEw?=
 =?utf-8?B?MlN3UEtTbzUzR1htMWdlZmUxZ0tUSDBrV0pXK2ZxMERvdkppQ0xpVktTaC9k?=
 =?utf-8?B?N3V0UzhmcGVhalpqSmtpQWc0N3hnclFvVk9HUmgzOHN6YU56QXJQU1JlSkNz?=
 =?utf-8?B?V3loU3hsUzBFTTVTMEpmbjVVeFFUODdrTXA3bHd3bmR1WjBHWjFHeEJHTHFH?=
 =?utf-8?B?Mk1tb3RkWEFUU2JuWTdNMW9RVHRSQlVwZjhTM0F0SVZzOVFMaTdWU0VSYnUx?=
 =?utf-8?B?bkFpdzg0UTJCbUFFWXNJVDI2WXRIakYyekJIWm9jQTlwcHppeTN6cjg3Umcx?=
 =?utf-8?B?OW1rS2Z1ckI4bWIrRlN3ZEhFNG5sQ1daWnp2S3JYSFAyZ1JVVTJ4L25ZZjFB?=
 =?utf-8?B?Zm1yYWpncUlySlNtZU5xRWlnY3dtMEVLY25PRW1iUXY4eGgzUFJ3dTMvZGE2?=
 =?utf-8?B?ak9jTlVHbjd1M1l5R1NYdkpBT2h1aHFXN3pPem0ydVl5dWZPT3dIbmg0S0VU?=
 =?utf-8?B?WHNDcEJoOTlXajNLS3R4cCtvR2ZYQ3BBZHY4eWVBYWd2Wnk1aXVPcUZFQjNT?=
 =?utf-8?B?d1NWNUs0Q1dDeDQ3V0JrME0vdWw0RzhwRDlCT0xZUzdxalJqanNJbkhjS3Bm?=
 =?utf-8?B?R2JHb0pvdlRBPT0=?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 0rG3y5AtbMaYIpVJbD2vujAOCNnfDuOB19g/Uqz/+IABnw2KizYjaovHYZJJQxFgvzY4vUhx1yP4cp5rxmg9Pk9+3mwr84PT2YY6Hw+kJtRYVWerEsmtQ8vZhWqSkvAmepUnogGDhOwhqDSEy64T0MxQCh+TGGl4JWFimpzK3xjgsrX7wE21KpTC6ccJwF+1daoNdbfof6dbsuNCigvdoNF1A7HdF6wm74zg0iwDdbUSmhdPpG7uppGMt5RcXySuLCVRoFb8+zPJx3WJKl5++jXUD2pltapPU56W+miuWcYaSoOjys6aU+Dxv4XqZ3FLcgpLuZh/nFJPZeBPm5e4fb+t7bxZ1tKFSvu1ZweehUS9LZqJSlkbqB/fN4X8JvkqAdfPazTewfLGlCOVjxCpxSf+2RXinpP0oYSPBnr5hxk=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4336;6:3uWIl2+1WIXwYptfJwF9/ULj9y9DMY9Jaup+piIqU3pYF5tOKmKQ8aoZmMOJRHHnCs93rTFZpqmIobOqE/DF/YZEf8ZbGOeAHy3SXJ8LoGHgkxdDu18/I5PcZbuUyoBcxFzUiGin6WGVGZ+9NKk+uUaF6tUPkWU46V5ePa3AyGJHXjhBrZ2GWnfyf+5NKwoSb8ejDPCQPyaVknmfj66zeC1pI5FJzt2tNOfcwbN99mxpw2L3Ya3rfHZBUzmedDxmMWJ3RUm0L3UVGZboSzRudhi78EKcBM2TEhJX68Pm2m/V70SkUgCgbAcDlUhXyrrsDGhsLsmolrsHAIqnuvFZ1NROSidL0/WaNmJ6DXJSj07Db3Yndf3/2ixjLAZzTfkKSBNg3tLOWYngT9uXSA2cgqhmXzaYiJYZuisUdi2LWmKeyZ7KUb4ed6qiy0jbBVIQbWOYINcX1Kgj2o+/t/3liA==;5:ZQlHHtL57y2f+iNGwYVu3W07uwR+VWc+5EC3S0ZozDijennWaxmSbCLfTBXlaEBpMWO7dQ0kS6eDSRcDvLYwV6U5cq8j5cFRxSzYfdJTK7HlNgOB3z/1HGIPq55+R9omJW2jJYtCQQGk4psUORRnynzs8c6K/vVLeaPATH0pr5RGztrwb02Nhq/4SOwBPFh5b3sy4B7k790TtsLiUsbo3w==;7:P+fBFmbYmYweHWuTCCwMgc61DK1/7LEWNJbn9QFI7tXmu878PxrKMBKMjk1XaWLKx8AGWLb2xq3ZZbJbesJnqYZTvr/YANVB69nwpY+1AUOFdjEMyi/JlesgCtkOu26QrUQhsWmCiFa15P1gueF0/w==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2019 02:15:11.5105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 656ae3ac-2a44-4c08-db4f-08d683341a18
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4336
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

Thanks for the patch.

On Fri, 2019-01-25 at 09:52:57 -0800, Vishal Sagar wrote:
> The Xilinx MIPI CSI-2 Rx Subsystem soft IP is used to capture images
> from MIPI CSI-2 camera sensors and output AXI4-Stream video data ready
> for image processing. Please refer to PG232 for details.
> 
> The driver is used to set the number of active lanes, if enabled
> in hardware. The CSI2 Rx controller filters out all packets except for
> the packets with data type fixed in hardware. RAW8 packets are always
> allowed to pass through.
> 
> It is also used to setup and handle interrupts and enable the core. It
> logs all the events in respective counters between streaming on and off.
> The generic short packets received are notified to application via
> v4l2_events.
> 
> The driver supports only the video format bridge enabled configuration.
> Some data types like YUV 422 10bpc, RAW16, RAW20 are supported when the
> CSI v2.0 feature is enabled in design. When the VCX feature is enabled,
> the maximum number of virtual channels becomes 16 from 4.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> ---
> v2
> - Fixed comments given by Hyun and Sakari.
> - Made all bitmask using BIT() and GENMASK()
> - Removed unused definitions
> - Removed DPHY access. This will be done by separate DPHY PHY driver.
> - Added support for CSI v2.0 for YUV 422 10bpc, RAW16, RAW20 and extra
>   virtual channels
> - Fixed the ports as sink and source
> - Now use the v4l2fwnode API to get number of data-lanes
> - Added clock framework support
> - Removed the close() function
> - updated the set format function
> - support only VFB enabled configuration
> 
>  drivers/media/platform/xilinx/Kconfig           |   10 +
>  drivers/media/platform/xilinx/Makefile          |    1 +
>  drivers/media/platform/xilinx/xilinx-csi2rxss.c | 1609 +++++++++++++++++++++++
>  include/uapi/linux/xilinx-v4l2-controls.h       |   14 +
>  include/uapi/linux/xilinx-v4l2-events.h         |   28 +
>  5 files changed, 1662 insertions(+)
>  create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
>  create mode 100644 include/uapi/linux/xilinx-v4l2-events.h
> 
> diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
> index 74ec8aa..30b4a25 100644
> --- a/drivers/media/platform/xilinx/Kconfig
> +++ b/drivers/media/platform/xilinx/Kconfig
> @@ -10,6 +10,16 @@ config VIDEO_XILINX
>  
>  if VIDEO_XILINX
>  
> +config VIDEO_XILINX_CSI2RXSS
> +	tristate "Xilinx CSI2 Rx Subsystem"
> +	help
> +	  Driver for Xilinx MIPI CSI2 Rx Subsystem. This is a V4L sub-device
> +	  based driver that takes input from CSI2 Tx source and converts
> +	  it into an AXI4-Stream. The subsystem comprises of a CSI2 Rx
> +	  controller, DPHY, an optional I2C controller and a Video Format
> +	  Bridge. The driver is used to set the number of active lanes and
> +	  get short packet data.
> +
>  config VIDEO_XILINX_TPG
>  	tristate "Xilinx Video Test Pattern Generator"
>  	depends on VIDEO_XILINX
> diff --git a/drivers/media/platform/xilinx/Makefile b/drivers/media/platform/xilinx/Makefile
> index 4cdc0b1..6119a34 100644
> --- a/drivers/media/platform/xilinx/Makefile
> +++ b/drivers/media/platform/xilinx/Makefile
> @@ -3,5 +3,6 @@
>  xilinx-video-objs += xilinx-dma.o xilinx-vip.o xilinx-vipp.o
>  
>  obj-$(CONFIG_VIDEO_XILINX) += xilinx-video.o
> +obj-$(CONFIG_VIDEO_XILINX_CSI2RXSS) += xilinx-csi2rxss.o
>  obj-$(CONFIG_VIDEO_XILINX_TPG) += xilinx-tpg.o
>  obj-$(CONFIG_VIDEO_XILINX_VTC) += xilinx-vtc.o
> diff --git a/drivers/media/platform/xilinx/xilinx-csi2rxss.c b/drivers/media/platform/xilinx/xilinx-csi2rxss.c
> new file mode 100644
> index 0000000..5accf01
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-csi2rxss.c
> @@ -0,0 +1,1609 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Driver for Xilinx MIPI CSI2 Rx Subsystem
> + *
> + * Copyright (C) 2016 - 2019 Xilinx, Inc.
> + *
> + * Contacts: Vishal Sagar <vishal.sagar@xilinx.com>
> + *
> + */
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/v4l2-subdev.h>
> +#include <linux/xilinx-v4l2-controls.h>
> +#include <linux/xilinx-v4l2-events.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
> +#include "xilinx-vip.h"
> +
> +/* Register register map */
> +#define XCSI_CCR_OFFSET		0x00
> +#define XCSI_CCR_SOFTRESET	BIT(1)
> +#define XCSI_CCR_ENABLE		BIT(0)
> +
> +#define XCSI_PCR_OFFSET		0x04
> +#define XCSI_PCR_MAXLANES_MASK	GENMASK(4, 3)
> +#define XCSI_PCR_ACTLANES_MASK	GENMASK(1, 0)
> +
> +#define XCSI_CSR_OFFSET		0x10
> +#define XCSI_CSR_PKTCNT		GENMASK(31, 16)
> +#define XCSI_CSR_SPFIFOFULL	BIT(3)
> +#define XCSI_CSR_SPFIFONE	BIT(2)
> +#define XCSI_CSR_SLBF		BIT(1)
> +#define XCSI_CSR_RIPCD		BIT(0)
> +
> +#define XCSI_GIER_OFFSET	0x20
> +#define XCSI_GIER_GIE		BIT(0)
> +
> +#define XCSI_ISR_OFFSET		0x24
> +#define XCSI_IER_OFFSET		0x28
> +
> +#define XCSI_ISR_FR		BIT(31)
> +#define XCSI_ISR_VCXFE		BIT(30)
> +#define XCSI_ISR_WCC		BIT(22)
> +#define XCSI_ISR_ILC		BIT(21)
> +#define XCSI_ISR_SPFIFOF	BIT(20)
> +#define XCSI_ISR_SPFIFONE	BIT(19)
> +#define XCSI_ISR_SLBF		BIT(18)
> +#define XCSI_ISR_STOP		BIT(17)
> +#define XCSI_ISR_SOTERR		BIT(13)
> +#define XCSI_ISR_SOTSYNCERR	BIT(12)
> +#define XCSI_ISR_ECC2BERR	BIT(11)
> +#define XCSI_ISR_ECC1BERR	BIT(10)
> +#define XCSI_ISR_CRCERR		BIT(9)
> +#define XCSI_ISR_DATAIDERR	BIT(8)
> +#define XCSI_ISR_VC3FSYNCERR	BIT(7)
> +#define XCSI_ISR_VC3FLVLERR	BIT(6)
> +#define XCSI_ISR_VC2FSYNCERR	BIT(5)
> +#define XCSI_ISR_VC2FLVLERR	BIT(4)
> +#define XCSI_ISR_VC1FSYNCERR	BIT(3)
> +#define XCSI_ISR_VC1FLVLERR	BIT(2)
> +#define XCSI_ISR_VC0FSYNCERR	BIT(1)
> +#define XCSI_ISR_VC0FLVLERR	BIT(0)
> +
> +#define XCSI_INTR_PROT_MASK	(XCSI_ISR_VC3FSYNCERR |	XCSI_ISR_VC3FLVLERR |\
> +				 XCSI_ISR_VC2FSYNCERR | XCSI_ISR_VC2FLVLERR |\
> +				 XCSI_ISR_VC1FSYNCERR | XCSI_ISR_VC1FLVLERR |\
> +				 XCSI_ISR_VC0FSYNCERR |	XCSI_ISR_VC0FLVLERR |\
> +				 XCSI_ISR_VCXFE)
> +
> +#define XCSI_INTR_PKTLVL_MASK	(XCSI_ISR_ECC2BERR | XCSI_ISR_ECC1BERR |\
> +				 XCSI_ISR_CRCERR | XCSI_ISR_DATAIDERR)
> +
> +#define XCSI_INTR_DPHY_MASK	(XCSI_ISR_SOTERR | XCSI_ISR_SOTSYNCERR)
> +
> +#define XCSI_INTR_SPKT_MASK	(XCSI_ISR_SPFIFOF | XCSI_ISR_SPFIFONE)
> +
> +#define XCSI_INTR_ERR_MASK	(XCSI_ISR_WCC | XCSI_ISR_ILC | XCSI_ISR_SLBF |\
> +				 XCSI_ISR_STOP)
> +
> +#define XCSI_INTR_FRAMERCVD_MASK	(XCSI_ISR_FR)
> +
> +#define XCSI_ISR_ALLINTR_MASK	(XCSI_INTR_PROT_MASK | XCSI_INTR_PKTLVL_MASK |\
> +				 XCSI_INTR_DPHY_MASK | XCSI_INTR_SPKT_MASK |\
> +				 XCSI_INTR_ERR_MASK | XCSI_INTR_FRAMERCVD_MASK)
> +
> +/*
> + * Removed VCXFE mask as it doesn't exist in IER
> + * Removed STOP state irq as this will keep driver in irq handler only
> + */
> +#define XCSI_IER_INTR_MASK	(XCSI_ISR_ALLINTR_MASK &\
> +				 ~(XCSI_ISR_STOP | XCSI_ISR_VCXFE))
> +
> +#define XCSI_SPKTR_OFFSET	0x30
> +#define XCSI_SPKTR_DATA		GENMASK(23, 8)
> +#define XCSI_SPKTR_VC		GENMASK(7, 6)
> +#define XCSI_SPKTR_DT		GENMASK(5, 0)
> +
> +#define XCSI_VCXR_OFFSET	0x34
> +#define XCSI_VCXR_VCERR		GENMASK(23, 0)
> +#define XCSI_VCXR_VCSTART	4
> +#define XCSI_VCXR_VCEND		15
> +#define XCSI_VCXR_FSYNCERR	BIT(1)
> +#define XCSI_VCXR_FLVLERR	BIT(0)
> +
> +#define XCSI_CLKINFR_OFFSET	0x3C
> +#define XCSI_CLKINFR_STOP	BIT(1)
> +
> +#define XCSI_DLXINFR_OFFSET	0x40
> +#define XCSI_DLXINFR_STOP	BIT(5)
> +#define XCSI_DLXINFR_SOTERR	BIT(1)
> +#define XCSI_DLXINFR_SOTSYNCERR	BIT(0)
> +#define XCSI_MAXDL_COUNT	0x4
> +
> +#define XCSI_VCXINF1R_OFFSET		0x60
> +#define XCSI_VCXINF1R_LINECOUNT		GENMASK(31, 16)
> +#define XCSI_VCXINF1R_LINECOUNT_SHIFT	16
> +#define XCSI_VCXINF1R_BYTECOUNT		GENMASK(15, 0)
> +
> +#define XCSI_VCXINF2R_OFFSET	0x64
> +#define XCSI_VCXINF2R_DT	GENMASK(5, 0)
> +#define XCSI_MAXVCX_COUNT	16
> +
> +/*
> + * The core takes less than 100 video clock cycles to reset.
> + * So choosing a timeout value larger than this.
> + */
> +#define XCSI_TIMEOUT_VAL	1000 /* us */
> +
> +/* Maximum short packet events */
> +#define XCSI_MAX_SPKT_EVENT	64
> +
> +/*
> + * Sink pad connected to sensor source pad.
> + * Source pad connected to next module like demosaic.
> + */
> +#define XCSI_MEDIA_PADS		2
> +#define XCSI_DEFAULT_WIDTH	1920
> +#define XCSI_DEFAULT_HEIGHT	1080
> +
> +/* Max string length for CSI Data type string */
> +#define XCSI_PXLFMT_STRLEN_MAX	16
> +
> +/* This range is the tolerance for DPHY clock of 200 MHz */
> +#define XCSI_DPHY_CLK_MIN	197000000000UL
> +#define XCSI_DPHY_CLK_MAX	203000000000UL

Could you share where this range comes from? Is it defined somewhere,
or from test?

> +#define XCSI_DPHY_CLK_REQ	200000000000UL

The changelog mentions there'll be a separate phy driver. Then wouldn't
the phy driver have to set own clock? If the phy driver becomes a child
driver of this subsystem driver, then it's fine to do it here.

> +
> +/* MIPI CSI2 Data Types from spec */
> +#define XCSI_DT_YUV4228B	0x1E
> +#define XCSI_DT_YUV42210B	0x1F
> +#define XCSI_DT_RGB444		0x20
> +#define XCSI_DT_RGB555		0x21
> +#define XCSI_DT_RGB565		0x22
> +#define XCSI_DT_RGB666		0x23
> +#define XCSI_DT_RGB888		0x24
> +#define XCSI_DT_RAW6		0x28
> +#define XCSI_DT_RAW7		0x29
> +#define XCSI_DT_RAW8		0x2A
> +#define XCSI_DT_RAW10		0x2B
> +#define XCSI_DT_RAW12		0x2C
> +#define XCSI_DT_RAW14		0x2D
> +#define XCSI_DT_RAW16		0x2E
> +#define XCSI_DT_RAW20		0x2F
> +
> +#define XCSI_VCX_START		4
> +#define XCSI_MAX_VC		4
> +#define XCSI_MAX_VCX		16
> +
> +#define XCSI_NEXTREG_OFFSET	4
> +
> +/* Bayer pattern for RAW data */
> +#define XCSI_BAYER_RGGB		0
> +#define XCSI_BAYER_BGGR		1
> +#define XCSI_BAYER_GBRG		2
> +#define XCSI_BAYER_GRBG		3
> +
> +/* There are 2 events frame sync and frame level error per VC */
> +#define XCSI_VCX_NUM_EVENTS	((XCSI_MAX_VCX - XCSI_MAX_VC) * 2)
> +
> +/*
> + * Macro to return "true" or "false" string if bit is set
> + */

Single line comment would be fine.

> +#define XCSI_GET_BITSET_STR(val, mask)	(val) & (mask) ? "true" : "false"
> +
> +static const struct of_device_id xcsi2rxss_of_id_table[] = {
> +	{ .compatible = "xlnx,mipi-csi2-rx-subsystem-4.0",},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, xcsi2rxss_of_id_table);
> +

This is a little too far from where this is used. :-) I'd move it
to closer.

> +/**
> + * struct xcsi2rxss_event - Event log structure
> + * @mask: Event mask
> + * @name: Name of the event
> + * @counter: Count number of events
> + */
> +struct xcsi2rxss_event {
> +	u32 mask;
> +	const char * const name;

Nit. extra space after '*'.

> +	unsigned int counter;
> +};
> +
> +/*
> + * struct xcsi2rxss_core - Core configuration CSI2 Rx Subsystem device structure
> + * @dev: Platform structure
> + * @iomem: Base address of subsystem
> + * @irq: requested irq number
> + * @enable_active_lanes: If number of active lanes can be modified
> + * @max_num_lanes: Maximum number of lanes present
> + * @vfb: Video Format Bridge enabled or not
> + * @datatype: Data type filter
> + * @bayer: bayer pattern
> + * @events: Structure to maintain event logs
> + * @vcx_events: Structure to maintain VCX event logs
> + * @en_vcx: If more than 4 VC are enabled
> + * @en_csi_v20: If CSI v2.0 is enabled
> + * @lite_aclk: AXI4-Lite interface clock
> + * @video_aclk: Video clock
> + * @dphy_clk_200M: 200MHz DPHY clock
> + */
> +struct xcsi2rxss_core {
> +	struct device *dev;
> +	void __iomem *iomem;
> +	int irq;
> +	bool enable_active_lanes;
> +	u32 max_num_lanes;
> +	bool vfb;
> +	u32 datatype;
> +	u32 bayer;
> +	struct xcsi2rxss_event *events;
> +	struct xcsi2rxss_event *vcx_events;
> +	bool en_vcx;
> +	bool en_csi_v20;
> +	struct clk *lite_aclk;
> +	struct clk *video_aclk;
> +	struct clk *dphy_clk_200M;
> +};
> +
> +/**
> + * struct xcsi2rxss_state - CSI2 Rx Subsystem device structure
> + * @core: Core structure for MIPI CSI2 Rx Subsystem
> + * @subdev: The v4l2 subdev structure
> + * @ctrl_handler: control handler
> + * @format: Active V4L2 formats on each pad
> + * @event: Holds the short packet event
> + * @lock: mutex for serializing operations

It may be just me, but it's not clear what it wants to serialize.
The comment better describe what resource it protects.

> + * @pads: media pads
> + * @streaming: Flag for storing streaming state
> + *
> + * This structure contains the device driver related parameters
> + */
> +struct xcsi2rxss_state {
> +	struct xcsi2rxss_core core;
> +	struct v4l2_subdev subdev;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	struct v4l2_mbus_framefmt format;
> +	struct v4l2_event event;
> +	/* used to serialize v4l2 operations */
> +	struct mutex lock;
> +	struct media_pad pads[XCSI_MEDIA_PADS];
> +	bool streaming;
> +};
> +
> +static struct xcsi2rxss_event xcsi2rxss_events[] = {
> +	{ XCSI_ISR_FR, "Frame Received", 0 },
> +	{ XCSI_ISR_VCXFE, "VCX Frame Errors", 0 },
> +	{ XCSI_ISR_WCC, "Word Count Errors", 0 },
> +	{ XCSI_ISR_ILC, "Invalid Lane Count Error", 0 },
> +	{ XCSI_ISR_SPFIFOF, "Short Packet FIFO OverFlow Error", 0 },
> +	{ XCSI_ISR_SPFIFONE, "Short Packet FIFO Not Empty", 0 },
> +	{ XCSI_ISR_SLBF, "Streamline Buffer Full Error", 0 },
> +	{ XCSI_ISR_STOP, "Lane Stop State", 0 },
> +	{ XCSI_ISR_SOTERR, "SOT Error", 0 },
> +	{ XCSI_ISR_SOTSYNCERR, "SOT Sync Error", 0 },
> +	{ XCSI_ISR_ECC2BERR, "2 Bit ECC Unrecoverable Error", 0 },
> +	{ XCSI_ISR_ECC1BERR, "1 Bit ECC Recoverable Error", 0 },
> +	{ XCSI_ISR_CRCERR, "CRC Error", 0 },
> +	{ XCSI_ISR_DATAIDERR, "Data Id Error", 0 },
> +	{ XCSI_ISR_VC3FSYNCERR, "Virtual Channel 3 Frame Sync Error", 0 },
> +	{ XCSI_ISR_VC3FLVLERR, "Virtual Channel 3 Frame Level Error", 0 },
> +	{ XCSI_ISR_VC2FSYNCERR, "Virtual Channel 2 Frame Sync Error", 0 },
> +	{ XCSI_ISR_VC2FLVLERR, "Virtual Channel 2 Frame Level Error", 0 },
> +	{ XCSI_ISR_VC1FSYNCERR, "Virtual Channel 1 Frame Sync Error", 0 },
> +	{ XCSI_ISR_VC1FLVLERR, "Virtual Channel 1 Frame Level Error", 0 },
> +	{ XCSI_ISR_VC0FSYNCERR, "Virtual Channel 0 Frame Sync Error", 0 },
> +	{ XCSI_ISR_VC0FLVLERR, "Virtual Channel 0 Frame Level Error", 0 }
> +};
> +
> +#define XCSI_NUM_EVENTS		ARRAY_SIZE(xcsi2rxss_events)
> +
> +static inline struct xcsi2rxss_state *
> +to_xcsi2rxssstate(struct v4l2_subdev *subdev)
> +{
> +	return container_of(subdev, struct xcsi2rxss_state, subdev);
> +}
> +
> +/*
> + * Register related operations
> + */

The xilinx-vip has same IO functions, but up to you.

> +static inline u32 xcsi2rxss_read(struct xcsi2rxss_core *xcsi2rxss, u32 addr)
> +{
> +	return ioread32(xcsi2rxss->iomem + addr);
> +}
> +
> +static inline void xcsi2rxss_write(struct xcsi2rxss_core *xcsi2rxss, u32 addr,
> +				   u32 value)
> +{
> +	iowrite32(value, xcsi2rxss->iomem + addr);
> +}
> +
> +static inline void xcsi2rxss_clr(struct xcsi2rxss_core *xcsi2rxss, u32 addr,
> +				 u32 clr)
> +{
> +	xcsi2rxss_write(xcsi2rxss, addr,
> +			xcsi2rxss_read(xcsi2rxss, addr) & ~clr);
> +}
> +
> +static inline void xcsi2rxss_set(struct xcsi2rxss_core *xcsi2rxss, u32 addr,
> +				 u32 set)
> +{
> +	xcsi2rxss_write(xcsi2rxss, addr,
> +			xcsi2rxss_read(xcsi2rxss, addr) | set);
> +}
> +
> +/**
> + * xcsi2rxss_clr_and_set - Clear and set the register with a bitmask
> + * @xcsi2rxss: Xilinx MIPI CSI2 Rx Subsystem subdev core struct
> + * @addr: address of register
> + * @clr: bitmask to be cleared
> + * @set: bitmask to be set
> + *
> + * Clear a bit(s) of mask @clr in the register at address @addr, then set
> + * a bit(s) of mask @set in the register after.
> + */
> +static void xcsi2rxss_clr_and_set(struct xcsi2rxss_core *xcsi2rxss,
> +				  u32 addr, u32 clr, u32 set)
> +{
> +	u32 reg;
> +
> +	reg = xcsi2rxss_read(xcsi2rxss, addr);
> +	reg &= ~clr;
> +	reg |= set;
> +	xcsi2rxss_write(xcsi2rxss, addr, reg);
> +}
> +
> +static void xcsi2rxss_enable(struct xcsi2rxss_core *core)
> +{
> +	xcsi2rxss_set(core, XCSI_CCR_OFFSET, XCSI_CCR_ENABLE);
> +}
> +
> +static void xcsi2rxss_disable(struct xcsi2rxss_core *core)
> +{
> +	xcsi2rxss_clr(core, XCSI_CCR_OFFSET, XCSI_CCR_ENABLE);
> +}
> +
> +static void xcsi2rxss_intr_enable(struct xcsi2rxss_core *core)
> +{
> +	xcsi2rxss_clr(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE);
> +	xcsi2rxss_write(core, XCSI_IER_OFFSET, XCSI_IER_INTR_MASK);
> +	xcsi2rxss_set(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE);
> +}
> +
> +static void xcsi2rxss_intr_disable(struct xcsi2rxss_core *core)
> +{
> +	xcsi2rxss_clr(core, XCSI_IER_OFFSET, XCSI_IER_INTR_MASK);
> +	xcsi2rxss_clr(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE);
> +}
> +
> +/**
> + * xcsi2rxss_reset - Does a soft reset of the MIPI CSI2 Rx Subsystem
> + * @core: Core Xilinx CSI2 Rx Subsystem structure pointer
> + *
> + * Core takes less than 100 video clock cycles to reset.
> + * So a larger timeout value is chosen for margin.
> + *
> + * Return: 0 - on success OR -ETIME if reset times out
> + */
> +static int xcsi2rxss_reset(struct xcsi2rxss_core *core)
> +{
> +	u32 timeout = XCSI_TIMEOUT_VAL;
> +
> +	xcsi2rxss_set(core, XCSI_CCR_OFFSET, XCSI_CCR_SOFTRESET);
> +
> +	while (xcsi2rxss_read(core, XCSI_CSR_OFFSET) & XCSI_CSR_RIPCD) {
> +		if (timeout == 0) {
> +			dev_err(core->dev, "soft reset timed out!\n");
> +			return -ETIME;
> +		}
> +
> +		timeout--;
> +		udelay(1);
> +	}
> +
> +	xcsi2rxss_clr(core, XCSI_CCR_OFFSET, XCSI_CCR_SOFTRESET);
> +	return 0;
> +}
> +
> +/**
> + * xcsi2rxss_irq_handler - Interrupt handler for CSI-2
> + * @irq: IRQ number
> + * @dev_id: Pointer to device state
> + *
> + * In the interrupt handler, a list of event counters are updated for
> + * corresponding interrupts. This is useful to get status / debug.
> + * If the short packet FIFO not empty or overflow interrupt is received
> + * capture the short packet and notify of event occurrence
> + *
> + * Return: IRQ_HANDLED after handling interrupts
> + *         IRQ_NONE is no interrupts
> + */
> +static irqreturn_t xcsi2rxss_irq_handler(int irq, void *dev_id)
> +{
> +	struct xcsi2rxss_state *state = (struct xcsi2rxss_state *)dev_id;
> +	struct xcsi2rxss_core *core = &state->core;
> +	u32 status;
> +
> +	status = xcsi2rxss_read(core, XCSI_ISR_OFFSET) & XCSI_ISR_ALLINTR_MASK;
> +	dev_dbg(core->dev, "interrupt status = 0x%08x\n", status);

Shouldn't this be rate-limited? I let you decide.

> +
> +	if (!status)
> +		return IRQ_NONE;
> +
> +	/* Received a short packet */
> +	if (status & XCSI_ISR_SPFIFONE) {
> +		memset(&state->event, 0, sizeof(state->event));
> +		state->event.type = V4L2_EVENT_XLNXCSIRX_SPKT;
> +		*((u32 *)(&state->event.u.data)) =
> +			xcsi2rxss_read(core, XCSI_SPKTR_OFFSET);
> +		v4l2_subdev_notify_event(&state->subdev, &state->event);
> +	}
> +
> +	/* Short packet FIFO overflow */
> +	if (status & XCSI_ISR_SPFIFOF) {
> +		dev_alert(core->dev, "Short packet FIFO overflowed\n");
> +		memset(&state->event, 0, sizeof(state->event));
> +		state->event.type = V4L2_EVENT_XLNXCSIRX_SPKT_OVF;
> +		v4l2_subdev_notify_event(&state->subdev, &state->event);
> +	}
> +
> +	/*
> +	 * Stream line buffer full
> +	 * This means there is a backpressure from downstream IP
> +	 */
> +	if (status & XCSI_ISR_SLBF) {
> +		dev_alert(core->dev, "Stream Line Buffer Full!\n");
> +		memset(&state->event, 0, sizeof(state->event));
> +		state->event.type = V4L2_EVENT_XLNXCSIRX_SLBF;
> +		v4l2_subdev_notify_event(&state->subdev, &state->event);
> +	}
> +
> +	/* Increment event counters */
> +	if (status & XCSI_ISR_ALLINTR_MASK) {
> +		unsigned int i;
> +
> +		for (i = 0; i < XCSI_NUM_EVENTS; i++) {
> +			if (!(status & core->events[i].mask))
> +				continue;
> +			core->events[i].counter++;
> +			dev_dbg(core->dev, "%s: %d\n", core->events[i].name,
> +				core->events[i].counter);
> +		}
> +
> +		if (status & XCSI_ISR_VCXFE && core->en_vcx) {
> +			u32 vcxstatus;
> +
> +			vcxstatus = xcsi2rxss_read(core, XCSI_VCXR_OFFSET);
> +			vcxstatus &= XCSI_VCXR_VCERR;
> +			for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++) {
> +				if (!(vcxstatus & core->vcx_events[i].mask))
> +					continue;
> +				core->vcx_events[i].counter++;
> +			}
> +			xcsi2rxss_write(core, XCSI_VCXR_OFFSET, vcxstatus);
> +		}
> +	}
> +
> +	xcsi2rxss_write(core, XCSI_ISR_OFFSET, status);
> +	return IRQ_HANDLED;
> +}
> +
> +static void xcsi2rxss_reset_event_counters(struct xcsi2rxss_state *state)
> +{
> +	int i;

Nit. unsigned.

> +
> +	for (i = 0; i < XCSI_NUM_EVENTS; i++)
> +		state->core.events[i].counter = 0;
> +
> +	if (state->core.en_vcx)

I don't know what's recommened style, but for multiline statement,
putting braces seems better for readability. Up to you.

> +		for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++)
> +			state->core.vcx_events[i].counter = 0;
> +}
> +
> +/* Print event counters */
> +static void xcsi2rxss_log_counters(struct xcsi2rxss_state *state)
> +{
> +	struct xcsi2rxss_core *core = &state->core;
> +	int i;
> +
> +	for (i = 0; i < XCSI_NUM_EVENTS; i++) {
> +		if (core->events[i].counter > 0)
> +			dev_info(core->dev, "%s events: %d\n",
> +				 core->events[i].name,
> +				 core->events[i].counter);
> +	}
> +
> +	if (core->en_vcx)
> +		for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++) {
> +			if (core->vcx_events[i].counter > 0)
> +				dev_info(core->dev,
> +					 "VC %d Frame %s err vcx events: %d\n",
> +					 (i / 2) + XCSI_VCX_START,
> +					 i & 1 ? "Sync" : "Level",
> +					 core->vcx_events[i].counter);
> +		}
> +}
> +
> +/**
> + * xcsi2rxss_log_status - Logs the status of the CSI-2 Receiver
> + * @sd: Pointer to V4L2 subdevice structure
> + *
> + * This function prints the current status of Xilinx MIPI CSI-2
> + *
> + * Return: 0 on success
> + */
> +static int xcsi2rxss_log_status(struct v4l2_subdev *sd)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> +	unsigned int reg, data, i, max_vc;
> +
> +	mutex_lock(&xcsi2rxss->lock);

This lock seems to protect access to xcsi2rxss. If so, could you please
clarify in the lock description?

> +
> +	xcsi2rxss_log_counters(xcsi2rxss);
> +
> +	dev_info(core->dev, "***** Core Status *****\n");
> +	data = xcsi2rxss_read(core, XCSI_CSR_OFFSET);
> +	dev_info(core->dev, "Short Packet FIFO Full = %s\n",
> +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_SPFIFOFULL));
> +	dev_info(core->dev, "Short Packet FIFO Not Empty = %s\n",
> +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_SPFIFONE));
> +	dev_info(core->dev, "Stream line buffer full = %s\n",
> +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_SLBF));
> +	dev_info(core->dev, "Soft reset/Core disable in progress = %s\n",
> +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_RIPCD));
> +
> +	/* Clk & Lane Info  */
> +	dev_info(core->dev, "******** Clock Lane Info *********\n");
> +	data = xcsi2rxss_read(core, XCSI_CLKINFR_OFFSET);
> +	dev_info(core->dev, "Clock Lane in Stop State = %s\n",
> +		 XCSI_GET_BITSET_STR(data, XCSI_CLKINFR_STOP));
> +
> +	dev_info(core->dev, "******** Data Lane Info *********\n");
> +	dev_info(core->dev, "Lane\tSoT Error\tSoT Sync Error\tStop State\n");
> +	reg = XCSI_DLXINFR_OFFSET;
> +	for (i = 0; i < XCSI_MAXDL_COUNT; i++) {
> +		data = xcsi2rxss_read(core, reg);
> +
> +		dev_info(core->dev, "%d\t%s\t\t%s\t\t%s\n", i,
> +			 XCSI_GET_BITSET_STR(data, XCSI_DLXINFR_SOTERR),
> +			 XCSI_GET_BITSET_STR(data, XCSI_DLXINFR_SOTSYNCERR),
> +			 XCSI_GET_BITSET_STR(data, XCSI_DLXINFR_STOP));
> +
> +		reg += XCSI_NEXTREG_OFFSET;
> +	}
> +
> +	/* Virtual Channel Image Information */
> +	dev_info(core->dev, "********** Virtual Channel Info ************\n");
> +	dev_info(core->dev, "VC\tLine Count\tByte Count\tData Type\n");
> +	if (core->en_vcx)
> +		max_vc = XCSI_MAX_VCX;
> +	else
> +		max_vc = XCSI_MAX_VC;
> +
> +	reg = XCSI_VCXINF1R_OFFSET;
> +	for (i = 0; i < max_vc; i++) {
> +		u32 line_count, byte_count, data_type;
> +
> +		/* Get line and byte count from VCXINFR1 Register */
> +		data = xcsi2rxss_read(core, reg);
> +		byte_count = data & XCSI_VCXINF1R_BYTECOUNT;
> +		line_count = data & XCSI_VCXINF1R_LINECOUNT;
> +		line_count >>= XCSI_VCXINF1R_LINECOUNT_SHIFT;
> +
> +		/* Get data type from VCXINFR2 Register */
> +		reg += XCSI_NEXTREG_OFFSET;
> +		data = xcsi2rxss_read(core, reg);
> +		data_type = data & XCSI_VCXINF2R_DT;
> +
> +		dev_info(core->dev, "%d\t%d\t\t%d\t\t0x%x\n", i, line_count,
> +			 byte_count, data_type);
> +
> +		/* Move to next pair of VC Info registers */
> +		reg += XCSI_NEXTREG_OFFSET;
> +	}
> +
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return 0;
> +}
> +
> +/*
> + * xcsi2rxss_subscribe_event - Subscribe to the custom short packet
> + * receive event.
> + * @sd: V4L2 Sub device
> + * @fh: V4L2 File Handle
> + * @sub: Subcribe event structure
> + *
> + * There are two types of events to be subscribed.
> + *
> + * First is to register for receiving a generic short packet.
> + * The generic short packets received are queued up in a FIFO.
> + * On reception of a generic short packet, an event will be generated
> + * with the short packet contents copied to its data area.
> + * Application subscribed to this event will poll for POLLPRI.
> + * On getting the event, the app dequeues the event to get the short packet
> + * data.
> + *
> + * Second is to register for Short packet FIFO overflow
> + * In case the rate of receiving short packets is high and
> + * the short packet FIFO overflows, this event will be triggered.
> + *
> + * Return: 0 on success, errors otherwise
> + */
> +static int xcsi2rxss_subscribe_event(struct v4l2_subdev *sd,
> +				     struct v4l2_fh *fh,
> +				     struct v4l2_event_subscription *sub)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> +	int ret;
> +
> +	mutex_lock(&xcsi2rxss->lock);
> +
> +	switch (sub->type) {
> +	case V4L2_EVENT_XLNXCSIRX_SPKT:
> +	case V4L2_EVENT_XLNXCSIRX_SPKT_OVF:
> +	case V4L2_EVENT_XLNXCSIRX_SLBF:
> +		ret = v4l2_event_subscribe(fh, sub, XCSI_MAX_SPKT_EVENT, NULL);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return ret;
> +}
> +
> +/**
> + * xcsi2rxss_unsubscribe_event - Unsubscribe from all events registered
> + * @sd: V4L2 Sub device
> + * @fh: V4L2 file handle
> + * @sub: pointer to Event unsubscription structure
> + *
> + * Return: zero on success, else a negative error code.
> + */
> +static int xcsi2rxss_unsubscribe_event(struct v4l2_subdev *sd,
> +				       struct v4l2_fh *fh,
> +				       struct v4l2_event_subscription *sub)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> +	int ret;
> +
> +	mutex_lock(&xcsi2rxss->lock);
> +	ret = v4l2_event_unsubscribe(fh, sub);
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return ret;
> +}
> +
> +/**
> + * xcsi2rxss_s_ctrl - This is used to set the Xilinx MIPI CSI-2 V4L2 controls
> + * @ctrl: V4L2 control to be set
> + *
> + * This function is used to set the V4L2 controls for the Xilinx MIPI
> + * CSI-2 Rx Subsystem. It is used to set the active lanes in the system.
> + * The event counters can be reset.
> + *
> + * Return: 0 on success, errors otherwise
> + */
> +static int xcsi2rxss_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss =
> +		container_of(ctrl->handler, struct xcsi2rxss_state,
> +			     ctrl_handler);
> +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> +	int ret = 0;
> +	u32 active_lanes = 1;

Nit. This can move into if statement below, without initializing it.

> +
> +	mutex_lock(&xcsi2rxss->lock);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_XILINX_MIPICSISS_ACT_LANES:
> +		/*
> +		 * This will be called only when "Enable Active Lanes" parameter
> +		 * is set in design
> +		 */
> +		if (core->enable_active_lanes) {
> +			xcsi2rxss_clr_and_set(core, XCSI_PCR_OFFSET,
> +					      XCSI_PCR_ACTLANES_MASK,
> +					      ctrl->val - 1);
> +			/*
> +			 * This delay is to allow the value to reflect as write
> +			 * and read paths are different.
> +			 */
> +			udelay(1);

Interesting this is required.

> +			active_lanes = xcsi2rxss_read(core, XCSI_PCR_OFFSET);
> +			active_lanes &= XCSI_PCR_ACTLANES_MASK;
> +			active_lanes++;
> +			if (active_lanes != ctrl->val)
> +				dev_info(core->dev, "RxByteClkHS absent\n");
> +			dev_dbg(core->dev, "active lanes = %d\n", ctrl->val);
> +		} else {
> +			ret = -EINVAL;
> +		}
> +		break;
> +	case V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS:
> +		xcsi2rxss_reset_event_counters(xcsi2rxss);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return ret;
> +}
> +
> +/**
> + * xcsi2rxss_g_volatile_ctrl - get the Xilinx MIPI CSI-2 Rx controls
> + * @ctrl: Pointer to V4L2 control
> + *
> + * This is used to get the number of frames received by the Xilinx
> + * MIPI CSI-2 Rx.
> + *
> + * Return: 0 on success, errors otherwise
> + */
> +static int xcsi2rxss_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss =
> +		container_of(ctrl->handler, struct xcsi2rxss_state,
> +			     ctrl_handler);
> +	int ret = 0;
> +
> +	mutex_lock(&xcsi2rxss->lock);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER:
> +		ctrl->val = xcsi2rxss->core.events[0].counter;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return ret;
> +}
> +
> +static int xcsi2rxss_start_stream(struct xcsi2rxss_state *state)
> +{
> +	struct xcsi2rxss_core *core = &state->core;
> +	int ret = 0;
> +
> +	xcsi2rxss_enable(core);
> +
> +	ret = xcsi2rxss_reset(core);

As the soft reset is done after enabling, I guess soft reset doesn't
reset those controls and registers which are set prior to it.

> +	if (ret < 0) {
> +		state->streaming = false;
> +		return ret;
> +	}
> +
> +	xcsi2rxss_intr_enable(core);
> +	state->streaming = true;
> +
> +	return ret;
> +}
> +
> +static void xcsi2rxss_stop_stream(struct xcsi2rxss_state *state)
> +{
> +	struct xcsi2rxss_core *core = &state->core;
> +
> +	xcsi2rxss_intr_disable(core);
> +	xcsi2rxss_disable(core);
> +	state->streaming = false;
> +}
> +
> +/**
> + * xcsi2rxss_s_stream - It is used to start/stop the streaming.
> + * @sd: V4L2 Sub device
> + * @enable: Flag (True / False)
> + *
> + * This function controls the start or stop of streaming for the
> + * Xilinx MIPI CSI-2 Rx Subsystem.
> + *
> + * Return: 0 on success, errors otherwise
> + */
> +static int xcsi2rxss_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> +	int ret = 0;
> +
> +	mutex_lock(&xcsi2rxss->lock);
> +
> +	if (enable) {
> +		if (!xcsi2rxss->streaming) {
> +			/* reset the event counters */
> +			xcsi2rxss_reset_event_counters(xcsi2rxss);

Is this required here? or can it be done explicitly by the application
separately?

> +			ret = xcsi2rxss_start_stream(xcsi2rxss);
> +		}
> +	} else {
> +		if (xcsi2rxss->streaming)
> +			xcsi2rxss_stop_stream(xcsi2rxss);
> +	}
> +
> +	mutex_unlock(&xcsi2rxss->lock);
> +	return ret;
> +}
> +
> +static struct v4l2_mbus_framefmt *
> +__xcsi2rxss_get_pad_format(struct xcsi2rxss_state *xcsi2rxss,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   unsigned int pad, u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(&xcsi2rxss->subdev, cfg,
> +						  pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &xcsi2rxss->format;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +/**
> + * xcsi2rxss_get_format - Get the pad format
> + * @sd: Pointer to V4L2 Sub device structure
> + * @cfg: Pointer to sub device pad information structure
> + * @fmt: Pointer to pad level media bus format
> + *
> + * This function is used to get the pad format information.
> + *
> + * Return: 0 on success
> + */
> +static int xcsi2rxss_get_format(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_format *fmt)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> +
> +	mutex_lock(&xcsi2rxss->lock);
> +	fmt->format = *__xcsi2rxss_get_pad_format(xcsi2rxss, cfg, fmt->pad,
> +						  fmt->which);
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return 0;
> +}
> +
> +/**
> + * xcsi2rxss_set_format - This is used to set the pad format
> + * @sd: Pointer to V4L2 Sub device structure
> + * @cfg: Pointer to sub device pad information structure
> + * @fmt: Pointer to pad level media bus format
> + *
> + * This function is used to set the pad format. Since the pad format is fixed
> + * in hardware, it can't be modified on run time. So when a format set is
> + * requested by application, all parameters except the format type is saved
> + * for the pad and the original pad format is sent back to the application.
> + *
> + * Return: 0 on success
> + */
> +static int xcsi2rxss_set_format(struct v4l2_subdev *sd,
> +				struct v4l2_subdev_pad_config *cfg,
> +				struct v4l2_subdev_format *fmt)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> +	struct v4l2_mbus_framefmt *__format;
> +	u32 code;
> +
> +	/* only sink pad format can be updated */
> +	mutex_lock(&xcsi2rxss->lock);
> +
> +	/*
> +	 * Only the format->code parameter matters for CSI as the
> +	 * CSI format cannot be changed at runtime.
> +	 * Ensure that format to set is copied to over to CSI pad format
> +	 */
> +	__format = __xcsi2rxss_get_pad_format(xcsi2rxss, cfg,
> +					      fmt->pad, fmt->which);
> +
> +	/* Save the pad format code */
> +	code = __format->code;
> +
> +	/*
> +	 * RAW8 is supported in all datatypes. So if requested media bus format
> +	 * is of RAW8 type, then allow to be set. In case core is configured to
> +	 * other RAW, YUV422 8/10 or RGB888, set appropriate media bus format.
> +	 */
> +	if ((fmt->format.code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
> +	     fmt->format.code == MEDIA_BUS_FMT_SGBRG8_1X8 ||
> +	     fmt->format.code == MEDIA_BUS_FMT_SGRBG8_1X8 ||
> +	     fmt->format.code == MEDIA_BUS_FMT_SRGGB8_1X8) ||
> +	    (core->datatype == XCSI_DT_RAW10 &&
> +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR10_1X10 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG10_1X10 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG10_1X10 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB10_1X10)) ||
> +	    (core->datatype == XCSI_DT_RAW12 &&
> +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR12_1X12 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG12_1X12 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG12_1X12 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB12_1X12)) ||
> +	    (core->datatype == XCSI_DT_RAW14 &&
> +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR14_1X14 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG14_1X14 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG14_1X14 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB14_1X14)) ||
> +	    (core->datatype == XCSI_DT_RAW16 &&
> +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR16_1X16 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG16_1X16 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG16_1X16 ||
> +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB16_1X16)) ||
> +	    (core->datatype == XCSI_DT_YUV4228B &&
> +	     fmt->format.code == MEDIA_BUS_FMT_UYVY8_1X16) ||
> +	    (core->datatype == XCSI_DT_YUV42210B &&
> +	     fmt->format.code == MEDIA_BUS_FMT_UYVY8_1X16) ||

Not sure if single bus format can be shared between 422 8B and 422 10B.

> +	    (core->datatype == XCSI_DT_RGB888 &&
> +	     fmt->format.code == MEDIA_BUS_FMT_RBG888_1X24)) {
> +		/* Copy over the format to be set */
> +		*__format = fmt->format;
> +	} else {
> +		/* Restore the original pad format code */
> +		fmt->format.code = code;
> +		__format->code = code;
> +		__format->width = fmt->format.width;
> +		__format->height = fmt->format.height;
> +	}
> +
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return 0;
> +}
> +
> +/**
> + * xcsi2rxss_open - Called on v4l2_open()
> + * @sd: Pointer to V4L2 sub device structure
> + * @fh: Pointer to V4L2 File handle
> + *
> + * This function is called on v4l2_open(). It sets the default format
> + * for both pads.
> + *
> + * Return: 0 on success
> + */
> +static int xcsi2rxss_open(struct v4l2_subdev *sd,
> +			  struct v4l2_subdev_fh *fh)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> +	struct v4l2_mbus_framefmt *format;
> +	unsigned int i;
> +
> +	for (i = 0; i < XCSI_MEDIA_PADS; i++) {
> +		format = v4l2_subdev_get_try_format(sd, fh->pad, i);
> +		*format = xcsi2rxss->format;
> +	}
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Media Operations
> + */
> +
> +static const struct media_entity_operations xcsi2rxss_media_ops = {
> +	.link_validate = v4l2_subdev_link_validate
> +};
> +
> +static const struct v4l2_ctrl_ops xcsi2rxss_ctrl_ops = {
> +	.g_volatile_ctrl = xcsi2rxss_g_volatile_ctrl,
> +	.s_ctrl	= xcsi2rxss_s_ctrl
> +};
> +
> +static struct v4l2_ctrl_config xcsi2rxss_ctrls[] = {
> +	{
> +		.ops	= &xcsi2rxss_ctrl_ops,
> +		.id	= V4L2_CID_XILINX_MIPICSISS_ACT_LANES,
> +		.name	= "Active Lanes",
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.min	= 1,
> +		.max	= 4,
> +		.step	= 1,
> +		.def	= 1,
> +	}, {
> +		.ops	= &xcsi2rxss_ctrl_ops,
> +		.id	= V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER,
> +		.name	= "Frames Received Counter",
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.min	= 0,
> +		.max	= 0xFFFFFFFF,
> +		.step	= 1,
> +		.def	= 0,
> +		.flags	= V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_ONLY,
> +	}, {
> +		.ops	= &xcsi2rxss_ctrl_ops,
> +		.id	= V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS,
> +		.name	= "Reset Counters",
> +		.type	= V4L2_CTRL_TYPE_BUTTON,
> +		.min	= 0,
> +		.max	= 1,
> +		.step	= 1,
> +		.def	= 0,
> +		.flags	= V4L2_CTRL_FLAG_WRITE_ONLY,
> +	}
> +};
> +
> +static const struct v4l2_subdev_core_ops xcsi2rxss_core_ops = {
> +	.log_status = xcsi2rxss_log_status,
> +	.subscribe_event = xcsi2rxss_subscribe_event,
> +	.unsubscribe_event = xcsi2rxss_unsubscribe_event
> +};
> +
> +static struct v4l2_subdev_video_ops xcsi2rxss_video_ops = {
> +	.s_stream = xcsi2rxss_s_stream
> +};
> +
> +static struct v4l2_subdev_pad_ops xcsi2rxss_pad_ops = {
> +	.get_fmt = xcsi2rxss_get_format,
> +	.set_fmt = xcsi2rxss_set_format,
> +};
> +
> +static struct v4l2_subdev_ops xcsi2rxss_ops = {
> +	.core = &xcsi2rxss_core_ops,
> +	.video = &xcsi2rxss_video_ops,
> +	.pad = &xcsi2rxss_pad_ops
> +};
> +
> +static const struct v4l2_subdev_internal_ops xcsi2rxss_internal_ops = {
> +	.open = xcsi2rxss_open,
> +};
> +
> +static void xcsi2rxss_set_default_format(struct xcsi2rxss_state *state)
> +{
> +	struct xcsi2rxss_core *core = &state->core;
> +
> +	memset(&state->format, 0, sizeof(state->format));
> +
> +	switch (core->datatype) {
> +	case XCSI_DT_YUV4228B:
> +	case XCSI_DT_YUV42210B:

As mentioned before, does this belong here? It looks like 10bit format,
but is classified as 8bit bus format.

> +		state->format.code = MEDIA_BUS_FMT_UYVY8_1X16;
> +		break;
> +	case XCSI_DT_RGB888:
> +		state->format.code = MEDIA_BUS_FMT_RBG888_1X24;
> +		break;
> +	case XCSI_DT_RAW10:
> +		switch (core->bayer) {
> +		case XCSI_BAYER_BGGR:
> +			state->format.code = MEDIA_BUS_FMT_SBGGR10_1X10;
> +			break;
> +		case XCSI_BAYER_GRBG:
> +			state->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
> +			break;
> +		case XCSI_BAYER_GBRG:
> +			state->format.code = MEDIA_BUS_FMT_SGBRG10_1X10;
> +			break;
> +		case XCSI_BAYER_RGGB:
> +		default:
> +			state->format.code = MEDIA_BUS_FMT_SRGGB10_1X10;
> +		}
> +		break;
> +	case XCSI_DT_RAW12:
> +		switch (core->bayer) {
> +		case XCSI_BAYER_BGGR:
> +			state->format.code = MEDIA_BUS_FMT_SBGGR12_1X12;
> +			break;
> +		case XCSI_BAYER_GRBG:
> +			state->format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
> +			break;
> +		case XCSI_BAYER_GBRG:
> +			state->format.code = MEDIA_BUS_FMT_SGBRG12_1X12;
> +			break;
> +		case XCSI_BAYER_RGGB:
> +		default:
> +			state->format.code = MEDIA_BUS_FMT_SRGGB12_1X12;
> +		}
> +		break;
> +	case XCSI_DT_RAW14:
> +		switch (core->bayer) {
> +		case XCSI_BAYER_BGGR:
> +			state->format.code = MEDIA_BUS_FMT_SBGGR14_1X14;
> +			break;
> +		case XCSI_BAYER_GRBG:
> +			state->format.code = MEDIA_BUS_FMT_SGRBG14_1X14;
> +			break;
> +		case XCSI_BAYER_GBRG:
> +			state->format.code = MEDIA_BUS_FMT_SGBRG14_1X14;
> +			break;
> +		case XCSI_BAYER_RGGB:
> +		default:
> +			state->format.code = MEDIA_BUS_FMT_SRGGB14_1X14;
> +		}
> +		break;
> +	case XCSI_DT_RAW16:
> +		switch (core->bayer) {
> +		case XCSI_BAYER_BGGR:
> +			state->format.code = MEDIA_BUS_FMT_SBGGR16_1X16;
> +			break;
> +		case XCSI_BAYER_GRBG:
> +			state->format.code = MEDIA_BUS_FMT_SGRBG16_1X16;
> +			break;
> +		case XCSI_BAYER_GBRG:
> +			state->format.code = MEDIA_BUS_FMT_SGBRG16_1X16;
> +			break;
> +		case XCSI_BAYER_RGGB:
> +		default:
> +			state->format.code = MEDIA_BUS_FMT_SRGGB16_1X16;
> +		}
> +		break;
> +	case XCSI_DT_RAW8:
> +	case XCSI_DT_RGB444:
> +	case XCSI_DT_RGB555:
> +	case XCSI_DT_RGB565:
> +	case XCSI_DT_RGB666:
> +		switch (core->bayer) {
> +		case XCSI_BAYER_BGGR:
> +			state->format.code = MEDIA_BUS_FMT_SBGGR8_1X8;
> +			break;
> +		case XCSI_BAYER_GRBG:
> +			state->format.code = MEDIA_BUS_FMT_SGRBG8_1X8;
> +			break;
> +		case XCSI_BAYER_GBRG:
> +			state->format.code = MEDIA_BUS_FMT_SGBRG8_1X8;
> +			break;
> +		case XCSI_BAYER_RGGB:
> +		default:
> +			state->format.code = MEDIA_BUS_FMT_SRGGB8_1X8;
> +		}
> +		break;
> +	}
> +
> +	state->format.field = V4L2_FIELD_NONE;
> +	state->format.colorspace = V4L2_COLORSPACE_SRGB;
> +	state->format.width = XCSI_DEFAULT_WIDTH;
> +	state->format.height = XCSI_DEFAULT_HEIGHT;
> +
> +	dev_dbg(core->dev, "default mediabus format = 0x%x",
> +		state->format.code);
> +}
> +
> +static int xcsi2rxss_clk_get(struct xcsi2rxss_core *core)
> +{
> +	int ret;
> +
> +	core->lite_aclk = devm_clk_get(core->dev, "lite_aclk");
> +	if (IS_ERR(core->lite_aclk)) {
> +		ret = PTR_ERR(core->lite_aclk);
> +		dev_err(core->dev, "failed to get lite_aclk (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	core->video_aclk = devm_clk_get(core->dev, "video_aclk");
> +	if (IS_ERR(core->video_aclk)) {
> +		ret = PTR_ERR(core->video_aclk);
> +		dev_err(core->dev, "failed to get video_aclk (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	core->dphy_clk_200M = devm_clk_get(core->dev, "dphy_clk_200M");
> +	if (IS_ERR(core->dphy_clk_200M)) {
> +		ret = PTR_ERR(core->dphy_clk_200M);
> +		dev_err(core->dev, "failed to get dphy_clk_200M (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	dev_dbg(core->dev, "Got all clocks!\n");

This debug print doesn't add any, but it's fine if you want to keep.

> +	return 0;
> +}
> +
> +static int xcsi2rxss_clk_enable(struct xcsi2rxss_core *core)
> +{
> +	unsigned long rate;
> +	int ret;
> +
> +	ret = clk_prepare_enable(core->lite_aclk);
> +	if (ret) {
> +		dev_err(core->dev, "failed enabling lite_aclk (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(core->video_aclk);
> +	if (ret) {
> +		dev_err(core->dev, "failed enabling video_aclk (%d)\n",
> +			ret);
> +		goto err_vidclk;
> +	}
> +
> +	ret = clk_prepare_enable(core->dphy_clk_200M);
> +	if (ret) {
> +		dev_err(core->dev, "failed enabling dphy clk (%d)\n",
> +			ret);
> +		goto err_dphyclk;
> +	}
> +
> +	ret = clk_set_rate(core->dphy_clk_200M, XCSI_DPHY_CLK_REQ);
> +	if (ret) {
> +		dev_err(core->dev, "failed to set dphy clk rate (%d)\n",
> +			ret);
> +		goto err_rate_set;
> +	}
> +
> +	rate = clk_get_rate(core->dphy_clk_200M);
> +	if (rate < XCSI_DPHY_CLK_MIN && rate > XCSI_DPHY_CLK_MAX) {

Please confirm on this range. From its name and so on, it looks like
it should be 200MHz.

> +		dev_err(core->dev, "Err DPHY Clock = %lu\n",
> +			rate);
> +		ret = -EINVAL;
> +		goto err_rate_set;
> +	}
> +
> +	dev_dbg(core->dev, "all clocks enabled!\n");
> +
> +	return ret;
> +
> +err_rate_set:
> +	clk_disable_unprepare(core->dphy_clk_200M);
> +err_dphyclk:
> +	clk_disable_unprepare(core->video_aclk);
> +err_vidclk:
> +	clk_disable_unprepare(core->lite_aclk);
> +	return ret;
> +}
> +
> +static void xcsi2rxss_clk_disable(struct xcsi2rxss_core *core)
> +{
> +	clk_disable_unprepare(core->dphy_clk_200M);
> +	clk_disable_unprepare(core->video_aclk);
> +	clk_disable_unprepare(core->lite_aclk);
> +}
> +
> +static int xcsi2rxss_parse_of(struct xcsi2rxss_state *xcsi2rxss)
> +{
> +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> +	struct device_node *node = xcsi2rxss->core.dev->of_node;
> +	struct device_node *ports = NULL;
> +	struct device_node *port = NULL;
> +	unsigned int nports;
> +	int ret;
> +
> +	core->en_csi_v20 = of_property_read_bool(node, "xlnx,en-csi-v2-0");

Can't this be a local variable?

> +	if (core->en_csi_v20) {
> +		core->en_vcx = of_property_read_bool(node, "xlnx,en-vcx");
> +		dev_dbg(core->dev, "vcx %s", core->en_vcx ? "enabled" :
> +			"disabled");
> +	}
> +
> +	dev_dbg(core->dev, "en_csi_v20 %s", core->en_csi_v20 ? "enabled" :
> +		"disabled");
> +
> +	core->enable_active_lanes =
> +		of_property_read_bool(node, "xlnx,en-active-lanes");
> +	dev_dbg(core->dev, "Enable active lanes property = %s\n",
> +		core->enable_active_lanes ? "Present" : "Absent");
> +
> +	ret = of_property_read_u32(node, "xlnx,csi-pxl-format",
> +				   &core->datatype);
> +	if (ret < 0) {
> +		dev_err(core->dev, "missing xlnx,csi-pxl-format property\n");
> +		return ret;
> +	}
> +
> +	ret = 0;

I think this line is not needed.

> +	switch (core->datatype) {
> +	case XCSI_DT_YUV4228B:
> +	case XCSI_DT_RGB444:
> +	case XCSI_DT_RGB555:
> +	case XCSI_DT_RGB565:
> +	case XCSI_DT_RGB666:
> +	case XCSI_DT_RGB888:
> +	case XCSI_DT_RAW6:
> +	case XCSI_DT_RAW7:
> +	case XCSI_DT_RAW8:
> +	case XCSI_DT_RAW10:
> +	case XCSI_DT_RAW12:
> +	case XCSI_DT_RAW14:
> +		break;
> +	case XCSI_DT_YUV42210B:
> +	case XCSI_DT_RAW16:
> +	case XCSI_DT_RAW20:
> +		if (!core->en_csi_v20) {
> +			ret = -EINVAL;
> +			dev_dbg(core->dev, "enable csi v2 for this pixel format");
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret < 0) {
> +		dev_err(core->dev, "invalid csi-pxl-format property!\n");
> +		return ret;
> +	}
> +
> +	dev_dbg(core->dev, "pixel format set as 0x%x\n", core->datatype);
> +
> +	core->vfb = of_property_read_bool(node, "xlnx,vfb");

Can't this be a local variable as well?

> +	dev_dbg(core->dev, "Video Format Bridge property = %s\n",
> +		core->vfb ? "Present" : "Absent");
> +
> +	if (!core->vfb) {
> +		dev_err(core->dev, "failed as VFB is disabled!\n");
> +		return -EINVAL;
> +	}
> +
> +	ports = of_get_child_by_name(node, "ports");
> +	if (!ports)
> +		ports = node;
> +
> +	nports = 0;
> +	for_each_child_of_node(ports, port) {
> +		const char *pattern = "mono";
> +		int len = strlen(pattern);
> +		struct device_node *endpoint;
> +		struct v4l2_fwnode_endpoint v4lendpoint;
> +		int ret;
> +
> +		if (!port->name || of_node_cmp(port->name, "port"))
> +			continue;
> +
> +		endpoint = of_get_next_child(port, NULL);
> +		if (!endpoint) {
> +			dev_err(core->dev, "No port at\n");
> +			return -EINVAL;
> +		}
> +
> +		/*
> +		 * since first port is sink port and it contains
> +		 * all info about data-lanes and cfa-pattern,
> +		 * don't parse second port but only check if exists
> +		 */
> +		if (nports == XVIP_PAD_SOURCE) {
> +			dev_dbg(core->dev, "no need to parse source port");
> +			nports++;
> +			of_node_put(endpoint);
> +			continue;
> +		}
> +
> +		core->bayer = XCSI_BAYER_RGGB;
> +		ret = of_property_read_string(port, "xlnx,cfa-pattern",
> +					      &pattern);
> +		if (ret == 0) {

Nit. !ret.

> +			if (!strncmp("grbg", pattern, len)) {
> +				core->bayer = XCSI_BAYER_GRBG;
> +			} else if (!strncmp("bggr", pattern, len)) {
> +				core->bayer = XCSI_BAYER_BGGR;
> +			} else if (!strncmp("rggb", pattern, len)) {
> +				core->bayer = XCSI_BAYER_RGGB;
> +			} else if (!strncmp("gbrg", pattern, len)) {
> +				core->bayer = XCSI_BAYER_GBRG;
> +			} else {
> +				dev_err(core->dev, "incorrect cfa string\n");
> +				return -EINVAL;
> +			}
> +		} else if (ret != -EINVAL) {

What about for other errors?

> +			dev_err(core->dev, "invalid cfa pattern!\n");
> +			return ret;
> +		}
> +		dev_dbg(core->dev, "bayer pattern = %d\n", core->bayer);
> +
> +		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
> +						 &v4lendpoint);
> +		of_node_put(endpoint);
> +		if (ret)
> +			return ret;
> +
> +		dev_dbg(core->dev, "%s : port %d bus type = %d\n",
> +			__func__, nports, v4lendpoint.bus_type);
> +
> +		if (v4lendpoint.bus_type == V4L2_MBUS_CSI2_DPHY) {
> +			dev_dbg(core->dev, "%s : base.port = %d base.id = %d\n",
> +				__func__, v4lendpoint.base.port,
> +				v4lendpoint.base.id);
> +
> +			dev_dbg(core->dev, "%s : mipi number lanes = %d\n",
> +				__func__,
> +				v4lendpoint.bus.mipi_csi2.num_data_lanes);
> +
> +			core->max_num_lanes =
> +				v4lendpoint.bus.mipi_csi2.num_data_lanes;
> +		} else {
> +			dev_dbg(core->dev, "%s : Not a CSI2 bus\n", __func__);

Not sure if this adds any info.

> +		}
> +
> +		/* Count the number of ports. */
> +		nports++;
> +	}
> +
> +	dev_dbg(core->dev, "max lanes = %d", core->max_num_lanes);
> +
> +	if (nports != XCSI_MEDIA_PADS) {
> +		dev_err(core->dev, "invalid number of ports %u\n", nports);
> +		return -EINVAL;
> +	}
> +
> +	/* Register interrupt handler */
> +	core->irq = irq_of_parse_and_map(node, 0);
> +	ret = devm_request_irq(core->dev, core->irq, xcsi2rxss_irq_handler,
> +			       IRQF_SHARED, "xilinx-csi2rxss", xcsi2rxss);
> +	if (ret) {
> +		dev_err(core->dev, "Err = %d Interrupt handler reg failed!\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int xcsi2rxss_probe(struct platform_device *pdev)
> +{
> +	struct v4l2_subdev *subdev;
> +	struct xcsi2rxss_state *xcsi2rxss;
> +	struct xcsi2rxss_core *core;
> +	struct resource *res;
> +	int ret, num_ctrls, i;
> +
> +	xcsi2rxss = devm_kzalloc(&pdev->dev, sizeof(*xcsi2rxss), GFP_KERNEL);
> +	if (!xcsi2rxss)
> +		return -ENOMEM;
> +
> +	core = &xcsi2rxss->core;
> +	core->dev = &pdev->dev;
> +
> +	mutex_init(&xcsi2rxss->lock);
> +
> +	ret = xcsi2rxss_parse_of(xcsi2rxss);
> +	if (ret < 0)
> +		return ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	core->iomem = devm_ioremap_resource(core->dev, res);
> +	if (IS_ERR(core->iomem))
> +		return PTR_ERR(core->iomem);
> +
> +	ret = xcsi2rxss_clk_get(core);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = xcsi2rxss_clk_enable(core);
> +	if (ret < 0)
> +		return ret;
> +
> +	xcsi2rxss_reset(core);
> +
> +	core->events = (struct xcsi2rxss_event *)&xcsi2rxss_events;
> +
> +	if (core->en_vcx) {
> +		u32 alloc_size;
> +
> +		alloc_size = sizeof(struct xcsi2rxss_event) *
> +			     XCSI_VCX_NUM_EVENTS;
> +		core->vcx_events = devm_kzalloc(&pdev->dev, alloc_size,
> +						GFP_KERNEL);
> +		if (!core->vcx_events) {
> +			mutex_destroy(&xcsi2rxss->lock);
> +			ret = -ENOMEM;
> +			goto all_clk_err;
> +		}
> +
> +		for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++)
> +			core->vcx_events[i].mask = 1 << i;
> +	}
> +
> +	/* Initialize V4L2 subdevice and media entity */
> +	xcsi2rxss->pads[XVIP_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> +	xcsi2rxss->pads[XVIP_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	/* Initialize the default format */
> +	xcsi2rxss_set_default_format(xcsi2rxss);
> +
> +	/* Initialize V4L2 subdevice and media entity */
> +	subdev = &xcsi2rxss->subdev;
> +	v4l2_subdev_init(subdev, &xcsi2rxss_ops);
> +	subdev->dev = &pdev->dev;
> +	subdev->internal_ops = &xcsi2rxss_internal_ops;
> +	strlcpy(subdev->name, dev_name(&pdev->dev), sizeof(subdev->name));
> +	subdev->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	subdev->entity.ops = &xcsi2rxss_media_ops;
> +	v4l2_set_subdevdata(subdev, xcsi2rxss);
> +
> +	ret = media_entity_pads_init(&subdev->entity, XCSI_MEDIA_PADS,
> +				     xcsi2rxss->pads);
> +	if (ret < 0)
> +		goto error;
> +
> +	/*
> +	 * In case the Enable Active Lanes config parameter is not set,
> +	 * dynamic lane reconfiguration is not allowed.
> +	 * So V4L2_CID_XILINX_MIPICSISS_ACT_LANES ctrl will not be registered.
> +	 * Accordingly allocate the number of controls
> +	 */
> +	num_ctrls = ARRAY_SIZE(xcsi2rxss_ctrls);
> +
> +	if (!core->enable_active_lanes)
> +		num_ctrls--;
> +
> +	dev_dbg(core->dev, "# of ctrls = %d\n", num_ctrls);
> +
> +	v4l2_ctrl_handler_init(&xcsi2rxss->ctrl_handler, num_ctrls);
> +	for (i = 0; i < ARRAY_SIZE(xcsi2rxss_ctrls); i++) {
> +		struct v4l2_ctrl *ctrl;
> +
> +		if (xcsi2rxss_ctrls[i].id ==
> +			V4L2_CID_XILINX_MIPICSISS_ACT_LANES) {
> +			if (!core->enable_active_lanes) {
> +				/* Don't register control */
> +				dev_dbg(core->dev,
> +					"Skip active lane control\n");
> +				continue;

This active lane control is not even registered, so the control handler
doesn't even have to check this flag. But I guess it doesn't hurt to
keep the check in the handler, so I let you decide.

> +			}
> +			xcsi2rxss_ctrls[i].max = core->max_num_lanes;
> +			xcsi2rxss_ctrls[i].def = core->max_num_lanes;
> +		}
> +
> +		dev_dbg(core->dev, "%d ctrl = 0x%x\n", i,
> +			xcsi2rxss_ctrls[i].id);
> +		ctrl = v4l2_ctrl_new_custom(&xcsi2rxss->ctrl_handler,
> +					    &xcsi2rxss_ctrls[i], NULL);
> +		if (!ctrl) {
> +			dev_err(core->dev, "Failed for %s ctrl\n",
> +				xcsi2rxss_ctrls[i].name);
> +			goto error;
> +		}
> +	}
> +
> +	dev_dbg(core->dev, "# v4l2 ctrls registered = %d\n", i - 1);
> +
> +	if (xcsi2rxss->ctrl_handler.error) {
> +		dev_err(core->dev, "failed to add controls\n");
> +		ret = xcsi2rxss->ctrl_handler.error;
> +		goto error;
> +	}
> +
> +	subdev->ctrl_handler = &xcsi2rxss->ctrl_handler;
> +	ret = v4l2_ctrl_handler_setup(&xcsi2rxss->ctrl_handler);
> +	if (ret < 0) {
> +		dev_err(core->dev, "failed to set controls\n");
> +		goto error;
> +	}
> +
> +	platform_set_drvdata(pdev, xcsi2rxss);
> +
> +	ret = v4l2_async_register_subdev(subdev);
> +	if (ret < 0) {
> +		dev_err(core->dev, "failed to register subdev\n");
> +		goto error;
> +	}
> +
> +	dev_info(core->dev, "Xilinx CSI2 Rx Subsystem device found!\n");
> +	return 0;

Just a nit. I'd add en empty line.

> +error:
> +	v4l2_ctrl_handler_free(&xcsi2rxss->ctrl_handler);
> +	media_entity_cleanup(&subdev->entity);
> +	mutex_destroy(&xcsi2rxss->lock);
> +all_clk_err:
> +	xcsi2rxss_clk_disable(core);
> +	return ret;
> +}
> +
> +static int xcsi2rxss_remove(struct platform_device *pdev)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss = platform_get_drvdata(pdev);
> +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> +	struct v4l2_subdev *subdev = &xcsi2rxss->subdev;
> +
> +	v4l2_async_unregister_subdev(subdev);
> +	v4l2_ctrl_handler_free(&xcsi2rxss->ctrl_handler);
> +	media_entity_cleanup(&subdev->entity);
> +	mutex_destroy(&xcsi2rxss->lock);
> +	xcsi2rxss_clk_disable(core);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver xcsi2rxss_driver = {
> +	.driver = {
> +		.name		= "xilinx-csi2rxss",
> +		.of_match_table	= xcsi2rxss_of_id_table,
> +	},
> +	.probe			= xcsi2rxss_probe,
> +	.remove			= xcsi2rxss_remove,
> +};
> +
> +module_platform_driver(xcsi2rxss_driver);
> +
> +MODULE_AUTHOR("Vishal Sagar <vsagar@xilinx.com>");
> +MODULE_DESCRIPTION("Xilinx MIPI CSI2 Rx Subsystem Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/uapi/linux/xilinx-v4l2-controls.h b/include/uapi/linux/xilinx-v4l2-controls.h
> index b6441fe..4ca3b44 100644
> --- a/include/uapi/linux/xilinx-v4l2-controls.h
> +++ b/include/uapi/linux/xilinx-v4l2-controls.h
> @@ -71,4 +71,18 @@
>  /* Noise level */
>  #define V4L2_CID_XILINX_TPG_NOISE_GAIN		(V4L2_CID_XILINX_TPG + 17)
>  
> +/*
> + * Xilinx MIPI CSI2 Rx Subsystem
> + */
> +
> +/* Base ID */
> +#define V4L2_CID_XILINX_MIPICSISS		(V4L2_CID_USER_BASE + 0xc080)
> +
> +/* Active Lanes */
> +#define V4L2_CID_XILINX_MIPICSISS_ACT_LANES	(V4L2_CID_XILINX_MIPICSISS + 1)
> +/* Frames received since streaming is set */
> +#define V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER	(V4L2_CID_XILINX_MIPICSISS + 2)
> +/* Reset all event counters */
> +#define V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS (V4L2_CID_XILINX_MIPICSISS + 3)
> +
>  #endif /* __UAPI_XILINX_V4L2_CONTROLS_H__ */
> diff --git a/include/uapi/linux/xilinx-v4l2-events.h b/include/uapi/linux/xilinx-v4l2-events.h
> new file mode 100644
> index 0000000..2fef0b5
> --- /dev/null
> +++ b/include/uapi/linux/xilinx-v4l2-events.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Xilinx V4L2 Events
> + *
> + * Copyright (C) 2019 Xilinx, Inc.
> + *
> + * Contacts: Vishal Sagar <vishal.sagar@xilinx.com>
> + *
> + */
> +
> +#ifndef __UAPI_XILINX_V4L2_EVENTS_H__
> +#define __UAPI_XILINX_V4L2_EVENTS_H__
> +
> +#include <linux/videodev2.h>
> +
> +/*
> + * Events
> + *
> + * V4L2_EVENT_XLNXCSIRX_SPKT: Short packet received
> + * V4L2_EVENT_XLNXCSIRX_SPKT_OVF: Short packet FIFO overflow
> + * V4L2_EVENT_XLNXCSIRX_SLBF: Stream line buffer full
> + */

Would be better to comment inline. But up to you.

Thanks,
-hyun

> +#define V4L2_EVENT_XLNXCSIRX_CLASS	(V4L2_EVENT_PRIVATE_START | 0x100)
> +#define V4L2_EVENT_XLNXCSIRX_SPKT	(V4L2_EVENT_XLNXCSIRX_CLASS | 0x1)
> +#define V4L2_EVENT_XLNXCSIRX_SPKT_OVF	(V4L2_EVENT_XLNXCSIRX_CLASS | 0x2)
> +#define V4L2_EVENT_XLNXCSIRX_SLBF	(V4L2_EVENT_XLNXCSIRX_CLASS | 0x3)
> +
> +#endif /* __UAPI_XILINX_V4L2_EVENTS_H__ */
> -- 
> 2.7.4
> 
> 
