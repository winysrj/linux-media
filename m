Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE21C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 22:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5260E2171F
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 22:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfABWG0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 17:06:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:58385 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfABWG0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Jan 2019 17:06:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2019 14:06:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,432,1539673200"; 
   d="scan'208";a="263952551"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 02 Jan 2019 14:06:25 -0800
Received: from orsmsx115.amr.corp.intel.com (10.22.240.11) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 2 Jan 2019 14:06:25 -0800
Received: from orsmsx106.amr.corp.intel.com ([169.254.1.152]) by
 ORSMSX115.amr.corp.intel.com ([169.254.4.23]) with mapi id 14.03.0415.000;
 Wed, 2 Jan 2019 14:06:25 -0800
From:   "Zhi, Yong" <yong.zhi@intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: RE: [PATCH 1/1] media: staging/intel-ipu3: Fix Kconfig for unmet
 direct dependencies
Thread-Topic: [PATCH 1/1] media: staging/intel-ipu3: Fix Kconfig for unmet
 direct dependencies
Thread-Index: AQHUoTDKq+OTbV0Gd0CM4Xz1+O56W6Wc8luA//+Z2IA=
Date:   Wed, 2 Jan 2019 22:06:24 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB46C9F@ORSMSX106.amr.corp.intel.com>
References: <1546278403-8306-1-git-send-email-yong.zhi@intel.com>
 <20190102201112.cuxy7y37mcophrvw@mara.localdomain>
In-Reply-To: <20190102201112.cuxy7y37mcophrvw@mara.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZWNlN2UwYWItMTVkOS00ZDMwLTk5OTktNWIzMzc1OTUzZTY4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZ2tLNXA1MXNETDRveEhNMWdQb1pxU0dreWNBM2FqNFI3OG5YZzJVYnhQVFM2S2Y3dVFrTU9UcklYSVhKdW90UiJ9
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi, Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@linux.intel.com]
> Sent: Wednesday, January 2, 2019 2:11 PM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; tfiga@chromium.org; Mani, Rajmohan
> <rajmohan.mani@intel.com>; hans.verkuil@cisco.com;
> mchehab@kernel.org; laurent.pinchart@ideasonboard.com; Cao, Bingbu
> <bingbu.cao@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>
> Subject: Re: [PATCH 1/1] media: staging/intel-ipu3: Fix Kconfig for unmet
> direct dependencies
> 
> Hi Yong,
> 
> On Mon, Dec 31, 2018 at 11:46:43AM -0600, Yong Zhi wrote:
> > Fix link error for specific .config reported by lkp robot:
> >
> > drivers/staging/media/ipu3/ipu3-dmamap.o: In function
> `ipu3_dmamap_alloc':
> > drivers/staging/media/ipu3/ipu3-dmamap.c:111: undefined reference to
> `alloc_iova'
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> > Happy New Year!!
> >
> >  drivers/staging/media/ipu3/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/media/ipu3/Kconfig
> > b/drivers/staging/media/ipu3/Kconfig
> > index 75cd889f18f7..c486cbbe859a 100644
> > --- a/drivers/staging/media/ipu3/Kconfig
> > +++ b/drivers/staging/media/ipu3/Kconfig
> > @@ -3,7 +3,7 @@ config VIDEO_IPU3_IMGU
> >  	depends on PCI && VIDEO_V4L2
> >  	depends on MEDIA_CONTROLLER && VIDEO_V4L2_SUBDEV_API
> >  	depends on X86
> > -	select IOMMU_IOVA
> > +	select IOMMU_IOVA if IOMMU_SUPPORT
> 
> I don't think this really addresses the issue: the IOVA library is needed in any
> case. I'll submit a patch...
> 

Sure, thanks!!

> >  	select VIDEOBUF2_DMA_SG
> >  	---help---
> >  	  This is the Video4Linux2 driver for Intel IPU3 image processing
> > unit,
> > --
> > 2.7.4
> >
> 
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
