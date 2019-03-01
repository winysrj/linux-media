Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF89C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 00:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D7AE20851
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 00:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="rcDc3oKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbfCAAVU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 19:21:20 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:10947
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729880AbfCAAVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 19:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zn/jg9E33Ays6eZ+lfrVFH2j4k7oiQ0KhQUBa5t7pbY=;
 b=rcDc3oKNbrje0R8Ctf1WETxSiDwliGqwHLq7NeiuJQZLixvw58vi5TF3ludpxSkb7luuGg9QA8bCY2NajzHwxmRxFSTs6dpqS1uhYVUPxluff6VcpP9rgNlajBnvv1LkqohqjmqsKevH66OiRA/WxQoddgMTk26gsYX3FLndLkg=
Received: from DM6PR02CA0069.namprd02.prod.outlook.com (2603:10b6:5:177::46)
 by MWHPR02MB2272.namprd02.prod.outlook.com (2603:10b6:300:5b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.16; Fri, 1 Mar
 2019 00:21:11 +0000
Received: from BL2NAM02FT032.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::205) by DM6PR02CA0069.outlook.office365.com
 (2603:10b6:5:177::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.18 via Frontend
 Transport; Fri, 1 Mar 2019 00:21:10 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT032.mail.protection.outlook.com (10.152.77.169) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1643.11
 via Frontend Transport; Fri, 1 Mar 2019 00:21:10 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:40610 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gzVvJ-0004OM-Fx; Thu, 28 Feb 2019 16:21:09 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gzVvE-0004po-Bg; Thu, 28 Feb 2019 16:21:04 -0800
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x210L1O3009041;
        Thu, 28 Feb 2019 16:21:02 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gzVvB-0004od-R7; Thu, 28 Feb 2019 16:21:01 -0800
Date:   Thu, 28 Feb 2019 16:18:57 -0800
From:   Hyun Kwon <hyun.kwon@xilinx.com>
To:     Daniel Vetter <daniel@ffwll.ch>
CC:     Hyun Kwon <hyunk@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefano Stabellini <stefanos@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Michal Simek <michals@xilinx.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 1/1] uio: Add dma-buf import ioctls
Message-ID: <20190301001856.GA20971@smtp.xilinx.com>
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
 <20190226115311.GA4094@kroah.com>
 <CAKMK7uE=dSyo5vdjtQf=k1rdoegiBgSozCOotXLSW2VAkz2Ldw@mail.gmail.com>
 <20190226221817.GB10631@smtp.xilinx.com>
 <CAKMK7uFay0mjHFhQqmQ7fneS2B0xNW_Nv4AWqp-FK1NnHVe5uw@mail.gmail.com>
 <20190228003606.GA1063@smtp.xilinx.com>
 <20190228100146.GK2665@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190228100146.GK2665@phenom.ffwll.local>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(2980300002)(199004)(51914003)(189003)(33656002)(50466002)(2486003)(6916009)(6666004)(356004)(1076003)(76506005)(57986006)(6306002)(14444005)(63266004)(106466001)(52396003)(23676004)(106002)(4326008)(76176011)(587094005)(229853002)(6246003)(53386004)(53546011)(305945005)(8936002)(81166006)(8676002)(81156014)(126002)(44832011)(11346002)(446003)(476003)(486006)(426003)(9786002)(336012)(186003)(26005)(77096007)(54906003)(316002)(58126008)(16586007)(93886005)(478600001)(966005)(47776003)(2906002)(36386004)(5660300002)(18370500001)(107986001)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB2272;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5e099bc-162e-4be5-010d-08d69ddbce4b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:MWHPR02MB2272;
