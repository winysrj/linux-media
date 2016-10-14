Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38589 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753574AbcJNPso (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 11:48:44 -0400
Message-ID: <1476460123.11834.43.camel@pengutronix.de>
Subject: Re: [PATCH 04/22] [media] v4l2-subdev.h: add prepare_stream op
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de
Date: Fri, 14 Oct 2016 17:48:43 +0200
In-Reply-To: <20161007231620.GE9460@valkosipuli.retiisi.org.uk>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-5-p.zabel@pengutronix.de>
         <20161007231620.GE9460@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 08.10.2016, 02:16 +0300 schrieb Sakari Ailus:
> Hi Philipp,
> 
> On Fri, Oct 07, 2016 at 06:00:49PM +0200, Philipp Zabel wrote:
> > In some cases, for example MIPI CSI-2 input on i.MX6, the sending and
> > receiving subdevice need to be prepared in lock-step before the actual
> > streaming can start. In the i.MX6 MIPI CSI-2 case, the sender needs to
> > put its MIPI CSI-2 transmitter lanes into stop state, and the receiver
> > needs to configure its D-PHY and detect the stop state on all active
> > lanes. Only then the sender can be enabled to stream data and the
> > receiver can lock its PLL to the clock lane.
> 
> Is there a need to explicitly control this? Shouldn't this already be the
> case when the transmitting device is powered on and is not streaming?

Even if the transmitter is expected to keep the lanes in this stop state
all the time while the subdevice is powered but not streaming, I still
have to wait for stop state detection before enabling the transmitter,
and only then enable the reciever.
I'll remove the prepare_streaming callback in the next version and
instead let the subdevices propagate s_stream upstream instead in the
next version.

regards
Philipp

