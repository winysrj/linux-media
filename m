Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578CBC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 22:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EF7E218A2
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 22:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="PV2hawhx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfBZWSl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 17:18:41 -0500
Received: from mail-eopbgr710078.outbound.protection.outlook.com ([40.107.71.78]:22304
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728989AbfBZWSk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 17:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+yNuls6czdZcPULun1ednM3lhS7p4rXYXcfFu5j9/s=;
 b=PV2hawhxjYsXuszOr8kuQUoq9AU2b8EsDNcUlM7JJelrkLKBEbdwoypIIYs+7VBjS2kkq6dXnV+OptcBy6+Z9jWPwelIeNhYACJS5ipOD7NXAp+gvPK6BbLp+N5B835PPG5BubjFEHFqK5rpPv7+p5b4ZSQOzDMD74dcNLvyG7c=
Received: from BYAPR02CA0043.namprd02.prod.outlook.com (2603:10b6:a03:54::20)
 by BL0PR02MB4516.namprd02.prod.outlook.com (2603:10b6:208:4a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1643.15; Tue, 26 Feb
 2019 22:18:32 +0000
Received: from CY1NAM02FT049.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::201) by BYAPR02CA0043.outlook.office365.com
 (2603:10b6:a03:54::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1643.15 via Frontend
 Transport; Tue, 26 Feb 2019 22:18:32 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT049.mail.protection.outlook.com (10.152.75.83) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1643.11
 via Frontend Transport; Tue, 26 Feb 2019 22:18:31 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gyl3X-0004Np-5g; Tue, 26 Feb 2019 14:18:31 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gyl3S-0005vi-0n; Tue, 26 Feb 2019 14:18:26 -0800
Received: from xsj-pvapsmtp01 (smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x1QMINdL023256;
        Tue, 26 Feb 2019 14:18:24 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gyl3P-0005vI-Rm; Tue, 26 Feb 2019 14:18:23 -0800
Date:   Tue, 26 Feb 2019 14:16:28 -0800
From:   Hyun Kwon <hyun.kwon@xilinx.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Hyun Kwon <hyunk@xilinx.com>,
        Stefano Stabellini <stefanos@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 1/1] uio: Add dma-buf import ioctls
Message-ID: <20190226221627.GA10631@smtp.xilinx.com>
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
 <20190226115311.GA4094@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190226115311.GA4094@kroah.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(346002)(39860400002)(2980300002)(51914003)(189003)(199004)(106002)(9786002)(76506005)(2906002)(26005)(106466001)(63266004)(54906003)(33656002)(47776003)(4326008)(6246003)(77096007)(57986006)(6306002)(426003)(966005)(486006)(316002)(16586007)(44832011)(476003)(126002)(336012)(11346002)(446003)(478600001)(58126008)(186003)(81156014)(8936002)(81166006)(8676002)(305945005)(1076003)(36386004)(50466002)(6916009)(229853002)(14444005)(356004)(23676004)(2486003)(76176011)(5660300002)(18370500001)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB4516;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0362e5ec-1279-4648-e330-08d69c385781
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BL0PR02MB4516;
X-MS-TrafficTypeDiagnostic: BL0PR02MB4516:
X-MS-Exchange-PUrlCount: 1
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Exchange-Diagnostics: 1;BL0PR02MB4516;20:4kTMlCAfn28Vk3gk4MA35VUHdnCfEwJNhhrfPaARO2GdaW831q543nLSCBWwNVPM2sF5qCtsnQrl0KqenrXIU/MhvRO6b0WnF/Kd+V7D2oD9ji3ChasJgssBMyk+cRAm425Z0MZZsckXXceA2JeTfRW9bO6NVGMFOSMHoRkJDsnWxjLmej9+U+ZQTzMJSpsT2MHdCIRPhldbSUL6E8ONiXFpHsRRVSKFVRa39xZKYujVy88cgpuOrFpKI8ltblw5iIXoBPUf5DCMFDttW5w4B6bXiVjTeR31mMoe8xNTg7kEgGzQeEp90TF9aOM3/ZkjKvRL36FI11bytdSBFhwWDqPuFufX1QkS+Pn4Jvqg4WWFRGam48N/UajQ8xSwsaRtxbeC2OCDNHNNN56a5RW4IlUOFxisUHwrN3e5KB408lDmdw75P5R6fnyvzWfgExGuvcKXOe3MCL/5lthzabsAlFhz95LCK9zgHxQz5J+qgeFCUTurHrgKcLr/cWkrJnSj
X-Microsoft-Antispam-PRVS: <BL0PR02MB4516318C0F04545F94B5B2A2D67B0@BL0PR02MB4516.namprd02.prod.outlook.com>
X-Forefront-PRVS: 096029FF66
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCTDBQUjAyTUI0NTE2OzIzOjlwMGlEdmhVMHRvUUdXRHhVWGJHaWNETFVq?=
 =?utf-8?B?c1R5VXlZM1dNeFRWM3BOdG1FSXUvV0hpVjVVWWFGZm5sMGNjSVRZVmFqYkJV?=
 =?utf-8?B?YkpPSUczOUhHalFTMWVLVHJscUJ5MXhxWDNkU051cTBVNFVzdGtrbHYzUXpP?=
 =?utf-8?B?NnZlTGRQNzVSWUQybWNpWGtFRk5LeGhaTFQxMWF2c0c1KzFEaE8vSnZzSnFO?=
 =?utf-8?B?aDhqcXZHMXlMYXB4L1ZCTVlGcVJjZ1ZZaUpLaExSb2QrUVZuVzU5WWxoVXFr?=
 =?utf-8?B?RlJ6d1VoaVAzai9JR2JsbnZOblJqZnBrS0VsM284RTgzcExEakZBMmlhWVN6?=
 =?utf-8?B?Z2NwOEdsUGJUcXJoNE03dDg5MjVkdEZjQ1NUSUpnV3RmaDJhdXhWVWZsWmZa?=
 =?utf-8?B?TDFKYXJ2UVdkSkFFQUVzODZ1RlJpZmUxNWRXTFdNMXo0bkFNMWFiK21JMGhm?=
 =?utf-8?B?L0lzR0VTY3gwblY2bGQ3M3NpQ093OWttODI1T1lGRWt6WFNlRXB1Mkg1NDA5?=
 =?utf-8?B?RXVHQ2JicGJnNHBrVDRmUEl6SmlncCtwRWttOE1tSXdvUDBMbWZ6bmNrVXFx?=
 =?utf-8?B?QkxiU0tNMGFTM0xzOURsMjY2d3N6WlRwUjJEUVd3enFOT0VnbUh1elBzV0Rr?=
 =?utf-8?B?Ylkvc1E1Q1ByV2pmSXJUQnNvUXVhYmNWa1RPQWI3eGpoV2ZPbll0emh1eXRu?=
 =?utf-8?B?NUFyMk9hKy90VkVjZXFib1R5LzR2elhVSUdRekgzWUtueHVSZ1pZNHNqRGdO?=
 =?utf-8?B?YTJhY2hWT1R0dWlVbVNxNy9NZk1Bd0x2Z2N1V1lxL0crNFVXTVJYUnpBdnJz?=
 =?utf-8?B?bWFZcDhJSXhHWkY1MXdMVmttalhXUkJoMHBZQjdIbmIwK0lLMzR1ZTA2VW82?=
 =?utf-8?B?dWw4VVFUTjRsMVJwbjVYYUd6aU1lYjBUaHowTGN0VUlJY3V6d1pnTXhXUEhD?=
 =?utf-8?B?WS9JVHYrUkR6QngxR3ZzUTNkdlRrdEI0L0VBcnlzNjc5Vk81Tkdnd3ZXMTBh?=
 =?utf-8?B?MnRicFpuMjRXTHVmdmF5Ull3Y25pTlZjc2t1VE9sZXVudUhkbGJMdU9lM1B4?=
 =?utf-8?B?WjdBaWduclc1OGhhQ0RTaGxOdnlMMk1GY3hEK1Z6VXpQZUJ6NGV6S004bzRj?=
 =?utf-8?B?b3VaOWhaZ2c5WWJaR1dSUVFyUGdOMkZOMUkrUWlpcFJ4Q3lFcVZ0WHhEWWg4?=
 =?utf-8?B?V2J0QTdaNzE5Mm9CVFEvSUNqZjZicTdNY2lLY3ZpdXVYaXhGcDdCT3JBRTZ0?=
 =?utf-8?B?WmJhM0ViMkd5UU1xOWFKTUU0Z3pVUmRST1l6R0I2QndtVjNYMXM2SFlueUhN?=
 =?utf-8?B?aGdkclMza2VXb2hYUWlGTHZIRHJMbEdVWEY1endUdFdCWm5YbGtqWmxCK2RS?=
 =?utf-8?B?RmhTakt6TWZWOUNzM1FEOUxtUjRwZ0NjUGdtQkhzUG1pMlBTaDZrTkxlNk5Z?=
 =?utf-8?B?bUg0OXZsVWM0OTNtWjByUVJQVEZJNkNpVXdidFRSRHExdkd0QXZKMnMxTWNz?=
 =?utf-8?B?N05nd0ZIM0xHcEp4bTJFaGVHY0h1Yk5BSVY2dHZqc3NLZHN2aDJKb2cyMTl3?=
 =?utf-8?B?S3RDbG4xNUhzR0g4SUtmTllkN1NxMkh2aEQ2Qjc2M00zS1BFZEF0K3BDNlVF?=
 =?utf-8?B?UUFKN1B0VnQyYVVsZitRVlB4WVlUVXpCSndQck1sU0J1dmJyOG1RekFRPT0=?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: dAuJXIn7xhNGK1ZaP+0sK+Nvdq3v9KLLjOU2JwHZHdotCNIf1nar3sLRQBxFw/0MpK4bTIfaIhVsmRfclbscZnreMOI9qu1EMBuz5sGFbuZtY8IS50m45bKA/2w9apzdJNlbiZMO+eMPVVq2h6x5m1ZSfH9Qk9PaDnOYmamECsD+lxVaRo/BnCiqnKgIx7+hpM1umk6rMNFBDoZKJYN4JimqahUX7RDYE9ar9X0TUXbWzETsVbg6Rkm9vxbEiNG/DjWY46hnGcs6+V56we17/LrHYYfY/jfxp0JNE1Nte3MBHgJvMpVT5cxRXXa0+9ILLYuMlVdS0/yLYKD6i4ixmTZDnsE9qouH8frDtBkYeHtCBcjRfrc3ia+L3jKH9Ab5cHXFK5J6+SgSi82kb4V65YveQD3nrGsfpNyur2UZ5qU=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2019 22:18:31.5942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0362e5ec-1279-4648-e330-08d69c385781
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4516
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Greg,

Thanks for the comments.

On Tue, 2019-02-26 at 03:53:11 -0800, Greg Kroah-Hartman wrote:
> On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> > Add the dmabuf map / unmap interfaces. This allows the user driver
> > to be able to import the external dmabuf and use it from user space.
> > 
> > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > ---
> >  drivers/uio/Makefile         |   2 +-
> >  drivers/uio/uio.c            |  43 +++++++++
> >  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/uio/uio_dmabuf.h     |  26 ++++++
> >  include/uapi/linux/uio/uio.h |  33 +++++++
> >  5 files changed, 313 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/uio/uio_dmabuf.c
> >  create mode 100644 drivers/uio/uio_dmabuf.h
> >  create mode 100644 include/uapi/linux/uio/uio.h
> > 
> > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > index c285dd2..5da16c7 100644
> > --- a/drivers/uio/Makefile
> > +++ b/drivers/uio/Makefile
> > @@ -1,5 +1,5 @@
> >  # SPDX-License-Identifier: GPL-2.0
> > -obj-$(CONFIG_UIO)	+= uio.o
> > +obj-$(CONFIG_UIO)	+= uio.o uio_dmabuf.o
> >  obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
> >  obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
> >  obj-$(CONFIG_UIO_DMEM_GENIRQ)	+= uio_dmem_genirq.o
> > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > index 1313422..6841f98 100644
> > --- a/drivers/uio/uio.c
> > +++ b/drivers/uio/uio.c
> > @@ -24,6 +24,12 @@
> >  #include <linux/kobject.h>
> >  #include <linux/cdev.h>
> >  #include <linux/uio_driver.h>
> > +#include <linux/list.h>
> > +#include <linux/mutex.h>
> > +
> > +#include <uapi/linux/uio/uio.h>
> > +
> > +#include "uio_dmabuf.h"
> >  
> >  #define UIO_MAX_DEVICES		(1U << MINORBITS)
> >  
> > @@ -454,6 +460,8 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
> >  struct uio_listener {
> >  	struct uio_device *dev;
> >  	s32 event_count;
> > +	struct list_head dbufs;
> > +	struct mutex dbufs_lock; /* protect @dbufs */
> >  };
> >  
> >  static int uio_open(struct inode *inode, struct file *filep)
> > @@ -500,6 +508,9 @@ static int uio_open(struct inode *inode, struct file *filep)
> >  	if (ret)
> >  		goto err_infoopen;
> >  
> > +	INIT_LIST_HEAD(&listener->dbufs);
> > +	mutex_init(&listener->dbufs_lock);
> > +
> >  	return 0;
> >  
> >  err_infoopen:
> > @@ -529,6 +540,10 @@ static int uio_release(struct inode *inode, struct file *filep)
> >  	struct uio_listener *listener = filep->private_data;
> >  	struct uio_device *idev = listener->dev;
> >  
> > +	ret = uio_dmabuf_cleanup(idev, &listener->dbufs, &listener->dbufs_lock);
> > +	if (ret)
> > +		dev_err(&idev->dev, "failed to clean up the dma bufs\n");
> > +
> >  	mutex_lock(&idev->info_lock);
> >  	if (idev->info && idev->info->release)
> >  		ret = idev->info->release(idev->info, inode);
> > @@ -652,6 +667,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
> >  	return retval ? retval : sizeof(s32);
> >  }
> >  
> > +static long uio_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> 
> We have resisted adding a uio ioctl for a long time, can't you do this
> through sysfs somehow?
> 

The dmabuf is managed as per process resource, so it's hard to do it through
sysfs.

> A meta-comment about your ioctl structure:
> 
> > +#define UIO_DMABUF_DIR_BIDIR	1
> > +#define UIO_DMABUF_DIR_TO_DEV	2
> > +#define UIO_DMABUF_DIR_FROM_DEV	3
> > +#define UIO_DMABUF_DIR_NONE	4
> 
> enumerated type?
> 
> > +
> > +struct uio_dmabuf_args {
> > +	__s32	dbuf_fd;
> > +	__u64	dma_addr;
> > +	__u64	size;
> > +	__u32	dir;
> 
> Why the odd alignment?  Are you sure this is the best packing for such a
> structure?
> 
> Why is dbuf_fd __s32?  dir can be __u8, right?

The dmabuf fd is defined as int, so __s32 seems correct. Please let me know
otherwise. The dir can be __u8. Will fix if there is v2 at all.

> 
> I don't know that dma layer very well, it would be good to get some
> review from others to see if this really is even a viable thing to do.
> The fd handling seems a bit "odd" here, but maybe I just do not
> understand it.

Agreed. So I'm looking forward to feedback or if there's more sensible
alternative.

Thanks,
-hyun

> 
> thanks,
> 
> greg k-h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