X-MS-TrafficTypeDiagnostic: MWHPR02MB2272:
X-MS-Exchange-PUrlCount: 6
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Exchange-Diagnostics: 1;MWHPR02MB2272;20:r98kEuR6Qe5VkGK5D1qx6ItqwXKBH2mqvpMI+lHUAZpG5f6LB2FxAXeijKboUeOVJzahUdvmzNa57cSFMOd5bdrz6pZSabIm/8vOcivSSIH0WLfq6FRZmFqBRrYRumrjmO1+lyq8+rWQESaUReSR+nsxz/kgD2uqil/nVyt8hl6TAKQvAp2WaTOs9mETi5aaA4vXhnRl6MTUk+3ihIs7Con3PDI/DaGsSoA22FEjebZQmZVNf4dAXfPLBaqr3UaLcfuiD7OpNErABV4cJbmngg91YHLtV/NCEIRweOl+soqks2M0JckTN3FmdMK8ahPVp9cdZpoqFt3SvGBQdECBE6WwYz3XttYVctdz+8RI8bxR4J6/RsyvntDNncSkyHvbvQwIUTNk+826wyaFo7VF5L+2m5kWRm5jOCCie9RE67Uzo16iHxCzl2BLmsByPGHHtWgl7/aawJO09iTbbkTpA+ISWRZQiXXropjTULpXDEsyaiuszFjnmRVQIEYTR6Ni
X-Microsoft-Antispam-PRVS: <MWHPR02MB22728F26F62DBC4F9110627DD6760@MWHPR02MB2272.namprd02.prod.outlook.com>
X-Forefront-PRVS: 09634B1196
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtNV0hQUjAyTUIyMjcyOzIzOjRBMGJkL0U0b1RUWHpIQWZDaXBmZFE1Vmty?=
 =?utf-8?B?a1FJdzFWNkhxdkVJbzZGQVZkRmFOZllDMWhBa2xGMUhGQ25NS1NVUmsySlJm?=
 =?utf-8?B?ZlZ5Szlnc3E5dTZXUUtrWkVmKzIyUTZJYkNBaGZ0T2JwenhiVERoS2Z3Yjhp?=
 =?utf-8?B?YzBrTXNsTlNjTWJBQjRaSEJMZEx5alhCa3U2K3pyaU5kdktkQm15bGwzekI1?=
 =?utf-8?B?Vlh5dzE0WEFCQkhwVHNEc2tVSlFBR2hmelhkaXBhc0R0dk8rOTRPb0lpOVly?=
 =?utf-8?B?QVc1NVpBNlQvcEkzNnhCUFAzSG9jeGRDMWpKSG5RRzR3eEV2eW01dS83bEs1?=
 =?utf-8?B?aFgzQTZZSVo5Z0pyUWV0cVhpNTUyTW80NjFQdENJckQyTDZVZmJFRVpBY2FN?=
 =?utf-8?B?MEhWdHJ4RUhKdXJ5eEgvNlh1L01pYjBqalE0L2pWa2NEY2JETnNrR0dza2pY?=
 =?utf-8?B?V1RKamlhZy84aEF2eUlkbWx0MHRFcVJ2Zlp2aTRlOXRBTmlXV2hBc3ZhMFcv?=
 =?utf-8?B?NForRDZoaitUU3hOdzcxV2dRLzhKWFAxNkJCSHI1My8wRmlOMzFXd3BRaCtr?=
 =?utf-8?B?cFR2WGI1M2xLbG9kVlBNbXZCNmE5QUVhUzVJbTd6MGJ6ajhHVGw4RS9vNXk1?=
 =?utf-8?B?Z0wrY3loeFN6c3liTmd6MEhxZFB4U0RkWGxRY05PNlFRV1BPc3pPcmIyRjR0?=
 =?utf-8?B?cmpPZ3BENW1NZ1BHZk1PdCtDZGNCN3FzZWF2cWloaFE4NUhkck00Njk4NXlN?=
 =?utf-8?B?OWhNNndjQWEzbmY0TElYQi9iSHFXTFRwY3FZWEltNGQ0K2VDQ2lLd2xncEhI?=
 =?utf-8?B?S0FtdEJ3QXhvRUc5TzVVckpWbzc0amczWWJWckV5KzE5aGZLSExyL2hTb1pt?=
 =?utf-8?B?dDBHRTF4MkNvMXZSTkROMUxTZWM0QkZKZXcvNmhXMTFZQzhGUy9wUmpZcFps?=
 =?utf-8?B?ZXpUMmVnaW16VFpJK3RVK3hOVWZOblVUUGFqTUcyUGdScEJCbjkwekc4dS93?=
 =?utf-8?B?aWNjMkJTeGZvaXlyTUJNa1JJZ2lOQ0VIZXpOd0pOcVBCK29zMEp6QU0yRU5T?=
 =?utf-8?B?M3pmbXpvZ0hlK1JZdjN5eitudUpjY2Vkd3NSdlJCbzdzNHhKVzcyV2s4eG94?=
 =?utf-8?B?dFd1K0lWWkYybnVpZ1I3MGduNGNwNmhrNUdDL0NVRnBCRS9xUk04L0hXYW93?=
 =?utf-8?B?aWhUSTUwY3kxbWh6dG5pNVJVZW1RMzVYNE5DOFBJK0ZTb0FpRkwyOE0yZWJo?=
 =?utf-8?B?YVdFN2E2RFdSc1Q4QUV3YlRrYlcweGo1VnZrd2RKQ0hxMVZ6WEFKWStXVTcr?=
 =?utf-8?B?RnNRMUZuQ2VqQnR6eXBOc1FmbU13TkZWVVdmZVgxRWFWZSsrUS90dGRRdHZS?=
 =?utf-8?B?REsvSFFGSFJmMUdyRUwyeHcybnlrOFROY3FRSUs0OHdUcUtQT2tIQlk2djU5?=
 =?utf-8?B?NU1ST1BENGlPL1FRUWZvOThrcHRSWG1XMzA1UmVDaWV0OTdSa0tTVlk2ck1S?=
 =?utf-8?B?d1hBQVp6VjhhQVJibDBuT3RsMHJ6dHU2LzlqS3E2V2RCazZvbExYdVZRKzhw?=
 =?utf-8?B?MUs3Q2tWZ0dvbjh0bC9JaEhyTU1aOVpMaDBMY1I1STNROGtibVNJdlo5YkpJ?=
 =?utf-8?B?R3g2RVpFVGVhQzA2cVlDeEQxWmxBTDRkMVBQbHJ3bWM0d1UwYUUwL3h3eUh0?=
 =?utf-8?B?YTBESUxXTW1DMVk1YzVhTm1GNzc2YkkrMDljc2h5WXlTUzZGYWVkem52RW4w?=
 =?utf-8?B?VGdVQXJmVE5vWjdObjM4ejRKKzRESmdHeEpjdEhzTkQ5aTNrYTA2c2dLM3l4?=
 =?utf-8?B?b2RIbWRIQ0RXN1ROeGxWd3VSVHFnVTZudU13QW02c29vb1BHazlqVkFlQUFK?=
 =?utf-8?Q?kqXldVoYAqSCCvXudpt16cmDJ40zaFsg?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ro6ymHdUx1hU7+3RB3TmmWLMe2Jl059bUcGgLZOm/ENBb2OL6R+AAqmbpRDZbG3fUtzjSaOXgcDcZAiQGSO6NqvCeOYwgVo5iVt3KaQkQKkUQB7h4t3q1fxUoZSDqYiT8AyN7jrjrnPfE6O4GOF7yyJ+HnhBXsk6Ql7f8Ou7Kodgf6qvPQ418VFTAx/5gc1jTfBAy+Z3yTZB9fgaQyZJ5kpaJNwXKDMkeR1xzKGZFeEKQ5ArTi2ZK1nuoz2rdlMEKVETSAqdXj8johOwzzcpM9/DfD+BZYYQAuQxpj60VjkALbNg5B2LKCiNDPF1QDvJMbsXjcAX7h8ktENhJBgdLcpf2V0UBq+sc1RIUnK6aX0cH9ZZicqGnsNT6K5JyxMooC9B3oOPGv/BoMw+NuMfSXvJKWlj9dhycWhXxjegEAU=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2019 00:21:10.1106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e099bc-162e-4be5-010d-08d69ddbce4b
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2272
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Daniel,

