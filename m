Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C37C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 22:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9309720652
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 22:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="xq5m/HVn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfBZWUb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 17:20:31 -0500
Received: from mail-eopbgr790055.outbound.protection.outlook.com ([40.107.79.55]:18279
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728766AbfBZWUb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 17:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EQOo5Ds8KaqHxcUIoEU3RgGv2B4W2QBj23WnKxZbF4=;
 b=xq5m/HVnDPiDG/nyXAb5//iib719u0xCJBuymPEn2eO/oy4w0x+SqkOdaa2fE1k0t1yDBHR1TrF5aaVOjtLzxc4/4aw9HLJeKAYKLGgN/QCDKoGD8Glzu1X+9IqU6q7F51FEdIVyxXGyTGNFSihvzN6T09MmwTYgjzDVYoA14sg=
Received: from MN2PR02CA0025.namprd02.prod.outlook.com (2603:10b6:208:fc::38)
 by MWHPR02MB2271.namprd02.prod.outlook.com (2603:10b6:300:5b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1643.15; Tue, 26 Feb
 2019 22:20:23 +0000
Received: from BL2NAM02FT047.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::204) by MN2PR02CA0025.outlook.office365.com
 (2603:10b6:208:fc::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.21 via Frontend
 Transport; Tue, 26 Feb 2019 22:20:22 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; ffwll.ch; dkim=none (message not signed)
 header.d=none;ffwll.ch; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT047.mail.protection.outlook.com (10.152.77.9) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1643.11
 via Frontend Transport; Tue, 26 Feb 2019 22:20:22 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:48054 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gyl5J-0006YV-IX; Tue, 26 Feb 2019 14:20:21 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gyl5E-0006jk-D9; Tue, 26 Feb 2019 14:20:16 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gyl5B-0006h8-Ho; Tue, 26 Feb 2019 14:20:13 -0800
Date:   Tue, 26 Feb 2019 14:18:18 -0800
From:   Hyun Kwon <hyun.kwon@xilinx.com>
To:     Daniel Vetter <daniel@ffwll.ch>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hyun Kwon <hyunk@xilinx.com>,
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
Message-ID: <20190226221817.GB10631@smtp.xilinx.com>
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
 <20190226115311.GA4094@kroah.com>
 <CAKMK7uE=dSyo5vdjtQf=k1rdoegiBgSozCOotXLSW2VAkz2Ldw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAKMK7uE=dSyo5vdjtQf=k1rdoegiBgSozCOotXLSW2VAkz2Ldw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(396003)(376002)(39860400002)(136003)(2980300002)(51914003)(199004)(189003)(8936002)(6246003)(81166006)(6916009)(47776003)(36386004)(33656002)(63266004)(305945005)(106466001)(8676002)(81156014)(57986006)(23676004)(93886005)(229853002)(2486003)(4326008)(6306002)(76506005)(76176011)(478600001)(16586007)(58126008)(2906002)(966005)(53546011)(9786002)(316002)(106002)(54906003)(1076003)(5660300002)(50466002)(77096007)(476003)(11346002)(26005)(126002)(446003)(186003)(426003)(44832011)(486006)(336012)(14444005)(356004)(18370500001)(107986001)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR02MB2271;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61ec3dfb-4b9f-4575-92e6-08d69c389957
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:MWHPR02MB2271;
X-MS-TrafficTypeDiagnostic: MWHPR02MB2271:
X-MS-Exchange-PUrlCount: 3
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Exchange-Diagnostics: 1;MWHPR02MB2271;20:rHKThBfH3OxAAltQ9Lk/PtU+AUUMBk2rlhpb+lukeOi0kAVpocXF4M3kewh7T00H5qwumXUwqTue+IzfgpLLf5NzYc7a4toB3//YgVbpWG0aad9yZLM+KCkSCoWAyBKc7p5BHV+1xAbSL0O30vbOLKIW/68s4KIVFKAZIvUN1bLNuGLR+TAXWK0nL2t8ZXWONJ8Klt/kFntJHlg5nMnlogCHhOS6ouZLoqXwWrdV1QYL9yPQ3n8hI7QUilp2bC31cRD2JFliVExK/xpBDCaIfaxABgo+7oonQQ/kzMeu9RMBIIheErQEq7q5lBENchfZBFfURqy/uVaylC6aNQzN2Qk/GKTPyuK2GeXYgrcInHKiY/vHOm+jv5QHr2vKg/X3tVptQzraP2W/xKVsQybBpGhuokoPamtC7CQgTVXcsb3f3tnXfR2exH1MQcs9aS1pVd54FRrw2+bV/LNuVV0NFIo14UvonCBFUruCbysYDHVejyGTheyczwMrhXI/5y4g
X-Microsoft-Antispam-PRVS: <MWHPR02MB22718019FAABA4067AE1EC56D67B0@MWHPR02MB2271.namprd02.prod.outlook.com>
X-Forefront-PRVS: 096029FF66
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtNV0hQUjAyTUIyMjcxOzIzOmxwZVZHK1pFdFk1UWJpM0dxL3FxYXJvNTha?=
 =?utf-8?B?bWthaUlHZlBkL0JhbUIybzZjamVPUTRRbk5JZUc0NXlveDRxWkRNbzBIcVZn?=
 =?utf-8?B?Vnh5VDQ0UDBLSUpkZTdmZ21IMW9ESkZVQis1TVp5NUNBYW8xcEcxMGRlZDRR?=
 =?utf-8?B?aU9HMEV1SWdoSVlJOWg3MmM3OUtxMVV1Z2xObHRuNC9VNkUzVzNnTk1SOGs2?=
 =?utf-8?B?Q1I5VlpLWGxzTVpXUDJqa2VTcjB3d1JXRkQ1dnRwUmlhUyt5OTZiRzRac3JL?=
 =?utf-8?B?OEY0T01qb0p1NEVjL05NdFBSVEd1aVd5SjNoc1laaFRHREFpd2t0Rmkvdzdo?=
 =?utf-8?B?OGJwNlRUZU0ySGQ5OE9IdGF1MVlNbHhucFBsdmY4WlZBdlIwL2ZNYzFMOWJz?=
 =?utf-8?B?YnFpZHhqRzdRSGxkR0YzRm9FSDRCdE9KdmcrSWtNc2hxaTlldkRhZFdCLzIw?=
 =?utf-8?B?Qm9ha2s0dm8rdnZVd014VFdDT0F1QU5oeHJFd1kzdktZMzV5NGVpT25PaTd2?=
 =?utf-8?B?VjVxVHJIY0IvenUram8rQjhLSDJ6anppNnRIbXRUUXZMc1NQNVV2em9iRzFz?=
 =?utf-8?B?NWZKUWRhVkZ6bDlCUU91OVdDWWV0bDFZQlVReFpBSmVJTWdsT1ByM2JlR0ow?=
 =?utf-8?B?dHc4U3VZbkF6Y0ljcUh0M2NZTEVJbUwwN2lNNlRKeHZPZHh4SkFLRFJ1TmZS?=
 =?utf-8?B?SFBWdEhzdFF1UGt3aTdKdjEvUndzVDVGZ1dpdm80Mzdhb3QyV3hsYlRSbG9q?=
 =?utf-8?B?VUgrUXRkcmxRaVhMT0JRVXJueStwRXcybWpHS1ZRUEwxbkJYUmIxcFRTMEo4?=
 =?utf-8?B?YXU3VWMzTU55eVJuTGlVay9tMnAxaElpQTBLK3UwZU5aeUc1WHA4M0JZQzNh?=
 =?utf-8?B?SUN4anpvbUc1YXF4eFhXVEtwRllSczIzWk01bVdVTWphd04yZm1BZEJVT3hu?=
 =?utf-8?B?dUNTNXRTdE05bVdiT2NKOHZuSEFJNUtqckZBV2F5MHlmTEp2cXhDVDQxV09T?=
 =?utf-8?B?OVpTVUR1d05wY1cxOEdPZ1cvUUw1WnZWSUorTXlTMys5SzRDVlR0YTlzOUEr?=
 =?utf-8?B?T0EzbE5ycnNIc0JVeXF2Z0hHNFBTTnFrSGRIZnd6dVJEMHFMcDNzNjV1engz?=
 =?utf-8?B?T0o4OGJKbTNtQVpJZkEyUUF3UXJDS1FKYTNmZ3hRMjFUZmw5TkFVOXVSeXIw?=
 =?utf-8?B?QVV6bTF3VG1LSElhcTVrRExHYmI5TWM3MzFaVkZUR1ljTlI2cmY3SlVEbVJu?=
 =?utf-8?B?a1hyY0ZROVZxRXJhd2loSGlyRGxXaUJ3dDV4TEJzNkI0cVhoODJCMHZCM01L?=
 =?utf-8?B?TFFodzJRNmlXZlpzUW0zM2VzTUV5emxBeUdnUW1ORkRRb05jcWJPTHI0SmJj?=
 =?utf-8?B?bVlVWFAyNm9DZWxHTXQzWVlhVCszcm45alVGOU9GemdDU3VjUzR1djVnWHBk?=
 =?utf-8?B?ZjBMSURtQUdKQ0t2RjF4Q0svanliSjRtNTdNY3kxWkRxMTB1b0FZVWNyQ2l3?=
 =?utf-8?B?cWJHcm1wUmdybGc0QVNNRHNpU0ZYa29hOEFJTERkbzRmYThwZmtkLzJ5MThK?=
 =?utf-8?B?RXJWeW1lbFdOdE9LWmwwZUdoT3lpb3Z2dWIxM25mMHVwSzhWN2ljUHkwRjBD?=
 =?utf-8?B?U2ZWVmpHNHQ5L1ZRZkNnZTlTSXV1c0JZelB6WGpwQjliOFAyakFLWmw3SG05?=
 =?utf-8?B?Z1FIOCtFaXE0MXhVN0NhWkV6WDJLbzM2OFFrVEVwUXZ3VEhFSkZOSGZmT0lZ?=
 =?utf-8?Q?M4Lq1vBbUt/inCSfQ4YxAIDl3qQB5D9/Wqyqs=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: SFER5VlT2WkhKxmraX5TcVQsKUvXTk+h8lcm89/oV7S8Ka68gHA5Ljc5SbB5e5oYGhfSpB7U/85l1asRwdcIuOsK6+CQClNKREK5mtiRDSHNgEdt5h0uxa98RT/xJtFve6GPFPPby75wnaFRKPapv6j9coBBDrpPqvWFn0aQQKivMQtJm0x9d46GVISJ8wYn9/XUkfky5nIz+WSro1Z8NLzu8vawewsCutOyOwrCKYJMigUmpBLYFrEN7lMu8kYElIyXIIp/G001tbZx0iUp2iLs0pjXJr0YTEXlfoaBNrsH3EnJzNLDKzpolck477mnDfSmhcCbf7mDQzsUazrwkipluDMdfYTJ0JJBP0rhL5GAdIyOeXOOsqFEXEWZQJ1Qx3ZVDGDumNBXyq+NJf7MojQauvOA5hqtMPKxx1j9p7U=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2019 22:20:22.1436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ec3dfb-4b9f-4575-92e6-08d69c389957
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2271
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Daniel,

Thanks for the comment.

On Tue, 2019-02-26 at 04:06:13 -0800, Daniel Vetter wrote:
> On Tue, Feb 26, 2019 at 12:53 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> > > Add the dmabuf map / unmap interfaces. This allows the user driver
> > > to be able to import the external dmabuf and use it from user space.
> > >
> > > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > > ---
> > >  drivers/uio/Makefile         |   2 +-
> > >  drivers/uio/uio.c            |  43 +++++++++
> > >  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/uio/uio_dmabuf.h     |  26 ++++++
> > >  include/uapi/linux/uio/uio.h |  33 +++++++
> > >  5 files changed, 313 insertions(+), 1 deletion(-)
> > >  create mode 100644 drivers/uio/uio_dmabuf.c
> > >  create mode 100644 drivers/uio/uio_dmabuf.h
> > >  create mode 100644 include/uapi/linux/uio/uio.h
> > >
> > > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > > index c285dd2..5da16c7 100644
> > > --- a/drivers/uio/Makefile
> > > +++ b/drivers/uio/Makefile
> > > @@ -1,5 +1,5 @@
> > >  # SPDX-License-Identifier: GPL-2.0
> > > -obj-$(CONFIG_UIO)    += uio.o
> > > +obj-$(CONFIG_UIO)    += uio.o uio_dmabuf.o
> > >  obj-$(CONFIG_UIO_CIF)        += uio_cif.o
> > >  obj-$(CONFIG_UIO_PDRV_GENIRQ)        += uio_pdrv_genirq.o
> > >  obj-$(CONFIG_UIO_DMEM_GENIRQ)        += uio_dmem_genirq.o
> > > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > > index 1313422..6841f98 100644
> > > --- a/drivers/uio/uio.c
> > > +++ b/drivers/uio/uio.c
> > > @@ -24,6 +24,12 @@
> > >  #include <linux/kobject.h>
> > >  #include <linux/cdev.h>
> > >  #include <linux/uio_driver.h>
> > > +#include <linux/list.h>
> > > +#include <linux/mutex.h>
> > > +
> > > +#include <uapi/linux/uio/uio.h>
> > > +
> > > +#include "uio_dmabuf.h"
> > >
> > >  #define UIO_MAX_DEVICES              (1U << MINORBITS)
> > >
> > > @@ -454,6 +460,8 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
> > >  struct uio_listener {
> > >       struct uio_device *dev;
> > >       s32 event_count;
> > > +     struct list_head dbufs;
> > > +     struct mutex dbufs_lock; /* protect @dbufs */
> > >  };
> > >
> > >  static int uio_open(struct inode *inode, struct file *filep)
> > > @@ -500,6 +508,9 @@ static int uio_open(struct inode *inode, struct file *filep)
> > >       if (ret)
> > >               goto err_infoopen;
> > >
> > > +     INIT_LIST_HEAD(&listener->dbufs);
> > > +     mutex_init(&listener->dbufs_lock);
> > > +
> > >       return 0;
> > >
> > >  err_infoopen:
> > > @@ -529,6 +540,10 @@ static int uio_release(struct inode *inode, struct file *filep)
> > >       struct uio_listener *listener = filep->private_data;
> > >       struct uio_device *idev = listener->dev;
> > >
> > > +     ret = uio_dmabuf_cleanup(idev, &listener->dbufs, &listener->dbufs_lock);
> > > +     if (ret)
> > > +             dev_err(&idev->dev, "failed to clean up the dma bufs\n");
> > > +
> > >       mutex_lock(&idev->info_lock);
> > >       if (idev->info && idev->info->release)
> > >               ret = idev->info->release(idev->info, inode);
> > > @@ -652,6 +667,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
> > >       return retval ? retval : sizeof(s32);
> > >  }
> > >
> > > +static long uio_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> >
> > We have resisted adding a uio ioctl for a long time, can't you do this
> > through sysfs somehow?
> >
> > A meta-comment about your ioctl structure:
> >
> > > +#define UIO_DMABUF_DIR_BIDIR 1
> > > +#define UIO_DMABUF_DIR_TO_DEV        2
> > > +#define UIO_DMABUF_DIR_FROM_DEV      3
> > > +#define UIO_DMABUF_DIR_NONE  4
> >
> > enumerated type?
> >
> > > +
> > > +struct uio_dmabuf_args {
> > > +     __s32   dbuf_fd;
> > > +     __u64   dma_addr;
> > > +     __u64   size;
> > > +     __u32   dir;
> >
> > Why the odd alignment?  Are you sure this is the best packing for such a
> > structure?
> >
> > Why is dbuf_fd __s32?  dir can be __u8, right?
> >
> > I don't know that dma layer very well, it would be good to get some
> > review from others to see if this really is even a viable thing to do.
> > The fd handling seems a bit "odd" here, but maybe I just do not
> > understand it.
> 
> Frankly looks like a ploy to sidestep review by graphics folks. We'd
> ask for the userspace first :-)

Please refer to pull request [1].

For any interest in more details, the libmetal is the abstraction layer
which provides platform independent APIs. The backend implementation
can be selected per different platforms: ex, rtos, linux,
standalone (xilinx),,,. For Linux, it supports UIO / vfio as of now.
The actual user space drivers sit on top of libmetal. Such drivers can be
found in [2]. This is why I try to avoid any device specific code in
Linux kernel.

> 
> Also, exporting dma_addr to userspace is considered a very bad idea.

I agree, hence the RFC to pick some brains. :-) Would it make sense
if this call doesn't export the physicall address, but instead takes
only the dmabuf fd and register offsets to be programmed?

