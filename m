Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2147 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZG3GkF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 02:40:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Date: Thu, 30 Jul 2009 08:39:46 +0200
Cc: acano@fastmail.fm, linux-media@vger.kernel.org
References: <20090718173758.GA32708@localhost.localdomain> <cb2af7c6ef118cb5fe1fab2720ec7973.squirrel@webmail.xs4all.nl> <20090730000634.21fea61a@pedra.chehab.org>
In-Reply-To: <20090730000634.21fea61a@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907300839.46715.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 30 July 2009 05:06:34 Mauro Carvalho Chehab wrote:
> Em Wed, 29 Jul 2009 17:08:31 +0200
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
> 
> > > I did some tests here: if we replace -EINVAL with -ENOIOCTLCMD, we can
> > > properly
> > > make v4l2_device_call_until_err() to work, fixing the lack of a proper
> > > error
> > > report at the drivers. This error code seems also appropriate for this
> > > case.
> > 
> > This is not sufficient: v4l2_device_call_until_err is not really suitable
> > for this. 
> 
> Agreed. Yet, the tests helped to see what changes were needed.
> 
> >This would be better:
> > 
> > #define __v4l2_device_call_subdevs_ctrls(v4l2_dev, cond, o, f, args...) \
> > ({                                                                      \
> >         struct v4l2_subdev *sd;                                         \
> >         long err = 0;                                                   \
> >                                                                         \
> >         list_for_each_entry(sd, &(v4l2_dev)->subdevs, list) {           \
> >                 if ((cond) && sd->ops->o && sd->ops->o->f)              \
> >                         err = sd->ops->o->f(sd , ##args);               \
> >                 if (err && err != -ENOIOCTLCMD)                         \
> 
> No, this is not right. In the case of controls, it should be, instead:
> 
>                  if (err != -ENOIOCTLCMD)

Indeed.

> 
> Also, such routine is has nothing specific for ctrls, so, the naming doesn't
> look nice. I'll find a better name.

I hacked it together on short notice, so feel to hack it some more :-)

> 
> >                         break;                                          \
> >         }                                                               \
> >         (err == -ENOIOCTLCMD) ? -EINVAL : err;                          \
> > })
> > 
> > This way -EINVAL is returned if the control isn't handled anywhere.
> 
> Ok, but I'm in doubt if -EINVAL is the better return code on such case, but, in
> order to not break backward compatibility, better to return -EINVAL.

I'd love to be able to change the use of EINVAL for unknown controls. I think
there are some other cases as well in the spec where EINVAL is incorrectly
used. But that's almost impossible to change without breaking backwards
compatibility.

The only way I can think of doing this is by having the application explicitly
request such changed behavior. But that's a very slippery slope to go on.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
