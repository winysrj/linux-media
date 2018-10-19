Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49809 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbeJSR6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 13:58:40 -0400
Message-ID: <1539942796.3395.8.camel@pengutronix.de>
Subject: Re: [PATCH v3 01/16] media: imx: add mem2mem device
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, nicolas@ndufresne.ca,
        Sascha Hauer <kernel@pengutronix.de>
Date: Fri, 19 Oct 2018 11:53:16 +0200
In-Reply-To: <CAJ+vNU2vraT=vUwS+1TYKuX50OsjZsNaN220y1kz8XgHvC48Sg@mail.gmail.com>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
         <20180918093421.12930-2-p.zabel@pengutronix.de>
         <CAJ+vNU2vraT=vUwS+1TYKuX50OsjZsNaN220y1kz8XgHvC48Sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Thu, 2018-10-18 at 15:53 -0700, Tim Harvey wrote:
[...]
> Philipp,
> 
> Thanks for submitting this!
> 
> I'm hoping this lets us use non-IMX capture devices along with the IMX
> media controller entities to so we can use hardware
> CSC,scaling,pixel-format-conversions and ultimately coda based encode.
> 
> I've built this on top of linux-media and see that it registers as
> /dev/video8 but I'm not clear how to use it? I don't see it within the
> media controller graph.

It's a V4L2 mem2mem device that can be handled by the GstV4l2Transform
element, for example. GStreamer should create a v4l2video8convert
element of that type.

The mem2mem device is not part of the media controller graph on purpose.
There is no interaction with any of the entities in the media controller
graph apart from the fact that the IC PP task we are using for mem2mem
scaling is sharing hardware resources with the IC PRP tasks used for the
media controller scaler entitites.

regards
Philipp
