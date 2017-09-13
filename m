Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46280 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750737AbdIMISZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 04:18:25 -0400
Date: Wed, 13 Sep 2017 11:18:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v12 06/26] v4l: fwnode: Support generic parsing of graph
 endpoints, per port
Message-ID: <20170913081821.4kqf2kfmkidkaqah@valkosipuli.retiisi.org.uk>
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
 <20170912134200.19556-7-sakari.ailus@linux.intel.com>
 <0b73f576-c37b-ad58-6f74-71ffc3f8f176@xs4all.nl>
 <a6cdf6cb-6abc-ac3b-274d-e8b43e2ac2c6@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6cdf6cb-6abc-ac3b-274d-e8b43e2ac2c6@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Wed, Sep 13, 2017 at 09:06:11AM +0200, Hans Verkuil wrote:
> On 09/13/2017 09:01 AM, Hans Verkuil wrote:
> > On 09/12/2017 03:41 PM, Sakari Ailus wrote:
> >> This is just like like v4l2_async_notifier_parse_fwnode_endpoints but it
> >> only parses endpoints on a single port. The behaviour is useful on devices
> >> that have both sinks and sources, in other words only some of these should
> >> be parsed.
> 
> I forgot to mention that I think the log message can be improved: it is not
> clear why you would only parse some of the ports for devices that have both
> sinks and sources. That should be explained better. And probably also in the
> header documentation.

I'll add both.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
