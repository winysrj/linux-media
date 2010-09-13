Return-path: <mchehab@localhost.localdomain>
Received: from perceval.irobotique.be ([92.243.18.41]:46846 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0IMGxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 02:53:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] Illuminators and status LED controls
Date: Mon, 13 Sep 2010 08:53:45 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20100906201105.4029d7e7@tele> <201009071730.33642.hverkuil@xs4all.nl> <4C86AB22.7020206@redhat.com>
In-Reply-To: <4C86AB22.7020206@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130853.46563.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Hi Hans,

On Tuesday 07 September 2010 23:14:10 Hans de Goede wrote:
> On 09/07/2010 05:30 PM, Hans Verkuil wrote:

[snip]

> Also note that at least with the uvc driver that due to how extension
> unit controls are working (the uvcvideo driver gets told about these
> vendor specific controls from a userspace helper), the menu index is
> the value which gets written to the hardware! So one cannot simply
> make this match some random enum.

That's not correct. The UVC driver maps the menu index to the hardware value, 
so there shouldn't be any problem here.

[snip]

> > This looks pretty decent IMHO:
> > 
> > enum v4l2_illuminator {
> > 
> >          V4L2_ILLUMINATOR_OFF = 0,
> >          V4L2_ILLUMINATOR_ON = 1,
> > 
> > };
> > #define V4L2_CID_ILLUMINATOR_0              (V4L2_CID_BASE+37)
> > #define V4L2_CID_ILLUMINATOR_1              (V4L2_CID_BASE+38)
> 
> I don't like this, as explained before most microscopes have a top
> and a bottom light, and you want to switch between them, or to
> all off, or to all on. So having a menu with 4 options for this
> makes a lot more sense then having 2 separate controls. Defining
> these values as standard values would take away the option for drivers
> to do something other then a simple on / off control here. Again
> what is wrong with with not defining standard meanings for standard
> controls with a menu type. This means less stuff in videodev2.h
> and more flexibility wrt using these control ids.
> 
> I think we should not even define a type for this one. If we
> get microscopes with pwm control for the lights we will want this
> to be an integer using one control per light.

LED dimming using PWM is something we can surely expect in the future, if not 
already available in existing devices.


-- 
Regards,

Laurent Pinchart
