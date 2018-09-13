Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:38787 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbeIMPEU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 11:04:20 -0400
Date: Thu, 13 Sep 2018 12:55:33 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3 16/23] v4l: fwnode: Initialise the V4L2 fwnode
 endpoints to zero
Message-ID: <20180913095533.nu6yjf6swga7fa6x@paasikivi.fi.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
 <20180912212942.19641-17-sakari.ailus@linux.intel.com>
 <20180913094614.GS20333@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180913094614.GS20333@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Sep 13, 2018 at 11:46:14AM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Thu, Sep 13, 2018 at 12:29:35AM +0300, Sakari Ailus wrote:
> > Initialise the V4L2 fwnode endpoints to zero in all drivers using
> > v4l2_fwnode_endpoint_parse(). This prepares for setting default endpoint
> > flags as well as the bus type. Setting bus type to zero will continue to
> > guess the bus among the guessable set (parallel, Bt.656 and CSI-2 D-PHY).
> >
> 
> I've played around with this patch, trying to use defaults in the
> renesas-ceu driver.
> 
> This is the resulting patch, if you want I can send it as follow-up or
> send it so that you can include it in your series if it's correct):
> https://paste.debian.net/hidden/a7795d3e/

Looks nice; could you send it out to the list for review?

The bus width default isn't specified in DT bindings; could you write a
patch that defines it?

Thanks.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
