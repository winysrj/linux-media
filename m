Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:5113 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755081Ab0IMMtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 08:49:55 -0400
Subject: Re: [PATCH] Illuminators control
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
In-Reply-To: <201009131007.58665.hverkuil@xs4all.nl>
References: <20100911110350.02c55173@tele>
	 <201009130908.37133.laurent.pinchart@ideasonboard.com>
	 <201009131007.58665.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 08:49:32 -0400
Message-ID: <1284382172.2031.45.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-09-13 at 10:07 +0200, Hans Verkuil wrote:
> On Monday, September 13, 2010 09:08:36 Laurent Pinchart wrote:
> > Hi,
> > 
> > On Saturday 11 September 2010 11:03:50 Jean-Francois Moine wrote:
> > 
> > > @@ -419,6 +421,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum 
> > v4l2_ctrl_type *type,
> > >  	case V4L2_CID_AUDIO_LIMITER_ENABLED:
> > >  	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> > >  	case V4L2_CID_PILOT_TONE_ENABLED:
> > > +	case V4L2_CID_ILLUMINATORS_1:
> > > +	case V4L2_CID_ILLUMINATORS_2:
> > >  		*type = V4L2_CTRL_TYPE_BOOLEAN;
> > >  		*min = 0;
> > >  		*max = *step = 1;
> > 
> > I would prefer integer controls for this, as we will need to support dimmable 
> > illuminators.
> > 
> > 
> 
> Don't. That should be a separate control. I expect that the brightness is
> something you touch a lot less than the on/of controls. Anyway, I think it
> makes a lot more sense to separate these two functions.



I would need to research what computerized microscopes today actually
have.

A quick look reveals: 
	http://www.bodelin.com/proscopehr/how_it_works/
	http://www.ecoscopestore.com/main.sc
	http://www.microscopeworld.com/MSWorld/Microscope-World/Digital-Microscopes/

handheld units likely have only on/off control for illumination.
Eyepiece cameras rely on what the existing laboratory microscope already
has for illumination.


In my limited experience, there are some microscope controls that a
human is going to have his hands on to get the desired image:
magnification, focus, and specimen position.  Illumination intensity
seems like it would fit in that group.

When I had a job in college fixing medical equipment, most microscopes
limited light using a mechanical iris controlled by hand.  The
illuminator was simply an on/off switch.  (BTW a mechanical iris is a
pain to take apart and rebuild.)  Light filters could be installed
between the illuminator and the iris. 

On some of the "digital microscopes" in the links above, you can see the
iris assembly underneath the stage.  The DMBA210 microscope has both a
manual iris and an illumination intensity knob.


So for digital microscopes we may not see illumination intensity
controllable by software.  Maybe for other types of cameras we will.

Regards,
Andy