> If you want to do this properly, you need a minimal in-kernel memory
> manager, and those tend to be based on top of drm_gem.c and merged
> through the gpu tree. The last place where we accidentally leaked a
> dma addr for gpu buffers was in the fbdev code, and we plugged that
> one with

Could you please help me understand how having a in-kernel memory manager
helps? Isn't it just moving same dmabuf import / paddr export functionality
in different modules: kernel memory manager vs uio. In fact, Xilinx does have
such memory manager based on drm gem in downstream. But for this time we took
the approach of implementing this through generic dmabuf allocator, ION, and
enabling the import capability in the UIO infrastructure instead.

Thanks,
-hyun

[1] https://github.com/OpenAMP/libmetal/pull/82/commits/951e2762bd487c98919ad12f2aa81773d8fe7859
[2] https://github.com/Xilinx/embeddedsw/tree/master/XilinxProcessorIPLib/drivers

> 
> commit 4be9bd10e22dfc7fc101c5cf5969ef2d3a042d8a (tag:
> drm-misc-next-fixes-2018-10-03)
> Author: Neil Armstrong <narmstrong@baylibre.com>
> Date:   Fri Sep 28 14:05:55 2018 +0200
> 
>     drm/fb_helper: Allow leaking fbdev smem_start
> 
> Together with cuse the above patch should be enough to implement a drm
> driver entirely in userspace at least.
> 
> Cheers, Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
