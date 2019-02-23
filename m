Return-Path: <SRS0=tcVs=Q6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2135C43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 20:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE84206B6
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 20:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="S0eaaz8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfBWUan (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 23 Feb 2019 15:30:43 -0500
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:44672
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbfBWUam (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Feb 2019 15:30:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hIxxS2MHF/11e7BFYTkPz1FhCrOlo5d+xoIe8BcaoAU=;
 b=S0eaaz8h0UEzErouFOhvZOj5UiqyHqFMbRrP+APNtL8VIlrKd1aRPN9OQq1pQz9P635cuhv1gP3voTa1CQoscV6IJbkdR368r7cBFAkDsqr7YsUeW2LQxYK/qUOsF4ZE3fZqVi931EI2C0OKNjumS4n+oZF6E/GmWau7794om48=
Received: from DM6PR02CA0009.namprd02.prod.outlook.com (2603:10b6:5:1c::22) by
 BL0PR02MB4516.namprd02.prod.outlook.com (2603:10b6:208:4a::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.15; Sat, 23 Feb 2019 20:30:32 +0000
Received: from CY1NAM02FT034.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by DM6PR02CA0009.outlook.office365.com
 (2603:10b6:5:1c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1643.15 via Frontend
 Transport; Sat, 23 Feb 2019 20:30:32 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 CY1NAM02FT034.mail.protection.outlook.com (10.152.75.190) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1643.11
 via Frontend Transport; Sat, 23 Feb 2019 20:30:31 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:60971 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gxdwM-00009o-RJ; Sat, 23 Feb 2019 12:30:30 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gxdwH-0002w9-Jj; Sat, 23 Feb 2019 12:30:25 -0800
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x1NKUOV5014449;
        Sat, 23 Feb 2019 12:30:24 -0800
Received: from [172.19.2.244] (helo=xsjhyunkubuntu)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyunk@smtp.xilinx.com>)
        id 1gxdwG-0002vn-BN; Sat, 23 Feb 2019 12:30:24 -0800
Received: by xsjhyunkubuntu (Postfix, from userid 13638)
        id 7B3452C73C8; Sat, 23 Feb 2019 12:28:41 -0800 (PST)
From:   Hyun Kwon <hyun.kwon@xilinx.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <dri-devel@lists.freedesktop.org>,
        Cyril Chemparathy <cyrilc@xilinx.com>,
        Jiaying Liang <jliang@xilinx.com>,
        Sonal Santan <sonals@xilinx.com>,
        Stefano Stabellini <stefanos@xilinx.com>,
        <linaro-mm-sig@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        <linux-media@vger.kernel.org>, Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH RFC 1/1] uio: Add dma-buf import ioctls
Date:   Sat, 23 Feb 2019 12:28:17 -0800
Message-ID: <1550953697-7288-2-git-send-email-hyun.kwon@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
References: <1550953697-7288-1-git-send-email-hyun.kwon@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(39860400002)(2980300002)(199004)(189003)(44832011)(336012)(110136005)(11346002)(478600001)(16586007)(14444005)(51416003)(426003)(47776003)(476003)(486006)(2616005)(126002)(446003)(356004)(42186006)(5660300002)(186003)(103686004)(4326008)(76176011)(26005)(6666004)(50226002)(316002)(2906002)(81166006)(90966002)(52956003)(54906003)(6266002)(107886003)(305945005)(48376002)(36756003)(8676002)(81156014)(106466001)(63266004)(5024004)(106002)(8936002)(50466002)(107986001)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB4516;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5c8d848-b3b8-42f3-924a-08d699cdc1da
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4608103)(4709054)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:BL0PR02MB4516;
X-MS-TrafficTypeDiagnostic: BL0PR02MB4516:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Exchange-Diagnostics: 1;BL0PR02MB4516;20:yit7o3W8otPlXhUSxpv9XFt061iv6f+bnwwFU88/V2MplyA/5+6Zp9MdF/rt+IcYXjbtNgs1h2CQe72dXd6LdR1JMoJ72yM4t7okXXTi2TnLJiKpHHEWEyN82k+c3jW9qxL5D1V5aAOuNmkw5npdIpDpnV8YEPRK44TQcZpD8C8Q31RTG6G7CPr0acMTmqbkdg9Tg0/8p+ZijMe07P8fswXMkqFrmWH+JCeWWanj7/I1go5+A4wSkzF6QZXYahx2dcFS3omyWcK+98KAx3oWMMFmWdcsTpGxzWqc0++aEHSyW7tPxRq4EIp16lSordVpThDmC6iu2gkBVKKLC6ehkJptKEt75bXBGf/fjVCN3r48uoNnrnvXzYSsjuGN7n3+gkHzSWGi9eNFG0AimxLO0f0WKQVQunIWAbt2+kbxMcgXI2ZtjeB8zatLtt9SQhgb0Q6FncC45UC6hqRehqukYZuX2Z0VsKU0g6PZeUHEvMoiCg+FUtXOmyMYB2l3zy/+
X-Microsoft-Antispam-PRVS: <BL0PR02MB4516E2FA3DCA67C2AE15A635D6780@BL0PR02MB4516.namprd02.prod.outlook.com>
X-Forefront-PRVS: 0957AD37A0
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BL0PR02MB4516;23:H/fLeo9uQndXj/vLT/Z7Rlvq7FR0NTxxTZoc68wAg?=
 =?us-ascii?Q?Le5jFQV6ovQn4bhUv/Tc2g6X6kidBh3njXJ3HciXWysYzh7Mxxa7U3pIt2uu?=
 =?us-ascii?Q?YawC8SUJWPfhF9g5YJjI6/73NNALyzQEMae9CLZcXNDHlWCuVIUFaTSat5op?=
 =?us-ascii?Q?iIUSqC/EMJIOVJhf79aF3Y5TcWCf4JIc8TXPkgEoWOO0uMBEzVsEJqHz9GAs?=
 =?us-ascii?Q?d0TTaUHMiVEbWykG5qaw2+lWFS1QqXqGi3qmdXFZjSRI77B011lQnw8bfvIP?=
 =?us-ascii?Q?jkoWmHXVQdC8KMuV4UNWro5ESONjV3V4wnRr0KmMTyQ7ccXjKKBfpGHA6Eqg?=
 =?us-ascii?Q?q8la2bvWbCv+3BSnuGQ/7brBMER0mVE/2jzczlVocqymWNhv2rCLoVV/ryR5?=
 =?us-ascii?Q?Z+v9el0todk2/534EeqfPzNdQXAxyXYqFDIRvGHMukMtwEvaDMxWhP4uXwYE?=
 =?us-ascii?Q?9ox09ofSS8XlXSmlcLEMozw8oD61x3URwC77XzUIbGDaDjTS3k1SuPLnZ+ip?=
 =?us-ascii?Q?w1GOy3rbwXZ/mP4lVwbG9JWLmilVuTPn7q3WfEJO7kKwJCdRV5nUfI7nZcMP?=
 =?us-ascii?Q?LwTpop9iQCpNK7F9vlNe8bSE4MKvvUI8OiEOtDIyMt1+IRi1Sfh2J99DKJ1U?=
 =?us-ascii?Q?3oBQhybtWMyJuztrNVC9WUMICpyCtO1/hIAqhp7J1pCpYZSJsa3qc3Du/zIe?=
 =?us-ascii?Q?7kAeVsA0pJkztjEbpTNla9qUpyNk0wACWBc4S2ic66x5vuf3bsHOxWZCPmVM?=
 =?us-ascii?Q?fh/lqP3IvLs/6pj7gkKxmSYwzqm9BBX6buF1Nqdwy6sCsL+kR6pygzUrQIOe?=
 =?us-ascii?Q?Yeq9XU5qXmvjpmBsy1snMty46J0cu4QLuy24s71Xu3TnqHYXUNNlJPXp/1GL?=
 =?us-ascii?Q?QfrtBb1aIrGsMNYyfxfZMCzdkbabdgB2W+wrtdObT4haI9cjKLLwMiGTz13d?=
 =?us-ascii?Q?uSD6Qm2xQ2KppAd9Z38r6QJIpCjKiy41JRHkZNNFMEyix9NWMNeV4J6Co785?=
 =?us-ascii?Q?XybKPsFFaCwDxbpkFpKwx6iBkE/HAvLR6/Epg49YJAjqOV4G7Mu1qKkeOnYv?=
 =?us-ascii?Q?CKkVc7fVL1PkUbaIdrUi2Sh5Su5HeS3344Q+Ie/W9xiO9Y81gzG3vExabbZu?=
 =?us-ascii?Q?uY0036sZidWfIljvcOt/zX7U9mlKdSt/v9U9QkVoIkjNIsLoZju5Grc7Dm1R?=
 =?us-ascii?Q?WGIlTiyvZS8bsq5tkf0c2I0ym8Ht2eM+XaV?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Nlm9Sw2mQ2hkLYjUE1UIMqzn2KyfQ+8z6bdtTK/i6eUJ7pruGfQnvebsvh80R0xc0SiQdzpVHksB2uZcD+foqib6NbGzkddQbEHKfgqNcFWHKQuFSOALW3NEfkzmQMkQS6s5oLpAtmtr+RgREvoSH3gW3B5zHfJJ26HLZXIlooVq1hOESs4LhBre8ZbCkGdx24OPvS42xay/2e0VUyZZe+U+0IUDDZ5aKn8/l+z7jX0P2kiz5FQZeI69q+flNM/mXwo04xs9nGvQ6x5BRUarlcZOzvddSJdaiTERoW+8+8vaS9ILEgFK4ODokvMHMZNbgAks01p8qjY9Xq7g0fa2a/kctP6n1LRJ97ioWQbJTNwBWRJYu1ZnNcoW7NQuQWHshVgxYBzVVjU/+djaX9qq94j+VtSq6HEJ/Zr41MTkIN0=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2019 20:30:31.4037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c8d848-b3b8-42f3-924a-08d699cdc1da
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4516
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the dmabuf map / unmap interfaces. This allows the user driver
to be able to import the external dmabuf and use it from user space.

Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
---
 drivers/uio/Makefile         |   2 +-
 drivers/uio/uio.c            |  43 +++++++++
 drivers/uio/uio_dmabuf.c     | 210 +++++++++++++++++++++++++++++++++++++++++++
 drivers/uio/uio_dmabuf.h     |  26 ++++++
 include/uapi/linux/uio/uio.h |  33 +++++++
 5 files changed, 313 insertions(+), 1 deletion(-)
 create mode 100644 drivers/uio/uio_dmabuf.c
 create mode 100644 drivers/uio/uio_dmabuf.h
 create mode 100644 include/uapi/linux/uio/uio.h

diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index c285dd2..5da16c7 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_UIO)	+= uio.o
+obj-$(CONFIG_UIO)	+= uio.o uio_dmabuf.o
 obj-$(CONFIG_UIO_CIF)	+= uio_cif.o
 obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
 obj-$(CONFIG_UIO_DMEM_GENIRQ)	+= uio_dmem_genirq.o
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 1313422..6841f98 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -24,6 +24,12 @@
 #include <linux/kobject.h>
 #include <linux/cdev.h>
 #include <linux/uio_driver.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+
+#include <uapi/linux/uio/uio.h>
+
+#include "uio_dmabuf.h"
 
 #define UIO_MAX_DEVICES		(1U << MINORBITS)
 
@@ -454,6 +460,8 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
 struct uio_listener {
 	struct uio_device *dev;
 	s32 event_count;
+	struct list_head dbufs;
+	struct mutex dbufs_lock; /* protect @dbufs */
 };
 
 static int uio_open(struct inode *inode, struct file *filep)
@@ -500,6 +508,9 @@ static int uio_open(struct inode *inode, struct file *filep)
 	if (ret)
 		goto err_infoopen;
 
+	INIT_LIST_HEAD(&listener->dbufs);
+	mutex_init(&listener->dbufs_lock);
+
 	return 0;
 
 err_infoopen:
