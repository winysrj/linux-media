Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34A7C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 17:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D19C206B7
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 17:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbfAGRrj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 12:47:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:62041 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfAGRrj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 12:47:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2019 09:47:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,451,1539673200"; 
   d="scan'208";a="265146294"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga004.jf.intel.com with ESMTP; 07 Jan 2019 09:47:38 -0800
Received: from orsmsx156.amr.corp.intel.com (10.22.240.22) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 7 Jan 2019 09:47:38 -0800
Received: from orsmsx106.amr.corp.intel.com ([169.254.1.179]) by
 ORSMSX156.amr.corp.intel.com ([169.254.8.107]) with mapi id 14.03.0415.000;
 Mon, 7 Jan 2019 09:47:38 -0800
From:   "Zhi, Yong" <yong.zhi@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: RE: [bug report] media: staging/intel-ipu3: Add imgu top level pci
 device driver
Thread-Topic: [bug report] media: staging/intel-ipu3: Add imgu top level pci
 device driver
Thread-Index: AQHUpCkfBqjGmYYizUipCxcs7PVMG6WkFkGw
Date:   Mon, 7 Jan 2019 17:47:38 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB50587@ORSMSX106.amr.corp.intel.com>
References: <20190104122856.GA1169@kadam>
In-Reply-To: <20190104122856.GA1169@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGFlMDVmOWYtYjk1MC00MjUzLWJjNGMtN2E2MjE3ODZjZTQxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiR3Z6WHlOQVh0a1RSelF4MUtYQ1wvckJvOFd5NnU2c1BZd3ZKK05BTittZW5nczBiXC84QUFwd2FIOE1zS29Bcmw3In0=
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Cc Tianshu and others.

Hi, Dan,

Thanks a lot for the code review.

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, January 4, 2019 6:29 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org
> Subject: [bug report] media: staging/intel-ipu3: Add imgu top level pci device
> driver
> 
> Hello Yong Zhi,
> 
> The patch 7fc7af649ca7: "media: staging/intel-ipu3: Add imgu top level pci
> device driver" from Dec 6, 2018, leads to the following static checker warning:
> 
> 	drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
> 	warn: 'b' is an error pointer or valid
> 
> drivers/staging/media/ipu3/ipu3.c
>     472 static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
>     473 {
>     474 	struct imgu_device *imgu = imgu_ptr;
>     475 	struct imgu_media_pipe *imgu_pipe;
>     476 	int p;
>     477
>     478 	/* Dequeue / queue buffers */
>     479 	do {
>     480 		u64 ns = ktime_get_ns();
>     481 		struct ipu3_css_buffer *b;
>     482 		struct imgu_buffer *buf = NULL;
>     483 		unsigned int node, pipe;
>     484 		bool dummy;
>     485
>     486 		do {
>     487 			mutex_lock(&imgu->lock);
>     488 			b = ipu3_css_buf_dequeue(&imgu->css);
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> ipu3_css_buf_dequeue() doesn't return NULL.
> 
>     489 			mutex_unlock(&imgu->lock);
>     490 		} while (PTR_ERR(b) == -EAGAIN);
>     491
>     492 		if (IS_ERR_OR_NULL(b)) {
>                             ^^^^^^^^^^^^^^^^^
> --> 493 			if (!b || PTR_ERR(b) == -EBUSY)	/* All done */
>                                     ^^
> When a function returns both NULL and error pointers, then NULL is
> considered a special case of success.  Like perhaps you request a feature, but
> that feature isn't enabled in the config.  It's fine, because the user *chose* to
> turn off the feature, so it's not an error but we also don't have a valid pointer
> we can use.
> 
> It looks like you were probably trying to do something like that but you
> missed part of the commit?  Otherwise we should delete the dead code.
> 

Ack, with recent code changes the NULL check becomes useless, thanks for catching this.

>     494 				break;
>     495 			dev_err(&imgu->pci_dev->dev,
>     496 				"failed to dequeue buffers (%ld)\n",
>     497 				PTR_ERR(b));
>     498 			break;
>     499 		}
>     500
> 
> regards,
> dan carpenter
