Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE801C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 17:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB8D520818
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 17:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfBDRnd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 12:43:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:30266 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbfBDRnc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 12:43:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2019 09:43:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,560,1539673200"; 
   d="scan'208";a="115192042"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga008.jf.intel.com with ESMTP; 04 Feb 2019 09:43:31 -0800
Received: from fmsmsx122.amr.corp.intel.com ([169.254.5.2]) by
 FMSMSX108.amr.corp.intel.com ([169.254.9.99]) with mapi id 14.03.0415.000;
 Mon, 4 Feb 2019 09:43:31 -0800
From:   "Mani, Rajmohan" <rajmohan.mani@intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>,
        "Zhi@paasikivi.fi.intel.com" <Zhi@paasikivi.fi.intel.com>,
        "Zhi, Yong" <yong.zhi@intel.com>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "tfiga@chromium.org" <tfiga@chromium.org>
Subject: RE: [PATCH] media: staging/intel-ipu3: Implement lock for stream
 on/off operations
Thread-Topic: [PATCH] media: staging/intel-ipu3: Implement lock for stream
 on/off operations
Thread-Index: AQHUuCOItqk09SukTkm5qxVbw0DkOqXICeuAgAACepCAA6IgAP//oZBwgAShetA=
Date:   Mon, 4 Feb 2019 17:43:30 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A599B325D85@fmsmsx122.amr.corp.intel.com>
References: <20190129222736.6216-1-rajmohan.mani@intel.com>
 <20190130085901.w2ogdoax7t4yfyj6@paasikivi.fi.intel.com>
 <6F87890CF0F5204F892DEA1EF0D77A599B325222@fmsmsx122.amr.corp.intel.com>
 <20190201163655.ufrazkvsabsp6gmv@paasikivi.fi.intel.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTdjODI1MjMtMGI1Yy00NDc1LTkxMWUtY2UwZmE0YTdjNmQ2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTnVzSzBCaXpVQ0xHbnNKbG5mRWVTME5YKzZnZGtmQ2EyVFhtR3N0bFBGVHF5RFgyUEppZUZVWXFYT1pqQUZvcyJ9
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

[snip]

> > > > >  fail_stop_pipeline:
> > > > > @@ -543,6 +546,8 @@ static void ipu3_vb2_stop_streaming(struct
> > > > vb2_queue *vq)
> > > > >  		dev_err(&imgu->pci_dev->dev,
> > > > >  			"failed to stop subdev streaming\n");
> > > > >
> > > > > +	mutex_lock(&imgu->streaming_lock);
> > > > > +
> > > > >  	/* Was this the first node with streaming disabled? */
> > > > >  	if (imgu->streaming && ipu3_all_nodes_streaming(imgu, node)) {
> > > > >  		/* Yes, really stop streaming now */ @@ -552,6 +557,7 @@
> > > > static
> > > > > void ipu3_vb2_stop_streaming(struct vb2_queue *vq)
> > > > >  			imgu->streaming = false;
> > > > >  	}
> > > > >
> > > > > +	mutex_unlock(&imgu->streaming_lock);
> > > > >  	ipu3_return_all_buffers(imgu, node, VB2_BUF_STATE_ERROR);
> >
> > I'd also call ipu3_return_all_buffers() before releasing the lock: in
> > principle the user may have queued new buffers on the devices before
> > the driver marks the buffers as faulty.
> >

Ack
(Somehow I missed this comment.)

[snip]
