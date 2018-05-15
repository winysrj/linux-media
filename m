Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:17472 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752260AbeEOJZL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 05:25:11 -0400
Date: Tue, 15 May 2018 12:25:07 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v16 0/2] rcar-csi2: add Renesas R-Car MIPI CSI-2
Message-ID: <20180515092507.6eaq3fsejd64fuqu@paasikivi.fi.intel.com>
References: <20180515005635.25715-1-niklas.soderlund+renesas@ragnatech.se>
 <2644518.Vheqspdx5b@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2644518.Vheqspdx5b@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 15, 2018 at 07:50:45AM +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> On Tuesday, 15 May 2018 03:56:33 EEST Niklas Söderlund wrote:
> > Hi,
> > 
> > This is the latest incarnation of R-Car MIPI CSI-2 receiver driver. It's
> > based on top of the media-tree and are tested on Renesas Salvator-X and
> > Salvator-XS together with adv7482 and the now in tree rcar-vin driver :-)
> > 
> > I hope this is the last incarnation of this patch-set, I do think it is
> > ready for upstream consumption :-)
> 
> So do I. Even though you dropped Hans' reviewed-by tag due to changes in the 
> hardware initialization code, I think the part that Hans cares about the most 
> is the V4L2 API implementation, so I believe his review still applies. In my 
> opinion the series has received the necessary review.
> 
> Hans, would you like to take this through your tree, or should we send a pull 
> request directly to Mauro ? I'd like the two patches to be merged in v4.18 if 
> possible.

I've applied the patches to my tree as discussed with Hans previously.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
