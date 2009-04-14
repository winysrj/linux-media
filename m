Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1660 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbZDNOvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 10:51:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC] White Balance control for digital camera
Date: Tue, 14 Apr 2009 16:50:59 +0200
Cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	g.liakhovetski@gmx.de, Jean-Francois Moine <moinejf@free.fr>,
	laurent.pinchart@skynet.be,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	=?utf-8?q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>
References: <5e9665e10904091450u3e70cda8w9e1d57e45365a32b@mail.gmail.com> <20090414085402.10293cfd@pedra.chehab.org>
In-Reply-To: <20090414085402.10293cfd@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141650.59580.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 14 April 2009 13:54:02 Mauro Carvalho Chehab wrote:
> On Fri, 10 Apr 2009 06:50:32 +0900
>
> "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com> wrote:
> > Hello everyone,
> >
> > I'm posting this RFC one more time because it seems to everyone has
> > been forgot this, and I'll be appreciated if any of you who is reading
> > this mailing list give me comment.
> >
> > I'm adding some choices for you to make it easier. (even the option
> > for that this is a pointless discussion)
> >
> >
> >
> > I've got a big question popping up handling white balance with
> > V4L2_CID_WHITE_BALANCE_TEMPERATURE CID.
> >
> > Because in digital camera we generally control over user interface
> > with pre-defined white balance name. I mean, user controls white
> > balance with presets not with kelvin number.
> > I'm very certain that TEMPERATURE CID is needed in many of video
> > capture devices, but also 100% sure that white balance preset control
> > is also necessary for digital cameras.
> > How can we control white balance through preset name with existing V4L2
> > API?
> >
> > For now, I define preset names in user space with supported color
> > temperature preset in driver like following.
> >
> > #define MANUAL_WB_TUNGSTEN 3000
> > #define MANUAL_WB_FLUORESCENT 4000
> > #define MANUAL_WB_SUNNY 5500
> > #define MANUAL_WB_CLOUDY 6000
> >
> > and make driver to handle those presets like this. (I split in several
> > ranges to make driver pretend to be generic)
> >
> > case V4L2_CID_WHITE_BALANCE_TEMPERATURE:
> >                if (vc->value < 3500) {
> >                        /* tungsten */
> >                        err = ce131f_cmds(c, ce131f_wb_tungsten);
> >                } else if (vc->value < 4100) {
> >                        /* fluorescent */
> >                        err = ce131f_cmds(c, ce131f_wb_fluorescent);
> >                } else if (vc->value < 6000) {
> >                        /* sunny */
> >                        err = ce131f_cmds(c, ce131f_wb_sunny);
> >                } else if (vc->value < 6500) {
> >                        /* cloudy */
> >                        err = ce131f_cmds(c, ce131f_wb_cloudy);
> >                } else {
> >                        printk(KERN_INFO "%s: unsupported kelvin
> > range\n", __func__);
> >                }
> >                ......
> >
> > I think this way seems to be ugly. Don't you think that another CID is
> > necessary to handle WB presets?
> > Because most of mobile camera modules can't make various color
> > temperatures in expecting kelvin number with user parameter.
> >
> > So, here you are some options you can chose to give your opinion.(or
> > you can make your own opinion)
> >
> > (A). Make a new CID to handle well known white balance presets
> > Like V4L2_CID_WHITE_BALANCE_PRESET for CID and enum values like
> > following for value
> >
> > enum v4l2_whitebalance_presets {
> >      V4L2_WHITEBALANCE_TUNGSTEN  = 0,
> >      V4L2_WHITEBALANCE_FLUORESCENT,
> >      V4L2_WHITEBALANCE_SUNNY,
> >      V4L2_WHITEBALANCE_CLOUDY,
> > ....
> >
> > (B). Define well known kelvin number in videodev2.h as preset name and
> > share with user space
> > Like following
> >
> > #define V4L2_WHITEBALANCE_TUNGSTEN 3000
> > #define V4L2_WHITEBALANCE_FLUORESCENT 4000
> > #define V4L2_WHITEBALANCE_SUNNY 5500
> > #define V4L2_WHITEBALANCE_CLOUDY 6000
> >
> > and use those defined values with V4L2_CID_WHITE_BALANCE_TEMPERATURE
> >
> > urgh.....
> >
> > (C). Leave it alone. It's a pointless discussion. we are good with
> > existing WB API.
> > (really?)
> >
> >
> > I'm very surprised about this kind of needs were not issued yet.
>
> I vote for (B). This is better than creating another user control for
> something that were already defined. The drivers that don't support
> specifying the color temperature, in Kelvin should round to the closest
> supported value, and return the proper configured value when questioned.

I'm going with A. My reasoning is that presets 1) differ per device, 2) will 
normally be better tested than a random temperature value.

Remember that the control API is meant to export the options that the device 
supports to the application. So the presets cannot be defined as macros but 
must really come from the device driver. An application can then show the 
available presets to the user.

I wonder if these two aren't mutually exclusive: you either can use any 
value, or only use presets.

Laurent, I see that uvc supports it: does the uvc standard mention anything 
with regards to presets?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
