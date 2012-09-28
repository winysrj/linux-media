Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2135 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab2I1RIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 13:08:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] add LNA support for DVB API
Date: Fri, 28 Sep 2012 19:07:47 +0200
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <E1THIJb-0006hA-NK@www.linuxtv.org> <201209281621.35561.hverkuil@xs4all.nl> <20120928123005.6e1c4a74@redhat.com>
In-Reply-To: <20120928123005.6e1c4a74@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209281907.47334.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 28 2012 17:30:05 Mauro Carvalho Chehab wrote:
> Em Fri, 28 Sep 2012 16:21:35 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Fri September 28 2012 14:43:32 Hans Verkuil wrote:
> > > Hi Antti,
> > > 
> > > Mauro asked me to look into LNA as well, in particular how this could be done
> > > on the analog side as well.
> 
> Thanks for that!
> 
> > > 
> > > While reading through this patch I noticed that the new property was added to
> > > dtv_property_process_set, but not to dtv_property_process_get. Can you look
> > > into that and add 'get' support for this property?
> > 
> > It's a sign of insanity when you start replying to your own email, but so
> > be it :-)
> 
> :)
> 
> > 
> > I've been thinking how this can be implemented in such a way that it works
> > well in all the various board/tuner configurations.
> > 
> > First, the property should be cached in dtv_frontend_properties, that way
> > tuners with a built-in LNA can use it. The initial value should be AUTO,
> > I guess.
> > 
> > The property_process_set code changes to:
> > 
> > 	case DTV_LNA:
> > 		if (fe->ops.set_lna)
> > 			r = fe->ops.set_lna(fe, tvp->u.data);
> > 		if (!r)
> > 			c->lna = tvp->u.data;
> > 		break;
> > 
> > Tuners can now check the c->lna value when set_params is called and take the
> > appropriate steps if they have a built-in LNA.
> >
> > To be able to access the LNA from the V4L2 side you would need to add two
> > new tuner ops in include/media/v4l2-subdev.h:
> > 
> > 	int (*g_lna)(struct v4l2_subdev *sd, u32 *lna);
> > 	int (*s_lna)(struct v4l2_subdev *sd, u32 lna);
> > 
> > The tuner-core.c driver can implement these ops to get and set c->lna accordingly.
> > 
> > A menu control would be needed to actually change the LNA.
> > 
> > The code that handles that control would have to call a board-specific function
> > if necessary (if the LNA is on the board), and call the tuner's s_lna op otherwise.
> > 
> 
> Makes sense.
> 
> > > The only question is whether the digital and analog APIs should share the same
> > LNA setting or keep different LNA states for each.
> > 
> > So if I call DTV_LNA to set the LNA, and then check the LNA control value from V4L2,
> > should the two match? Or should we keep separate states and whenever you select
> > digital or analog mode the LNA is updated with the corresponding LNA value for that
> > mode.
> > 
> > The latter is a bit more work (struct analog_parameters should probably be extended
> > with an LNA value), but I do think it is a cleaner solution.
> 
> I think they both should share the same LNA state, as this depends on the physical
> connection (e. g. if the antenna has LNA; if the signal reception is weak or strong
> with that particular antenna).
> 
> > I am not sure if the LNA work on the analog side should be done without having
> > hardware that actually uses it, but at least the LNA support on the digital side
> > should be done in such a way that it can be extended for analog as well.
> 
> There are several saa7134 hardware with LNA support. I have one of such boards
> here, although never needed to dig into the LNA stuff on it.

I'll wait until Antti makes the necessary changes on the digital side, after that
I'll see if I can make a patch for the analog part, and post that. There is an
outside chance that I have a board with an LNA as well: for ivtv there were issues
with a Samsung TCPN 2121P30A tuner where the LNA had to be turned on or off manually
(it should have been automatic but due to a hardware bug that didn't work). This
was never supported in ivtv, but this would make a good test case.

The only problem is that I don't know if I still have that card or if I gave it
to Andy. I think it went to him, actually.

Regards,

	Hans
