Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53056 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750715AbdIKOME (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 10:12:04 -0400
Date: Mon, 11 Sep 2017 17:12:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-acpi@vger.kernel.org, mika.westerberg@intel.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v10 18/24] v4l: fwnode: Add a helper function to obtain
 device / interger references
Message-ID: <20170911141200.rxn36p7u77b2rzzs@valkosipuli.retiisi.org.uk>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-19-sakari.ailus@linux.intel.com>
 <11c951eb-0315-0149-829e-ed73d748e783@xs4all.nl>
 <20170911122820.fkbd2rnaddiestab@valkosipuli.retiisi.org.uk>
 <2e2eba02-39bc-11e1-d9f1-b83a6f580667@xs4all.nl>
 <20170911132710.mcgqn6tbiabzvpqq@valkosipuli.retiisi.org.uk>
 <21d712c2-7608-7153-4421-2c12b90dcb7a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d712c2-7608-7153-4421-2c12b90dcb7a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 11, 2017 at 03:34:16PM +0200, Hans Verkuil wrote:
> >>>>> +		u32 val;
> >>>>> +
> >>>>> +		fwnode_for_each_child_node(fwnode, child) {
> >>>>> +			if (fwnode_property_read_u32(child, *props, &val))
> >>>>> +				continue;
> >>>>> +
> >>>>> +			if (val == *args)
> >>>>> +				break;
> >>>>
> >>>> I'm lost. This really needs comments and perhaps even an DT or ACPI example
> >>>> so you can see what exactly it is we're doing here.
> >>>
> >>> I'll add comments to the code. A good example will be ACPI documentation
> >>> for LEDs, see 17th patch in v9. That will go through the linux-pm tree so
> >>> it won't be available in the same tree for a while.
> >>
> >> Ideally an ACPI and an equivalent DT example would be nice to have, but I might
> >> be asking too much. I'm not that familiar with ACPI, so for me a DT example
> >> is easier.
> > 
> > This won't be useful on DT although you could technically use it. In DT you
> > can directly refer to any node but on ACPI you can just refer to devices,
> > hence this.
> 
> So this function will effectively only be used with acpi? That should be
> documented. I think that explains some of my confusion since I was trying
> to map this code to a device tree, without much success.

I'll add to the documentation of the function:

 * While it is technically possible to use this function on DT, it is only
 * meaningful on ACPI. On Device tree you can refer to any node in the tree but
 * on ACPI the references are limited to devices.

> 
> > Would you be happy with the leds.txt example? I think it's a good example
> > as it's directly related to this.
> 
> Yes, that will work.

I'll add a separate patch that I'll post later on. The ACPI documentation
should get merged first.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
