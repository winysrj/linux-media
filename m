Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF802C43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 00:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B108214D8
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 00:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="y3cVawvT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbfB1Aih (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 19:38:37 -0500
Received: from mail-eopbgr690059.outbound.protection.outlook.com ([40.107.69.59]:55808
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730139AbfB1Aig (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 19:38:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bz/CJFWuOI734RlkTCuFV8QlB4FCU0cEhBdV79orLCM=;
 b=y3cVawvTB9WBPTyqyh8IDx7NbxaiYc3m1WM2MCpH9MwL74KOT9dSYiT5AaEvMWQm1LcmC2qUunQJXhMELyd6g8rtrv3yNPIb1TFvbUSZJu7UCuHjb60QXDcNqg7eciaeN6FzSkL8jYK++fGJcys4ZtE6HVBOpSUc0ekzNcRoatE=
Received: from SN4PR0201CA0046.namprd02.prod.outlook.com
 (2603:10b6:803:2e::32) by BN6PR02MB2258.namprd02.prod.outlook.com
 (2603:10b6:404:32::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1643.16; Thu, 28 Feb
 2019 00:38:19 +0000
Received: from SN1NAM02FT047.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by SN4PR0201CA0046.outlook.office365.com
 (2603:10b6:803:2e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.16 via Frontend
 Transport; Thu, 28 Feb 2019 00:38:19 +0000
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT047.mail.protection.outlook.com (10.152.72.201) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1643.11
 via Frontend Transport; Thu, 28 Feb 2019 00:38:18 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gz9iM-0002zU-7V; Wed, 27 Feb 2019 16:38:18 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gz9iH-0005dY-3H; Wed, 27 Feb 2019 16:38:13 -0800
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x1S0c6JL017519;
        Wed, 27 Feb 2019 16:38:07 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gz9iA-0005d0-PD; Wed, 27 Feb 2019 16:38:06 -0800
Date:   Wed, 27 Feb 2019 16:36:06 -0800
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
Message-ID: <20190228003606.GA1063@smtp.xilinx.com>
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
 <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
 <20190226115311.GA4094@kroah.com>
 <CAKMK7uE=dSyo5vdjtQf=k1rdoegiBgSozCOotXLSW2VAkz2Ldw@mail.gmail.com>
 <20190226221817.GB10631@smtp.xilinx.com>
 <CAKMK7uFay0mjHFhQqmQ7fneS2B0xNW_Nv4AWqp-FK1NnHVe5uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAKMK7uFay0mjHFhQqmQ7fneS2B0xNW_Nv4AWqp-FK1NnHVe5uw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(346002)(136003)(396003)(2980300002)(189003)(199004)(51914003)(54906003)(446003)(316002)(58126008)(50466002)(57986006)(5660300002)(63266004)(76506005)(9786002)(2906002)(106466001)(16586007)(106002)(4326008)(6246003)(8676002)(336012)(486006)(47776003)(305945005)(126002)(476003)(26005)(14444005)(426003)(44832011)(186003)(587094005)(77096007)(6346003)(36386004)(53546011)(478600001)(229853002)(11346002)(6916009)(1076003)(76176011)(8936002)(23676004)(2486003)(53386004)(81166006)(81156014)(33656002)(966005)(6306002)(356004)(93886005)(18370500001)(42866002)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2258;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61f4288e-9ed7-4313-18c7-08d69d1508fa
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BN6PR02MB2258;
X-MS-TrafficTypeDiagnostic: BN6PR02MB2258:
X-MS-Exchange-PUrlCount: 6
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Exchange-Diagnostics: 1;BN6PR02MB2258;20:ddzKs2vOhEevGPMb+/vz/i4mWfdAGp2a4drdnzGbqOn/NRNDJJA7CEtNIMMdT2Q7ZBb7bbl4RUPb+obIaLvqxnwa5HhVYRxZrhp/dYNuH+a1yHXgnrrlbRnl6HYDM1kOxLTlTYK5mChYfvpCu9jKcRhqrJ66PteGiYx89yod8d5AhJvQM6Zmc9j7xf6PqCoa6K+nq5fgMu1kbpChseWRQ+jiEnb9WGVCRrpMbB3JvmJG++a3dEPJWyON5zOH5F7/kvrXuYpxCjKD7C1lEQKC7SY6fSBcb4OToEm04WkoywVnrucVGuDFkgrirqgIfkSzl7aDihsSa1WWaZJi5NUdnTgC8EuOq563ZT7h8QEd+ISRJPD+q2UCcc5A+uoJpaXiY9eyNbSyJtTaei6gqnEJ5QcfqAiYUVmEOIsd6S+7R5p6GmZY2pduNKoQyEg4HbbDrE6FqUDlGpI3109UQC8Jf+gU8ltej0UmsjhMOU15acZvJm8Ue1b0LVoS/WGWKQsN
X-Microsoft-Antispam-PRVS: <BN6PR02MB2258336391EAE0C2D6B7C332D6750@BN6PR02MB2258.namprd02.prod.outlook.com>
X-Forefront-PRVS: 0962D394D2
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCTjZQUjAyTUIyMjU4OzIzOjVFU3hwR28rZmtqYUFhenRKR0pDOWFONkQv?=
 =?utf-8?B?ODZ0bXVrVDhPT0VXcDdFWFZWbWpXZWdqZWp3MHp1RDRLSWNTazBaVDg2U1Ir?=
 =?utf-8?B?TVlkV0JHREZKYzJVTEtUZFFTQ0hQM3FDQmdZMFF3TElxNitqdFNtbDQ3Z1BW?=
 =?utf-8?B?M0Q1OC80TWdvM3BuY2ZQMC9PVnRVK25kQ0Y4QTZtTWFuc09USzdPQXlmc1Ey?=
 =?utf-8?B?Q2R6WmZBWHB4KzhrODQvbmpVYnZUNFUwckdyZjhyb2tSNDVQeUdTMnoyTldR?=
 =?utf-8?B?c0x4ODdGMWNCMEhFU2VmaHhSUTluVzdrUlpoOWNqbHhGbnlLRGV0c3d2b09P?=
 =?utf-8?B?UXVNVUVBY3lrT1phb0hQQ1ZFZG56L2t3SG1TQ3BRdEk5Z0cvcW1iV2wwQUQ3?=
 =?utf-8?B?YWhpVTZkQ1JCUnFCVno3MlJKQ3BmaGRPdVpOeG52SVZIUmkyTU91aEM5NnNI?=
 =?utf-8?B?cXN6dG5XdnRDNWNrTWoycmdjRE50ZUZaVk14RDdGUGpPSlpFMDJWK1JqclpH?=
 =?utf-8?B?bGhLb1o0eHdxT0NWbncxNmxXb1hlZ3dKbFlSbUVUbUIweGY2VVBUZ243YkIw?=
 =?utf-8?B?dnZEOVFva051OUxvQ0QrVmtxYlpTakI3UzI4WG9yZUFwb2V4aHl0U3REanVW?=
 =?utf-8?B?QzlUdTdYaDBEUW9TNVBzc3pNcWx3WVh2cUxzNy9yYVc1dHh4dGQva1BVQ1pz?=
 =?utf-8?B?L3FmNFBBNUlUY0NmRnpCRGRWM3ZzTUFOcWFMK3JVRmdZVUNhbnlTSVpwbnp6?=
 =?utf-8?B?Y0xtWlJ0MXUyMTkyeVRDNDNKaVQ4ck5xcm5Wd1BoOVFxb2VXa2NRTHZCOWNv?=
 =?utf-8?B?d0VRQlYyM3R1dXYyNG5nand4RjVFRFFMa0NCblFVT2JpRzVqbndhY1MyZWxt?=
 =?utf-8?B?NFNxd29lWWpKdmJJRHJvazZuTXo5L3dKYUliUWlHZ0Zhd2V6cGM1MkNIN2F5?=
 =?utf-8?B?WGtIZTAyTDhSZnpOQjNlbkMwRmRoVjZ1aUY5NzN4SnZOdk1GSEF1aTBtVktF?=
 =?utf-8?B?VG81NnJiWERIU2JwdGNLYlpDVlRGM1l2a0o2SW5nNEw5VHFVbFZ0QzhsT1A2?=
 =?utf-8?B?WjRXY1JqLzZnbkxQaEZrYjNOM0JPaEJTS1lsMi9qV1BqZ3BIWUg1RHQyMmhI?=
 =?utf-8?B?MEdmNzhid0E2cFU2QlMyY3VXKzdOWGNYYXFqRldBOFRIOUNNay9Na2ZFMmlj?=
 =?utf-8?B?d01ubStiZjNvM3kzRFZhbGpYdUdDdkVPMHRhaDIvOWhFS0lDcDQrNnB4a3FC?=
 =?utf-8?B?MG9UV0QvclVtU294TWQ0UVpCSnczNkt6YUdMWW1wUzR4UEkzRFJ1VDBjZnd2?=
 =?utf-8?B?RnBYZkl3bWhyTDBwcFdncW0yNlVHTzJxVUFxQW9IQk5nM1d2YmlRSWlsNHh5?=
 =?utf-8?B?Q1BHZWJVY1I3NE9ocEhFaEhIc2d2TVdtY0hyQUJZRXQzVGpENFJMYllaMzNp?=
 =?utf-8?B?cGJ1bG9USXhzWUhUc1hVanZUOFIxWUk1Z2NsKzdXTUFtVVpITzBCTU93ZE5B?=
 =?utf-8?B?V0MyTjcyVFhKbG9ERlgyajhmWjhXdDg0Z3VzbkxJS0pGVHB4KzR3VUFuZEMw?=
 =?utf-8?B?ampoZkJLRERPSWNCSWdNZG5ZbGZkNzhMa1MyVkttOUxFYUo4dyt4Y0tRRnFy?=
 =?utf-8?B?Vytod1VhRGFHaUllTFhjbFJqaXJFNnB1MWNKM1oyU2t5eER3Sm9xQXhrV2xi?=
 =?utf-8?B?RVZWbWx4ZGpocG1BUjQvOFFlRlpZNExxb1hoMmwxcW9ERUxudmJ0elhjaENE?=
 =?utf-8?B?MjhNMjk5U0tJK2lxdDNTdGU4bEIwN0N0a1RlMEd6WjhlVWpxMUhpUEl0M3BI?=
 =?utf-8?B?ZW4rVkNTeVkvV3Y1VWJEZnRDYlU0UkJvaGFFU0d0dGNjQmc9PQ==?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: uAygwNZRa8FUSWR7zA7RwHkN9mFPum6QkHrP29r6khSJByPHam7D/nVroTmkKQP6kdrAIedOUTTmVtRg+etDJNOQXhlCS5IgwFK2l+pzdv6whrgnO1P35Qtj1pzkS9sY8f8Wg1CrwZv9Fl8AgpTQAD1lg5lO4DwsglI2Sv7wxYkw9/Fe3tsHiQkO0SWMdOp1J+8Ej8lE1TAnSd8km4Iuuas3ag7vtbjGsGNnGYg38SJy22JDyfSJlCj9jICmWy84CS9Z3j/d+Mr2baybJ/v4sWOMoewrxVu60nKH4Qwx66iwLcwBIRcUnuWLOIbc9pSksucqMkitysh+yNPybKjgE7567UM3lnk5Wi1Rb9sH4Qt3/LEaPWqj3gjefEYW8ppd6HUJ1ZQdl9SOCkGDgocPQaObGdNHopGTzcUzAPLe42I=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2019 00:38:18.6332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61f4288e-9ed7-4313-18c7-08d69d1508fa
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2258
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Daniel,

On Wed, 2019-02-27 at 06:13:45 -0800, Daniel Vetter wrote:
> On Tue, Feb 26, 2019 at 11:20 PM Hyun Kwon <hyun.kwon@xilinx.com> wrote:
> >
> > Hi Daniel,
> >
> > Thanks for the comment.
> >
> > On Tue, 2019-02-26 at 04:06:13 -0800, Daniel Vetter wrote:
> > > On Tue, Feb 26, 2019 at 12:53 PM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Sat, Feb 23, 2019 at 12:28:17PM -0800, Hyun Kwon wrote:
> > > > > Add the dmabuf map / unmap interfaces. This allows the user driver
> > > > > to be able to import the external dmabuf and use it from user space.
> > > > >
> > > > > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > > > > ---
> > > > >  drivers/uio/Makefile         |   2 +-
> > > > >  drivers/uio/uio.c            |  43 +++++++++
> > > > >  drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
> > > > >  drivers/uio/uio_dmabuf.h     |  26 ++++++
> > > > >  include/uapi/linux/uio/uio.h |  33 +++++++
> > > > >  5 files changed, 313 insertions(+), 1 deletion(-)
> > > > >  create mode 100644 drivers/uio/uio_dmabuf.c
> > > > >  create mode 100644 drivers/uio/uio_dmabuf.h
> > > > >  create mode 100644 include/uapi/linux/uio/uio.h
> > > > >
> > > > > diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> > > > > index c285dd2..5da16c7 100644
> > > > > --- a/drivers/uio/Makefile
> > > > > +++ b/drivers/uio/Makefile
> > > > > @@ -1,5 +1,5 @@
> > > > >  # SPDX-License-Identifier: GPL-2.0
> > > > > -obj-$(CONFIG_UIO)    += uio.o
> > > > > +obj-$(CONFIG_UIO)    += uio.o uio_dmabuf.o
> > > > >  obj-$(CONFIG_UIO_CIF)        += uio_cif.o
> > > > >  obj-$(CONFIG_UIO_PDRV_GENIRQ)        += uio_pdrv_genirq.o
> > > > >  obj-$(CONFIG_UIO_DMEM_GENIRQ)        += uio_dmem_genirq.o
> > > > > diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> > > > > index 1313422..6841f98 100644
> > > > > --- a/drivers/uio/uio.c
> > > > > +++ b/drivers/uio/uio.c
> > > > > @@ -24,6 +24,12 @@
> > > > >  #include <linux/kobject.h>
> > > > >  #include <linux/cdev.h>
> > > > >  #include <linux/uio_driver.h>
> > > > > +#include <linux/list.h>
> > > > > +#include <linux/mutex.h>
> > > > > +
> > > > > +#include <uapi/linux/uio/uio.h>
> > > > > +
> > > > > +#include "uio_dmabuf.h"
> > > > >
> > > > >  #define UIO_MAX_DEVICES              (1U << MINORBITS)
> > > > >
> > > > > @@ -454,6 +460,8 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
> > > > >  struct uio_listener {
> > > > >       struct uio_device *dev;
> > > > >       s32 event_count;
> > > > > +     struct list_head dbufs;
> > > > > +     struct mutex dbufs_lock; /* protect @dbufs */
> > > > >  };
> > > > >
> > > > >  static int uio_open(struct inode *inode, struct file *filep)
> > > > > @@ -500,6 +508,9 @@ static int uio_open(struct inode *inode, struct file *filep)
> > > > >       if (ret)
> > > > >               goto err_infoopen;
> > > > >
> > > > > +     INIT_LIST_HEAD(&listener->dbufs);
> > > > > +     mutex_init(&listener->dbufs_lock);
> > > > > +
> > > > >       return 0;
> > > > >
> > > > >  err_infoopen:
> > > > > @@ -529,6 +540,10 @@ static int uio_release(struct inode *inode, struct file *filep)
> > > > >       struct uio_listener *listener = filep->private_data;
> > > > >       struct uio_device *idev = listener->dev;
> > > > >
> > > > > +     ret = uio_dmabuf_cleanup(idev, &listener->dbufs, &listener->dbufs_lock);
> > > > > +     if (ret)
> > > > > +             dev_err(&idev->dev, "failed to clean up the dma bufs\n");
> > > > > +
> > > > >       mutex_lock(&idev->info_lock);
> > > > >       if (idev->info && idev->info->release)
> > > > >               ret = idev->info->release(idev->info, inode);
> > > > > @@ -652,6 +667,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
> > > > >       return retval ? retval : sizeof(s32);
> > > > >  }
> > > > >
> > > > > +static long uio_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> > > >
> > > > We have resisted adding a uio ioctl for a long time, can't you do this
> > > > through sysfs somehow?
> > > >
> > > > A meta-comment about your ioctl structure:
> > > >
> > > > > +#define UIO_DMABUF_DIR_BIDIR 1
> > > > > +#define UIO_DMABUF_DIR_TO_DEV        2
> > > > > +#define UIO_DMABUF_DIR_FROM_DEV      3
> > > > > +#define UIO_DMABUF_DIR_NONE  4
> > > >
> > > > enumerated type?
> > > >
> > > > > +
> > > > > +struct uio_dmabuf_args {
> > > > > +     __s32   dbuf_fd;
> > > > > +     __u64   dma_addr;
> > > > > +     __u64   size;
> > > > > +     __u32   dir;
> > > >
> > > > Why the odd alignment?  Are you sure this is the best packing for such a
> > > > structure?
> > > >
> > > > Why is dbuf_fd __s32?  dir can be __u8, right?
> > > >
> > > > I don't know that dma layer very well, it would be good to get some
> > > > review from others to see if this really is even a viable thing to do.
> > > > The fd handling seems a bit "odd" here, but maybe I just do not
> > > > understand it.
> > >
> > > Frankly looks like a ploy to sidestep review by graphics folks. We'd
> > > ask for the userspace first :-)
> >
> > Please refer to pull request [1].
> >
> > For any interest in more details, the libmetal is the abstraction layer
> > which provides platform independent APIs. The backend implementation
> > can be selected per different platforms: ex, rtos, linux,
> > standalone (xilinx),,,. For Linux, it supports UIO / vfio as of now.
> > The actual user space drivers sit on top of libmetal. Such drivers can be
> > found in [2]. This is why I try to avoid any device specific code in
> > Linux kernel.
> >
> > >
> > > Also, exporting dma_addr to userspace is considered a very bad idea.
> >
> > I agree, hence the RFC to pick some brains. :-) Would it make sense
> > if this call doesn't export the physicall address, but instead takes
> > only the dmabuf fd and register offsets to be programmed?
> >
> > > If you want to do this properly, you need a minimal in-kernel memory
> > > manager, and those tend to be based on top of drm_gem.c and merged
> > > through the gpu tree. The last place where we accidentally leaked a
> > > dma addr for gpu buffers was in the fbdev code, and we plugged that
> > > one with
> >
> > Could you please help me understand how having a in-kernel memory manager
> > helps? Isn't it just moving same dmabuf import / paddr export functionality
> > in different modules: kernel memory manager vs uio. In fact, Xilinx does have
> > such memory manager based on drm gem in downstream. But for this time we took
> > the approach of implementing this through generic dmabuf allocator, ION, and
> > enabling the import capability in the UIO infrastructure instead.
> 
> There's a group of people working on upstreaming a xilinx drm driver
> already. Which driver are we talking about? Can you pls provide a link
> to that xilinx drm driver?
> 

The one I was pushing [1] is implemented purely for display, and not
intended for anything other than that as of now. What I'm refering to above
is part of Xilinx FPGA (acceleration) runtime [2]. As far as I know,
it's planned to be upstreamed, but not yet started. The Xilinx runtime
software has its own in-kernel memory manager based on drm_cma_gem with
its own ioctls [3].

Thanks,
-hyun

[1] https://patchwork.kernel.org/patch/10513001/
[2] https://github.com/Xilinx/XRT
[3] https://github.com/Xilinx/XRT/tree/master/src/runtime_src/driver/zynq/drm

> Thanks, Daniel
> 
> > Thanks,
> > -hyun
> >
> > [1] https://github.com/OpenAMP/libmetal/pull/82/commits/951e2762bd487c98919ad12f2aa81773d8fe7859
> > [2] https://github.com/Xilinx/embeddedsw/tree/master/XilinxProcessorIPLib/drivers
> >
> > >
> > > commit 4be9bd10e22dfc7fc101c5cf5969ef2d3a042d8a (tag:
> > > drm-misc-next-fixes-2018-10-03)
> > > Author: Neil Armstrong <narmstrong@baylibre.com>
> > > Date:   Fri Sep 28 14:05:55 2018 +0200
> > >
> > >     drm/fb_helper: Allow leaking fbdev smem_start
> > >
> > > Together with cuse the above patch should be enough to implement a drm
> > > driver entirely in userspace at least.
> > >
> > > Cheers, Daniel
> > > --
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> 
> 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
