Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE32C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 18:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAB7E21741
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 18:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="37oUMy1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfA1SfP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 13:35:15 -0500
Received: from mail-eopbgr690073.outbound.protection.outlook.com ([40.107.69.73]:18400
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727227AbfA1SfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 13:35:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/N6ySNLhfi2nRJYDuJ1Vny1P/6VjsTyd4GiiAwxNQ4=;
 b=37oUMy1V/1iSf1VR7zMQ/iZWCCp9ifiPkJik8ketOZfIeDJa4GNjf/Y1HulB5fzL/10tNRatU4Jz3rsaiTvwHcO9mrMf5UtBPffRT94+Q/eNmADbIJ3U6pfZB40NU5zqrz/sMkZxDYtxS3+vRYEANtiAR/3B+nQjrPD5H+iEs1o=
Received: from BN7PR02CA0021.namprd02.prod.outlook.com (2603:10b6:408:20::34)
 by SN4PR0201MB3518.namprd02.prod.outlook.com (2603:10b6:803:4c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.16; Mon, 28 Jan
 2019 18:35:04 +0000
Received: from SN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by BN7PR02CA0021.outlook.office365.com
 (2603:10b6:408:20::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1558.19 via Frontend
 Transport; Mon, 28 Jan 2019 18:35:04 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; ideasonboard.com; dkim=none (message not signed)
 header.d=none;ideasonboard.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 SN1NAM02FT036.mail.protection.outlook.com (10.152.72.149) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1580.10
 via Frontend Transport; Mon, 28 Jan 2019 18:35:03 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:50360 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1goBkN-0003fJ-50; Mon, 28 Jan 2019 10:35:03 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1goBkI-000771-1s; Mon, 28 Jan 2019 10:34:58 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1goBk6-00075q-IG; Mon, 28 Jan 2019 10:34:46 -0800
Date:   Mon, 28 Jan 2019 10:34:30 -0800
From:   Hyun Kwon <hyun.kwon@xilinx.com>
To:     Vishal Sagar <vsagar@xilinx.com>
CC:     Hyun Kwon <hyunk@xilinx.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>,
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
Message-ID: <20190128183428.GA23150@smtp.xilinx.com>
References: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
 <1548438777-11203-3-git-send-email-vishal.sagar@xilinx.com>
 <20190126021457.GB2412@smtp.xilinx.com>
 <CY4PR02MB2709EE444A18D73A3025D200A7960@CY4PR02MB2709.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CY4PR02MB2709EE444A18D73A3025D200A7960@CY4PR02MB2709.namprd02.prod.outlook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39850400004)(136003)(396003)(376002)(346002)(2980300002)(45074003)(189003)(199004)(51914003)(13464003)(54534003)(336012)(6636002)(6862004)(30864003)(93886005)(47776003)(14444005)(36386004)(2486003)(23676004)(107886003)(77096007)(6246003)(186003)(53546011)(4326008)(229853002)(76176011)(58126008)(8936002)(81156014)(114624004)(81166006)(316002)(8676002)(54906003)(9786002)(1076003)(57986006)(63266004)(446003)(26005)(356004)(50466002)(476003)(6666004)(478600001)(106002)(486006)(2870700001)(126002)(33656002)(44832011)(7416002)(426003)(305945005)(53946003)(76506005)(2906002)(11346002)(106466001)(18370500001)(107986001)(5001870100001)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0201MB3518;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;SN1NAM02FT036;1:4QmzEAZZfwvp3mhRmbRTLnt+/B3E6o6AJ/J1Ov4g2wqOZ48WdeX8T0Gw1Ln8hkdLXRyaa00c1AtdWc5dawH6h1ffYgkZ45dJpX+Gr6LIp1QibeMuw/WrMhU6rR41lJXROAX5KFJtR7m3Cc8ihDrnRnZlxXCzvZdC510BvKgAaGk=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb635717-b8d6-4651-e61c-08d6854f51cf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN4PR0201MB3518;
X-Microsoft-Exchange-Diagnostics: 1;SN4PR0201MB3518;3:nz5P9U3F4Db5SaLLzlJt/+6JuU43ve9OZpzQ52hiMG5KzomtC9TNiFMOS2qGkNU+jOmkcvdTaOBHc94m7tYkk0DumF8AwXzELipvzZJ2OVMmWoXdHD/MZ0U2Nsrqwvi6JX1ujPv1lMxPgNzIMG9FUy/3GtuZV/jk8KbICQYcOU9zvFhljg9nISws9MCQbQznx8msd/aCWMVjJ3Zk1/gSxZJ2R4xkbZAUaRDHGmfyYvVsCn1S2QpGAxyPr770H9j1aFQC3+41vQV17eIDitv0P3+MNoLACLzOW/qeLZAIJAOBTExPpGp0wZwbEcwHePmwSvMYCeCM02LvsMrEqIEMjhKbt6m/5W9htSV/yynyeIPaJXkabLExatiCbCNmd/wI;25:Wa6/Lmj7rMntVbApINZ+Kt6EaLzhbXAt0CEqXuSUb0ezTVCZDT7eZLfRureb2Dy2iyNr4m1hfgLfWDdEoupJRPB0uZ4YV6jk6vP2l0Wr7MfzszGbJsRE0Q/HHA6KlEkY8Ihl6DQT1GXxpzojpsOtvJomDadDmYf1TrJfYsy3ToHDzMjl0mSAirldMmHrsV8xd0m7FWdXDaQeznk7hYCvB78R5pnTmv/Y0BQ/ajovjVKwbK3qVdVxtJ+/hpfL//Vk34b85u5KdEDBW8apOoJOZ2oSOyJ6eku9YPvBy5AzrSTAxz0hrYSpRQxZUXbhOBIWNh29Xb+YddqSYL2sFNZURA==
X-MS-TrafficTypeDiagnostic: SN4PR0201MB3518:
X-Microsoft-Exchange-Diagnostics: 1;SN4PR0201MB3518;31:W2b1JB+1Fd28CYcOIrnMnq/dOQsE4IKhGazqUC0gC8rX+jthS4WXE9y+2M8MbhUknBp05N5BPSBDcjozUVJtlO7NTNoHsaoj+8DfIA4zGeoBe6Pgf3NFCruCm5+HDKhspHEFprx4HUS32BNE90FvfxLSHkZh9sWFsoZBVHJt1uGw1h5sawFQurAk+iA2TG+rSIxXjNNxJAeA0IhQRrW8eI6NKBUjUjMYT65Da3fZeOE=;20:IUhwqrTRVKen6PauabPOyVTT4McuJsRPSnh9/vDIy5aH2PekpSPx9rHP8DGYDps1GZ7PuxqxbL6zfw4jF9+wXo89QfSBdAByCoeCO2jUVd9njo0uZ8PR69cqZ22q9uBzrQRRomkL7kmbuHquKKDZn+NdBN7p3FlZfd6STKMeOhk1Qp3jyvIKI2mhoTMPnz2lb2cPh789LUfsl3JNpp0aNvt/HjnoQE+xSlSzyGBsnHVX/6EfJ8DEQ2QbHC3MPMlrxyE+uSeYC3KtE3q2y2MSidWqKztuZ3VRw/3H4V0Tzy5RO8fHKys/5mRzLzaHxSk4L1jLLvufmqOUNSSDWNQKZQKrhFASbWUufXjs4Ym5NeUmyVGYm8kfes2Z682LaIYZ8AirNsd41Fu5lxcnHEXgjCJd0HTgcsRcomKZx4zq6ONWChK/hVbs3Mrsx15RNOXGM+ou1+QHw7BhbDM0yyXvGSFbDfgMDSnw1xSAVoD4CKJOcOwLH3EaJRR8vYEf9OTa
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <SN4PR0201MB3518C7B9A56B8EA7E5FF7B3ED6960@SN4PR0201MB3518.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;SN4PR0201MB3518;4:PX2O5F6VM0ce3Pdq4wHQLrZmVIIL3qrIlrL8H021Kxs7Dulc14NZgeyONO6zi0eprMsR7oxKb+uwi4MN8sx724O/qxj5SFjNuGifrFfJkVbK5BgB0dT3J4ltsNEG4O8GoAvO1to4rLGnTFNj1y3BjZWpQqF+LXReyroJveFOK2aCt2zwA9xYTIBQDBDec3GeNRpiY/82aLm4DK8DSx0f8+Jfo5jP4qGEZ5TJ5N5kiUjVUr/F4jp9dCemsY2oqpm4gLe9HEvPIV9M7Lg3qLWZZdmK8x/dzF0MeCCRpZunnGuDxyZYod0kA6Z7SkH3AlKT
X-Forefront-PRVS: 0931CB1479
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtTTjRQUjAyMDFNQjM1MTg7MjM6c0p4dms1cjlUaXZwMVYzUVhxU3hCaDR1?=
 =?utf-8?B?VUpkNFJoNmxRa0dOQlMxd1FhZmh2MThxdVhUZnN5UlpOR21FcE1ENWloSWdo?=
 =?utf-8?B?SUFkZjVCNU9DWEZ1RWJQbnV2NWFsdjNoc1BHbHFFV2pZWC9YN2I4MVJmUHVJ?=
 =?utf-8?B?NmxBYVFoa3RoeUZMaEYyTHZXWmh2NStYV2NjdTdUSnRoRjlxcWxHQUdwNXBo?=
 =?utf-8?B?ZU1UVXdybFgyTHRNS1kwZEJUNVRZOGNtc1dhTjZaSGg1azluUnlOSzNDN2dT?=
 =?utf-8?B?S0JtYlhOdDFwMldxMEtrQ1FMMFlUMDAxUVhJcHAzc2M1U1hnMjhXYmJCNjNE?=
 =?utf-8?B?QnhxZmRIM1FwK3cra2YweWtKUWQ0V0llSlJSamRHbWFDWWMzelk2ak9CdVVS?=
 =?utf-8?B?QnU1SXFUVXZpYm51dDNhdkN3d09vNXdvdno4VStJTFVhN2s0aVFCc0tOSWNP?=
 =?utf-8?B?RkdBWnZBdTNtSjZDZ29neTJ5K0s4UHI4UEtzT0JlQnZNcW9SSnZVaUdjOW9h?=
 =?utf-8?B?VjFYdTdBdm83Q2JWdzc1VFlqNW1iekxJNE1JanJqR2h6aExCNXNFaTJYU1Uy?=
 =?utf-8?B?c0NlYVBjWjByTjFwQjdsZk81d3hEc2Z0TUUxT3R6QTlOL1gyZDZUcHVsbzl1?=
 =?utf-8?B?QVp3elZheFlOamlKZG90Q0hmY3JQWWhzajRPL05MRU5NdCt4NXViczc0NzR6?=
 =?utf-8?B?Qk5EK0psdytTWXlMR1hzSlhjWlJFYStJNFg4WHFPSnp2MEVCZzNvalVtdERv?=
 =?utf-8?B?ODh6NUQrK1IvYTVJZTJXU0N0YnluZ1RxWFIycWJ1M2pidlhtU0ZOL2lYakF3?=
 =?utf-8?B?bTdIcGtvZ0xGUlc3N2JrTTFYNmhQMFRTWDBaY09LWDhPcU42SkVPMEFFRkg3?=
 =?utf-8?B?Q2tTZDBjVEwxVy9SS3d3SGhUOXdiTGJpRGQyejRHNURZZkJDRWdGNWxOU0xQ?=
 =?utf-8?B?M3RBRWsrNHp0Rk1KcXVSQS9pR3JjbHoyTlMvQWVZQXpEVi9SMndaZjFYN1dL?=
 =?utf-8?B?Y0kwWEIxQ1piOTNvRUJPOGpJODRLcjQycTBWbFpCdEJEbHJPUVdGbTBvOWxC?=
 =?utf-8?B?MWFnWUc1VHJWT3VRdkFJUXI0VjNOeTJPMTVaS2s3bjBUSmpVc3V4OUkwQ2Vp?=
 =?utf-8?B?R091K1l0Vm4rbzFWS09HWkRTMFpCTmJBaHJFOTljdTVrWjNqY0pudWp5N2Jp?=
 =?utf-8?B?djZMOHBUenRCb1VOQnJLYnpueVpvZzgyTU5kSWNGYTd1TkhqUThXWkFUNU5R?=
 =?utf-8?B?Q2hLWGhodmtEd0hGVk1Zd3IvbFM3NzdBU24xcUpjZmR6VERFUGtCWklnWWwy?=
 =?utf-8?B?RGM4cnpkUU1mRzJOWWJrdm5US2M1ZFUyNCt6dFhsbDBONEZnak1WSDEzT1ZE?=
 =?utf-8?B?N0tlaCtOemNkM3BCN3RQWndXUnVzYXp0Z2R3T08zclFFbmh3K0dOL2RQZXND?=
 =?utf-8?B?aGVhUk9FYUpYbmFLVEZaK25GUlhHdWM2bG5UaTNpQkFvL3dPa09USlhzMDR2?=
 =?utf-8?B?cHJTNGI0NUExSmNLL2VPcDZaREpaS0U1endDYVZMQmZ2dlQwQk5WS3N4VXdC?=
 =?utf-8?B?MVZ3K250aHdIN3kza1BnVmpnU0w3M2svTXZtUU5tOHNZMnN0eW4zbGRDVTdi?=
 =?utf-8?B?M3JwZDVyUEZhVCtnbU5NTnZoWklvT2FPM1JoOXAwTUpjNTBpRzlUc01tUy9T?=
 =?utf-8?B?K3RrTm5OKzlvdHFiYno2S2p0eWxDY0hWUTJnbC93Q3U2RU8vL0szVTh2b2tE?=
 =?utf-8?B?MjVGWXNIUWtSNzdSRCt4SU51L3F2MGYyNkNPOExXaTZUVWZmaCtiWWJndEY0?=
 =?utf-8?B?S0pQOFZMNlJ6MkxGbGlsdkloY1RLSG5ERzhxQzgrWE5WZGdwYmY3MVNrWkRy?=
 =?utf-8?B?Z25reGM5QmZIT2RhKzRHdHpyYlVnV0R0S2k3QUpHL0hzVEtSY3JBaHNsUitQ?=
 =?utf-8?B?NjRiNzBHT1hpaUtQUFQ5b0QwQTBNYnJZeWMvYUtwdDc2K2EySmtDclVSTVVK?=
 =?utf-8?B?bGxyNGxSeW1nME5vMkVsUFpRTjlndFJXS1g1K3d3PT0=?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 5c2E0/brOG6HslwgfKgUzPGepLxbnUUBim5QjVFcX0eUyK09Bwabvszpy613TiWJ9y8dzdVRE6GZkF4GP+WNolXbl2f8FT0hogrfOI6alucjLCj+J3+2MvoNpRhAkg+WjWlO0RH4j3RUBv4sv5ED8GrNY/zOgt+vndD28SCqQ7lSvMXLT8wacsPa5rGfpaZA60wFyXsO5+oxDn7HysRjeXYB4J/VtuQOFCFmuABpNPPVXIGXErNAI0GqWcHmSW/u9+hovcaR2GjXh1ZaNOx+UmFmKbiSpUUteQY+VvDkj2zXSSbnjWHLnInhgG3fQJskKxktFT3YC31org09CWAthS+3yrazBOgREDcNcqyRtd51w5sba38pG8Fboy7p78vFVK2pg77KQkl1A0qMQYBXQ4uFRCGIyPcKiFLbjY9A3/c=
X-Microsoft-Exchange-Diagnostics: 1;SN4PR0201MB3518;6:uIq1pNMSNtn2pIOE7eADghKXjeS20P+u0HWTVG74EKVVzCgtvwKJE2rLTWeTvpraVeoab68scUo0xAXud1OWuCYOktZlz6xlUAwlJ3C5kgkdxkKYmXY1tvZ8rJliwR6m4ECwg/fQ0urNXIep7StHUvB+0ZiIjw3vTagxE/JRPXD8gdBDTiG5t21b84hVX6CxZXKf0dUlu4fxHnRdQKPwCeU6IYnGDprl/fRXW3kQEpXKh8cfgXJE5xe8p3rr4W1uOjJ6mScCzo5pzIShN+E467L/4Qo3UOpZzS9Km553XtCdCs4UfvjzJHpI7V+lbLipdNTXymXkB9Lsb7NuUoLApI586+2Zojh5ZRXAGK/Nq9oz5jndMqBd5pgmc2rASdIEFBxKqEwUng4Y87d+CTDs6xLWdAGARf+xJDo3jG23pInz+1Y6bMBVRWToAWZVkEjv/lsXUre9ru4WeEPStD3wtw==;5:/33D5C1NeFGBgkZpKaJRoLQuzr0zJIKsJqRBtA5/KL7U/kpwMa6OAVYrFsuUsk+0z2eNeLkeHrOIWsO2hYUG0Di0QMz1JYWIef7G/bzjdfGfghNDMGOLJGBgi1BilG2qGg01uB/BD8XNBwVTJKFyyixzMiMZfq6+PKOouuvvt3iL/+CBvwTfYuEhe702XsUejfGD/CtTdSG8ckQqY3+Bbw==;7:iNUnYKy87Z7akcQTUD2v55/ACfYmzcYLEz/uKJbYvmeuqpNJOAT2KUPqriLmdvUpa29p6xdr/ZEwwbLVQ6ZDlIxZxLxzPJjXDTKXtDcBNFtcjP+ADyb0PtCQW08bb4NwGLQUoOnpnEbWtepKZpRDHw==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2019 18:35:03.5669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb635717-b8d6-4651-e61c-08d6854f51cf
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0201MB3518
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

On Mon, 2019-01-28 at 03:16:49 -0800, Vishal Sagar wrote:
> Hi Hyun,
> 
> Thanks for the review.
> 
> > -----Original Message-----
> > From: Hyun Kwon [mailto:hyun.kwon@xilinx.com]
> > Sent: Saturday, January 26, 2019 7:45 AM
> > To: Vishal Sagar <vishal.sagar@xilinx.com>
> > Cc: Hyun Kwon <hyunk@xilinx.com>; laurent.pinchart@ideasonboard.com;
> > mchehab@kernel.org; robh+dt@kernel.org; mark.rutland@arm.com; Michal
> > Simek <michals@xilinx.com>; linux-media@vger.kernel.org;
> > devicetree@vger.kernel.org; sakari.ailus@linux.intel.com;
> > hans.verkuil@cisco.com; linux-arm-kernel@lists.infradead.org; linux-
> > kernel@vger.kernel.org; Dinesh Kumar <dineshk@xilinx.com>; Sandip Kothari
> > <sandipk@xilinx.com>
> > Subject: Re: [PATCH v2 2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx
> > Subsystem driver
> > 
> > Hi Vishal,
> > 
> > Thanks for the patch.
> > 
> > On Fri, 2019-01-25 at 09:52:57 -0800, Vishal Sagar wrote:
> > > The Xilinx MIPI CSI-2 Rx Subsystem soft IP is used to capture images
> > > from MIPI CSI-2 camera sensors and output AXI4-Stream video data ready
> > > for image processing. Please refer to PG232 for details.
> > >
> > > The driver is used to set the number of active lanes, if enabled
> > > in hardware. The CSI2 Rx controller filters out all packets except for
> > > the packets with data type fixed in hardware. RAW8 packets are always
> > > allowed to pass through.
> > >
> > > It is also used to setup and handle interrupts and enable the core. It
> > > logs all the events in respective counters between streaming on and off.
> > > The generic short packets received are notified to application via
> > > v4l2_events.
> > >
> > > The driver supports only the video format bridge enabled configuration.
> > > Some data types like YUV 422 10bpc, RAW16, RAW20 are supported when
> > the
> > > CSI v2.0 feature is enabled in design. When the VCX feature is enabled,
> > > the maximum number of virtual channels becomes 16 from 4.
> > >
> > > Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> > > ---
> > > v2
> > > - Fixed comments given by Hyun and Sakari.
> > > - Made all bitmask using BIT() and GENMASK()
> > > - Removed unused definitions
> > > - Removed DPHY access. This will be done by separate DPHY PHY driver.
> > > - Added support for CSI v2.0 for YUV 422 10bpc, RAW16, RAW20 and extra
> > >   virtual channels
> > > - Fixed the ports as sink and source
> > > - Now use the v4l2fwnode API to get number of data-lanes
> > > - Added clock framework support
> > > - Removed the close() function
> > > - updated the set format function
> > > - support only VFB enabled configuration
> > >
> > >  drivers/media/platform/xilinx/Kconfig           |   10 +
> > >  drivers/media/platform/xilinx/Makefile          |    1 +
> > >  drivers/media/platform/xilinx/xilinx-csi2rxss.c | 1609
> > +++++++++++++++++++++++
> > >  include/uapi/linux/xilinx-v4l2-controls.h       |   14 +
> > >  include/uapi/linux/xilinx-v4l2-events.h         |   28 +
> > >  5 files changed, 1662 insertions(+)
> > >  create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
> > >  create mode 100644 include/uapi/linux/xilinx-v4l2-events.h
> > >
> > > diff --git a/drivers/media/platform/xilinx/Kconfig
> > b/drivers/media/platform/xilinx/Kconfig
> > > index 74ec8aa..30b4a25 100644
> > > --- a/drivers/media/platform/xilinx/Kconfig
> > > +++ b/drivers/media/platform/xilinx/Kconfig
> > > @@ -10,6 +10,16 @@ config VIDEO_XILINX
> > >
> > >  if VIDEO_XILINX
> > >
> > > +config VIDEO_XILINX_CSI2RXSS
> > > +	tristate "Xilinx CSI2 Rx Subsystem"
> > > +	help
> > > +	  Driver for Xilinx MIPI CSI2 Rx Subsystem. This is a V4L sub-device
> > > +	  based driver that takes input from CSI2 Tx source and converts
> > > +	  it into an AXI4-Stream. The subsystem comprises of a CSI2 Rx
> > > +	  controller, DPHY, an optional I2C controller and a Video Format
> > > +	  Bridge. The driver is used to set the number of active lanes and
> > > +	  get short packet data.
> > > +
> > >  config VIDEO_XILINX_TPG
> > >  	tristate "Xilinx Video Test Pattern Generator"
> > >  	depends on VIDEO_XILINX
> > > diff --git a/drivers/media/platform/xilinx/Makefile
> > b/drivers/media/platform/xilinx/Makefile
> > > index 4cdc0b1..6119a34 100644
> > > --- a/drivers/media/platform/xilinx/Makefile
> > > +++ b/drivers/media/platform/xilinx/Makefile
> > > @@ -3,5 +3,6 @@
> > >  xilinx-video-objs += xilinx-dma.o xilinx-vip.o xilinx-vipp.o
> > >
> > >  obj-$(CONFIG_VIDEO_XILINX) += xilinx-video.o
> > > +obj-$(CONFIG_VIDEO_XILINX_CSI2RXSS) += xilinx-csi2rxss.o
> > >  obj-$(CONFIG_VIDEO_XILINX_TPG) += xilinx-tpg.o
> > >  obj-$(CONFIG_VIDEO_XILINX_VTC) += xilinx-vtc.o
> > > diff --git a/drivers/media/platform/xilinx/xilinx-csi2rxss.c
> > b/drivers/media/platform/xilinx/xilinx-csi2rxss.c
> > > new file mode 100644
> > > index 0000000..5accf01
> > > --- /dev/null
> > > +++ b/drivers/media/platform/xilinx/xilinx-csi2rxss.c
> > > @@ -0,0 +1,1609 @@
> > > +// SPDX-License-Identifier: GPL-2.0+
> > > +/*
> > > + * Driver for Xilinx MIPI CSI2 Rx Subsystem
> > > + *
> > > + * Copyright (C) 2016 - 2019 Xilinx, Inc.
> > > + *
> > > + * Contacts: Vishal Sagar <vishal.sagar@xilinx.com>
> > > + *
> > > + */
> > > +#include <linux/clk.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/module.h>
> > > +#include <linux/mutex.h>
> > > +#include <linux/of.h>
> > > +#include <linux/of_irq.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/v4l2-subdev.h>
> > > +#include <linux/xilinx-v4l2-controls.h>
> > > +#include <linux/xilinx-v4l2-events.h>
> > > +#include <media/media-entity.h>
> > > +#include <media/v4l2-common.h>
> > > +#include <media/v4l2-ctrls.h>
> > > +#include <media/v4l2-event.h>
> > > +#include <media/v4l2-fwnode.h>
> > > +#include <media/v4l2-subdev.h>
> > > +#include "xilinx-vip.h"
> > > +
> > > +/* Register register map */
> > > +#define XCSI_CCR_OFFSET		0x00
> > > +#define XCSI_CCR_SOFTRESET	BIT(1)
> > > +#define XCSI_CCR_ENABLE		BIT(0)
> > > +
> > > +#define XCSI_PCR_OFFSET		0x04
> > > +#define XCSI_PCR_MAXLANES_MASK	GENMASK(4, 3)
> > > +#define XCSI_PCR_ACTLANES_MASK	GENMASK(1, 0)
> > > +
> > > +#define XCSI_CSR_OFFSET		0x10
> > > +#define XCSI_CSR_PKTCNT		GENMASK(31, 16)
> > > +#define XCSI_CSR_SPFIFOFULL	BIT(3)
> > > +#define XCSI_CSR_SPFIFONE	BIT(2)
> > > +#define XCSI_CSR_SLBF		BIT(1)
> > > +#define XCSI_CSR_RIPCD		BIT(0)
> > > +
> > > +#define XCSI_GIER_OFFSET	0x20
> > > +#define XCSI_GIER_GIE		BIT(0)
> > > +
> > > +#define XCSI_ISR_OFFSET		0x24
> > > +#define XCSI_IER_OFFSET		0x28
> > > +
> > > +#define XCSI_ISR_FR		BIT(31)
> > > +#define XCSI_ISR_VCXFE		BIT(30)
> > > +#define XCSI_ISR_WCC		BIT(22)
> > > +#define XCSI_ISR_ILC		BIT(21)
> > > +#define XCSI_ISR_SPFIFOF	BIT(20)
> > > +#define XCSI_ISR_SPFIFONE	BIT(19)
> > > +#define XCSI_ISR_SLBF		BIT(18)
> > > +#define XCSI_ISR_STOP		BIT(17)
> > > +#define XCSI_ISR_SOTERR		BIT(13)
> > > +#define XCSI_ISR_SOTSYNCERR	BIT(12)
> > > +#define XCSI_ISR_ECC2BERR	BIT(11)
> > > +#define XCSI_ISR_ECC1BERR	BIT(10)
> > > +#define XCSI_ISR_CRCERR		BIT(9)
> > > +#define XCSI_ISR_DATAIDERR	BIT(8)
> > > +#define XCSI_ISR_VC3FSYNCERR	BIT(7)
> > > +#define XCSI_ISR_VC3FLVLERR	BIT(6)
> > > +#define XCSI_ISR_VC2FSYNCERR	BIT(5)
> > > +#define XCSI_ISR_VC2FLVLERR	BIT(4)
> > > +#define XCSI_ISR_VC1FSYNCERR	BIT(3)
> > > +#define XCSI_ISR_VC1FLVLERR	BIT(2)
> > > +#define XCSI_ISR_VC0FSYNCERR	BIT(1)
> > > +#define XCSI_ISR_VC0FLVLERR	BIT(0)
> > > +
> > > +#define XCSI_INTR_PROT_MASK	(XCSI_ISR_VC3FSYNCERR |
> > 	XCSI_ISR_VC3FLVLERR |\
> > > +				 XCSI_ISR_VC2FSYNCERR |
> > XCSI_ISR_VC2FLVLERR |\
> > > +				 XCSI_ISR_VC1FSYNCERR |
> > XCSI_ISR_VC1FLVLERR |\
> > > +				 XCSI_ISR_VC0FSYNCERR |
> > 	XCSI_ISR_VC0FLVLERR |\
> > > +				 XCSI_ISR_VCXFE)
> > > +
> > > +#define XCSI_INTR_PKTLVL_MASK	(XCSI_ISR_ECC2BERR |
> > XCSI_ISR_ECC1BERR |\
> > > +				 XCSI_ISR_CRCERR | XCSI_ISR_DATAIDERR)
> > > +
> > > +#define XCSI_INTR_DPHY_MASK	(XCSI_ISR_SOTERR |
> > XCSI_ISR_SOTSYNCERR)
> > > +
> > > +#define XCSI_INTR_SPKT_MASK	(XCSI_ISR_SPFIFOF | XCSI_ISR_SPFIFONE)
> > > +
> > > +#define XCSI_INTR_ERR_MASK	(XCSI_ISR_WCC | XCSI_ISR_ILC |
> > XCSI_ISR_SLBF |\
> > > +				 XCSI_ISR_STOP)
> > > +
> > > +#define XCSI_INTR_FRAMERCVD_MASK	(XCSI_ISR_FR)
> > > +
> > > +#define XCSI_ISR_ALLINTR_MASK	(XCSI_INTR_PROT_MASK |
> > XCSI_INTR_PKTLVL_MASK |\
> > > +				 XCSI_INTR_DPHY_MASK |
> > XCSI_INTR_SPKT_MASK |\
> > > +				 XCSI_INTR_ERR_MASK |
> > XCSI_INTR_FRAMERCVD_MASK)
> > > +
> > > +/*
> > > + * Removed VCXFE mask as it doesn't exist in IER
> > > + * Removed STOP state irq as this will keep driver in irq handler only
> > > + */
> > > +#define XCSI_IER_INTR_MASK	(XCSI_ISR_ALLINTR_MASK &\
> > > +				 ~(XCSI_ISR_STOP | XCSI_ISR_VCXFE))
> > > +
> > > +#define XCSI_SPKTR_OFFSET	0x30
> > > +#define XCSI_SPKTR_DATA		GENMASK(23, 8)
> > > +#define XCSI_SPKTR_VC		GENMASK(7, 6)
> > > +#define XCSI_SPKTR_DT		GENMASK(5, 0)
> > > +
> > > +#define XCSI_VCXR_OFFSET	0x34
> > > +#define XCSI_VCXR_VCERR		GENMASK(23, 0)
> > > +#define XCSI_VCXR_VCSTART	4
> > > +#define XCSI_VCXR_VCEND		15
> > > +#define XCSI_VCXR_FSYNCERR	BIT(1)
> > > +#define XCSI_VCXR_FLVLERR	BIT(0)
> > > +
> > > +#define XCSI_CLKINFR_OFFSET	0x3C
> > > +#define XCSI_CLKINFR_STOP	BIT(1)
> > > +
> > > +#define XCSI_DLXINFR_OFFSET	0x40
> > > +#define XCSI_DLXINFR_STOP	BIT(5)
> > > +#define XCSI_DLXINFR_SOTERR	BIT(1)
> > > +#define XCSI_DLXINFR_SOTSYNCERR	BIT(0)
> > > +#define XCSI_MAXDL_COUNT	0x4
> > > +
> > > +#define XCSI_VCXINF1R_OFFSET		0x60
> > > +#define XCSI_VCXINF1R_LINECOUNT		GENMASK(31, 16)
> > > +#define XCSI_VCXINF1R_LINECOUNT_SHIFT	16
> > > +#define XCSI_VCXINF1R_BYTECOUNT		GENMASK(15, 0)
> > > +
> > > +#define XCSI_VCXINF2R_OFFSET	0x64
> > > +#define XCSI_VCXINF2R_DT	GENMASK(5, 0)
> > > +#define XCSI_MAXVCX_COUNT	16
> > > +
> > > +/*
> > > + * The core takes less than 100 video clock cycles to reset.
> > > + * So choosing a timeout value larger than this.
> > > + */
> > > +#define XCSI_TIMEOUT_VAL	1000 /* us */
> > > +
> > > +/* Maximum short packet events */
> > > +#define XCSI_MAX_SPKT_EVENT	64
> > > +
> > > +/*
> > > + * Sink pad connected to sensor source pad.
> > > + * Source pad connected to next module like demosaic.
> > > + */
> > > +#define XCSI_MEDIA_PADS		2
> > > +#define XCSI_DEFAULT_WIDTH	1920
> > > +#define XCSI_DEFAULT_HEIGHT	1080
> > > +
> > > +/* Max string length for CSI Data type string */
> > > +#define XCSI_PXLFMT_STRLEN_MAX	16
> > > +
> > > +/* This range is the tolerance for DPHY clock of 200 MHz */
> > > +#define XCSI_DPHY_CLK_MIN	197000000000UL
> > > +#define XCSI_DPHY_CLK_MAX	203000000000UL
> > 
> > Could you share where this range comes from? Is it defined somewhere,
> > or from test?
> > 
> > > +#define XCSI_DPHY_CLK_REQ	200000000000UL
> > 
> > The changelog mentions there'll be a separate phy driver. Then wouldn't
> > the phy driver have to set own clock? If the phy driver becomes a child
> > driver of this subsystem driver, then it's fine to do it here.
> > 
> 
> This CSI2 Rx controller is tied to Xilinx DPHY controller. 
> It would be good to have a separate phy driver for Xilinx DPHY which controls this clock.
> But till then, the DPHY 200Mhz clock should be controlled by this driver.
> 
> Is this ok?
> 

