Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33A4C282DB
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 15:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF973218FD
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 15:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfBAPrp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 10:47:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:37305 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbfBAPro (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 10:47:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2019 07:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,549,1539673200"; 
   d="scan'208";a="123191077"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga003.jf.intel.com with ESMTP; 01 Feb 2019 07:47:44 -0800
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 1 Feb 2019 07:47:44 -0800
Received: from orsmsx106.amr.corp.intel.com ([169.254.1.180]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.145]) with mapi id 14.03.0415.000;
 Fri, 1 Feb 2019 07:47:43 -0800
From:   "Zhi, Yong" <yong.zhi@intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v2 2/2] media: ipu3-imgu: Remove dead code for NULL check
Thread-Topic: [PATCH v2 2/2] media: ipu3-imgu: Remove dead code for NULL
 check
Thread-Index: AQHUrcBRw1oOEx6Ha02orled1cBzIKXLYISA///NTnA=
Date:   Fri, 1 Feb 2019 15:47:42 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB6C079@ORSMSX106.amr.corp.intel.com>
References: <1547659127-13055-1-git-send-email-yong.zhi@intel.com>
 <1547659127-13055-2-git-send-email-yong.zhi@intel.com>
 <20190201104322.r2lgas55wc5pgq6s@paasikivi.fi.intel.com>
In-Reply-To: <20190201104322.r2lgas55wc5pgq6s@paasikivi.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzA1NjNmZWYtNTYwYi00MWExLThiYzAtMGNmNzU5NDgzMTdhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaHU1MEg5UTJPVVk5ZmlIV0tsNU1ZSTlYUHIzWDhiZTBLV0ZBMlVNODdOemNHNUVid1czRlhoaWQ4THBTRFZVcCJ9
x-originating-ip: [10.22.254.138]
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
> Sent: Friday, February 1, 2019 2:43 AM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; Mani, Rajmohan
> <rajmohan.mani@intel.com>; tfiga@chromium.org;
> laurent.pinchart@ideasonboard.com; hans.verkuil@cisco.com;
> mchehab@kernel.org; dan.carpenter@oracle.com; Qiu, Tian Shu
> <tian.shu.qiu@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
> Subject: Re: [PATCH v2 2/2] media: ipu3-imgu: Remove dead code for NULL
> check
> 
> Hi Yong,
> 
> On Wed, Jan 16, 2019 at 09:18:47AM -0800, Yong Zhi wrote:
> > Since ipu3_css_buf_dequeue() never returns NULL, remove the dead code
> > to fix static checker warning:
> >
> > drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
> > warn: 'b' is an error pointer or valid
> >
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com> [Bug report:
> > https://lore.kernel.org/linux-media/20190104122856.GA1169@kadam/]
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I don't see Laurent's Reviewed-by: tag on the list. Did you get that from him
> off-list? If he hasn't given one, please send v3 without that tag.
> 

The bug report link was suggested by Laurent, so that I assume he reviewed the patch, I can re-send without the tag if this does not count. 

> Thanks.
> 
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
