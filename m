Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:39612 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753574AbcJNPtH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 11:49:07 -0400
Message-ID: <1476460145.11834.47.camel@pengutronix.de>
Subject: Re: [PATCH 12/22] [media] tc358743: put lanes in STOP state before
 starting streaming
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Marek Vasut <marex@denx.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
Date: Fri, 14 Oct 2016 17:49:05 +0200
In-Reply-To: <70746e61-ac7d-a773-35a2-8296d0119efb@denx.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-13-p.zabel@pengutronix.de>
         <70746e61-ac7d-a773-35a2-8296d0119efb@denx.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 07.10.2016, 21:02 +0200 schrieb Marek Vasut:
> On 10/07/2016 06:00 PM, Philipp Zabel wrote:
> > Without calling tc358743_set_csi from the new prepare_stream callback
> > (or calling tc358743_s_dv_timings or tc358743_set_fmt from userspace
> > after stopping the stream), the i.MX6 MIPI CSI2 input fails waiting
> > for lanes to enter STOP state when streaming is started again.
> 
> What is the impact of that failure ? How does it manifest itself ?

The i.MX MIPI CSI-2 driver fails waiting for the lanes to enter stop
state. If the error is ignored, stream startup is not reliable.

I'll handle this a bit differently in the next version.

regards
Philipp

