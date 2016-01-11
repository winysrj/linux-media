Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54840 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbcAKMFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 07:05:24 -0500
Date: Mon, 11 Jan 2016 10:05:15 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-api@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] [media] media.h: let be clear that tuners need to use
 connectors
Message-ID: <20160111100515.11337a1e@recife.lan>
In-Reply-To: <CAH-u=83N53gzxGgXZbRAF0aJb_j8Bv0gRLCp6dQwxDuBO90yPA@mail.gmail.com>
References: <16cd172bc9cec7ce438df95c142d2219998e32fe.1449867690.git.mchehab@osg.samsung.com>
	<1667088.5VvxRK5I9C@avalon>
	<CAH-u=83N53gzxGgXZbRAF0aJb_j8Bv0gRLCp6dQwxDuBO90yPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 10 Jan 2016 19:01:27 +0100
Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com> escreveu:

> Hi,
> 
> 2016-01-10 16:30 GMT+01:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Hi Mauro,
> >
> > Thank you for the patch.
> >
> > On Friday 11 December 2015 19:01:31 Mauro Carvalho Chehab wrote:
> >> The V4L2 core won't be adding connectors to the tuners and other
> >> entities that need them. Let it be clear.
> >>
> >> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This patch was added due to Laurent's comments to this patch:
	https://patchwork.linuxtv.org/patch/31279/

> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >> ---
> >>  include/uapi/linux/media.h | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> >> index 86f9753e5c03..cacfceb0d81d 100644
> >> --- a/include/uapi/linux/media.h
> >> +++ b/include/uapi/linux/media.h
> >> @@ -74,10 +74,11 @@ struct media_device_info {
> >>  /*
> >>   * Connectors
> >>   */
> >> +/* It is a responsibility of the entity drivers to add connectors and links
> >
> > Do you mean entity drivers or "master/bridge" (for lack of a better word)
> > drivers ?
> 
> Is is the responsability of the media device I think...

Yes, the device responsible to create the media_device (e. g. the
bridge driver, on USB drivers) is the one responsible to create such
connectors, but answering that question for DT-based devices is not
trivial.

Right now, no DT-based driver create connectors, although, it makes sense to
add support for it in order to properly support the IGEPv2 expansion board:
	https://www.isee.biz/products/igep-expansion-boards/igepv2-expansion

in order to represent the input PAD for the two connector inputs associated
with the TVP5151 analog demux, e. g. entity_81 on the image below:
	https://mchehab.fedorapeople.org/mc-next-gen/omap3-igepv2-with-tvp5150-capture.

>From the board schematics:
	https://www.isee.biz/support/downloads?task=callelement&format=raw&item_id=156&element=f85c494b-2b32-4109-b8c1-083cca2b7db6&method=download&args[0]=3bf010234a287974f527ab93d7e06c32

this board has two RCA input PAD connectors, called "VIDEO IN 1" and
"VIDEO IN 2", connected to tvp5151 pins AIP1A and AIP1B. The tvp5151
is supported by the tvp5150 driver, with is also used by several
USB-based em28xx TV boards.

In the IGEPv2 case, I'm not sure if delegating the task of creating the
video input connectors to the "master" driver (e. g. omap3isp) is the best 
strategy. IMHO, the best is to add DT support for the tvp5150 driver to parse
the input connectors would make more sense than adding it at omap3isp.

That's said, the current input selection framework is crap, at least
on tvp5150 driver: it is using/abusing of v4l2_subdev_audio_ops.s_routing
ops to select the video input. The comment for this field at
include/media/v4l2-subdev.h is:

 * @s_routing: used to define the input and/or output pins of an audio chip,
 *	and any additional configuration data.
 *	Never attempt to use user-level input IDs (e.g. Composite, S-Video,
 *	Tuner) at this level. An i2c device shouldn't know about whether an
 *	input pin is connected to a Composite connector, become on another
 *	board or platform it might be connected to something else entirely.
 *	The calling driver is responsible for mapping a user-level input to
 *	the right pins on the i2c device.

The description is confusing, as "composite, s-video, tuner" is *not* the
audio input. They're actually audio/video inputs. It also delegates the
association of the input ID to the "calling" driver, with doesn't seem to
make much sense for DT.

Also, if we parse the input connectors at the tvp5150, we would need
to add more ops in order to properly support the VIDIOC input ioctls:
VIDIOC_ENUMINPUT, VIDIOC_G_INPUT, VIDIOC_S_INPUT.

So, while the changes at tvp5150 for accepting DT-based input connectors
seem trivial, that would likely require some non-trivial V4L2 core changes
in order to add an "input selection framework". Also, we need to double-check
if it won't cause troubles for the em28xx-based tvp5150 devices.

So, for now, I would prefer to keep the comments there vague, like on the
proposed patch. We may need to revisit it after we add MC support to the
em28xx driver and connectors support for the IGPv2 expansion board.

Regards,
Mauro

> 
> > I don't think it should be the responsibility of the tuner driver to
> > create connectors, as the tuner driver shouldn't know about the entities
> > surrounding it.
> >
> >> */ #define MEDIA_ENT_F_CONN_RF                (MEDIA_ENT_F_BASE + 21)
> >>  #define MEDIA_ENT_F_CONN_SVIDEO              (MEDIA_ENT_F_BASE + 22)
> >>  #define MEDIA_ENT_F_CONN_COMPOSITE   (MEDIA_ENT_F_BASE + 23)
> >> -     /* For internal test signal generators and other debug connectors */
> >> +/* For internal test signal generators and other debug connectors */
> >>  #define MEDIA_ENT_F_CONN_TEST                (MEDIA_ENT_F_BASE + 24)
> >>
> >>  /*
> >> @@ -105,6 +106,10 @@ struct media_device_info {
> >>  #define MEDIA_ENT_F_FLASH            (MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
> >>  #define MEDIA_ENT_F_LENS             (MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
> >>  #define MEDIA_ENT_F_ATV_DECODER              (MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
> >> +/*
> >> + * It is a responsibility of the entity drivers to add connectors and links
> >> + *   for the tuner entities.
> >> + */
> >>  #define MEDIA_ENT_F_TUNER            (MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
> >>
> >>  #define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN      MEDIA_ENT_F_OLD_SUBDEV_BASE
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> <div id="DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2"><table
> style="border-top: 1px solid #aaabb6; margin-top: 30px;">
> 	<tr>
> 		<td style="width: 105px; padding-top: 15px;">
> 			<a href="https://www.avast.com/sig-email?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
> target="_blank"><img
> src="https://ipmcdn.avast.com/images/logo-avast-v1.png" style="width:
> 90px; height:33px;"/></a>
> 		</td>
> 		<td style="width: 470px; padding-top: 20px; color: #41424e;
> font-size: 13px; font-family: Arial, Helvetica, sans-serif;
> line-height: 18px;">Cet e-mail a été envoyé depuis un ordinateur
> protégé par Avast. <br /><a
> href="https://www.avast.com/sig-email?utm_medium=email&utm_source=link&utm_campaign=sig-email&utm_content=webmail"
> target="_blank" style="color: #4453ea;">www.avast.com</a> 		</td>
> 	</tr>
> </table>
> <a href="#DDB4FAA8-2DD7-40BB-A1B8-4E2AA1F9FDF2" width="1" height="1"></a></div>
