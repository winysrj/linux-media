Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01DFC4360F
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 23:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C809820818
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 23:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfBUXvk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:51:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:50776 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbfBUXvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 18:51:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2019 15:51:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,397,1544515200"; 
   d="scan'208";a="118122756"
Received: from oliviapo-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.44.84])
  by orsmga006.jf.intel.com with ESMTP; 21 Feb 2019 15:51:05 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id D689721D81; Fri, 22 Feb 2019 01:50:59 +0200 (EET)
Date:   Fri, 22 Feb 2019 01:50:59 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 17/30] v4l: subdev: compat: Implement handling for
 VIDIOC_SUBDEV_[GS]_ROUTING
Message-ID: <20190221235059.eekgbwj7zsgnrpmf@kekkonen.localdomain>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
 <20190115235303.GG31088@pendragon.ideasonboard.com>
 <20190218112109.slu6kkcbwb6fn2hr@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190218112109.slu6kkcbwb6fn2hr@uno.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 18, 2019 at 12:21:09PM +0100, Jacopo Mondi wrote:
> Hi Laurent, Sakari,
> 
> On Wed, Jan 16, 2019 at 01:53:03AM +0200, Laurent Pinchart wrote:
> > Hi Niklas,
> >
> > Thank you for the patch.
> >
> > On Fri, Nov 02, 2018 at 12:31:31AM +0100, Niklas Söderlund wrote:
> > > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > >
> > > Implement compat IOCTL handling for VIDIOC_SUBDEV_G_ROUTING and
> > > VIDIOC_SUBDEV_S_ROUTING IOCTLs.
> >
> > Let's instead design the ioctl in a way that doesn't require compat
> > handling.
> >
> 
> Care to explain what makes this ioctl require a compat version? I
> don't see assumptions on the word length on the implementation. What
> am I missing?

The size of the "routes" pointer isn't constant, therefore affecting the
memory layout of the struct (and thus requiring compat code). It should be
__u64. (Please see my other reply to the same patch.)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
