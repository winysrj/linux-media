Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZG3DGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 23:06:45 -0400
Date: Thu, 30 Jul 2009 00:06:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: acano@fastmail.fm, linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Message-ID: <20090730000634.21fea61a@pedra.chehab.org>
In-Reply-To: <cb2af7c6ef118cb5fe1fab2720ec7973.squirrel@webmail.xs4all.nl>
References: <20090718173758.GA32708@localhost.localdomain>
	<20090729000753.GA24496@localhost.localdomain>
	<20090729015730.34ab86c6@pedra.chehab.org>
	<200907290809.32089.hverkuil@xs4all.nl>
	<20090729094009.6dc01728@pedra.chehab.org>
	<7aa4c771a5b1cf3117cf9faf027cc05c.squirrel@webmail.xs4all.nl>
	<20090729114211.065ed01f@pedra.chehab.org>
	<cb2af7c6ef118cb5fe1fab2720ec7973.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Jul 2009 17:08:31 +0200
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> > I did some tests here: if we replace -EINVAL with -ENOIOCTLCMD, we can
> > properly
> > make v4l2_device_call_until_err() to work, fixing the lack of a proper
> > error
> > report at the drivers. This error code seems also appropriate for this
> > case.
> 
> This is not sufficient: v4l2_device_call_until_err is not really suitable
> for this. 

Agreed. Yet, the tests helped to see what changes were needed.

>This would be better:
> 
> #define __v4l2_device_call_subdevs_ctrls(v4l2_dev, cond, o, f, args...) \
> ({                                                                      \
>         struct v4l2_subdev *sd;                                         \
>         long err = 0;                                                   \
>                                                                         \
>         list_for_each_entry(sd, &(v4l2_dev)->subdevs, list) {           \
>                 if ((cond) && sd->ops->o && sd->ops->o->f)              \
>                         err = sd->ops->o->f(sd , ##args);               \
>                 if (err && err != -ENOIOCTLCMD)                         \

No, this is not right. In the case of controls, it should be, instead:

                 if (err != -ENOIOCTLCMD)

Also, such routine is has nothing specific for ctrls, so, the naming doesn't
look nice. I'll find a better name.

>                         break;                                          \
>         }                                                               \
>         (err == -ENOIOCTLCMD) ? -EINVAL : err;                          \
> })
> 
> This way -EINVAL is returned if the control isn't handled anywhere.

Ok, but I'm in doubt if -EINVAL is the better return code on such case, but, in
order to not break backward compatibility, better to return -EINVAL.

> >
> > This means several trivial patches on each v4l device driver, just
> > replacing
> > the error codes for 3 ioctl handlers (s_ctrl, g_ctrl, queryctrl).
> >
> > I'll try to write such patches for v4l devices, since I want to get rid of
> > this
> > bug on 2.6.31, at least on em28xx driver. If I have more time, I'll fix
> > other
> > bridge drivers as well.
> 
> Keep in mind that changing this for one i2c driver will mean that you have
> to check its behavior on all v4l2 drivers that use that i2c driver.

As drivers currently don't check for the returned code (maybe except for a very
few ones), this probably is not a big issue. Yet, I'll use a semantic check to
generate the patches, to be sure that all cases were covered.

> >> Currently the control handling code in our v4l drivers is, to be blunt,
> >> a
> >> pile of crap. And it is ideal to move this into the v4l2 framework since
> >> 90% of this is common code.
> >
> > Hmm, except for a few places that still implement this at the old way,
> > most of
> > the common code is already at v4l2 core. So, I'm not sure what you're
> > referring.
> 
> Just to name a few:
> 
> 1) Range checking of the control values.
> 2) Generic handling of QUERYCTRL/QUERYMENU including standard support for
> the V4L2_CTRL_FLAG_NEXT_CTRL.
> 3) Generic handling of the VIDIOC_G/S/TRY_EXT_CTRLS ioctls so all drivers
> can handle them.
> 4) Controls that are handled in subdevs should be automatically detected
> by the core so that they are enumerated correctly.
> 
> There really is no support for this in the core, except for some utility
> functions in v4l2-common.c.

Ok.



Cheers,
Mauro
