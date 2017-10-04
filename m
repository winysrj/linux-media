Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7372 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbdJDMpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 08:45:10 -0400
Date: Wed, 4 Oct 2017 15:45:01 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Rob Herring <robh@kernel.org>, hverkuil@xs4all.nl,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v10 00/24] Unified fwnode endpoint parser, async
 sub-device notifier support, N9 flash DTS
Message-ID: <20171004124500.bm2rt3abfem63svi@kekkonen.localdomain>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <CAJZ5v0g4MUx8xaZjBwfVtYnad2+-ftkjk6Y51VRxS86YZar3oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0g4MUx8xaZjBwfVtYnad2+-ftkjk6Y51VRxS86YZar3oQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rafael,

On Tue, Oct 03, 2017 at 02:04:50AM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> On Mon, Sep 11, 2017 at 9:59 AM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > Hi folks,
> >
> > We have a large influx of new, unmerged, drivers that are now parsing
> > fwnode endpoints and each one of them is doing this a little bit
> > differently. The needs are still exactly the same for the graph data
> > structure is device independent. This is still a non-trivial task and the
> > majority of the driver implementations are buggy, just buggy in different
> > ways.
> >
> > Facilitate parsing endpoints by adding a convenience function for parsing
> > the endpoints, and make the omap3isp and rcar-vin drivers use them as an
> > example.
> >
> > To show where we're getting with this, I've added support for async
> > sub-device notifier support that is notifiers that can be registered by
> > sub-device drivers as well as V4L2 fwnode improvements to make use of them
> > and the DTS changes for the Nokia N9. Some of these patches I've posted
> > previously in this set here:
> >
> > <URL:http://www.spinics.net/lists/linux-media/msg118764.html>
> >
> > Since that, the complete callback of the master notifier registering the
> > V4L2 device is only called once all sub-notifiers have been completed as
> > well. This way the device node creation can be postponed until all devices
> > have been successfully initialised.
> >
> > With this, the as3645a driver successfully registers a sub-device to the
> > media device created by the omap3isp driver. The kernel also has the
> > information it's related to the sensor driven by the smiapp driver but we
> > don't have a way to expose that information yet.
> 
> I don't see core changes in this set, so I'm assuming it to be
> targeted at the users of endpoints etc.

Yes, this is dealing with V4L2 and how information from firmware is used
mainly but there is also DT binding documentation.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
