Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33911C04EBF
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 16:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B23B12082B
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 16:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="LB/tifqc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B23B12082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbeLDQlu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 11:41:50 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:37942 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbeLDQlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 11:41:50 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2E5FA553;
        Tue,  4 Dec 2018 17:41:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1543941708;
        bh=3nxbKsUrdlT4tP45o2eZzAaWcNV/WDEh8hJdk85S4ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LB/tifqcUrDtW0eCHWri3SCNfFYPWScc8BaoecayIO1brcoAtimFEHwbg/qSeKy1h
         oSZzaqilkMYJKRJn/8obL2IoqYcRt5jLx5V7cRL8MHOxSeh1gJdkpcK/cW5RVbG8wA
         hgwnNIkbqGsfIesyvoV0y5MzsljAXiIbH8Sm8HDA=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc:     Tomasz Figa <tfiga@chromium.org>, "Zhi, Yong" <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date:   Tue, 04 Dec 2018 18:42:20 +0200
Message-ID: <3857756.QIBhGo4FK8@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5981529599@fmsmsx122.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <6700442.fUP6q3B3KZ@avalon> <6F87890CF0F5204F892DEA1EF0D77A5981529599@fmsmsx122.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rajmohan,

On Tuesday, 4 December 2018 18:07:16 EET Mani, Rajmohan wrote:
> >> On Thursday, 29 November 2018 21:51:32 EET Tomasz Figa wrote:
> >>> On Thu, Nov 29, 2018 at 6:43 AM Laurent Pinchart wrote:
> >>>> On Tuesday, 30 October 2018 00:22:54 EET Yong Zhi wrote:
> >> 
> >> [snip]
> >> 
> >>>>> 1. Link pad flag of video nodes (i.e. ipu3-imgu 0 output) need to
> >>>>> be enabled prior to the test.
> >>>>> 2. Stream tests are not performed since it requires
> >>>>> pre-configuration for each case.
> >>>> 
> >>>> And that's a bit of an issue. I've tested the driver with a small
> >>>> script based on media-ctl to configure links and yavta to
> >>>> interface with the video nodes, and got the following oops:

[snip]

> >>>> The script can be found at
> >>>> https://lists.libcamera.org/pipermail/libcamera-devel/2018-Novembe
> >>>> r/000040.html.
> >>>> 
> >>>> I may be doing something wrong (and I probably am), but in any
> >>>> case, the driver shouldn't crash. Could you please have a look ?
> >>> 
> >>> It looks like the driver doesn't have the default state initialized
> >>> correctly somewhere and it ends up using 0 as the divisor in some
> >>> calculation? Something to fix indeed.
> >> 
> >> That's probably the case. I'll trust Intel to fix that in v8 :-)
> > 
> > Ack.
> 
> Thanks for catching this.
> I was able to reproduce this error and I see that error handling
> is missing, leading to the panic.
> 
> https://git.linuxtv.org/sailus/media_tree.git/tree/drivers/media
> /pci/intel/ipu3/ipu3-css-params.c?h=ipu3-v7&id=
> 19cee7329ca2d0156043cac6afcde535e93310af#n433
> 
> is where the -EINVAL is returned.
> 
> Setting the return type as int for the following function and all
> its callers to use the return value properly to error out, makes
> the panic go away.

I assume that I will still not be able to process frames through the pipe 
then, as I'll get an error :-) Could you tell me why the configuration is 
incorrect and how I can fix it ?

> ipu3_css_osys_calc_frame_and_stripe_params()
> 
> Will include the fix in v8.

Thank you.

> Thanks for catching this.

You're welcome.

-- 
Regards,

Laurent Pinchart