@@ -529,6 +540,10 @@ static int uio_release(struct inode *inode, struct file *filep)
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
 
+	ret = uio_dmabuf_cleanup(idev, &listener->dbufs, &listener->dbufs_lock);
+	if (ret)
+		dev_err(&idev->dev, "failed to clean up the dma bufs\n");
+
 	mutex_lock(&idev->info_lock);
 	if (idev->info && idev->info->release)
 		ret = idev->info->release(idev->info, inode);
@@ -652,6 +667,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
 	return retval ? retval : sizeof(s32);
 }
 
+static long uio_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	struct uio_listener *listener = filep->private_data;
+	struct uio_device *idev = listener->dev;
+	long ret;
+
+	if (!idev->info)
+		return -EIO;
+
+	switch (cmd) {
+	case UIO_IOC_MAP_DMABUF:
+		ret = uio_dmabuf_map(idev, &listener->dbufs,
+				     &listener->dbufs_lock, (void __user *)arg);
+		break;
+	case UIO_IOC_UNMAP_DMABUF:
+		ret = uio_dmabuf_unmap(idev, &listener->dbufs,
+				       &listener->dbufs_lock,
+				       (void __user *)arg);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static int uio_find_mem_index(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -821,6 +863,7 @@ static const struct file_operations uio_fops = {
 	.write		= uio_write,
 	.mmap		= uio_mmap,
 	.poll		= uio_poll,
+	.unlocked_ioctl	= uio_ioctl,
 	.fasync		= uio_fasync,
 	.llseek		= noop_llseek,
 };
diff --git a/drivers/uio/uio_dmabuf.c b/drivers/uio/uio_dmabuf.c
new file mode 100644
index 0000000..b18f146
--- /dev/null
+++ b/drivers/uio/uio_dmabuf.c
@@ -0,0 +1,210 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Xilinx, Inc.
+ *
+ * Author: Hyun Woo Kwon <hyun.kwon@xilinx.com>
+ *
+ * DMA buf support for UIO device
+ *
+ */
+
+#include <linux/dma-buf.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+#include <linux/uio_driver.h>
+#include <linux/slab.h>
+
+#include <uapi/linux/uio/uio.h>
+
+#include "uio_dmabuf.h"
+
+struct uio_dmabuf_mem {
+	int dbuf_fd;
+	struct dma_buf *dbuf;
+	struct dma_buf_attachment *dbuf_attach;
+	struct sg_table *sgt;
+	enum dma_data_direction dir;
+	struct list_head list;
+};
+
+long uio_dmabuf_map(struct uio_device *dev, struct list_head *dbufs,
+		    struct mutex *dbufs_lock, void __user *user_args)
+{
+	struct uio_dmabuf_args args;
+	struct uio_dmabuf_mem *dbuf_mem;
+	struct dma_buf *dbuf;
+	struct dma_buf_attachment *dbuf_attach;
+	enum dma_data_direction dir;
+	struct sg_table *sgt;
+	long ret;
+
+	if (copy_from_user(&args, user_args, sizeof(args))) {
+		ret = -EFAULT;
+		dev_err(dev->dev.parent, "failed to copy from user\n");
+		goto err;
+	}
+
+	dbuf = dma_buf_get(args.dbuf_fd);
+	if (IS_ERR(dbuf)) {
+		dev_err(dev->dev.parent, "failed to get dmabuf\n");
+		return PTR_ERR(dbuf);
+	}
+
+	dbuf_attach = dma_buf_attach(dbuf, dev->dev.parent);
+	if (IS_ERR(dbuf_attach)) {
+		dev_err(dev->dev.parent, "failed to attach dmabuf\n");
+		ret = PTR_ERR(dbuf_attach);
+		goto err_put;
+	}
+
+	switch (args.dir) {
+	case UIO_DMABUF_DIR_BIDIR:
+		dir = DMA_BIDIRECTIONAL;
+		break;
+	case UIO_DMABUF_DIR_TO_DEV:
+		dir = DMA_TO_DEVICE;
+		break;
+	case UIO_DMABUF_DIR_FROM_DEV:
+		dir = DMA_FROM_DEVICE;
+		break;
+	default:
+		/* Not needed with check. Just here for any future change  */
+		dev_err(dev->dev.parent, "invalid direction\n");
+		ret = -EINVAL;
+		goto err_detach;
+	}
+
+	sgt = dma_buf_map_attachment(dbuf_attach, dir);
+	if (IS_ERR(sgt)) {
+		dev_err(dev->dev.parent, "failed to get dmabuf scatterlist\n");
+		ret = PTR_ERR(sgt);
+		goto err_detach;
+	}
+
+	/* Accept only contiguous one */
+	if (sgt->nents != 1) {
+		dma_addr_t next_addr = sg_dma_address(sgt->sgl);
+		struct scatterlist *s;
+		unsigned int i;
+
+		for_each_sg(sgt->sgl, s, sgt->nents, i) {
+			if (!sg_dma_len(s))
+				continue;
+
+			if (sg_dma_address(s) != next_addr) {
+				dev_err(dev->dev.parent,
+					"dmabuf not contiguous\n");
+				ret = -EINVAL;
+				goto err_unmap;
+			}
+
+			next_addr = sg_dma_address(s) + sg_dma_len(s);
+		}
+	}
+
+	dbuf_mem = kzalloc(sizeof(*dbuf_mem), GFP_KERNEL);
+	if (!dbuf_mem) {
+		ret = -ENOMEM;
+		goto err_unmap;
+	}
+
+	dbuf_mem->dbuf_fd = args.dbuf_fd;
+	dbuf_mem->dbuf = dbuf;
+	dbuf_mem->dbuf_attach = dbuf_attach;
+	dbuf_mem->sgt = sgt;
+	dbuf_mem->dir = dir;
+	args.dma_addr = sg_dma_address(sgt->sgl);
+	args.size = dbuf->size;
+
+	if (copy_to_user(user_args, &args, sizeof(args))) {
+		ret = -EFAULT;
+		dev_err(dev->dev.parent, "failed to copy to user\n");
+		goto err_free;
+	}
+
+	mutex_lock(dbufs_lock);
+	list_add(&dbuf_mem->list, dbufs);
+	mutex_unlock(dbufs_lock);
+
+	return 0;
+
+err_free:
+	kfree(dbuf_mem);
+err_unmap:
+	dma_buf_unmap_attachment(dbuf_attach, sgt, dir);
+err_detach:
+	dma_buf_detach(dbuf, dbuf_attach);
+err_put:
+	dma_buf_put(dbuf);
+err:
+	return ret;
+}
+
+long uio_dmabuf_unmap(struct uio_device *dev, struct list_head *dbufs,
+		      struct mutex *dbufs_lock, void __user *user_args)
+
+{
+	struct uio_dmabuf_args args;
+	struct uio_dmabuf_mem *dbuf_mem;
+	long ret;
+
+	if (copy_from_user(&args, user_args, sizeof(args))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	mutex_lock(dbufs_lock);
+	list_for_each_entry(dbuf_mem, dbufs, list) {
+		if (dbuf_mem->dbuf_fd == args.dbuf_fd)
+			break;
+	}
+
+	if (dbuf_mem->dbuf_fd != args.dbuf_fd) {
+		dev_err(dev->dev.parent, "failed to find the dmabuf (%d)\n",
+			args.dbuf_fd);
+		ret = -EINVAL;
+		goto err_unlock;
+	}
+	list_del(&dbuf_mem->list);
+	mutex_unlock(dbufs_lock);
+
+	dma_buf_unmap_attachment(dbuf_mem->dbuf_attach, dbuf_mem->sgt,
+				 dbuf_mem->dir);
+	dma_buf_detach(dbuf_mem->dbuf, dbuf_mem->dbuf_attach);
+	dma_buf_put(dbuf_mem->dbuf);
+	kfree(dbuf_mem);
+
+	memset(&args, 0x0, sizeof(args));
+
+	if (copy_to_user(user_args, &args, sizeof(args))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	return 0;
+
+err_unlock:
+	mutex_unlock(dbufs_lock);
+err:
+	return ret;
+}
+
+int uio_dmabuf_cleanup(struct uio_device *dev, struct list_head *dbufs,
+		       struct mutex *dbufs_lock)
+{
+	struct uio_dmabuf_mem *dbuf_mem, *next;
+
+	mutex_lock(dbufs_lock);
+	list_for_each_entry_safe(dbuf_mem, next, dbufs, list) {
+		list_del(&dbuf_mem->list);
+		dma_buf_unmap_attachment(dbuf_mem->dbuf_attach, dbuf_mem->sgt,
+					 dbuf_mem->dir);
+		dma_buf_detach(dbuf_mem->dbuf, dbuf_mem->dbuf_attach);
+		dma_buf_put(dbuf_mem->dbuf);
+		kfree(dbuf_mem);
+	}
+	mutex_unlock(dbufs_lock);
+
+	return 0;
+}
diff --git a/drivers/uio/uio_dmabuf.h b/drivers/uio/uio_dmabuf.h
new file mode 100644
index 0000000..3020030
--- /dev/null
+++ b/drivers/uio/uio_dmabuf.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Xilinx, Inc.
+ *
+ * Author: Hyun Woo Kwon <hyun.kwon@xilinx.com>
+ *
+ * DMA buf support for UIO device
+ *
+ */
+
+#ifndef _UIO_DMABUF_H_
+#define _UIO_DMABUF_H_
+
+struct uio_device;
+struct list_head;
+struct mutex;
+
+long uio_dmabuf_map(struct uio_device *dev, struct list_head *dbufs,
+		    struct mutex *dbufs_lock, void __user *user_args);
+long uio_dmabuf_unmap(struct uio_device *dev, struct list_head *dbufs,
+		      struct mutex *dbufs_lock, void __user *user_args);
+
+int uio_dmabuf_cleanup(struct uio_device *dev, struct list_head *dbufs,
+		       struct mutex *dbufs_lock);
+
+#endif
diff --git a/include/uapi/linux/uio/uio.h b/include/uapi/linux/uio/uio.h
new file mode 100644
index 0000000..298bfd7
--- /dev/null
+++ b/include/uapi/linux/uio/uio.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * The header for UIO driver
+ *
+ * Copyright (C) 2019 Xilinx, Inc.
+ *
+ * Author: Hyun Woo Kwon <hyun.kwon@xilinx.com>
+ */
+
+#ifndef _UAPI_UIO_UIO_H_
+#define _UAPI_UIO_UIO_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define UIO_DMABUF_DIR_BIDIR	1
+#define UIO_DMABUF_DIR_TO_DEV	2
+#define UIO_DMABUF_DIR_FROM_DEV	3
+#define UIO_DMABUF_DIR_NONE	4
+
+struct uio_dmabuf_args {
+	__s32	dbuf_fd;
+	__u64	dma_addr;
+	__u64	size;
+	__u32	dir;
+};
+
+#define UIO_IOC_BASE		'U'
+
+#define	UIO_IOC_MAP_DMABUF	_IOWR(UIO_IOC_BASE, 0x1, struct uio_dmabuf_args)
+#define	UIO_IOC_UNMAP_DMABUF	_IOWR(UIO_IOC_BASE, 0x2, struct uio_dmabuf_args)
+
+#endif
-- 
2.7.4

