Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:54816 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1952059AbdEAIcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 May 2017 04:32:55 -0400
Date: Mon, 1 May 2017 10:32:48 +0200
From: Simon Horman <horms@verge.net.au>
To: kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] RFC: ADV748x HDMI/Analog video receiver
Message-ID: <20170501083248.GG18349@verge.net.au>
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
 <20170428070935.GC10196@verge.net.au>
 <b0497e51-78f1-40e2-b97d-7c1ce7939b1d@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0497e51-78f1-40e2-b97d-7c1ce7939b1d@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 09:47:05AM +0100, Kieran Bingham wrote:
> Hi Simon,
> 
> On 28/04/17 08:09, Simon Horman wrote:
> > On Thu, Apr 27, 2017 at 07:25:59PM +0100, Kieran Bingham wrote:
> >> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >>
> >> This is an RFC for the Analog Devices ADV748x driver, and follows on from a
> >> previous posting by Niklas Söderlund [0] of an earlier incarnation of this
> >> driver.
> > 
> > ...
> > 
> >> This series presents the following patches:
> >>
> >>  [PATCH 1/5] v4l2-subdev: Provide a port mapping for asynchronous
> >>  [PATCH 2/5] rcar-vin: Match sources against ports if specified.
> >>  [PATCH 3/5] media: i2c: adv748x: add adv748x driver
> >>  [PATCH 4/5] arm64: dts: r8a7795: salvator-x: enable VIN, CSI and ADV7482
> >>  [PATCH 5/5] arm64: dts: r8a7796: salvator-x: enable VIN, CSI and ADV7482
> > 
> > I am marking the above dts patches as "RFC" and do not plan to apply them
> > unless you ping me or repost them.
> 
> Yes, sorry - the whole series was supposed to be marked as RFC, but I didn't
> think about it - and apparently only applied the tag to the cover letter.
> 
> Apologies for any confusion.

It was clear enough, though an tag RFC in every patch would be better.
In any case I was referring to how I have handled these patches in
patchwork.

Apologies for any confusion.

> > Assuming they don't cause any
> > regressions I would be happy to consider applying them as soon as their
> > dependencies are accepted.
> 
> Does that mean you've done a cursory glance over the content ? :-)

Yes, I did take a quick glance.

> In this instance, the port numbers need to revert back to a zero-base,
> but I would appreciate an eye on how and where I've put the
> representation of the physical hdmi/cvbs connectors. Having modified
> plenty of DT, but not actually submitted much - I still feel 'new' at it
> - so I'm sure I may not have followed the standards quite right yet.

Assuming you are talking about where in the DT file the hdmi and cvbs nodes
should go, I think this is somewhat arbitrary so long as they are within
the top-level node - what you have looks good to me.

> The dts patches are based heavily on the previous posting by Niklas, but I have
> extended to put the extra hdmi and cvbs links in.
> 
> Regards
> --
> Kieran
> 
