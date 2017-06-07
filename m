Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33711 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751203AbdFGJh1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 05:37:27 -0400
Message-ID: <1496828246.2268.4.camel@pengutronix.de>
Subject: Re: [PATCH] [media] imx: switch from V4L2 OF to V4L2 fwnode API
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        kernel@pengutronix.de
Date: Wed, 07 Jun 2017 11:37:26 +0200
In-Reply-To: <59c1f567-d1d5-dbbd-284b-5ea810051f39@gmail.com>
References: <20170504133730.19934-1-p.zabel@pengutronix.de>
         <59c1f567-d1d5-dbbd-284b-5ea810051f39@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-06-06 at 18:00 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> v4l2_fwnode patch has been merged to mediatree, so I've applied this
> to my imx-media-staging-md-v16 branch, thanks for the patch!
> 
> However before I can submit version 8 of the patchset, the video-mux
> driver also needs conversion. Can you submit a version 8 of your
> video-mux patchset (your last was v7) containing the switch to
> v4l2-fwnode, and I will incorporate into the imx-media v8 patchset.
> 
> Thanks!
> Steve

I removed the V4L2 OF API dependency from the video-mux driver, so it
works unchanged after the V4L2 fwnode API merge. But I had not yet sent
v8 with the documentation changes suggested by Sakari. Fixed now.

regards
Philipp
