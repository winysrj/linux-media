Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47816 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750809AbcJGVwX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 17:52:23 -0400
Date: Sat, 8 Oct 2016 00:52:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Subject: Re: [PATCH 02/22] [media] v4l2-async: allow subdevices to add
 further subdevices to the notifier waiting list
Message-ID: <20161007215216.GB9460@valkosipuli.retiisi.org.uk>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-3-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007160107.5074-3-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Fri, Oct 07, 2016 at 06:00:47PM +0200, Philipp Zabel wrote:
> Currently the v4l2_async_notifier needs to be given a list of matches
> for all expected subdevices on creation. When chaining subdevices that
> are asynchronously probed via device tree, the bridge device that sets
> up the notifier does not know the complete list of subdevices, as it
> can only parse its own device tree node to obtain information about
> the nearest neighbor subdevices.
> To support indirectly connected subdevices, we need to support amending
> the existing notifier waiting list with newly found neighbor subdevices
> with each registered subdevice.

Could you elaborate a little what's the exact use case for this? What kind
of a device?

Thanks.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