On Thu, 2019-02-28 at 02:01:46 -0800, Daniel Vetter wrote:
> On Wed, Feb 27, 2019 at 04:36:06PM -0800, Hyun Kwon wrote:
> > Hi Daniel,
> > 
> > On Wed, 2019-02-27 at 06:13:45 -0800, Daniel Vetter wrote:
> > > On Tue, Feb 26, 2019 at 11:20 PM Hyun Kwon <hyun.kwon@xilinx.com> wrote:
> > > >
> > > > Hi Daniel,
> > > >
> > > > Thanks for the comment.
> > > >
> > > > On Tue, 2019-02-26 at 04:06:13 -0800, Daniel Vetter wrote:
> > > > > On Tue, Feb 26, 2019 at 12:53 PM Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> > > > > > > Add the dmabuf map / unmap interfaces. This allows the user driver
> > > > > > > to be able to import the external dmabuf and use it from user space.
> > > > > > >
> > > > > > > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > > > > > > ---
> > > > > > >  drivers/uio/Makefile         |   2 +-
> > > > > > >  drivers/uio/uio.c            |  43 +++++++++
> > > > > > >  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
> > > > > > >  drivers/uio/uio_dmabuf.h     |  26 ++++++
> > > > > > >  include/uapi/linux/uio/uio.h |  33 +++++++
> > > > > > >  5 files changed, 313 insertions(+), 1 deletion(-)
> > > > > > >  create mode 100644 drivers/uio/uio_dmabuf.c
> > > > > > >  create mode 100644 drivers/uio/uio_dmabuf.h
> > > > > > >  create mode 100644 include/uapi/linux/uio/uio.h
> > > > > > >
> > > > > > > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > > > > > > index c285dd2..5da16c7 100644
> > > > > > > --- a/drivers/uio/Makefile
> > > > > > > +++ b/drivers/uio/Makefile
> > > > > > > @@ -1,5 +1,5 @@

