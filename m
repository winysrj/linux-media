Return-Path: <SRS0=XDLN=QC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AFEC282C0
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 02:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 683462087E
	for <linux-media@archiver.kernel.org>; Sat, 26 Jan 2019 02:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="Jl6VRwSr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbfAZCPL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 21:15:11 -0500
Received: from mail-eopbgr780051.outbound.protection.outlook.com ([40.107.78.51]:12736
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725550AbfAZCPK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 21:15:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7Aw5WbG+qGCPhXhAF1bSWdJJqZAEkyoQobKlp4zLH4=;
 b=Jl6VRwSrfep18GHZZsb76NJ2lGGgXzmpbsSM5FKXwmNsRAinW2Rj9oq0FQ6BhvcZkEpOcae75OWHlXnLM0BZJSj3faqoC1Aq6m3kpRArzCNfWx8bpm8rQQzvX4y+/3FVHaISb1023Oxo60A9HvGII6Gd4VUcoEtTAfy9vkMs9Gk=
Received: from SN6PR02CA0010.namprd02.prod.outlook.com (2603:10b6:805:a2::23)
 by BL0PR02MB4322.namprd02.prod.outlook.com (2603:10b6:208:40::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.21; Sat, 26 Jan
 2019 02:15:02 +0000
Received: from CY1NAM02FT023.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by SN6PR02CA0010.outlook.office365.com
 (2603:10b6:805:a2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.16 via Frontend
 Transport; Sat, 26 Jan 2019 02:15:02 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT023.mail.protection.outlook.com (10.152.74.237) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1580.10
 via Frontend Transport; Sat, 26 Jan 2019 02:15:01 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gnDUq-00023t-Ln; Fri, 25 Jan 2019 18:15:00 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gnDUl-0003Do-HP; Fri, 25 Jan 2019 18:14:55 -0800
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x0Q2EpDi011509;
        Fri, 25 Jan 2019 18:14:52 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gnDUh-0003DS-Ro; Fri, 25 Jan 2019 18:14:51 -0800
Date:   Fri, 25 Jan 2019 18:14:46 -0800
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
Subject: Re: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Message-ID: <20190126021446.GA2412@smtp.xilinx.com>
References: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
 <1548438777-11203-2-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1548438777-11203-2-git-send-email-vishal.sagar@xilinx.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(396003)(136003)(346002)(39860400002)(2980300002)(51914003)(189003)(199004)(7416002)(186003)(63266004)(305945005)(336012)(50466002)(76176011)(23676004)(2486003)(316002)(33656002)(16586007)(57986006)(76506005)(14444005)(54906003)(106002)(58126008)(426003)(44832011)(478600001)(229853002)(2906002)(106466001)(4326008)(476003)(8936002)(446003)(1076003)(6246003)(26005)(81166006)(6666004)(126002)(356004)(36386004)(47776003)(9786002)(11346002)(81156014)(8676002)(77096007)(107886003)(6862004)(486006)(6636002)(18370500001)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB4322;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CY1NAM02FT023;1:Ng2PWweiQszg1WEs+RUb+OsMZBNICKpeEBJDJ983Vkvz7ugF6igOIZLq9LsJAYpzGWYjXStpFnKPeq38sFM3glGi/62dCe2WjK9J2MfbREvRJPf45JpzZpBNW2N3rkWc7KvODATZu8eSScsCBFJrCLPiOeRihZYVAVBEYfyFhak=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2eaa5bd-9c25-493d-a5cf-08d683341402
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BL0PR02MB4322;
X-Microsoft-Exchange-Diagnostics: 1;BL0PR02MB4322;3:VJaBlFYdDsSsgiqVAtBEljqi46oCTU9dThsb6bylaoEsrtF5sgztVLiQq3BMXgpT6qoOQVdmQexi3nAVe0ESAj8CcJqnC+nNkHBJYWUhYZK+5OztMTy9jrrIxfHcR4yLTCAmwypy+wbBmiQE6oRTHMMsc7hJpy00iccL5X17ujz+xO9iSX6UZlTMiVwOKb5egGRfxiAjeX9y8hnDdbMQ6t9Ll0EcPMr7q96/40/ubJMMaIls6jt9+I43kBFc7Wbk5eHHeW3vK6FbU4NuJ8BtEOY/ZLNQvXTXtxd10JZcbCRoEIUM5GpegjXGAuy+cwuP8mksZM/iq0ND/jtd67haw9AnuWd1bJvp6cDuZLw4xd3zgZKrX0n2HY5UagCIpP7X;25:y0ZzQx4iaCD7VGxIHg4e7WZ7mFX4Fe1aAJRhLsNN2pi+DjLCj7MevS0LV75To0TD1m1LUuhTxoVvP93PPnwyGHedRRddCT0AODWSN58LpwbGXdbhwOO7jR5y1hgkuO222eJ5dvtaIpt3myRDEevK3XuYMbsXkR0kAHYgYoHpTj4ta8HSYX+b0HzXx4yU0mJorbOacPA223Sics7joJfWGPXYlzk3/tjDBSFw2Mrcn0pk2upvXLxwQujvRHW2YipCXG/Nrgf3PvrXJNS+A8/2T5AA2xjoA/m6/3ylXLE+zuB+TZzgpFUbsNdUa2ykFXK51wfqjT9K6iqNsKsU4/I+Gg==
X-MS-TrafficTypeDiagnostic: BL0PR02MB4322:
X-Microsoft-Exchange-Diagnostics: 1;BL0PR02MB4322;31:iqIPC4l5upAHvQEP1kOjBEO2CSEoLq+mNE75qz3kNnnveFKbVoeOmeRt+Y7l6Ub3uDQNGzNQ47Lzq1gpyMPmzYgSONCaobQyLzomZoiJqwdOTLGCGmdZUhFp+FzkJGutXuSCMMzi26NrAsit8hkkvH3Re2O/KNJPllfRPTF7v8i646iZoEvyphZWMUqVBQWugaR/RTFcY1+wUOIYhV5baf3ZcpuDCGyU9mVBpUE6FjQ=;20:JPwC4VfgQbAGRanY/kmA+ReiJXGW5s4BkxkBc8oTlekd6sGVL5tkq7Z6rf1PDN5cQSHRxEvlCDlWUdjIbqqrB8LVTzOxxsXUmmk5SasRpI398Zu6PDvHvKGAFltEngYpaBthgPOtRIy+7n3xWJNb9TRm2sEli1XpQDn7j9vX4SxIEoL2aUjBbazKLxs19yHs7OCNAKvo58I0Tuc+D4Loa6uu6rg2aBwe7HjxNgEKvTTlsLk2BJP3lb/uVVBDRXi3XmesZR+1w1ry9tJmZZQXRplKCO34HeDYRj8Kzh1+aolAyBNxi79mDa+7P4iHeKrKX4EVXSdh8XK/Eu7lwgoQFvsCcOlUVu3JzWkUlHKSsgPawTVKJJ04uDnKXx3cd5kEWOogtmL0izr/7n3wOWFevcwORRw11+Z//PsqoAMhJZ1nuhA/q2zoI95YD5Q446Adwhj9JBMr8GlGb1RO5TjYDHlVbELhGu7+Hq2HEeM+A6iK/TaHyUR3NiuAouSQC7cN
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <BL0PR02MB43225953FDAD8AF0AF6FF676D6940@BL0PR02MB4322.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;BL0PR02MB4322;4:abSUgrkNTiOa9Rx2/HMZYdisZjrVKI3v4Ju11a/UNMRiPh560xE+ivUROKKDGVL4C/h4tYBYrPqf2paswI8Y678o4R4Fs57xD19JmAyQ475NrZr4pTSN3OIFY07lpn3OH4pA7In1cZG/GHiGpnkh64PxOOUrJLcM/gE4N5DuLN6LSaCiowW2emfwtc/FojuPfeu9up07+xcjkwR9jBlIfsFGfWl6YlAdWgvvrvYPUykXrrRWwql4sr2bUlFU7i8yIJ/xyug0KOYwKBSolal/BNG9iWewwCAxOhkdKHFa2KY=
X-Forefront-PRVS: 0929F1BAED
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCTDBQUjAyTUI0MzIyOzIzOmlrRTZWSjd4V2o2Vlg4VlJzR0JjN0xUaUQ4?=
 =?utf-8?B?MllNUUhEVzBiSUpLSjlNTjVhL05UYWhOSldCdWlEZ09sU1BmMzFCcmIva01B?=
 =?utf-8?B?STJBR2M0R0txU1JETTRYNW9EbEkwUHRDRXY3d0JsSjZPcitBMlBocDQvOWln?=
 =?utf-8?B?dzJnbU8vbUsvdlJoWjRPOExFMk9WWFVMdzQ5djRxS1RrSy9KdUJIT295NE5X?=
 =?utf-8?B?TUE3cU94Q2Nhd1A3N2pUVWFjb1AxY0hiV1M1WmFjTUtST3ZpcTFSMXZ6VHN6?=
 =?utf-8?B?WXdvcXpWd1VHWm9rMEErMEFFUTdEaWJHckNTWEo4NWdpL0JzMmNPUjJNQW1w?=
 =?utf-8?B?THdNUzdITkJsN2lzV0U4K3FlbFFuWjE5LzRBblB2VnpxVWd5TFBFanp6RVhC?=
 =?utf-8?B?STVGZWdIUUJOalZKKzFVQnowRHdMeDg0TVBHeDhGRnIxckFYZ21RbmxaMlFs?=
 =?utf-8?B?NnQ4OGhWRE5hSGZJaVFZUFRmV09UQzB5aGRLNGhMb05PeUUzcHJpdDJPeXpz?=
 =?utf-8?B?ZHpyWHBZKzRjbnFvc3ZNQ3E1TVk2VUlGRjZWVGhQbGZCcyttUlNNdFBvTlRJ?=
 =?utf-8?B?L3hvUktqVnMxTmRIR1hLbjZQT0tSajdVMVVPTXBhQmduL3B0VGdDMVdYVERB?=
 =?utf-8?B?T1F1MXVKSHMrcmpNTlh0UU1zT3lFa1c2WVdMMmc0eitVcHNyZW5TcFFlMnI0?=
 =?utf-8?B?bEk3bEJLZi96WVB1OWUwZ3BUU1NpclBiM21sODBvT2FOUEZNRllnU3Rhajg5?=
 =?utf-8?B?ZlhWeG5WaG1VcW1ZTUI5UVRtS1ZmR0k5aCtnUFJXNDJPWlg4QUpWdmllZlFK?=
 =?utf-8?B?cE4wUkI4aDZrWnQzOXlnM3MzajRxVmlDeUxmM0dEUnMrQm1iWHY5Qm42UnBp?=
 =?utf-8?B?SGlwazRiblIzWWdCejdJV1JVdkliUk05SURXaWxvLzRRK2szRkdoODVTYzRS?=
 =?utf-8?B?cTJMTEFoYnNESWh5T3dyTjZ4YWlkOEN4SDRUOUpScENEanQraWhpbVMwS0Zs?=
 =?utf-8?B?c1hvbmpqUG9JWW5UVmVvakFzQytTRjZJdDhyeUhtZmlpMzRxQzJlMnQ5d2dh?=
 =?utf-8?B?UktBZkxzTUdLVmhCN2xDOUhldkhyWWRnbXNDaFhTQ1NJdWFhTlZ1K1o2NzNV?=
 =?utf-8?B?U1FZM3ZzSVlLalB1YjJXSCtPdGpad2VFdW1aODI3bHhLbU55M1IwZ1NkY0p5?=
 =?utf-8?B?dlNlOE5mZGROV0VtQm5hUlFnakxFb3c1cGhmaXp4Ymg5bENtTFVGZVlTWFZN?=
 =?utf-8?B?aXB2RDNDSmYvQ0xrMnZ3S0JLRmVWMFZnS0RwMEMwOTc2WE5MRlJKdTBaSE9l?=
 =?utf-8?B?WFFDYnBtSDcxZEUvemZjVmozZGUraVVYRVpVRGFFOXBrUzI2emFlN0tsano3?=
 =?utf-8?B?MlF5Z2JFZFJ6eURyQ2p1czYxcjhpVGdDcTFYd1ZuemdqMEJTd2JpM3AwWkI4?=
 =?utf-8?B?WTJJUDh0V1lLYTRTRFpqVVBUWDJQK0xLNlVTQWRGbE1CcUpuK1kwMHVhS01w?=
 =?utf-8?B?OWFtOTM5d1p5bFV4TGo3UEhrYzJOUWFwSWdsL0xtajdOdkkwUkxhZXhHZTdG?=
 =?utf-8?B?c1VZc05tT2duZkdDVzhldDNlN0FSR2xaRFRVYVFSN0FVSno4d1pweVY3Vmhq?=
 =?utf-8?B?emVqd3k5eEtTaHFaVEdIZWdhdTRuOGNwT3FJeTNmdC9IbS9HUFUxaXhEVU5W?=
 =?utf-8?Q?hVwWNww9aMXTH9b7Bk=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FY54u6N7P93E04BW2kvJuSa2np2cCg9S1sKYNQ3gp91SV7246pPGwA2UFaXsnLpGqCzK5tgVS+C55yPS++1BbpuTLQcs+P5xGnCs6cF0zXFheAT0dhPxoOcnMZKCxPCYq67kq861mVw0F1BjyyZQmNlsQEEI2/jmelRj7aFC8eRGKp4yaINzTzqss9TfPmXY8ZTobTiZJQsJQpezuL6oaxZNi+3UoC8s4ezd1o2o3ukZfCbLc8aaNHoJQG5Wa/rhMg3NHdITsAWhZZPCds6xoxW0wysOQj8VH0pJWvUhM5XtSj37dmMgBeMZQ6V+N22etW7Tm6SR3FJSNiStpSd3SMvnCCsNMVodwb4nISRyBpwytOB9lkl9H5a+uj/axcJoro+Khxljse0RRHG44e+zE2wuO7YCNbrGm42KpQzRt7s=
X-Microsoft-Exchange-Diagnostics: 1;BL0PR02MB4322;6:fPpPmmsXAyOTYbV55xIbK2TW3gdddR1I9mxyiJubZulNiyMS49OfpWntbQJOgcK+JzTrF5qC843+ET/JUw6gd3tFyZomsPfb9sCUbpR4NK5r+7eFVhoaRVz6mYv279TRn4l3+zMBzcRwZWvpAPzwMDVXcFBy3ux1QUbCRQ+Kxlo6m3RI0EvOJPxfkJpd9ZzPo2XmZGPF4vAtNJGWaOXeg+rgIFKDj2kLD+GlKsgq9ZzbCmyJBd5DulFBqbUemOi1QC1SK5x8igmEoWMXh1+K/m8gG/s+uaqxbQi6J/RS0mxDafnJk0kyECuoD+v0uTBWWNC47hqswYa8wgSwWohMbRvM2YucqmDHsnHoO67Jv0V0R8u9VvyI/pyzOEPU01skyIwPtwjU9CFIW/kkCQOJvgn8HZdlWwD1URDZIO756yWdgUWd4Alne+BWx2UuHGfolQQUSOoBKNDcoQDXsbXU2Q==;5:ZASZnjpvhkOUH4d4xjx2NN+C0C1yuWWY+wKVZHl9wUT8cjCp3jFBsHQ6+GMI7akkSolig+yfFwB5hj6HeHAoSOpSmS5HsCBcdGlSK1qCosmxsl4Q23N4RFRr7liVoN5Z/6pheqCtjkAsyysknrnEf5p9wv3KqHHMfK25sALbVejWHbUcR1GD6RoeiyfFqD3sA8bQHK6ObD6EYWAdRkg6ww==;7:KPCpS7eT6wDxmufHDoCra9AFln90eqPfENUo7UJARIeI6PMLtzj97n+83otl+b8CoM2UQMROKAVuM/8AIrHP72px/zc2zJwHDSNvi+E1KpPKPU+MLSg7/Knu0qhLGXcMKEcjV/SaUuTY2VBJGhcijA==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2019 02:15:01.0824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2eaa5bd-9c25-493d-a5cf-08d683341402
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4322
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

Thanks for the patch.

On Fri, 2019-01-25 at 09:52:56 -0800, Vishal Sagar wrote:
> Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> 
> The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> ---
> v2
> - updated the compatible string to latest version supported
> - removed DPHY related parameters
> - added CSI v2.0 related property (including VCX for supporting upto 16
>   virtual channels).
> - modified csi-pxl-format from string to unsigned int type where the value
>   is as per the CSI specification
> - Defined port 0 and port 1 as sink and source ports.
> - Removed max-lanes property as suggested by Rob and Sakari
> 
>  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 105 +++++++++++++++++++++
>  1 file changed, 105 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> new file mode 100644
> index 0000000..98781cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> @@ -0,0 +1,105 @@
> +Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
> +--------------------------------------------------------
> +
> +The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traffic
> +from compliant camera sensors and send the output as AXI4 Stream video data
> +for image processing.
> +
> +The subsystem consists of a MIPI DPHY in slave mode which captures the
> +data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
> +packet data. The Video Format Bridge (VFB) converts this data to AXI4 Stream
> +video data.
> +
> +For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Subsystem.
> +
> +Required properties:
> +--------------------
> +- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
> +- reg: Physical base address and length of the registers set for the device.
> +- interrupt-parent: specifies the phandle to the parent interrupt controller
> +- interrupts: Property with a value describing the interrupt number.
> +- clocks: List of phandles to AXI Lite, Video and 200 MHz DPHY clocks.
> +- clock-names: Must contain "lite_aclk", "video_aclk" and "dphy_clk_200M" in
> +  the same order as clocks listed in clocks property.
> +- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw design.
> +  Packets other than this data type (except for RAW8 and User defined data
> +  types) will be filtered out. Possible values are as below -
> +  0x1E - YUV4228B
> +  0x1F - YUV42210B
> +  0x20 - RGB444
> +  0x21 - RGB555
> +  0x22 - RGB565
> +  0x23 - RGB666
> +  0x24 - RGB888
> +  0x28 - RAW6
> +  0x29 - RAW7
> +  0x2A - RAW8
> +  0x2B - RAW10
> +  0x2C - RAW12
> +  0x2D - RAW14
> +  0x2E - RAW16
> +  0x2F - RAW20
> +- xlnx,vfb: This is present when Video Format Bridge is enabled.

Isn't this optional as well?

> +
> +Optional properties:
> +--------------------
> +- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
> +- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
> +  only 4. This is present only if xlnx,en-csi-v2-0 is present.
> +- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
> +  Configuration Register.
> +- xlnx,cfa-pattern: This goes in the sink port to indicate bayer pattern.
> +  Valid values are "bggr", "rggb", "gbrg" and "grbg".
> +
> +Ports
> +-----
> +The device node shall contain two 'port' child nodes as defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +The port@0 is sink port and shall connect to CSI2 source like camera.
> +It must have the data-lanes property. It may have the xlnx,cfa-pattern
> +property to indicate bayer pattern of source.

These two properties better be spelled out properly. Maybe better to mention
the data-lanes is from video-interfaces.txt.

Thanks,
-hyun

> +
> +The port@1 is source port could be connected to any video processing IP
> +which can work with AXI4 Stream data.
> +
> +Both ports must have remote-endpoints.
> +
> +Example:
> +
> +	csiss_1: csiss@a0020000 {
> +		compatible = "xlnx,mipi-csi2-rx-subsystem-4.0";
> +		reg = <0x0 0xa0020000 0x0 0x10000>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 95 4>;
> +		xlnx,csi-pxl-format = <0x2a>;
> +		xlnx,vfb;
> +		xlnx,en-active-lanes;
> +		xlnx,en-csi-v2-0;
> +		xlnx,en-vcx;
> +		clock-names = "lite_aclk", "dphy_clk_200M", "video_aclk";
> +		clocks = <&misc_clk_0>, <&misc_clk_1>, <&misc_clk_2>;
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			port@0 {
> +				/* Sink port */
> +				reg = <0>;
> +				xlnx,cfa-pattern = "bggr"
> +				csiss_in: endpoint {
> +					data-lanes = <1 2 3 4>;
> +					/* MIPI CSI2 Camera handle */
> +					remote-endpoint = <&camera_out>;
> +				};
> +			};
> +			port@1 {
> +				/* Source port */
> +				reg = <1>;
> +				csiss_out: endpoint {
> +					remote-endpoint = <&vproc_in>;
> +				};
> +			};
> +		};
> +	};
> -- 
> 2.7.4
> 
