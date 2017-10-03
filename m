Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36227 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdJCAEv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 20:04:51 -0400
MIME-Version: 1.0
In-Reply-To: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 3 Oct 2017 02:04:50 +0200
Message-ID: <CAJZ5v0g4MUx8xaZjBwfVtYnad2+-ftkjk6Y51VRxS86YZar3oQ@mail.gmail.com>
Subject: Re: [PATCH v10 00/24] Unified fwnode endpoint parser, async
 sub-device notifier support, N9 flash DTS
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Rob Herring <robh@kernel.org>, hverkuil@xs4all.nl,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Sep 11, 2017 at 9:59 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi folks,
>
> We have a large influx of new, unmerged, drivers that are now parsing
> fwnode endpoints and each one of them is doing this a little bit
> differently. The needs are still exactly the same for the graph data
> structure is device independent. This is still a non-trivial task and the
> majority of the driver implementations are buggy, just buggy in different
> ways.
>
> Facilitate parsing endpoints by adding a convenience function for parsing
> the endpoints, and make the omap3isp and rcar-vin drivers use them as an
> example.
>
> To show where we're getting with this, I've added support for async
> sub-device notifier support that is notifiers that can be registered by
> sub-device drivers as well as V4L2 fwnode improvements to make use of them
> and the DTS changes for the Nokia N9. Some of these patches I've posted
> previously in this set here:
>
> <URL:http://www.spinics.net/lists/linux-media/msg118764.html>
>
> Since that, the complete callback of the master notifier registering the
> V4L2 device is only called once all sub-notifiers have been completed as
> well. This way the device node creation can be postponed until all devices
> have been successfully initialised.
>
> With this, the as3645a driver successfully registers a sub-device to the
> media device created by the omap3isp driver. The kernel also has the
> information it's related to the sensor driven by the smiapp driver but we
> don't have a way to expose that information yet.

I don't see core changes in this set, so I'm assuming it to be
targeted at the users of endpoints etc.

Thanks,
Rafael