[snip]

> > > > > Frankly looks like a ploy to sidestep review by graphics folks. We'd
> > > > > ask for the userspace first :-)
> > > >
> > > > Please refer to pull request [1].
> > > >
> > > > For any interest in more details, the libmetal is the abstraction layer
> > > > which provides platform independent APIs. The backend implementation
> > > > can be selected per different platforms: ex, rtos, linux,
> > > > standalone (xilinx),,,. For Linux, it supports UIO / vfio as of now.
> > > > The actual user space drivers sit on top of libmetal. Such drivers can be
> > > > found in [2]. This is why I try to avoid any device specific code in
> > > > Linux kernel.
> > > >
> > > > >
> > > > > Also, exporting dma_addr to userspace is considered a very bad idea.
> > > >
> > > > I agree, hence the RFC to pick some brains. :-) Would it make sense
> > > > if this call doesn't export the physicall address, but instead takes
> > > > only the dmabuf fd and register offsets to be programmed?
> > > >
> > > > > If you want to do this properly, you need a minimal in-kernel memory
> > > > > manager, and those tend to be based on top of drm_gem.c and merged
> > > > > through the gpu tree. The last place where we accidentally leaked a
> > > > > dma addr for gpu buffers was in the fbdev code, and we plugged that
> > > > > one with
> > > >
> > > > Could you please help me understand how having a in-kernel memory manager
> > > > helps? Isn't it just moving same dmabuf import / paddr export functionality
> > > > in different modules: kernel memory manager vs uio. In fact, Xilinx does have
> > > > such memory manager based on drm gem in downstream. But for this time we took
> > > > the approach of implementing this through generic dmabuf allocator, ION, and
> > > > enabling the import capability in the UIO infrastructure instead.
> > > 
> > > There's a group of people working on upstreaming a xilinx drm driver
> > > already. Which driver are we talking about? Can you pls provide a link
> > > to that xilinx drm driver?
> > > 
> > 
> > The one I was pushing [1] is implemented purely for display, and not
> > intended for anything other than that as of now. What I'm refering to above
> > is part of Xilinx FPGA (acceleration) runtime [2]. As far as I know,
> > it's planned to be upstreamed, but not yet started. The Xilinx runtime
> > software has its own in-kernel memory manager based on drm_cma_gem with
> > its own ioctls [3].
> > 
> > Thanks,
> > -hyun
> > 
> > [1] https://patchwork.kernel.org/patch/10513001/
> > [2] https://github.com/Xilinx/XRT
> > [3] https://github.com/Xilinx/XRT/tree/master/src/runtime_src/driver/zynq/drm
> 
> I've done a very quick look only, and yes this is kinda what I'd expect.
> Doing a small drm gem driver for an fpga/accelarator that needs lots of
> memories is the right architecture, since at the low level of kernel
> interfaces a gpu really isn't anything else than an accelarater.
> 
> And from a very cursory look the gem driver you mentioned (I only scrolled
> through the ioctl handler quickly) looks reasonable.

Thanks for taking time to look and share input. But still I'd like to
understand why it's more reasonable if the similar ioctl exists with drm
than with uio. Is it because such drm ioctl is vendor specific?

Thanks,
-hyun

> -Daniel
> > 
> > > Thanks, Daniel
> > > 
> > > > Thanks,
> > > > -hyun
> > > >
> > > > [1] https://github.com/OpenAMP/libmetal/pull/82/commits/951e2762bd487c98919ad12f2aa81773d8fe7859
> > > > [2] https://github.com/Xilinx/embeddedsw/tree/master/XilinxProcessorIPLib/drivers
> > > >
> > > > >
> > > > > commit 4be9bd10e22dfc7fc101c5cf5969ef2d3a042d8a (tag:
> > > > > drm-misc-next-fixes-2018-10-03)
> > > > > Author: Neil Armstrong <narmstrong@baylibre.com>
> > > > > Date:   Fri Sep 28 14:05:55 2018 +0200
> > > > >
> > > > >     drm/fb_helper: Allow leaking fbdev smem_start
> > > > >
> > > > > Together with cuse the above patch should be enough to implement a drm
> > > > > driver entirely in userspace at least.
> > > > >
> > > > > Cheers, Daniel
> > > > > --
> > > > > Daniel Vetter
> > > > > Software Engineer, Intel Corporation
> > > > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> > > 
> > > 
> > > 
> > > -- 
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
