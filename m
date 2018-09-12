Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:20646 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbeIMCAL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:00:11 -0400
Date: Wed, 12 Sep 2018 23:53:33 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH v2 18/23] v4l: fwnode: Use media bus type for bus parser
 selection
Message-ID: <20180912205333.b4uunnddps4jybp7@kekkonen.localdomain>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
 <20180827093000.29165-19-sakari.ailus@linux.intel.com>
 <20180912151505.GB11509@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180912151505.GB11509@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for the comments.

On Wed, Sep 12, 2018 at 05:15:05PM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Mon, Aug 27, 2018 at 12:29:55PM +0300, Sakari Ailus wrote:
> > Use the media bus types instead of the fwnode bus types internally. This
> > is the interface to the drivers as well, making the use of the fwnode bus
> > types more localised to the V4L2 fwnode framework.
> >
> 
> So basically now "v4l2_fwnode_bus_type" it is only used in a few
> places in v4l2-fwnode and has to be kept in sync with the bus types
> listed in the devicetree bindings documentation?

Correct.

> 
> Do you think it is still worth to keep around functions dealing with
> that enum type as "v4l2_fwnode_bus_type_to_string()" ?
> It is only used by a debug printout (without that much value added, as
> we can print out the integer parsed from the DT). In all other cases
> it can be converted to the corresponing v4l2_mbus_type immediately.

One of the aims of this patchset is to make debugging easier. A string is
more informative to the developers than a number, and for a few additional
lines of code I think that is justifiable.

I'll send v3 probably early tomorrow as I fixed a build issue;
V4L2_MBUS_UNKNOWN was used in one patch that preceded its introduction.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