The dt binding shouldn't change, because otherwise it means the current
dt binding is incorrect.

> > > +
> > > +/* MIPI CSI2 Data Types from spec */
> > > +#define XCSI_DT_YUV4228B	0x1E
> > > +#define XCSI_DT_YUV42210B	0x1F
> > > +#define XCSI_DT_RGB444		0x20
> > > +#define XCSI_DT_RGB555		0x21
> > > +#define XCSI_DT_RGB565		0x22
> > > +#define XCSI_DT_RGB666		0x23
> > > +#define XCSI_DT_RGB888		0x24
> > > +#define XCSI_DT_RAW6		0x28
> > > +#define XCSI_DT_RAW7		0x29
> > > +#define XCSI_DT_RAW8		0x2A
> > > +#define XCSI_DT_RAW10		0x2B
> > > +#define XCSI_DT_RAW12		0x2C
> > > +#define XCSI_DT_RAW14		0x2D
> > > +#define XCSI_DT_RAW16		0x2E
> > > +#define XCSI_DT_RAW20		0x2F
> > > +
> > > +#define XCSI_VCX_START		4
> > > +#define XCSI_MAX_VC		4
> > > +#define XCSI_MAX_VCX		16
> > > +
> > > +#define XCSI_NEXTREG_OFFSET	4
> > > +
> > > +/* Bayer pattern for RAW data */
> > > +#define XCSI_BAYER_RGGB		0
> > > +#define XCSI_BAYER_BGGR		1
> > > +#define XCSI_BAYER_GBRG		2
> > > +#define XCSI_BAYER_GRBG		3
> > > +
> > > +/* There are 2 events frame sync and frame level error per VC */
> > > +#define XCSI_VCX_NUM_EVENTS	((XCSI_MAX_VCX - XCSI_MAX_VC) * 2)
> > > +
> > > +/*
> > > + * Macro to return "true" or "false" string if bit is set
> > > + */
> > 
> > Single line comment would be fine.
> 
> Agree. Will update it in next version.
> 
> > 
> > > +#define XCSI_GET_BITSET_STR(val, mask)	(val) & (mask) ? "true" : "false"
> > > +
> > > +static const struct of_device_id xcsi2rxss_of_id_table[] = {
> > > +	{ .compatible = "xlnx,mipi-csi2-rx-subsystem-4.0",},
> > > +	{ }
> > > +};
> > > +MODULE_DEVICE_TABLE(of, xcsi2rxss_of_id_table);
> > > +
> > 
> > This is a little too far from where this is used. :-) I'd move it
> > to closer.
> 
> Ok will move it in next revision.
> 
> > 
> > > +/**
> > > + * struct xcsi2rxss_event - Event log structure
> > > + * @mask: Event mask
> > > + * @name: Name of the event
> > > + * @counter: Count number of events
> > > + */
> > > +struct xcsi2rxss_event {
> > > +	u32 mask;
> > > +	const char * const name;
> > 
> > Nit. extra space after '*'.
> 
> Will fix in next version.
> 
> > 
> > > +	unsigned int counter;
> > > +};
> > > +
> > > +/*
> > > + * struct xcsi2rxss_core - Core configuration CSI2 Rx Subsystem device
> > structure
> > > + * @dev: Platform structure
> > > + * @iomem: Base address of subsystem
> > > + * @irq: requested irq number
> > > + * @enable_active_lanes: If number of active lanes can be modified
> > > + * @max_num_lanes: Maximum number of lanes present
> > > + * @vfb: Video Format Bridge enabled or not
> > > + * @datatype: Data type filter
> > > + * @bayer: bayer pattern
> > > + * @events: Structure to maintain event logs
> > > + * @vcx_events: Structure to maintain VCX event logs
> > > + * @en_vcx: If more than 4 VC are enabled
> > > + * @en_csi_v20: If CSI v2.0 is enabled
> > > + * @lite_aclk: AXI4-Lite interface clock
> > > + * @video_aclk: Video clock
> > > + * @dphy_clk_200M: 200MHz DPHY clock
> > > + */
> > > +struct xcsi2rxss_core {
> > > +	struct device *dev;
> > > +	void __iomem *iomem;
> > > +	int irq;
> > > +	bool enable_active_lanes;
> > > +	u32 max_num_lanes;
> > > +	bool vfb;
> > > +	u32 datatype;
> > > +	u32 bayer;
> > > +	struct xcsi2rxss_event *events;
> > > +	struct xcsi2rxss_event *vcx_events;
> > > +	bool en_vcx;
> > > +	bool en_csi_v20;
> > > +	struct clk *lite_aclk;
> > > +	struct clk *video_aclk;
> > > +	struct clk *dphy_clk_200M;
> > > +};
> > > +
> > > +/**
> > > + * struct xcsi2rxss_state - CSI2 Rx Subsystem device structure
> > > + * @core: Core structure for MIPI CSI2 Rx Subsystem
> > > + * @subdev: The v4l2 subdev structure
> > > + * @ctrl_handler: control handler
> > > + * @format: Active V4L2 formats on each pad
> > > + * @event: Holds the short packet event
> > > + * @lock: mutex for serializing operations
> > 
> > It may be just me, but it's not clear what it wants to serialize.
> > The comment better describe what resource it protects.
> 
> Ok will mention that in the next revision.
> > 
> > > + * @pads: media pads
> > > + * @streaming: Flag for storing streaming state
> > > + *
> > > + * This structure contains the device driver related parameters
> > > + */
> > > +struct xcsi2rxss_state {
> > > +	struct xcsi2rxss_core core;
> > > +	struct v4l2_subdev subdev;
> > > +	struct v4l2_ctrl_handler ctrl_handler;
> > > +	struct v4l2_mbus_framefmt format;
> > > +	struct v4l2_event event;
> > > +	/* used to serialize v4l2 operations */
> > > +	struct mutex lock;
> > > +	struct media_pad pads[XCSI_MEDIA_PADS];
> > > +	bool streaming;
> > > +};
> > > +
> > > +static struct xcsi2rxss_event xcsi2rxss_events[] = {
> > > +	{ XCSI_ISR_FR, "Frame Received", 0 },
> > > +	{ XCSI_ISR_VCXFE, "VCX Frame Errors", 0 },
> > > +	{ XCSI_ISR_WCC, "Word Count Errors", 0 },
> > > +	{ XCSI_ISR_ILC, "Invalid Lane Count Error", 0 },
> > > +	{ XCSI_ISR_SPFIFOF, "Short Packet FIFO OverFlow Error", 0 },
> > > +	{ XCSI_ISR_SPFIFONE, "Short Packet FIFO Not Empty", 0 },
> > > +	{ XCSI_ISR_SLBF, "Streamline Buffer Full Error", 0 },
> > > +	{ XCSI_ISR_STOP, "Lane Stop State", 0 },
> > > +	{ XCSI_ISR_SOTERR, "SOT Error", 0 },
> > > +	{ XCSI_ISR_SOTSYNCERR, "SOT Sync Error", 0 },
> > > +	{ XCSI_ISR_ECC2BERR, "2 Bit ECC Unrecoverable Error", 0 },
> > > +	{ XCSI_ISR_ECC1BERR, "1 Bit ECC Recoverable Error", 0 },
> > > +	{ XCSI_ISR_CRCERR, "CRC Error", 0 },
> > > +	{ XCSI_ISR_DATAIDERR, "Data Id Error", 0 },
> > > +	{ XCSI_ISR_VC3FSYNCERR, "Virtual Channel 3 Frame Sync Error", 0 },
> > > +	{ XCSI_ISR_VC3FLVLERR, "Virtual Channel 3 Frame Level Error", 0 },
> > > +	{ XCSI_ISR_VC2FSYNCERR, "Virtual Channel 2 Frame Sync Error", 0 },
> > > +	{ XCSI_ISR_VC2FLVLERR, "Virtual Channel 2 Frame Level Error", 0 },
> > > +	{ XCSI_ISR_VC1FSYNCERR, "Virtual Channel 1 Frame Sync Error", 0 },
> > > +	{ XCSI_ISR_VC1FLVLERR, "Virtual Channel 1 Frame Level Error", 0 },
> > > +	{ XCSI_ISR_VC0FSYNCERR, "Virtual Channel 0 Frame Sync Error", 0 },
> > > +	{ XCSI_ISR_VC0FLVLERR, "Virtual Channel 0 Frame Level Error", 0 }
> > > +};
> > > +
> > > +#define XCSI_NUM_EVENTS		ARRAY_SIZE(xcsi2rxss_events)
> > > +
> > > +static inline struct xcsi2rxss_state *
> > > +to_xcsi2rxssstate(struct v4l2_subdev *subdev)
> > > +{
> > > +	return container_of(subdev, struct xcsi2rxss_state, subdev);
> > > +}
> > > +
> > > +/*
> > > + * Register related operations
> > > + */
> > 
> > The xilinx-vip has same IO functions, but up to you.
> > 
> > > +static inline u32 xcsi2rxss_read(struct xcsi2rxss_core *xcsi2rxss, u32 addr)
> > > +{
> > > +	return ioread32(xcsi2rxss->iomem + addr);
> > > +}
> > > +
> > > +static inline void xcsi2rxss_write(struct xcsi2rxss_core *xcsi2rxss, u32 addr,
> > > +				   u32 value)
> > > +{
> > > +	iowrite32(value, xcsi2rxss->iomem + addr);
> > > +}
> > > +
> > > +static inline void xcsi2rxss_clr(struct xcsi2rxss_core *xcsi2rxss, u32 addr,
> > > +				 u32 clr)
> > > +{
> > > +	xcsi2rxss_write(xcsi2rxss, addr,
> > > +			xcsi2rxss_read(xcsi2rxss, addr) & ~clr);
> > > +}
> > > +
> > > +static inline void xcsi2rxss_set(struct xcsi2rxss_core *xcsi2rxss, u32 addr,
> > > +				 u32 set)
> > > +{
> > > +	xcsi2rxss_write(xcsi2rxss, addr,
> > > +			xcsi2rxss_read(xcsi2rxss, addr) | set);
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_clr_and_set - Clear and set the register with a bitmask
> > > + * @xcsi2rxss: Xilinx MIPI CSI2 Rx Subsystem subdev core struct
> > > + * @addr: address of register
> > > + * @clr: bitmask to be cleared
> > > + * @set: bitmask to be set
> > > + *
> > > + * Clear a bit(s) of mask @clr in the register at address @addr, then set
> > > + * a bit(s) of mask @set in the register after.
> > > + */
> > > +static void xcsi2rxss_clr_and_set(struct xcsi2rxss_core *xcsi2rxss,
> > > +				  u32 addr, u32 clr, u32 set)
> > > +{
> > > +	u32 reg;
> > > +
> > > +	reg = xcsi2rxss_read(xcsi2rxss, addr);
> > > +	reg &= ~clr;
> > > +	reg |= set;
> > > +	xcsi2rxss_write(xcsi2rxss, addr, reg);
> > > +}
> > > +
> > > +static void xcsi2rxss_enable(struct xcsi2rxss_core *core)
> > > +{
> > > +	xcsi2rxss_set(core, XCSI_CCR_OFFSET, XCSI_CCR_ENABLE);
> > > +}
> > > +
> > > +static void xcsi2rxss_disable(struct xcsi2rxss_core *core)
> > > +{
> > > +	xcsi2rxss_clr(core, XCSI_CCR_OFFSET, XCSI_CCR_ENABLE);
> > > +}
> > > +
> > > +static void xcsi2rxss_intr_enable(struct xcsi2rxss_core *core)
> > > +{
> > > +	xcsi2rxss_clr(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE);
> > > +	xcsi2rxss_write(core, XCSI_IER_OFFSET, XCSI_IER_INTR_MASK);
> > > +	xcsi2rxss_set(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE);
> > > +}
> > > +
> > > +static void xcsi2rxss_intr_disable(struct xcsi2rxss_core *core)
> > > +{
> > > +	xcsi2rxss_clr(core, XCSI_IER_OFFSET, XCSI_IER_INTR_MASK);
> > > +	xcsi2rxss_clr(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE);
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_reset - Does a soft reset of the MIPI CSI2 Rx Subsystem
> > > + * @core: Core Xilinx CSI2 Rx Subsystem structure pointer
> > > + *
> > > + * Core takes less than 100 video clock cycles to reset.
> > > + * So a larger timeout value is chosen for margin.
> > > + *
> > > + * Return: 0 - on success OR -ETIME if reset times out
> > > + */
> > > +static int xcsi2rxss_reset(struct xcsi2rxss_core *core)
> > > +{
> > > +	u32 timeout = XCSI_TIMEOUT_VAL;
> > > +
> > > +	xcsi2rxss_set(core, XCSI_CCR_OFFSET, XCSI_CCR_SOFTRESET);
> > > +
> > > +	while (xcsi2rxss_read(core, XCSI_CSR_OFFSET) & XCSI_CSR_RIPCD) {
> > > +		if (timeout == 0) {
> > > +			dev_err(core->dev, "soft reset timed out!\n");
> > > +			return -ETIME;
> > > +		}
> > > +
> > > +		timeout--;
> > > +		udelay(1);
> > > +	}
> > > +
> > > +	xcsi2rxss_clr(core, XCSI_CCR_OFFSET, XCSI_CCR_SOFTRESET);
> > > +	return 0;
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_irq_handler - Interrupt handler for CSI-2
> > > + * @irq: IRQ number
> > > + * @dev_id: Pointer to device state
> > > + *
> > > + * In the interrupt handler, a list of event counters are updated for
> > > + * corresponding interrupts. This is useful to get status / debug.
> > > + * If the short packet FIFO not empty or overflow interrupt is received
> > > + * capture the short packet and notify of event occurrence
> > > + *
> > > + * Return: IRQ_HANDLED after handling interrupts
> > > + *         IRQ_NONE is no interrupts
> > > + */
> > > +static irqreturn_t xcsi2rxss_irq_handler(int irq, void *dev_id)
> > > +{
> > > +	struct xcsi2rxss_state *state = (struct xcsi2rxss_state *)dev_id;
> > > +	struct xcsi2rxss_core *core = &state->core;
> > > +	u32 status;
> > > +
> > > +	status = xcsi2rxss_read(core, XCSI_ISR_OFFSET) &
> > XCSI_ISR_ALLINTR_MASK;
> > > +	dev_dbg(core->dev, "interrupt status = 0x%08x\n", status);
> > 
> > Shouldn't this be rate-limited? I let you decide.
> 
> Right. I will add that to all messages in the IRQ handler.
> 
> > 
> > > +
> > > +	if (!status)
> > > +		return IRQ_NONE;
> > > +
> > > +	/* Received a short packet */
> > > +	if (status & XCSI_ISR_SPFIFONE) {
> > > +		memset(&state->event, 0, sizeof(state->event));
> > > +		state->event.type = V4L2_EVENT_XLNXCSIRX_SPKT;
> > > +		*((u32 *)(&state->event.u.data)) =
> > > +			xcsi2rxss_read(core, XCSI_SPKTR_OFFSET);
> > > +		v4l2_subdev_notify_event(&state->subdev, &state->event);
> > > +	}
> > > +
> > > +	/* Short packet FIFO overflow */
> > > +	if (status & XCSI_ISR_SPFIFOF) {
> > > +		dev_alert(core->dev, "Short packet FIFO overflowed\n");
> > > +		memset(&state->event, 0, sizeof(state->event));
> > > +		state->event.type = V4L2_EVENT_XLNXCSIRX_SPKT_OVF;
> > > +		v4l2_subdev_notify_event(&state->subdev, &state->event);
> > > +	}
> > > +
> > > +	/*
> > > +	 * Stream line buffer full
> > > +	 * This means there is a backpressure from downstream IP
> > > +	 */
> > > +	if (status & XCSI_ISR_SLBF) {
> > > +		dev_alert(core->dev, "Stream Line Buffer Full!\n");
> > > +		memset(&state->event, 0, sizeof(state->event));
> > > +		state->event.type = V4L2_EVENT_XLNXCSIRX_SLBF;
> > > +		v4l2_subdev_notify_event(&state->subdev, &state->event);
> > > +	}
> > > +
> > > +	/* Increment event counters */
> > > +	if (status & XCSI_ISR_ALLINTR_MASK) {
> > > +		unsigned int i;
> > > +
> > > +		for (i = 0; i < XCSI_NUM_EVENTS; i++) {
> > > +			if (!(status & core->events[i].mask))
> > > +				continue;
> > > +			core->events[i].counter++;
> > > +			dev_dbg(core->dev, "%s: %d\n", core->events[i].name,
> > > +				core->events[i].counter);
> > > +		}
> > > +
> > > +		if (status & XCSI_ISR_VCXFE && core->en_vcx) {
> > > +			u32 vcxstatus;
> > > +
> > > +			vcxstatus = xcsi2rxss_read(core, XCSI_VCXR_OFFSET);
> > > +			vcxstatus &= XCSI_VCXR_VCERR;
> > > +			for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++) {
> > > +				if (!(vcxstatus & core->vcx_events[i].mask))
> > > +					continue;
> > > +				core->vcx_events[i].counter++;
> > > +			}
> > > +			xcsi2rxss_write(core, XCSI_VCXR_OFFSET, vcxstatus);
> > > +		}
> > > +	}
> > > +
> > > +	xcsi2rxss_write(core, XCSI_ISR_OFFSET, status);
> > > +	return IRQ_HANDLED;
> > > +}
> > > +
> > > +static void xcsi2rxss_reset_event_counters(struct xcsi2rxss_state *state)
> > > +{
> > > +	int i;
> > 
> > Nit. unsigned.
> > 
> 
> Ok. 
> 
> > > +
> > > +	for (i = 0; i < XCSI_NUM_EVENTS; i++)
> > > +		state->core.events[i].counter = 0;
> > > +
> > > +	if (state->core.en_vcx)
> > 
> > I don't know what's recommened style, but for multiline statement,
> > putting braces seems better for readability. Up to you.
> > 
> 
> I didn't get any checkpatch warnings for this so kept it like this.
> Ok I will add the braces.
> 
> > > +		for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++)
> > > +			state->core.vcx_events[i].counter = 0;
> > > +}
> > > +
> > > +/* Print event counters */
> > > +static void xcsi2rxss_log_counters(struct xcsi2rxss_state *state)
> > > +{
> > > +	struct xcsi2rxss_core *core = &state->core;
> > > +	int i;
> > > +
> > > +	for (i = 0; i < XCSI_NUM_EVENTS; i++) {
> > > +		if (core->events[i].counter > 0)
> > > +			dev_info(core->dev, "%s events: %d\n",
> > > +				 core->events[i].name,
> > > +				 core->events[i].counter);
> > > +	}
> > > +
> > > +	if (core->en_vcx)
> > > +		for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++) {
> > > +			if (core->vcx_events[i].counter > 0)
> > > +				dev_info(core->dev,
> > > +					 "VC %d Frame %s err vcx events: %d\n",
> > > +					 (i / 2) + XCSI_VCX_START,
> > > +					 i & 1 ? "Sync" : "Level",
> > > +					 core->vcx_events[i].counter);
> > > +		}
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_log_status - Logs the status of the CSI-2 Receiver
> > > + * @sd: Pointer to V4L2 subdevice structure
> > > + *
> > > + * This function prints the current status of Xilinx MIPI CSI-2
> > > + *
> > > + * Return: 0 on success
> > > + */
> > > +static int xcsi2rxss_log_status(struct v4l2_subdev *sd)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> > > +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> > > +	unsigned int reg, data, i, max_vc;
> > > +
> > > +	mutex_lock(&xcsi2rxss->lock);
> > 
> > This lock seems to protect access to xcsi2rxss. If so, could you please
> > clarify in the lock description?
> 
> Yes will update the name in the next version. 
> > 
> > > +
> > > +	xcsi2rxss_log_counters(xcsi2rxss);
> > > +
> > > +	dev_info(core->dev, "***** Core Status *****\n");
> > > +	data = xcsi2rxss_read(core, XCSI_CSR_OFFSET);
> > > +	dev_info(core->dev, "Short Packet FIFO Full = %s\n",
> > > +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_SPFIFOFULL));
> > > +	dev_info(core->dev, "Short Packet FIFO Not Empty = %s\n",
> > > +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_SPFIFONE));
> > > +	dev_info(core->dev, "Stream line buffer full = %s\n",
> > > +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_SLBF));
> > > +	dev_info(core->dev, "Soft reset/Core disable in progress = %s\n",
> > > +		 XCSI_GET_BITSET_STR(data, XCSI_CSR_RIPCD));
> > > +
> > > +	/* Clk & Lane Info  */
> > > +	dev_info(core->dev, "******** Clock Lane Info *********\n");
> > > +	data = xcsi2rxss_read(core, XCSI_CLKINFR_OFFSET);
> > > +	dev_info(core->dev, "Clock Lane in Stop State = %s\n",
> > > +		 XCSI_GET_BITSET_STR(data, XCSI_CLKINFR_STOP));
> > > +
> > > +	dev_info(core->dev, "******** Data Lane Info *********\n");
> > > +	dev_info(core->dev, "Lane\tSoT Error\tSoT Sync Error\tStop State\n");
> > > +	reg = XCSI_DLXINFR_OFFSET;
> > > +	for (i = 0; i < XCSI_MAXDL_COUNT; i++) {
> > > +		data = xcsi2rxss_read(core, reg);
> > > +
> > > +		dev_info(core->dev, "%d\t%s\t\t%s\t\t%s\n", i,
> > > +			 XCSI_GET_BITSET_STR(data, XCSI_DLXINFR_SOTERR),
> > > +			 XCSI_GET_BITSET_STR(data,
> > XCSI_DLXINFR_SOTSYNCERR),
> > > +			 XCSI_GET_BITSET_STR(data, XCSI_DLXINFR_STOP));
> > > +
> > > +		reg += XCSI_NEXTREG_OFFSET;
> > > +	}
> > > +
> > > +	/* Virtual Channel Image Information */
> > > +	dev_info(core->dev, "********** Virtual Channel Info
> > ************\n");
> > > +	dev_info(core->dev, "VC\tLine Count\tByte Count\tData Type\n");
> > > +	if (core->en_vcx)
> > > +		max_vc = XCSI_MAX_VCX;
> > > +	else
> > > +		max_vc = XCSI_MAX_VC;
> > > +
> > > +	reg = XCSI_VCXINF1R_OFFSET;
> > > +	for (i = 0; i < max_vc; i++) {
> > > +		u32 line_count, byte_count, data_type;
> > > +
> > > +		/* Get line and byte count from VCXINFR1 Register */
> > > +		data = xcsi2rxss_read(core, reg);
> > > +		byte_count = data & XCSI_VCXINF1R_BYTECOUNT;
> > > +		line_count = data & XCSI_VCXINF1R_LINECOUNT;
> > > +		line_count >>= XCSI_VCXINF1R_LINECOUNT_SHIFT;
> > > +
> > > +		/* Get data type from VCXINFR2 Register */
> > > +		reg += XCSI_NEXTREG_OFFSET;
> > > +		data = xcsi2rxss_read(core, reg);
> > > +		data_type = data & XCSI_VCXINF2R_DT;
> > > +
> > > +		dev_info(core->dev, "%d\t%d\t\t%d\t\t0x%x\n", i, line_count,
> > > +			 byte_count, data_type);
> > > +
> > > +		/* Move to next pair of VC Info registers */
> > > +		reg += XCSI_NEXTREG_OFFSET;
> > > +	}
> > > +
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/*
> > > + * xcsi2rxss_subscribe_event - Subscribe to the custom short packet
> > > + * receive event.
> > > + * @sd: V4L2 Sub device
> > > + * @fh: V4L2 File Handle
> > > + * @sub: Subcribe event structure
> > > + *
> > > + * There are two types of events to be subscribed.
> > > + *
> > > + * First is to register for receiving a generic short packet.
> > > + * The generic short packets received are queued up in a FIFO.
> > > + * On reception of a generic short packet, an event will be generated
> > > + * with the short packet contents copied to its data area.
> > > + * Application subscribed to this event will poll for POLLPRI.
> > > + * On getting the event, the app dequeues the event to get the short packet
> > > + * data.
> > > + *
> > > + * Second is to register for Short packet FIFO overflow
> > > + * In case the rate of receiving short packets is high and
> > > + * the short packet FIFO overflows, this event will be triggered.
> > > + *
> > > + * Return: 0 on success, errors otherwise
> > > + */
> > > +static int xcsi2rxss_subscribe_event(struct v4l2_subdev *sd,
> > > +				     struct v4l2_fh *fh,
> > > +				     struct v4l2_event_subscription *sub)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> > > +	int ret;
> > > +
> > > +	mutex_lock(&xcsi2rxss->lock);
> > > +
> > > +	switch (sub->type) {
> > > +	case V4L2_EVENT_XLNXCSIRX_SPKT:
> > > +	case V4L2_EVENT_XLNXCSIRX_SPKT_OVF:
> > > +	case V4L2_EVENT_XLNXCSIRX_SLBF:
> > > +		ret = v4l2_event_subscribe(fh, sub, XCSI_MAX_SPKT_EVENT,
> > NULL);
> > > +		break;
> > > +	default:
> > > +		ret = -EINVAL;
> > > +	}
> > > +
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_unsubscribe_event - Unsubscribe from all events registered
> > > + * @sd: V4L2 Sub device
> > > + * @fh: V4L2 file handle
> > > + * @sub: pointer to Event unsubscription structure
> > > + *
> > > + * Return: zero on success, else a negative error code.
> > > + */
> > > +static int xcsi2rxss_unsubscribe_event(struct v4l2_subdev *sd,
> > > +				       struct v4l2_fh *fh,
> > > +				       struct v4l2_event_subscription *sub)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> > > +	int ret;
> > > +
> > > +	mutex_lock(&xcsi2rxss->lock);
> > > +	ret = v4l2_event_unsubscribe(fh, sub);
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_s_ctrl - This is used to set the Xilinx MIPI CSI-2 V4L2 controls
> > > + * @ctrl: V4L2 control to be set
> > > + *
> > > + * This function is used to set the V4L2 controls for the Xilinx MIPI
> > > + * CSI-2 Rx Subsystem. It is used to set the active lanes in the system.
> > > + * The event counters can be reset.
> > > + *
> > > + * Return: 0 on success, errors otherwise
> > > + */
> > > +static int xcsi2rxss_s_ctrl(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss =
> > > +		container_of(ctrl->handler, struct xcsi2rxss_state,
> > > +			     ctrl_handler);
> > > +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> > > +	int ret = 0;
> > > +	u32 active_lanes = 1;
> > 
> > Nit. This can move into if statement below, without initializing it.
> > 
> Yes. Will do it in next version.
> 
> > > +
> > > +	mutex_lock(&xcsi2rxss->lock);
> > > +
> > > +	switch (ctrl->id) {
> > > +	case V4L2_CID_XILINX_MIPICSISS_ACT_LANES:
> > > +		/*
> > > +		 * This will be called only when "Enable Active Lanes" parameter
> > > +		 * is set in design
> > > +		 */
> > > +		if (core->enable_active_lanes) {
> > > +			xcsi2rxss_clr_and_set(core, XCSI_PCR_OFFSET,
> > > +					      XCSI_PCR_ACTLANES_MASK,
> > > +					      ctrl->val - 1);
> > > +			/*
> > > +			 * This delay is to allow the value to reflect as write
> > > +			 * and read paths are different.
> > > +			 */
> > > +			udelay(1);
> > 
> > Interesting this is required.
> 
> Yes I have mentioned the reason in the comments based on PG232.
> 
> > 
> > > +			active_lanes = xcsi2rxss_read(core, XCSI_PCR_OFFSET);
> > > +			active_lanes &= XCSI_PCR_ACTLANES_MASK;
> > > +			active_lanes++;
> > > +			if (active_lanes != ctrl->val)
> > > +				dev_info(core->dev, "RxByteClkHS absent\n");
> > > +			dev_dbg(core->dev, "active lanes = %d\n", ctrl->val);
> > > +		} else {
> > > +			ret = -EINVAL;
> > > +		}
> > > +		break;
> > > +	case V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS:
> > > +		xcsi2rxss_reset_event_counters(xcsi2rxss);
> > > +		break;
> > > +	default:
> > > +		break;
> > > +	}
> > > +
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_g_volatile_ctrl - get the Xilinx MIPI CSI-2 Rx controls
> > > + * @ctrl: Pointer to V4L2 control
> > > + *
> > > + * This is used to get the number of frames received by the Xilinx
> > > + * MIPI CSI-2 Rx.
> > > + *
> > > + * Return: 0 on success, errors otherwise
> > > + */
> > > +static int xcsi2rxss_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss =
> > > +		container_of(ctrl->handler, struct xcsi2rxss_state,
> > > +			     ctrl_handler);
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&xcsi2rxss->lock);
> > > +
> > > +	switch (ctrl->id) {
> > > +	case V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER:
> > > +		ctrl->val = xcsi2rxss->core.events[0].counter;
> > > +		break;
> > > +	default:
> > > +		ret = -EINVAL;
> > > +	}
> > > +
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int xcsi2rxss_start_stream(struct xcsi2rxss_state *state)
> > > +{
> > > +	struct xcsi2rxss_core *core = &state->core;
> > > +	int ret = 0;
> > > +
> > > +	xcsi2rxss_enable(core);
> > > +
> > > +	ret = xcsi2rxss_reset(core);
> > 
> > As the soft reset is done after enabling, I guess soft reset doesn't
> > reset those controls and registers which are set prior to it.
> > 
> 
> Correct. As mentioned in PG 232 page 21 soft reset bit description, 
> "All registers reset to their default value (except for this bit, Core Enable and Active lanes configuration).
> In addition to resetting registers when this bit is set to 1:
> • Shut down port is not asserted on the PPI lanes
> • Internal FIFOs (PPI, Packet, Generic Short Packet) are flushed
> • Control Finite State Machine (FSM) stops processing current packet. Any partially written packet to
> memory is marked as errored. This packet, when made available through the AXI4-Stream interface,
> reports the error on TUSER[1]."
> 

Thanks for sharing details. Wouldn't it be better to reset in disable then?

Thanks,
-hyun


> 
> > > +	if (ret < 0) {
> > > +		state->streaming = false;
> > > +		return ret;
> > > +	}
> > > +
> > > +	xcsi2rxss_intr_enable(core);
> > > +	state->streaming = true;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static void xcsi2rxss_stop_stream(struct xcsi2rxss_state *state)
> > > +{
> > > +	struct xcsi2rxss_core *core = &state->core;
> > > +
> > > +	xcsi2rxss_intr_disable(core);
> > > +	xcsi2rxss_disable(core);
> > > +	state->streaming = false;
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_s_stream - It is used to start/stop the streaming.
> > > + * @sd: V4L2 Sub device
> > > + * @enable: Flag (True / False)
> > > + *
> > > + * This function controls the start or stop of streaming for the
> > > + * Xilinx MIPI CSI-2 Rx Subsystem.
> > > + *
> > > + * Return: 0 on success, errors otherwise
> > > + */
> > > +static int xcsi2rxss_s_stream(struct v4l2_subdev *sd, int enable)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&xcsi2rxss->lock);
> > > +
> > > +	if (enable) {
> > > +		if (!xcsi2rxss->streaming) {
> > > +			/* reset the event counters */
> > > +			xcsi2rxss_reset_event_counters(xcsi2rxss);
> > 
> > Is this required here? or can it be done explicitly by the application
> > separately?
> > 
> 
> Yes this can be done separately by the application using the reset counters v4l2 command.
> Reason to keep it here is to count the number of errors happening between enabling and disabling a stream.
> 
> > > +			ret = xcsi2rxss_start_stream(xcsi2rxss);
> > > +		}
> > > +	} else {
> > > +		if (xcsi2rxss->streaming)
> > > +			xcsi2rxss_stop_stream(xcsi2rxss);
> > > +	}
> > > +
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +	return ret;
> > > +}
> > > +
> > > +static struct v4l2_mbus_framefmt *
> > > +__xcsi2rxss_get_pad_format(struct xcsi2rxss_state *xcsi2rxss,
> > > +			   struct v4l2_subdev_pad_config *cfg,
> > > +			   unsigned int pad, u32 which)
> > > +{
> > > +	switch (which) {
> > > +	case V4L2_SUBDEV_FORMAT_TRY:
> > > +		return v4l2_subdev_get_try_format(&xcsi2rxss->subdev, cfg,
> > > +						  pad);
> > > +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> > > +		return &xcsi2rxss->format;
> > > +	default:
> > > +		return NULL;
> > > +	}
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_get_format - Get the pad format
> > > + * @sd: Pointer to V4L2 Sub device structure
> > > + * @cfg: Pointer to sub device pad information structure
> > > + * @fmt: Pointer to pad level media bus format
> > > + *
> > > + * This function is used to get the pad format information.
> > > + *
> > > + * Return: 0 on success
> > > + */
> > > +static int xcsi2rxss_get_format(struct v4l2_subdev *sd,
> > > +				struct v4l2_subdev_pad_config *cfg,
> > > +				struct v4l2_subdev_format *fmt)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> > > +
> > > +	mutex_lock(&xcsi2rxss->lock);
> > > +	fmt->format = *__xcsi2rxss_get_pad_format(xcsi2rxss, cfg, fmt->pad,
> > > +						  fmt->which);
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_set_format - This is used to set the pad format
> > > + * @sd: Pointer to V4L2 Sub device structure
> > > + * @cfg: Pointer to sub device pad information structure
> > > + * @fmt: Pointer to pad level media bus format
> > > + *
> > > + * This function is used to set the pad format. Since the pad format is fixed
> > > + * in hardware, it can't be modified on run time. So when a format set is
> > > + * requested by application, all parameters except the format type is saved
> > > + * for the pad and the original pad format is sent back to the application.
> > > + *
> > > + * Return: 0 on success
> > > + */
> > > +static int xcsi2rxss_set_format(struct v4l2_subdev *sd,
> > > +				struct v4l2_subdev_pad_config *cfg,
> > > +				struct v4l2_subdev_format *fmt)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> > > +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> > > +	struct v4l2_mbus_framefmt *__format;
> > > +	u32 code;
> > > +
> > > +	/* only sink pad format can be updated */
> > > +	mutex_lock(&xcsi2rxss->lock);
> > > +
> > > +	/*
> > > +	 * Only the format->code parameter matters for CSI as the
> > > +	 * CSI format cannot be changed at runtime.
> > > +	 * Ensure that format to set is copied to over to CSI pad format
> > > +	 */
> > > +	__format = __xcsi2rxss_get_pad_format(xcsi2rxss, cfg,
> > > +					      fmt->pad, fmt->which);
> > > +
> > > +	/* Save the pad format code */
> > > +	code = __format->code;
> > > +
> > > +	/*
> > > +	 * RAW8 is supported in all datatypes. So if requested media bus format
> > > +	 * is of RAW8 type, then allow to be set. In case core is configured to
> > > +	 * other RAW, YUV422 8/10 or RGB888, set appropriate media bus
> > format.
> > > +	 */
> > > +	if ((fmt->format.code == MEDIA_BUS_FMT_SBGGR8_1X8 ||
> > > +	     fmt->format.code == MEDIA_BUS_FMT_SGBRG8_1X8 ||
> > > +	     fmt->format.code == MEDIA_BUS_FMT_SGRBG8_1X8 ||
> > > +	     fmt->format.code == MEDIA_BUS_FMT_SRGGB8_1X8) ||
> > > +	    (core->datatype == XCSI_DT_RAW10 &&
> > > +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR10_1X10 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG10_1X10 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG10_1X10 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB10_1X10)) ||
> > > +	    (core->datatype == XCSI_DT_RAW12 &&
> > > +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR12_1X12 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG12_1X12 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG12_1X12 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB12_1X12)) ||
> > > +	    (core->datatype == XCSI_DT_RAW14 &&
> > > +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR14_1X14 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG14_1X14 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG14_1X14 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB14_1X14)) ||
> > > +	    (core->datatype == XCSI_DT_RAW16 &&
> > > +	     (fmt->format.code == MEDIA_BUS_FMT_SBGGR16_1X16 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGBRG16_1X16 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SGRBG16_1X16 ||
> > > +	      fmt->format.code == MEDIA_BUS_FMT_SRGGB16_1X16)) ||
> > > +	    (core->datatype == XCSI_DT_YUV4228B &&
> > > +	     fmt->format.code == MEDIA_BUS_FMT_UYVY8_1X16) ||
> > > +	    (core->datatype == XCSI_DT_YUV42210B &&
> > > +	     fmt->format.code == MEDIA_BUS_FMT_UYVY8_1X16) ||
> > 
> > Not sure if single bus format can be shared between 422 8B and 422 10B.
> 
> You are right. I missed it. I will remove it in next version.
> 
> > 
> > > +	    (core->datatype == XCSI_DT_RGB888 &&
> > > +	     fmt->format.code == MEDIA_BUS_FMT_RBG888_1X24)) {
> > > +		/* Copy over the format to be set */
> > > +		*__format = fmt->format;
> > > +	} else {
> > > +		/* Restore the original pad format code */
> > > +		fmt->format.code = code;
> > > +		__format->code = code;
> > > +		__format->width = fmt->format.width;
> > > +		__format->height = fmt->format.height;
> > > +	}
> > > +
> > > +	mutex_unlock(&xcsi2rxss->lock);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/**
> > > + * xcsi2rxss_open - Called on v4l2_open()
> > > + * @sd: Pointer to V4L2 sub device structure
> > > + * @fh: Pointer to V4L2 File handle
> > > + *
> > > + * This function is called on v4l2_open(). It sets the default format
> > > + * for both pads.
> > > + *
> > > + * Return: 0 on success
> > > + */
> > > +static int xcsi2rxss_open(struct v4l2_subdev *sd,
> > > +			  struct v4l2_subdev_fh *fh)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = to_xcsi2rxssstate(sd);
> > > +	struct v4l2_mbus_framefmt *format;
> > > +	unsigned int i;
> > > +
> > > +	for (i = 0; i < XCSI_MEDIA_PADS; i++) {
> > > +		format = v4l2_subdev_get_try_format(sd, fh->pad, i);
> > > +		*format = xcsi2rxss->format;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* -----------------------------------------------------------------------------
> > > + * Media Operations
> > > + */
> > > +
> > > +static const struct media_entity_operations xcsi2rxss_media_ops = {
> > > +	.link_validate = v4l2_subdev_link_validate
> > > +};
> > > +
> > > +static const struct v4l2_ctrl_ops xcsi2rxss_ctrl_ops = {
> > > +	.g_volatile_ctrl = xcsi2rxss_g_volatile_ctrl,
> > > +	.s_ctrl	= xcsi2rxss_s_ctrl
> > > +};
> > > +
> > > +static struct v4l2_ctrl_config xcsi2rxss_ctrls[] = {
> > > +	{
> > > +		.ops	= &xcsi2rxss_ctrl_ops,
> > > +		.id	= V4L2_CID_XILINX_MIPICSISS_ACT_LANES,
> > > +		.name	= "Active Lanes",
> > > +		.type	= V4L2_CTRL_TYPE_INTEGER,
> > > +		.min	= 1,
> > > +		.max	= 4,
> > > +		.step	= 1,
> > > +		.def	= 1,
> > > +	}, {
> > > +		.ops	= &xcsi2rxss_ctrl_ops,
> > > +		.id	= V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER,
> > > +		.name	= "Frames Received Counter",
> > > +		.type	= V4L2_CTRL_TYPE_INTEGER,
> > > +		.min	= 0,
> > > +		.max	= 0xFFFFFFFF,
> > > +		.step	= 1,
> > > +		.def	= 0,
> > > +		.flags	= V4L2_CTRL_FLAG_VOLATILE |
> > V4L2_CTRL_FLAG_READ_ONLY,
> > > +	}, {
> > > +		.ops	= &xcsi2rxss_ctrl_ops,
> > > +		.id	= V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS,
> > > +		.name	= "Reset Counters",
> > > +		.type	= V4L2_CTRL_TYPE_BUTTON,
> > > +		.min	= 0,
> > > +		.max	= 1,
> > > +		.step	= 1,
> > > +		.def	= 0,
> > > +		.flags	= V4L2_CTRL_FLAG_WRITE_ONLY,
> > > +	}
> > > +};
> > > +
> > > +static const struct v4l2_subdev_core_ops xcsi2rxss_core_ops = {
> > > +	.log_status = xcsi2rxss_log_status,
> > > +	.subscribe_event = xcsi2rxss_subscribe_event,
> > > +	.unsubscribe_event = xcsi2rxss_unsubscribe_event
> > > +};
> > > +
> > > +static struct v4l2_subdev_video_ops xcsi2rxss_video_ops = {
> > > +	.s_stream = xcsi2rxss_s_stream
> > > +};
> > > +
> > > +static struct v4l2_subdev_pad_ops xcsi2rxss_pad_ops = {
> > > +	.get_fmt = xcsi2rxss_get_format,
> > > +	.set_fmt = xcsi2rxss_set_format,
> > > +};
> > > +
> > > +static struct v4l2_subdev_ops xcsi2rxss_ops = {
> > > +	.core = &xcsi2rxss_core_ops,
> > > +	.video = &xcsi2rxss_video_ops,
> > > +	.pad = &xcsi2rxss_pad_ops
> > > +};
> > > +
> > > +static const struct v4l2_subdev_internal_ops xcsi2rxss_internal_ops = {
> > > +	.open = xcsi2rxss_open,
> > > +};
> > > +
> > > +static void xcsi2rxss_set_default_format(struct xcsi2rxss_state *state)
> > > +{
> > > +	struct xcsi2rxss_core *core = &state->core;
> > > +
> > > +	memset(&state->format, 0, sizeof(state->format));
> > > +
> > > +	switch (core->datatype) {
> > > +	case XCSI_DT_YUV4228B:
> > > +	case XCSI_DT_YUV42210B:
> > 
> > As mentioned before, does this belong here? It looks like 10bit format,
> > but is classified as 8bit bus format.
> > 
> 
> I will remove this 10bit format. Xilinx YUV422 10bpc on AXI4 Stream isn't represented by any of the MEDIA_BUS_FMT_*. 
> 
> > > +		state->format.code = MEDIA_BUS_FMT_UYVY8_1X16;
> > > +		break;
> > > +	case XCSI_DT_RGB888:
> > > +		state->format.code = MEDIA_BUS_FMT_RBG888_1X24;
> > > +		break;
> > > +	case XCSI_DT_RAW10:
> > > +		switch (core->bayer) {
> > > +		case XCSI_BAYER_BGGR:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SBGGR10_1X10;
> > > +			break;
> > > +		case XCSI_BAYER_GRBG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGRBG10_1X10;
> > > +			break;
> > > +		case XCSI_BAYER_GBRG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGBRG10_1X10;
> > > +			break;
> > > +		case XCSI_BAYER_RGGB:
> > > +		default:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SRGGB10_1X10;
> > > +		}
> > > +		break;
> > > +	case XCSI_DT_RAW12:
> > > +		switch (core->bayer) {
> > > +		case XCSI_BAYER_BGGR:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SBGGR12_1X12;
> > > +			break;
> > > +		case XCSI_BAYER_GRBG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGRBG12_1X12;
> > > +			break;
> > > +		case XCSI_BAYER_GBRG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGBRG12_1X12;
> > > +			break;
> > > +		case XCSI_BAYER_RGGB:
> > > +		default:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SRGGB12_1X12;
> > > +		}
> > > +		break;
> > > +	case XCSI_DT_RAW14:
> > > +		switch (core->bayer) {
> > > +		case XCSI_BAYER_BGGR:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SBGGR14_1X14;
> > > +			break;
> > > +		case XCSI_BAYER_GRBG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGRBG14_1X14;
> > > +			break;
> > > +		case XCSI_BAYER_GBRG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGBRG14_1X14;
> > > +			break;
> > > +		case XCSI_BAYER_RGGB:
> > > +		default:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SRGGB14_1X14;
> > > +		}
> > > +		break;
> > > +	case XCSI_DT_RAW16:
> > > +		switch (core->bayer) {
> > > +		case XCSI_BAYER_BGGR:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SBGGR16_1X16;
> > > +			break;
> > > +		case XCSI_BAYER_GRBG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGRBG16_1X16;
> > > +			break;
> > > +		case XCSI_BAYER_GBRG:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SGBRG16_1X16;
> > > +			break;
> > > +		case XCSI_BAYER_RGGB:
> > > +		default:
> > > +			state->format.code =
> > MEDIA_BUS_FMT_SRGGB16_1X16;
> > > +		}
> > > +		break;
> > > +	case XCSI_DT_RAW8:
> > > +	case XCSI_DT_RGB444:
> > > +	case XCSI_DT_RGB555:
> > > +	case XCSI_DT_RGB565:
> > > +	case XCSI_DT_RGB666:
> > > +		switch (core->bayer) {
> > > +		case XCSI_BAYER_BGGR:
> > > +			state->format.code = MEDIA_BUS_FMT_SBGGR8_1X8;
> > > +			break;
> > > +		case XCSI_BAYER_GRBG:
> > > +			state->format.code = MEDIA_BUS_FMT_SGRBG8_1X8;
> > > +			break;
> > > +		case XCSI_BAYER_GBRG:
> > > +			state->format.code = MEDIA_BUS_FMT_SGBRG8_1X8;
> > > +			break;
> > > +		case XCSI_BAYER_RGGB:
> > > +		default:
> > > +			state->format.code = MEDIA_BUS_FMT_SRGGB8_1X8;
> > > +		}
> > > +		break;
> > > +	}
> > > +
> > > +	state->format.field = V4L2_FIELD_NONE;
> > > +	state->format.colorspace = V4L2_COLORSPACE_SRGB;
> > > +	state->format.width = XCSI_DEFAULT_WIDTH;
> > > +	state->format.height = XCSI_DEFAULT_HEIGHT;
> > > +
> > > +	dev_dbg(core->dev, "default mediabus format = 0x%x",
> > > +		state->format.code);
> > > +}
> > > +
> > > +static int xcsi2rxss_clk_get(struct xcsi2rxss_core *core)
> > > +{
> > > +	int ret;
> > > +
> > > +	core->lite_aclk = devm_clk_get(core->dev, "lite_aclk");
> > > +	if (IS_ERR(core->lite_aclk)) {
> > > +		ret = PTR_ERR(core->lite_aclk);
> > > +		dev_err(core->dev, "failed to get lite_aclk (%d)\n",
> > > +			ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	core->video_aclk = devm_clk_get(core->dev, "video_aclk");
> > > +	if (IS_ERR(core->video_aclk)) {
> > > +		ret = PTR_ERR(core->video_aclk);
> > > +		dev_err(core->dev, "failed to get video_aclk (%d)\n",
> > > +			ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	core->dphy_clk_200M = devm_clk_get(core->dev, "dphy_clk_200M");
> > > +	if (IS_ERR(core->dphy_clk_200M)) {
> > > +		ret = PTR_ERR(core->dphy_clk_200M);
> > > +		dev_err(core->dev, "failed to get dphy_clk_200M (%d)\n",
> > > +			ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	dev_dbg(core->dev, "Got all clocks!\n");
> > 
> > This debug print doesn't add any, but it's fine if you want to keep.
> 
> I will remove in next version. It is more of trace print than debug.
> 
> > 
> > > +	return 0;
> > > +}
> > > +
> > > +static int xcsi2rxss_clk_enable(struct xcsi2rxss_core *core)
> > > +{
> > > +	unsigned long rate;
> > > +	int ret;
> > > +
> > > +	ret = clk_prepare_enable(core->lite_aclk);
> > > +	if (ret) {
> > > +		dev_err(core->dev, "failed enabling lite_aclk (%d)\n",
> > > +			ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	ret = clk_prepare_enable(core->video_aclk);
> > > +	if (ret) {
> > > +		dev_err(core->dev, "failed enabling video_aclk (%d)\n",
> > > +			ret);
> > > +		goto err_vidclk;
> > > +	}
> > > +
> > > +	ret = clk_prepare_enable(core->dphy_clk_200M);
> > > +	if (ret) {
> > > +		dev_err(core->dev, "failed enabling dphy clk (%d)\n",
> > > +			ret);
> > > +		goto err_dphyclk;
> > > +	}
> > > +
> > > +	ret = clk_set_rate(core->dphy_clk_200M, XCSI_DPHY_CLK_REQ);
> > > +	if (ret) {
> > > +		dev_err(core->dev, "failed to set dphy clk rate (%d)\n",
> > > +			ret);
> > > +		goto err_rate_set;
> > > +	}
> > > +
> > > +	rate = clk_get_rate(core->dphy_clk_200M);
> > > +	if (rate < XCSI_DPHY_CLK_MIN && rate > XCSI_DPHY_CLK_MAX) {
> > 
> > Please confirm on this range. From its name and so on, it looks like
> > it should be 200MHz.
> 
> This is range is confirmed from the RTL source code. The clock should be as close to 200MHz possible within given deviation.
> 
> > 
> > > +		dev_err(core->dev, "Err DPHY Clock = %lu\n",
> > > +			rate);
> > > +		ret = -EINVAL;
> > > +		goto err_rate_set;
> > > +	}
> > > +
> > > +	dev_dbg(core->dev, "all clocks enabled!\n");
> > > +
> > > +	return ret;
> > > +
> > > +err_rate_set:
> > > +	clk_disable_unprepare(core->dphy_clk_200M);
> > > +err_dphyclk:
> > > +	clk_disable_unprepare(core->video_aclk);
> > > +err_vidclk:
> > > +	clk_disable_unprepare(core->lite_aclk);
> > > +	return ret;
> > > +}
> > > +
> > > +static void xcsi2rxss_clk_disable(struct xcsi2rxss_core *core)
> > > +{
> > > +	clk_disable_unprepare(core->dphy_clk_200M);
> > > +	clk_disable_unprepare(core->video_aclk);
> > > +	clk_disable_unprepare(core->lite_aclk);
> > > +}
> > > +
> > > +static int xcsi2rxss_parse_of(struct xcsi2rxss_state *xcsi2rxss)
> > > +{
> > > +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> > > +	struct device_node *node = xcsi2rxss->core.dev->of_node;
> > > +	struct device_node *ports = NULL;
> > > +	struct device_node *port = NULL;
> > > +	unsigned int nports;
> > > +	int ret;
> > > +
> > > +	core->en_csi_v20 = of_property_read_bool(node, "xlnx,en-csi-v2-0");
> > 
> > Can't this be a local variable?
> In its current usage, yes. I will modify this and resend in next version. 
> 
> > 
> > > +	if (core->en_csi_v20) {
> > > +		core->en_vcx = of_property_read_bool(node, "xlnx,en-vcx");
> > > +		dev_dbg(core->dev, "vcx %s", core->en_vcx ? "enabled" :
> > > +			"disabled");
> > > +	}
> > > +
> > > +	dev_dbg(core->dev, "en_csi_v20 %s", core->en_csi_v20 ? "enabled" :
> > > +		"disabled");
> > > +
> > > +	core->enable_active_lanes =
> > > +		of_property_read_bool(node, "xlnx,en-active-lanes");
> > > +	dev_dbg(core->dev, "Enable active lanes property = %s\n",
> > > +		core->enable_active_lanes ? "Present" : "Absent");
> > > +
> > > +	ret = of_property_read_u32(node, "xlnx,csi-pxl-format",
> > > +				   &core->datatype);
> > > +	if (ret < 0) {
> > > +		dev_err(core->dev, "missing xlnx,csi-pxl-format property\n");
> > > +		return ret;
> > > +	}
> > > +
> > > +	ret = 0;
> > 
> > I think this line is not needed.
> 
> Ok. I will remove it in next version.
> 
> > 
> > > +	switch (core->datatype) {
> > > +	case XCSI_DT_YUV4228B:
> > > +	case XCSI_DT_RGB444:
> > > +	case XCSI_DT_RGB555:
> > > +	case XCSI_DT_RGB565:
> > > +	case XCSI_DT_RGB666:
> > > +	case XCSI_DT_RGB888:
> > > +	case XCSI_DT_RAW6:
> > > +	case XCSI_DT_RAW7:
> > > +	case XCSI_DT_RAW8:
> > > +	case XCSI_DT_RAW10:
> > > +	case XCSI_DT_RAW12:
> > > +	case XCSI_DT_RAW14:
> > > +		break;
> > > +	case XCSI_DT_YUV42210B:
> > > +	case XCSI_DT_RAW16:
> > > +	case XCSI_DT_RAW20:
> > > +		if (!core->en_csi_v20) {
> > > +			ret = -EINVAL;
> > > +			dev_dbg(core->dev, "enable csi v2 for this pixel
> > format");
> > > +		}
> > > +		break;
> > > +	default:
> > > +		ret = -EINVAL;
> > > +	}
> > > +
> > > +	if (ret < 0) {
> > > +		dev_err(core->dev, "invalid csi-pxl-format property!\n");
> > > +		return ret;
> > > +	}
> > > +
> > > +	dev_dbg(core->dev, "pixel format set as 0x%x\n", core->datatype);
> > > +
> > > +	core->vfb = of_property_read_bool(node, "xlnx,vfb");
> > 
> > Can't this be a local variable as well?
> 
> True. I will update it in next version.
> 
> > 
> > > +	dev_dbg(core->dev, "Video Format Bridge property = %s\n",
> > > +		core->vfb ? "Present" : "Absent");
> > > +
> > > +	if (!core->vfb) {
> > > +		dev_err(core->dev, "failed as VFB is disabled!\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ports = of_get_child_by_name(node, "ports");
> > > +	if (!ports)
> > > +		ports = node;
> > > +
> > > +	nports = 0;
> > > +	for_each_child_of_node(ports, port) {
> > > +		const char *pattern = "mono";
> > > +		int len = strlen(pattern);
> > > +		struct device_node *endpoint;
> > > +		struct v4l2_fwnode_endpoint v4lendpoint;
> > > +		int ret;
> > > +
> > > +		if (!port->name || of_node_cmp(port->name, "port"))
> > > +			continue;
> > > +
> > > +		endpoint = of_get_next_child(port, NULL);
> > > +		if (!endpoint) {
> > > +			dev_err(core->dev, "No port at\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > > +		/*
> > > +		 * since first port is sink port and it contains
> > > +		 * all info about data-lanes and cfa-pattern,
> > > +		 * don't parse second port but only check if exists
> > > +		 */
> > > +		if (nports == XVIP_PAD_SOURCE) {
> > > +			dev_dbg(core->dev, "no need to parse source port");
> > > +			nports++;
> > > +			of_node_put(endpoint);
> > > +			continue;
> > > +		}
> > > +
> > > +		core->bayer = XCSI_BAYER_RGGB;
> > > +		ret = of_property_read_string(port, "xlnx,cfa-pattern",
> > > +					      &pattern);
> > > +		if (ret == 0) {
> > 
> > Nit. !ret.
> > 
> 
> Will update in next version.
> 
> 
> > > +			if (!strncmp("grbg", pattern, len)) {
> > > +				core->bayer = XCSI_BAYER_GRBG;
> > > +			} else if (!strncmp("bggr", pattern, len)) {
> > > +				core->bayer = XCSI_BAYER_BGGR;
> > > +			} else if (!strncmp("rggb", pattern, len)) {
> > > +				core->bayer = XCSI_BAYER_RGGB;
> > > +			} else if (!strncmp("gbrg", pattern, len)) {
> > > +				core->bayer = XCSI_BAYER_GBRG;
> > > +			} else {
> > > +				dev_err(core->dev, "incorrect cfa string\n");
> > > +				return -EINVAL;
> > > +			}
> > > +		} else if (ret != -EINVAL) {
> > 
> > What about for other errors?
> 
> There are only 3 types of errors. -EINVAL means that property doesn't exist.
> This is ok xlnx,cfa-pattern is not a required property.
> In case it exists, then the value read should be one of those strings mentioned above.
> Otherwise ret val either means that there was NULL string value for the property or 
> The string was not a proper null terminated string both of which mean a default value will be set on core->bayer.
> 
> > 
> > > +			dev_err(core->dev, "invalid cfa pattern!\n");
> > > +			return ret;
> > > +		}
> > > +		dev_dbg(core->dev, "bayer pattern = %d\n", core->bayer);
> > > +
> > > +		ret =
> > v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
> > > +						 &v4lendpoint);
> > > +		of_node_put(endpoint);
> > > +		if (ret)
> > > +			return ret;
> > > +
> > > +		dev_dbg(core->dev, "%s : port %d bus type = %d\n",
> > > +			__func__, nports, v4lendpoint.bus_type);
> > > +
> > > +		if (v4lendpoint.bus_type == V4L2_MBUS_CSI2_DPHY) {
> > > +			dev_dbg(core->dev, "%s : base.port = %d base.id =
> > %d\n",
> > > +				__func__, v4lendpoint.base.port,
> > > +				v4lendpoint.base.id);
> > > +
> > > +			dev_dbg(core->dev, "%s : mipi number lanes = %d\n",
> > > +				__func__,
> > > +				v4lendpoint.bus.mipi_csi2.num_data_lanes);
> > > +
> > > +			core->max_num_lanes =
> > > +				v4lendpoint.bus.mipi_csi2.num_data_lanes;
> > > +		} else {
> > > +			dev_dbg(core->dev, "%s : Not a CSI2 bus\n", __func__);
> > 
> > Not sure if this adds any info.
> 
> Not really required. I will convert this to a comment in next revision.
> 
> > 
> > > +		}
> > > +
> > > +		/* Count the number of ports. */
> > > +		nports++;
> > > +	}
> > > +
> > > +	dev_dbg(core->dev, "max lanes = %d", core->max_num_lanes);
> > > +
> > > +	if (nports != XCSI_MEDIA_PADS) {
> > > +		dev_err(core->dev, "invalid number of ports %u\n", nports);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	/* Register interrupt handler */
> > > +	core->irq = irq_of_parse_and_map(node, 0);
> > > +	ret = devm_request_irq(core->dev, core->irq, xcsi2rxss_irq_handler,
> > > +			       IRQF_SHARED, "xilinx-csi2rxss", xcsi2rxss);
> > > +	if (ret) {
> > > +		dev_err(core->dev, "Err = %d Interrupt handler reg failed!\n",
> > > +			ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int xcsi2rxss_probe(struct platform_device *pdev)
> > > +{
> > > +	struct v4l2_subdev *subdev;
> > > +	struct xcsi2rxss_state *xcsi2rxss;
> > > +	struct xcsi2rxss_core *core;
> > > +	struct resource *res;
> > > +	int ret, num_ctrls, i;
> > > +
> > > +	xcsi2rxss = devm_kzalloc(&pdev->dev, sizeof(*xcsi2rxss), GFP_KERNEL);
> > > +	if (!xcsi2rxss)
> > > +		return -ENOMEM;
> > > +
> > > +	core = &xcsi2rxss->core;
> > > +	core->dev = &pdev->dev;
> > > +
> > > +	mutex_init(&xcsi2rxss->lock);
> > > +
> > > +	ret = xcsi2rxss_parse_of(xcsi2rxss);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +	core->iomem = devm_ioremap_resource(core->dev, res);
> > > +	if (IS_ERR(core->iomem))
> > > +		return PTR_ERR(core->iomem);
> > > +
> > > +	ret = xcsi2rxss_clk_get(core);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	ret = xcsi2rxss_clk_enable(core);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	xcsi2rxss_reset(core);
> > > +
> > > +	core->events = (struct xcsi2rxss_event *)&xcsi2rxss_events;
> > > +
> > > +	if (core->en_vcx) {
> > > +		u32 alloc_size;
> > > +
> > > +		alloc_size = sizeof(struct xcsi2rxss_event) *
> > > +			     XCSI_VCX_NUM_EVENTS;
> > > +		core->vcx_events = devm_kzalloc(&pdev->dev, alloc_size,
> > > +						GFP_KERNEL);
> > > +		if (!core->vcx_events) {
> > > +			mutex_destroy(&xcsi2rxss->lock);
> > > +			ret = -ENOMEM;
> > > +			goto all_clk_err;
> > > +		}
> > > +
> > > +		for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++)
> > > +			core->vcx_events[i].mask = 1 << i;
> > > +	}
> > > +
> > > +	/* Initialize V4L2 subdevice and media entity */
> > > +	xcsi2rxss->pads[XVIP_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> > > +	xcsi2rxss->pads[XVIP_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> > > +
> > > +	/* Initialize the default format */
> > > +	xcsi2rxss_set_default_format(xcsi2rxss);
> > > +
> > > +	/* Initialize V4L2 subdevice and media entity */
> > > +	subdev = &xcsi2rxss->subdev;
> > > +	v4l2_subdev_init(subdev, &xcsi2rxss_ops);
> > > +	subdev->dev = &pdev->dev;
> > > +	subdev->internal_ops = &xcsi2rxss_internal_ops;
> > > +	strlcpy(subdev->name, dev_name(&pdev->dev), sizeof(subdev->name));
> > > +	subdev->flags |= V4L2_SUBDEV_FL_HAS_EVENTS |
> > V4L2_SUBDEV_FL_HAS_DEVNODE;
> > > +	subdev->entity.ops = &xcsi2rxss_media_ops;
> > > +	v4l2_set_subdevdata(subdev, xcsi2rxss);
> > > +
> > > +	ret = media_entity_pads_init(&subdev->entity, XCSI_MEDIA_PADS,
> > > +				     xcsi2rxss->pads);
> > > +	if (ret < 0)
> > > +		goto error;
> > > +
> > > +	/*
> > > +	 * In case the Enable Active Lanes config parameter is not set,
> > > +	 * dynamic lane reconfiguration is not allowed.
> > > +	 * So V4L2_CID_XILINX_MIPICSISS_ACT_LANES ctrl will not be
> > registered.
> > > +	 * Accordingly allocate the number of controls
> > > +	 */
> > > +	num_ctrls = ARRAY_SIZE(xcsi2rxss_ctrls);
> > > +
> > > +	if (!core->enable_active_lanes)
> > > +		num_ctrls--;
> > > +
> > > +	dev_dbg(core->dev, "# of ctrls = %d\n", num_ctrls);
> > > +
> > > +	v4l2_ctrl_handler_init(&xcsi2rxss->ctrl_handler, num_ctrls);
> > > +	for (i = 0; i < ARRAY_SIZE(xcsi2rxss_ctrls); i++) {
> > > +		struct v4l2_ctrl *ctrl;
> > > +
> > > +		if (xcsi2rxss_ctrls[i].id ==
> > > +			V4L2_CID_XILINX_MIPICSISS_ACT_LANES) {
> > > +			if (!core->enable_active_lanes) {
> > > +				/* Don't register control */
> > > +				dev_dbg(core->dev,
> > > +					"Skip active lane control\n");
> > > +				continue;
> > 
> > This active lane control is not even registered, so the control handler
> > doesn't even have to check this flag. But I guess it doesn't hurt to
> > keep the check in the handler, so I let you decide.
> > 
> 
> It wasn't there in the first patch version. But based on suggestion added this, I think it would be good to keep the check.
> 
> > > +			}
> > > +			xcsi2rxss_ctrls[i].max = core->max_num_lanes;
> > > +			xcsi2rxss_ctrls[i].def = core->max_num_lanes;
> > > +		}
> > > +
> > > +		dev_dbg(core->dev, "%d ctrl = 0x%x\n", i,
> > > +			xcsi2rxss_ctrls[i].id);
> > > +		ctrl = v4l2_ctrl_new_custom(&xcsi2rxss->ctrl_handler,
> > > +					    &xcsi2rxss_ctrls[i], NULL);
> > > +		if (!ctrl) {
> > > +			dev_err(core->dev, "Failed for %s ctrl\n",
> > > +				xcsi2rxss_ctrls[i].name);
> > > +			goto error;
> > > +		}
> > > +	}
> > > +
> > > +	dev_dbg(core->dev, "# v4l2 ctrls registered = %d\n", i - 1);
> > > +
> > > +	if (xcsi2rxss->ctrl_handler.error) {
> > > +		dev_err(core->dev, "failed to add controls\n");
> > > +		ret = xcsi2rxss->ctrl_handler.error;
> > > +		goto error;
> > > +	}
> > > +
> > > +	subdev->ctrl_handler = &xcsi2rxss->ctrl_handler;
> > > +	ret = v4l2_ctrl_handler_setup(&xcsi2rxss->ctrl_handler);
> > > +	if (ret < 0) {
> > > +		dev_err(core->dev, "failed to set controls\n");
> > > +		goto error;
> > > +	}
> > > +
> > > +	platform_set_drvdata(pdev, xcsi2rxss);
> > > +
> > > +	ret = v4l2_async_register_subdev(subdev);
> > > +	if (ret < 0) {
> > > +		dev_err(core->dev, "failed to register subdev\n");
> > > +		goto error;
> > > +	}
> > > +
> > > +	dev_info(core->dev, "Xilinx CSI2 Rx Subsystem device found!\n");
> > > +	return 0;
> > 
> > Just a nit. I'd add en empty line.
> 
> Ok. Will add empty line here.
> 
> > 
> > > +error:
> > > +	v4l2_ctrl_handler_free(&xcsi2rxss->ctrl_handler);
> > > +	media_entity_cleanup(&subdev->entity);
> > > +	mutex_destroy(&xcsi2rxss->lock);
> > > +all_clk_err:
> > > +	xcsi2rxss_clk_disable(core);
> > > +	return ret;
> > > +}
> > > +
> > > +static int xcsi2rxss_remove(struct platform_device *pdev)
> > > +{
> > > +	struct xcsi2rxss_state *xcsi2rxss = platform_get_drvdata(pdev);
> > > +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> > > +	struct v4l2_subdev *subdev = &xcsi2rxss->subdev;
> > > +
> > > +	v4l2_async_unregister_subdev(subdev);
> > > +	v4l2_ctrl_handler_free(&xcsi2rxss->ctrl_handler);
> > > +	media_entity_cleanup(&subdev->entity);
> > > +	mutex_destroy(&xcsi2rxss->lock);
> > > +	xcsi2rxss_clk_disable(core);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static struct platform_driver xcsi2rxss_driver = {
> > > +	.driver = {
> > > +		.name		= "xilinx-csi2rxss",
> > > +		.of_match_table	= xcsi2rxss_of_id_table,
> > > +	},
> > > +	.probe			= xcsi2rxss_probe,
> > > +	.remove			= xcsi2rxss_remove,
> > > +};
> > > +
> > > +module_platform_driver(xcsi2rxss_driver);
> > > +
> > > +MODULE_AUTHOR("Vishal Sagar <vsagar@xilinx.com>");
> > > +MODULE_DESCRIPTION("Xilinx MIPI CSI2 Rx Subsystem Driver");
> > > +MODULE_LICENSE("GPL v2");
> > > diff --git a/include/uapi/linux/xilinx-v4l2-controls.h
> > b/include/uapi/linux/xilinx-v4l2-controls.h
> > > index b6441fe..4ca3b44 100644
> > > --- a/include/uapi/linux/xilinx-v4l2-controls.h
> > > +++ b/include/uapi/linux/xilinx-v4l2-controls.h
> > > @@ -71,4 +71,18 @@
> > >  /* Noise level */
> > >  #define V4L2_CID_XILINX_TPG_NOISE_GAIN
> > 	(V4L2_CID_XILINX_TPG + 17)
> > >
> > > +/*
> > > + * Xilinx MIPI CSI2 Rx Subsystem
> > > + */
> > > +
> > > +/* Base ID */
> > > +#define V4L2_CID_XILINX_MIPICSISS		(V4L2_CID_USER_BASE +
> > 0xc080)
> > > +
> > > +/* Active Lanes */
> > > +#define V4L2_CID_XILINX_MIPICSISS_ACT_LANES
> > 	(V4L2_CID_XILINX_MIPICSISS + 1)
> > > +/* Frames received since streaming is set */
> > > +#define V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER
> > 	(V4L2_CID_XILINX_MIPICSISS + 2)
> > > +/* Reset all event counters */
> > > +#define V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS
> > (V4L2_CID_XILINX_MIPICSISS + 3)
> > > +
> > >  #endif /* __UAPI_XILINX_V4L2_CONTROLS_H__ */
> > > diff --git a/include/uapi/linux/xilinx-v4l2-events.h b/include/uapi/linux/xilinx-
> > v4l2-events.h
> > > new file mode 100644
> > > index 0000000..2fef0b5
> > > --- /dev/null
> > > +++ b/include/uapi/linux/xilinx-v4l2-events.h
> > > @@ -0,0 +1,28 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * Xilinx V4L2 Events
> > > + *
> > > + * Copyright (C) 2019 Xilinx, Inc.
> > > + *
> > > + * Contacts: Vishal Sagar <vishal.sagar@xilinx.com>
> > > + *
> > > + */
> > > +
> > > +#ifndef __UAPI_XILINX_V4L2_EVENTS_H__
> > > +#define __UAPI_XILINX_V4L2_EVENTS_H__
> > > +
> > > +#include <linux/videodev2.h>
> > > +
> > > +/*
> > > + * Events
> > > + *
> > > + * V4L2_EVENT_XLNXCSIRX_SPKT: Short packet received
> > > + * V4L2_EVENT_XLNXCSIRX_SPKT_OVF: Short packet FIFO overflow
> > > + * V4L2_EVENT_XLNXCSIRX_SLBF: Stream line buffer full
> > > + */
> > 
> > Would be better to comment inline. But up to you.
> 
> Ok. Will do it in next version
> 
> Regards
> Vishal Sagar
> 
> > 
> > Thanks,
> > -hyun
> > 
> > > +#define V4L2_EVENT_XLNXCSIRX_CLASS	(V4L2_EVENT_PRIVATE_START |
> > 0x100)
> > > +#define V4L2_EVENT_XLNXCSIRX_SPKT	(V4L2_EVENT_XLNXCSIRX_CLASS
> > | 0x1)
> > > +#define V4L2_EVENT_XLNXCSIRX_SPKT_OVF
> > 	(V4L2_EVENT_XLNXCSIRX_CLASS | 0x2)
> > > +#define V4L2_EVENT_XLNXCSIRX_SLBF	(V4L2_EVENT_XLNXCSIRX_CLASS
> > | 0x3)
> > > +
> > > +#endif /* __UAPI_XILINX_V4L2_EVENTS_H__ */
> > > --
> > > 2.7.4
> > >
> > >
> 
