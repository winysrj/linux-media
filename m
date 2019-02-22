Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B888C10F00
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D760520665
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfBVL3X (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:29:23 -0500
Received: from mga17.intel.com ([192.55.52.151]:42467 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbfBVL3W (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:29:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2019 03:29:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,399,1544515200"; 
   d="scan'208";a="128515526"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga003.jf.intel.com with ESMTP; 22 Feb 2019 03:29:19 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 66E21206FC; Fri, 22 Feb 2019 13:29:18 +0200 (EET)
Date:   Fri, 22 Feb 2019 13:29:18 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 16/30] v4l: subdev: Add [GS]_ROUTING subdev ioctls and
 operations
Message-ID: <20190222112917.l7sgmdb56jmbnos2@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-17-niklas.soderlund+renesas@ragnatech.se>
 <20190221143940.k56z2vwovu3y5okh@uno.localdomain>
 <20190221223131.rago5jmpxhygtuep@kekkonen.localdomain>
 <20190222084019.62atdkk6qipnugvf@uno.localdomain>
 <20190222110429.ybmqdwba5rszntb7@paasikivi.fi.intel.com>
 <20190222111747.tlj2xdjhnjwrlqxx@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222111747.tlj2xdjhnjwrlqxx@uno.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On Fri, Feb 22, 2019 at 12:17:47PM +0100, Jacopo Mondi wrote:
> Hi Sakari,
>     thanks for your suggestions.
> 
> On Fri, Feb 22, 2019 at 01:04:29PM +0200, Sakari Ailus wrote:
> > Hi Jacopo,
> 
> [snip]
> 
> > > On the previous example, I thought about GMSL-like devices, that can
> > > output the video streams received from different remotes in a
> > > separate virtual channel, at the same time.
> > >
> > > A possible routing table in that case would be like:
> > >
> > > Pads 0, 1, 2, 3 = SINKS
> > > Pad 4 = SOURCE with 4 streams (1 for each VC)
> > >
> > > 0/0 -> 4/0
> > > 0/0 -> 4/1
> > > 0/0 -> 4/2
> > > 0/0 -> 4/3
> > > 1/0 -> 4/0
> > > 1/0 -> 4/1
> > > 1/0 -> 4/2
> > > 1/0 -> 4/3
> > > 2/0 -> 4/0
> > > 2/0 -> 4/1
> > > 2/0 -> 4/2
> > > 2/0 -> 4/3
> > > 3/0 -> 4/0
> > > 3/0 -> 4/1
> > > 3/0 -> 4/2
> > > 3/0 -> 4/3
> >
> > If more than one pad can handle multiplexed streams, then you may end up in
> > a situation like that. Indeed.
> >
> 
> Please note that in this case there is only one pad that can handle
> multiplexed stream. The size of the routing table is the
> multiplication of the total number of pads by the product of all
> streams per pad. In this case (4 * (1 * 1 * 1 * 4))

Oh, good point, that's the case for G_ROUTING. I thought of S_ROUTING only.
:-)

> 
> > >
> > > With only one route per virtual channel active at a time.
> 
> [snip]
> 
> > >
> > > Thanks, I had a look at the MEDIA_ ioctls yesterday, G_TOPOLOGY in
> > > particular, which uses several pointers to arrays.
> > >
> > > Unfortunately, I didn't come up with anything better than using a
> > > translation structure, from the IOCTL layer to the subdevice
> > > operations layer:
> > > https://paste.debian.net/hidden/b192969d/
> > > (sharing a link for early comments, I can send v3 and you can comment
> > > there directly if you prefer to :)
> >
> > Hmm. That is a downside indeed. It's still a lesser problem than the compat
> > code in general --- which has been a source for bugs as well as nasty
> > security problems over time.
> >
> 
> Good!
> 
> > I think we need a naming scheme for such structs. How about just
> > calling that struct e.g. v4l2_subdev_krouting instead? It's simple, easy to
> > understand and it includes a suggestion which one is the kernel-only
> > variant.
> >
> 
> I kind of like that! thanks!
> 
> > You can btw. zero the struct memory by assigning { 0 } to it in
> > declaration. memset() in general is much more trouble. In this case you
> > could even do the assignments in delaration as well.
> >
> 
> Thanks, noted. I have been lazy and copied memset from other places in
> the ioctl handling code. I should check on your suggestions because I
> remember one of the many 0-initialization statement was a GCC specific one,
> don't remember which...

{} is GCC specific whereas { 0 } is not. But there have been long-standing
GCC bugs related to the use of { 0 } which is quite unfortunate --- they've
produced warnings or errors from code that is valid C...

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
