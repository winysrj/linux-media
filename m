Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAB4C282C2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 17:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96031218A2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 17:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="nhGxyKKZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfAYRwv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 12:52:51 -0500
Received: from mail-eopbgr750052.outbound.protection.outlook.com ([40.107.75.52]:39232
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729200AbfAYRwu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 12:52:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xF0z/TSMT94Nn5jnSuOalyBVgGvlrmQ1NRD0c5CBUM=;
 b=nhGxyKKZyPMOdvC6L2rMWrl6AOSm/D+VYREQMMP56GS9KxBGKcbpJIBoWVwz1XdReoIXI+ES/j3MZR+S2EgV4ghU8d9X7mDzeGTBiAr2KQV5HFisHwyWANSRX4cQJi97Ddz0sg56PJ4VFupSQ7voOVsooFydzKj4GcnfA2xFLA0=
Received: from SN4PR0201CA0059.namprd02.prod.outlook.com
 (2603:10b6:803:20::21) by SN6PR02MB4463.namprd02.prod.outlook.com
 (2603:10b6:805:a8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.18; Fri, 25 Jan
 2019 17:52:47 +0000
Received: from BL2NAM02FT042.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by SN4PR0201CA0059.outlook.office365.com
 (2603:10b6:803:20::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1558.16 via Frontend
 Transport; Fri, 25 Jan 2019 17:52:47 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT042.mail.protection.outlook.com (10.152.76.193) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1558.11
 via Frontend Transport; Fri, 25 Jan 2019 17:52:46 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gn5eo-0006wV-Dc; Fri, 25 Jan 2019 09:52:46 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gn5ej-0005u0-A1; Fri, 25 Jan 2019 09:52:41 -0800
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x0PHqY5s030434;
        Fri, 25 Jan 2019 09:52:35 -0800
Received: from [172.23.29.77] (helo=xhdyacto-vnc1.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <vishal.sagar@xilinx.com>)
        id 1gn5ec-0005s2-FD; Fri, 25 Jan 2019 09:52:34 -0800
From:   Vishal Sagar <vishal.sagar@xilinx.com>
To:     <hyun.kwon@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <michal.simek@xilinx.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <sakari.ailus@linux.intel.com>,
        <hans.verkuil@cisco.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dineshk@xilinx.com>,
        <sandipk@xilinx.com>, Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH v2 0/2] Add support for Xilinx CSI2 Receiver Subsystem
Date:   Fri, 25 Jan 2019 23:22:55 +0530
Message-ID: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(346002)(39850400004)(136003)(376002)(2980300002)(199004)(189003)(476003)(2616005)(77096007)(126002)(63266004)(44832011)(16586007)(106466001)(51416003)(486006)(7696005)(50466002)(48376002)(6666004)(110136005)(106002)(54906003)(426003)(186003)(336012)(26005)(356004)(36756003)(8936002)(50226002)(14444005)(107886003)(4326008)(8676002)(81156014)(81166006)(305945005)(2906002)(478600001)(9786002)(86362001)(7416002)(316002)(36386004)(2201001)(47776003)(107986001)(921003)(83996005)(2101003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB4463;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;BL2NAM02FT042;1:Xk3eQhX4PGOy+SnVoHOe1qCVf2VBED6Y1gs4ekVJDUneyqIjhW/wD0Fx/zHLTrs2sfNM+XGekdGmHpk7+aN0ZL2TpO/xs/z9h/MybZ1s9nPXs/QPAIuMGHP+MGhs3A0+gT+KF4Uy64VUW2kMxEx2DBCq4l6gATYIBnGuJNBk72o=
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44765d6a-741b-4d45-3263-08d682edea77
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR02MB4463;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4463;3:kKlu5zSbb/8Hu3co15xnlJX2aKMStbPXkGq9XMzWKA3wRVuyqzvmAtgc9gbJstl0HVrVSzHli50zY9MYJle7tjyD0mYbeWItl1MhOQDpHOvyvlNsPmOi9n4bqMlO/SVsX5P8CV2bCmJXuYQH0/d9gfP/d/T91w0+1dpMYyaqA/vMJLfr8JHuFf6vVWHB7t7uwDQU3o2i3XqQ0rnZ59hkSzg5dOuWVzogPFlqhcdH3iKHAM7P9nj6T9hk6KF5y6KuqE9ABEBWBxKkQFDw4m4DIUbdKP2qBdCZrF8yoRcGUfgSuOlzHa1gK0gS7Rn7JSaGzxdLpOZsgMFLy9NVmR4M4cG9dAB2xl3i4fF3nGkTxgoyyHFZlOSLCCzrx/bx/h6I;25:MU/E5teBwMWwVTqyuCFugyhluvEa+tFA8wd9uDonQpkoYdDanWwq3sbadcdYZO57Y0jqbzYnX8xEozl8wYAKh04C3xnRl1FjXHS+hYnGza2F8Muz6uJpLHrMpdiaJ2WL4xd5q17U6DaPFoKnUx8wPoCxHxPoce4oh0Y9NtaUXyNYc1RmqH9Ce/NTdGIrsYqwU+pfzM8kfsfq4R25YDRbGuX7KteM0NoG+CI30RIS0PDtJ544ySQq4I+3rJLO1nIL7nc+AGcLRrlPm51EIpdx8M9oBhXJC9uHsikgWR7hhqKmP4bPeK3rJjhHuQD3bTlgViLjAuvhCVR6VGQAvf4kMA==
X-MS-TrafficTypeDiagnostic: SN6PR02MB4463:
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4463;31:QO3Bl7HmQdzlGAEDvHt0IDlbs90CmTickdJulmnJ6ML4BLu0TAd4DxW8FoQam0cUBCogFFmDmRGOzAT7dbcawxaCkEZK2O3+VIpbaL0mYw/JEootEZN903CKyNElJyHWGkQEJ4Fa1JFG0o0DlwIXVdydY10n25p9NfQONYjC01eL4LcdLQ/hxWeNcq3dzCeL174AT+ScnerZNTuYO+6qoPCaeT5oJ1cNbzxIxGbw3Mk=;20:LlS70fxSwn687TSHCgXuprQzi4SktrL3j+k/FgFZxtmcjEK6EwM+mkx3d6jIlIl6DZ52fSb57Gb7liuRZTpgwcAEf5GxFYD3w9ybtspq+mMTe5xCcN9fNtBE9jLTPWb/nfWG9lFkdX9nW4UNFHhg4eVagQVVpeu0Ok0GAl6DFqG5kx+9ZtFKevrfrHJ+MT9VhucE9x+4mUHsQ/jMZb7gH/tMaolWVz/X+H0FXD4dCGrrqoJ8O7uCNWGLWFKpK4MHK8Acw1eSSfnES2Vq6PHGXm1sSccFFNgrWUkQecDYtKNS6j201suZP4bfbZz/GPLDo536mQu9rCgqSKrNehkbXmavq/3OZ+e4sN2uQrvYKGRDWozR1eS7XDBsFU8DwdOGsdqK0753J/atPAqrreh8dQioG7FJqLOUmT6krRp3LygFiB7EbLwGK2r36rDSyOP+Ma2MtSNLkmj9PT7kzmHsaPmjwvR/7+jvN+YraZVrILIaXqhvH7FqW83mSI8dk+qh
X-Microsoft-Antispam-PRVS: <SN6PR02MB44635DFA76CA6CB232BFC881F69B0@SN6PR02MB4463.namprd02.prod.outlook.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4463;4:V8GSUtRUcxNZGUbNhxayN/IqU6ikg0dkXTK8xql8OSliRP1OQcDu3oOEcFEquYFI7M8LAWpfAP0/nwxMF1fXpn7MJRGQgrwr8qiiGaMcIqUlnuDH0KWH1tfpYO6XxTO47tHTdGVBilIh0ykpxAWA79L/SB/iGGZigYaYoVvYDlZsgkmGqDNGExYnnWo+gk1bHFa/DPlPKxBeD2UytQ4QWk+nCg0SA84BBuGrOm5jEQeb2EwoRnEiioMsVen3Lo5r2m3srUE4qJoR7NQxpYfUJrpglNtA/a7UIQLw6GRvEdfPN2INChdoMjWMvQfJxi9y
X-Forefront-PRVS: 0928072091
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR02MB4463;23:mHLQQmTZXJpqb7lzpzLwuWHEt70swiusAkgAW5UVX?=
 =?us-ascii?Q?PJs3USGd2JsfJZbkQ4t7G+iso5SP6IjWL8eUQIv/6SaWctvmG9ZOI60XIcQB?=
 =?us-ascii?Q?t3/sz2dmCBS76pp5rgHCJgKTK9mCplV5rErL+8qFABevCqLoK18glbX9LQNf?=
 =?us-ascii?Q?wnVKtfu5rvJ/cwekYoCU9gV70mxdFxKSs0F3OSgWwjuhWu1n6Q/JH+f5jLgG?=
 =?us-ascii?Q?nU+AN/Y5RsLU9e1FmTKyaUnnXkHO6LfKdBRW313yyXXRmA/DFfLFp0qMRsnQ?=
 =?us-ascii?Q?XaEcAyueRDcPqtwTCujfHlUa3WQwQvHB8GR3xQ1W9U7uwIKYR4BOmL9oSUUx?=
 =?us-ascii?Q?63NmKhxX1VpHcSBuR2kgFXO1wt6KgX4BUm+7z5034z/exg2O0pdpsFoj1uWD?=
 =?us-ascii?Q?XQ1oj4CZbApjejz0BG1WxRYbSPcVQPfSOx3yCkZFtzc/8Y4/XO9MKae/Yfke?=
 =?us-ascii?Q?I1ieBrIbou2OTdeT0o4lQDCg3y7YnAEf9r/SbD+8IfB+Pvub4PGqCKxLaOdj?=
 =?us-ascii?Q?fJecQPPSSG4PTstSIcGQ4qIiiWSZUIU2Y0POzImsRq8gMY6oas6Q+JX9uDNf?=
 =?us-ascii?Q?GHG/DQjCggXs+T+WNf0ZdYlfrrrXSGYzzVQRMh7lSchh8WejC1iVsbA6NRjk?=
 =?us-ascii?Q?VLStltE99HcjnpcJs4vHUxRzNGF5L6uLZDNeufKRmkkWGA2HIVHkYDBa8aSM?=
 =?us-ascii?Q?KCLNWYio5LLkLkdGQ9VnbPM3kbmQUh9PSxFwxKtbDDvbmSTxuvIe4DMtPsm/?=
 =?us-ascii?Q?nULVSNtTiazGcFoWt8LEAxea/26xYJVw4ANL6xAUGQj9lahycwOLH/zuq96F?=
 =?us-ascii?Q?hHCUuXeuV5FZKniCci4QjqoBcvm9Co53598VqJXza4N/qP/9LJ2uwRUHpAWE?=
 =?us-ascii?Q?0LWFkvPHENehLRMeMabrmxNG+reB+Arhcew72DmarwCx9AMA7RG4ckxd/gWV?=
 =?us-ascii?Q?QTDFjF9IRDzpRhBhs8FCdVVzptVdKKG7Ky3L3oqKA/9EM+lZI3maC9OnsiN1?=
 =?us-ascii?Q?nJvN5grMD8ty31wca71QWrn/9Yp8yyo+Pfbo2mflFjBmLWYdSxSKJmoB8xXV?=
 =?us-ascii?Q?7Oqfji7OxJZPHJeAH6l1akuoIMzSm1B1qHvTjuyGMlmjqkcXlupiUqOlPDew?=
 =?us-ascii?Q?uGL56v8LR+GD99fgFWUr9S4Hyi+hPIg0B0h7WnEhSkyPCfMYOE6hE5ipbPQ2?=
 =?us-ascii?Q?bK6NlSanCcm9uc=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 2fB2NHEzyBKi7K/lUBuNcFKb9DHbUfHhmK3WN6ttr9b+0usw88fbGOJIjB5j0irKJziGsO8QHUix1KohGPcaL034UX7P3AxF/dIs0maxgOYUv/dAaBWw6bglC8N8dMh0pEDn4vWlaFYSnWMLQnnP0/fXfdQ//E1BMANV/po5/bCIWhkQqpQS72HVvcV2jViDa6v34dvEAsWeYyu1XUTU5XI7FfY3CcnUbg4uhmr9OOzbZmJD8ipCuypxkk6OL0mfBh1sdCpaymL4OVLIzM5twW4GAh2/mzNEXkDy4pr9j+wHK/JfBAeaE6neoWLpfddoqkIiiH9R1uAqLOQIIFzN/rfC8jOkEzrSMRq3UERl4Y2JgdYUAz2ply/Z5FKLrcjRik6gBC0i7JXd3ZmMZVvUVdnNqWRSqyTGfN0emu+Qhno=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR02MB4463;6:2f7xYvkyKXjD4UYqNLxP2PCXkKeBR4BJMKmU07K9IEgFhIrfYjs1quH1t+uGqau4jTUS2ll24HfP7jj+rIJepd0JBjCtcbfBuwFOjv52/iWsO3Jl9NI9aA7wl6/TLQ2zvJkVmXQDU47Ucq6eXJI3Y3khY2YhG9+bzeRFoY3uRj3JHfvOqsVsDeEF7Xzupx9D2aQNupM3gC5rLyjMIDYHTBUNqbJtnrwSBilUqRYUXXb68rQogONg92Fre+4H8SZ63fIa6mML6bD7HDKnJ3joDc5Wrdm04yYEFQenFJnY3Bs6gyazTOtloSzEDkZFR7ju846fOR0CsG5W/8gEjrqbxo51n6O9CWXzqYTEj3Dq6fZVg4qxUVqPVUVBxhluUNJlHbjE3C40/IgEXEWkJ24f7Ams5vAX7u9qlUzrOxvyrLp46xba8uTMkhqQ60VYGSFVr9So0XwERBRXk4aMj0EfAg==;5:4JldqHIgy6A/GEmCw8/Vih2WJdtZrEhOkE6yqhrzbePHV1xvutLpkHgtzRcbFExLOL/hL0zzHbWY0pTD7BBcXNJLgbyAJh2UoEsny06xUW9nME1glBQXG9w57rWJ+WaxGwVgweisXcqrZrbEED8mHo6qBCBauY9WWbIpkgYxRgkVQYjBDuEB9a/Jtzf9KPbOKQvZ1C2rQ4Cn/40Wednakg==;7:jYGFxzJJVJKE7rnOWpobsjKLduzgWBFYOF9smVzggRr6tfZ8xFmG2WyAzH+GigxmEW+mgeeja8C2A8f3Ra6QOBy3LrNvUVdzAZcRgAfXjAzWCsybcC+F+dgU1/zmDv4CQI9p/f0Uwg55EhxzJaRjmA==
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2019 17:52:46.9700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44765d6a-741b-4d45-3263-08d682edea77
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4463
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

 .../bindings/media/xilinx/xlnx,csi2rxss.txt        |  105 ++
 drivers/media/platform/xilinx/Kconfig              |   10 +
 drivers/media/platform/xilinx/Makefile             |    1 +
 drivers/media/platform/xilinx/xilinx-csi2rxss.c    | 1609 ++++++++++++++++++++
 include/uapi/linux/xilinx-v4l2-controls.h          |   14 +
 include/uapi/linux/xilinx-v4l2-events.h            |   28 +
 6 files changed, 1767 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
 create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
 create mode 100644 include/uapi/linux/xilinx-v4l2-events.h

-- 
2.7.4

