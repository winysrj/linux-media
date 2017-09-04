Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59478 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753764AbdIDQHP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 12:07:15 -0400
Date: Mon, 4 Sep 2017 19:07:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v7 07/18] omap3isp: Fix check for our own sub-devices
Message-ID: <20170904160712.ha6n3k52swgzlbkm@valkosipuli.retiisi.org.uk>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-8-sakari.ailus@linux.intel.com>
 <f8a4ba8c-f749-26ab-0897-c929b3f23e9f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8a4ba8c-f749-26ab-0897-c929b3f23e9f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 04, 2017 at 03:28:04PM +0200, Hans Verkuil wrote:
> On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> > We only want to link sub-devices that were bound to the async notifier the
> > isp driver registered but there may be other sub-devices in the
> > v4l2_device as well. Check for the correct async notifier.
> 
> Just to be sure I understand this correctly: the original code wasn't wrong as such,
> but this new test is just more precise.

Well, it would be wrong very soon. :-)

So yes. As long as there's just a single user of the async notifiers in for
a V4L2 device, what used to be there works. The other drivers don't seem to
be affected.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
