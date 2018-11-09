Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51705 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbeKIX1R (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 18:27:17 -0500
Date: Fri, 9 Nov 2018 14:46:24 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 0/9] TVP5150 fixes and new features
Message-ID: <20181109134624.2fxin2erjun57lrh@pengutronix.de>
References: <20180918131453.21031-1-m.felsch@pengutronix.de>
 <20181029184113.5tfdjdlj75m2wd6m@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029184113.5tfdjdlj75m2wd6m@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I don't want to spam you. Can you give me some feedback? I know the
merge window is a busy time, so maybe you have some time now.

Regards,
Marco

On 18-10-29 19:41, Marco Felsch wrote:
> Hi Mauro,
> 
> just a reminder, Rob already added his ack/rev-by tags.
> 
> Thanks,
> Marco
> 
> On 18-09-18 15:14, Marco Felsch wrote:
> > Hi,
> > 
> > this is my v3 with the integrated reviews from my v2 [1]. This serie
> > applies to Mauro's experimental.git [2].
> > 
> > @Mauro:
> > Patch ("media: tvp5150: fix irq_request error path during probe") is new
> > in this series. Maybe you can squash them with ("media: tvp5150: Add sync lock
> > interrupt handling"), thanks.
> > 
> > I've tested this series on a customer dt-based board. Unfortunately I
> > haven't a device which use the em28xx driver. So other tester a welcome :)
> > 
> > [1] https://www.spinics.net/lists/devicetree/msg244129.html
> > [2] https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150-4
> > 
> > Javier Martinez Canillas (1):
> >   partial revert of "[media] tvp5150: add HW input connectors support"
> > 
> > Marco Felsch (7):
> >   media: tvp5150: fix irq_request error path during probe
> >   media: tvp5150: add input source selection of_graph support
> >   media: dt-bindings: tvp5150: Add input port connectors DT bindings
> >   media: v4l2-subdev: add stubs for v4l2_subdev_get_try_*
> >   media: v4l2-subdev: fix v4l2_subdev_get_try_* dependency
> >   media: tvp5150: add FORMAT_TRY support for get/set selection handlers
> >   media: tvp5150: add s_power callback
> > 
> > Michael Tretter (1):
> >   media: tvp5150: initialize subdev before parsing device tree
> > 
> >  .../devicetree/bindings/media/i2c/tvp5150.txt |  92 ++-
> >  drivers/media/i2c/tvp5150.c                   | 657 +++++++++++++-----
> >  include/dt-bindings/media/tvp5150.h           |   2 -
> >  include/media/v4l2-subdev.h                   |  15 +-
> >  4 files changed, 584 insertions(+), 182 deletions(-)
> > 
> > -- 
> > 2.19.0
> > 
> > 
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
