Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44020 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752647AbcJSVbD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 17:31:03 -0400
Date: Thu, 20 Oct 2016 00:30:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
Message-ID: <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 14, 2016 at 07:34:20PM +0200, Philipp Zabel wrote:
> Hi,
> 
> the second round removes the prepare_stream callback and instead lets the
> intermediate subdevices propagate s_stream calls to their sources rather
> than individually calling s_stream on each subdevice from the bridge driver.
> This is similar to how drm bridges recursively call into their next neighbor.
> It makes it easier to do bringup ordering on a per-link level, as long as the
> source preparation can be done at s_power, and the sink can just prepare, call
> s_stream on its source, and then enable itself inside s_stream. Obviously this
> would only work in a generic fashion if all asynchronous subdevices with both
> inputs and outputs would propagate s_stream to their source subdevices.

Hi Philipp,

I'll review the async patches tomorrow / the day after. I have not forgotten
them. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
