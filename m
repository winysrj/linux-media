Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41687 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbcIUMiY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 08:38:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/7] ov7670: add devicetree support
Date: Wed, 21 Sep 2016 15:39:13 +0300
Message-ID: <4483871.dyhER8N5Lv@avalon>
In-Reply-To: <20160921113328.GD18295@valkosipuli.retiisi.org.uk>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl> <3513546.0HAk52lbkG@avalon> <20160921113328.GD18295@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

On Wednesday 21 Sep 2016 14:33:29 Sakari Ailus wrote:
> Hi Laurent,
> 
> On Wed, Aug 17, 2016 at 03:44:00PM +0300, Laurent Pinchart wrote:
> > > +			assigned-clock-rates = <24000000>;
> > 
> > You should compute and set the clock rate dynamically in the driver, not
> > hardcode it in DT.
> 
> This frequency is typically defined by hardware engineers and it's
> hand-picked from possible ranges. What counts is EMC so you don't disturb
> a GSM/3G/4G modem (if you have one) or GPS receiver, for instance. In order
> to freely choose this frequency, you'd also need to be aware of the limits
> of the sensor's internal clock tree, and make sure you still would be able
> to obtain the desired frame rates for there are often corner cases where the
> resulting maximum pixel clock may be substantially lower if your input
> frequency goes up.
> 
> I also haven't encountered a use case for more than a single, fixed
> frequency. In other words I'd keep this constant.

My review predates our recent discussion on this topic. I still believe that 
in the general case we could want to express allowable frequencies constraints 
in DT and let the driver compute the desired frequency based on timings. 
However, I also agree that there are very few cases for this, so it's not 
really worth tackling the issue at the moment. I'm thus fine with the usage of 
assigned-clock-rates.

-- 
Regards,

Laurent Pinchart

