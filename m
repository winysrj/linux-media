Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57615 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbbGNKKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 06:10:13 -0400
Message-ID: <1436868609.3793.25.camel@pengutronix.de>
Subject: Re: [PATCH 5/5] [media] tc358743: allow event subscription
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kernel@pengutronix.de
Date: Tue, 14 Jul 2015 12:10:09 +0200
In-Reply-To: <55A39BE3.2070905@xs4all.nl>
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de>
	 <1436533897-3060-5-git-send-email-p.zabel@pengutronix.de>
	 <55A39BE3.2070905@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 13.07.2015, 13:07 +0200 schrieb Hans Verkuil:
> On 07/10/2015 03:11 PM, Philipp Zabel wrote:
> > This is useful to subscribe to HDMI hotplug events via the
> > V4L2_CID_DV_RX_POWER_PRESENT control.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/i2c/tc358743.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> > index 4a889d4..91fffa8 100644
> > --- a/drivers/media/i2c/tc358743.c
> > +++ b/drivers/media/i2c/tc358743.c
> > @@ -40,6 +40,7 @@
> >  #include <media/v4l2-dv-timings.h>
> >  #include <media/v4l2-device.h>
> >  #include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> >  #include <media/v4l2-of.h>
> >  #include <media/tc358743.h>
> >  
> > @@ -1604,6 +1605,8 @@ static const struct v4l2_subdev_core_ops tc358743_core_ops = {
> >  	.s_register = tc358743_s_register,
> >  #endif
> >  	.interrupt_service_routine = tc358743_isr,
> > +	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
> 
> Ah, they are set here.
> 
> But note that v4l2_ctrl_subdev_subscribe_event is not enough, since this driver
> also issues the V4L2_EVENT_SOURCE_CHANGE event.
> 
> See this patch on how to do that:
> 
> http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/commit/?h=for-v4.3a&id=85c9b0b83795dac3d27043619a727af5c7313fe7
> 
> Note: requires the new v4l2_subdev_notify_event function that's not yet
> merged (just posted the pull request for that).

Ok, I think I'll split this up and send patch 5 separately, then.

regards
Philipp

