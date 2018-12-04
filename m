Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914A6C07E85
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 16:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 623C220659
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 16:53:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 623C220659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbeLDQxg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 11:53:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:8982 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbeLDQx3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 11:53:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2018 08:53:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,314,1539673200"; 
   d="scan'208";a="280874528"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga005.jf.intel.com with ESMTP; 04 Dec 2018 08:53:28 -0800
Received: from fmsmsx122.amr.corp.intel.com ([169.254.5.168]) by
 FMSMSX106.amr.corp.intel.com ([169.254.5.52]) with mapi id 14.03.0415.000;
 Tue, 4 Dec 2018 08:53:28 -0800
From:   "Mani, Rajmohan" <rajmohan.mani@intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Thread-Topic: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Thread-Index: AQHUb9aJ2xONOQn66UKjxJluMlyZrqVnikaAgABWAwCAADMOAP//erHggAdi27CAAJYyAP//fHuA
Date:   Tue, 4 Dec 2018 16:53:27 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A59815295E0@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <6700442.fUP6q3B3KZ@avalon>
 <6F87890CF0F5204F892DEA1EF0D77A5981529599@fmsmsx122.amr.corp.intel.com>
 <3857756.QIBhGo4FK8@avalon>
In-Reply-To: <3857756.QIBhGo4FK8@avalon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWQ0MWU1YTctMmUwMC00ODBmLWFkMGEtNDFlMjg3YTkyNzU4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiREx3SGt2aWJ3T05BS0JJQ2JIVTEwOEcrcCtMdnlsdmt5Y0JYVnZNK1RIK1BUbXFSMkY2NGc4cXRHQ2cxQUxLRyJ9
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, December 04, 2018 8:42 AM
> To: Mani, Rajmohan <rajmohan.mani@intel.com>
> Cc: Tomasz Figa <tfiga@chromium.org>; Zhi, Yong <yong.zhi@intel.com>;
> Linux Media Mailing List <linux-media@vger.kernel.org>; Sakari Ailus
> <sakari.ailus@linux.intel.com>; Mauro Carvalho Chehab
> <mchehab@kernel.org>; Hans Verkuil <hans.verkuil@cisco.com>; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>;
> Toivonen, Tuukka <tuukka.toivonen@intel.com>; Qiu, Tian Shu
> <tian.shu.qiu@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
> Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
> 
> Hi Rajmohan,
> 
> On Tuesday, 4 December 2018 18:07:16 EET Mani, Rajmohan wrote:
> > >> On Thursday, 29 November 2018 21:51:32 EET Tomasz Figa wrote:
> > >>> On Thu, Nov 29, 2018 at 6:43 AM Laurent Pinchart wrote:
> > >>>> On Tuesday, 30 October 2018 00:22:54 EET Yong Zhi wrote:
> > >>
> > >> [snip]
> > >>
> > >>>>> 1. Link pad flag of video nodes (i.e. ipu3-imgu 0 output) need
> > >>>>> to be enabled prior to the test.
> > >>>>> 2. Stream tests are not performed since it requires
> > >>>>> pre-configuration for each case.
> > >>>>
> > >>>> And that's a bit of an issue. I've tested the driver with a small
> > >>>> script based on media-ctl to configure links and yavta to
> > >>>> interface with the video nodes, and got the following oops:
> 
> [snip]
> 
> > >>>> The script can be found at
> > >>>> https://lists.libcamera.org/pipermail/libcamera-devel/2018-Novemb
> > >>>> e
> > >>>> r/000040.html.
> > >>>>
> > >>>> I may be doing something wrong (and I probably am), but in any
> > >>>> case, the driver shouldn't crash. Could you please have a look ?
> > >>>
> > >>> It looks like the driver doesn't have the default state
> > >>> initialized correctly somewhere and it ends up using 0 as the
> > >>> divisor in some calculation? Something to fix indeed.
> > >>
> > >> That's probably the case. I'll trust Intel to fix that in v8 :-)
> > >
> > > Ack.
> >
> > Thanks for catching this.
> > I was able to reproduce this error and I see that error handling is
> > missing, leading to the panic.
> >
> > https://git.linuxtv.org/sailus/media_tree.git/tree/drivers/media
> > /pci/intel/ipu3/ipu3-css-params.c?h=ipu3-v7&id=
> > 19cee7329ca2d0156043cac6afcde535e93310af#n433
> >
> > is where the -EINVAL is returned.
> >
> > Setting the return type as int for the following function and all its
> > callers to use the return value properly to error out, makes the panic
> > go away.
> 
> I assume that I will still not be able to process frames through the pipe then, as
> I'll get an error :-) Could you tell me why the configuration is incorrect and how
> I can fix it ?
> 

:)
Let me look into this more and get back.
Thanks for your patience.

Raj

> > ipu3_css_osys_calc_frame_and_stripe_params()
> >
> > Will include the fix in v8.
> 
> Thank you.
> 
> > Thanks for catching this.
> 
> You're welcome.
> 
> --
> Regards,
> 
> Laurent Pinchart
> 
> 

