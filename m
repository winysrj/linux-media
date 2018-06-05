Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:37669 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbeFEHtm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 03:49:42 -0400
Date: Tue, 5 Jun 2018 09:49:38 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, geert@glider.be,
        mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 8/8] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180605074938.mljwmgpjlplvkp2v@verge.net.au>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-9-git-send-email-jacopo+renesas@jmondi.org>
 <20180604122325.GH19674@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180604122325.GH19674@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 04, 2018 at 02:23:25PM +0200, Niklas Söderlund wrote:
> Hi Jacopo,
> 
> Thanks for your work.
> 
> On 2018-05-29 17:05:59 +0200, Jacopo Mondi wrote:
> > The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
> > driver and only confuse users. Remove them in all Gen2 SoC that use
> > them.
> > 
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> The more I think about this the more I lean towards that this patch 
> should be dropped. The properties accurately describes the hardware and 
> I think there is value in that. That the driver currently don't parse or 
> make use of them don't in my view reduce there value. Maybe you should 
> break out this patch to a separate series?

I also think there is value in describing the hardware not the state of the
driver at this time.  Is there any missmatch between these properties and
the bindings?
