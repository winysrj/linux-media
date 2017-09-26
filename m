Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:38899 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936633AbdIZI3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 04:29:51 -0400
Date: Tue, 26 Sep 2017 11:29:47 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v14 22/28] v4l: fwnode: Add a convenience function for
 registering sensors
Message-ID: <20170926082947.xwwhn6k2v5dktviz@paasikivi.fi.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-24-sakari.ailus@linux.intel.com>
 <ac50fc71-c528-a703-04bb-6abc1fc7c19a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac50fc71-c528-a703-04bb-6abc1fc7c19a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 26, 2017 at 10:26:35AM +0200, Hans Verkuil wrote:
> On 26/09/17 00:25, Sakari Ailus wrote:
> > Add a convenience function for parsing firmware for information on related
> > devices using v4l2_async_notifier_parse_fwnode_sensor_common() registering
> > the notifier and finally the async sub-device itself.
> > 
> > This should be useful for sensor drivers that do not have device specific
> > requirements related to firmware information parsing or the async
> > framework.
> 
> I'm confused. This is a second patch 22/28 that appears to be identical to the
> previous one.
> 
> I'm ignoring this one, I assume something went wrong when you mailed this series.

Yes. I changed the subject but accidentally used the same directory for the
patches. The patch is the same.

The intended subject prefix is "v4l: fwnode".

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
