Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3565 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1FLSJU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 14:09:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv4 PATCH 1/8] tuner-core: rename check_mode to supported_mode
Date: Sun, 12 Jun 2011 20:09:10 +0200
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <201106121807.32764.hverkuil@xs4all.nl> <4DF4F6F9.60202@redhat.com>
In-Reply-To: <4DF4F6F9.60202@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106122009.10116.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, June 12, 2011 19:27:21 Mauro Carvalho Chehab wrote:
> Em 12-06-2011 13:07, Hans Verkuil escreveu:
> > On Sunday, June 12, 2011 16:37:55 Mauro Carvalho Chehab wrote:
> >> Em 12-06-2011 07:59, Hans Verkuil escreveu:
> >>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> The check_mode function checks whether a mode is supported. So calling it
> >>> supported_mode is more appropriate. In addition it returned either 0 or
> >>> -EINVAL which suggests that the -EINVAL error should be passed on. However,
> >>> that's not the case so change the return type to bool.
> >>
> >> I prefer to keep returning -EINVAL. This is the proper thing to do, and
> >> to return the result to the caller. A fixme should be added though, so,
> >> after someone add a subdev call that would properly handle the -EINVAL
> >> code for multiple tuners, the functions should return the error code
> >> instead of 0.
> > 
> > No, you can't return -EINVAL here. It is the responsibility of the bridge
> > driver to determine whether there is e.g. a radio tuner. So if one of these
> > tuner subdevs is called with mode radio while it is a tv tuner, then that
> > is not an error, but instead it is a request that can safely be ignored
> > as not relevant for that tuner. It is up to the bridge driver to ensure
> > that a tuner is loaded that is actually valid for the radio mode.
> > 
> > Subdev ops should only return errors when there is a real problem (e.g. i2c
> > errors) and should just return 0 if a request is not for them.
> > 
> > That's why I posted these first two patches: these functions suggest that you
> > can return an error if the mode doesn't match when you really cannot.
> > 
> > If I call v4l2_device_call_until_err() for e.g. s_frequency, then the error
> > that is returned should match a real error (e.g. an i2c error), not that one
> > of the tv tuners refused the radio mode. I know there is a radio tuner somewhere,
> > otherwise there wouldn't be a /dev/radio node.
> > 
> > I firmly believe that the RFCv4 series is correct and just needs an additional
> > patch adding some documentation.
> > 
> > That said, it would make sense to move the first three patches to the end
> > instead if you prefer. Since these are cleanups, not bug fixes like the others.
> 
> 
> The errors at tuner should be propagated. If there's just one tuner, the error
> code should just be returned by the ioctl. But, if there are two tuners, if the bridge 
> driver calls G_TUNER (or any other tuner subdev call) and both tuners return -EINVAL, 
> then it needs to return -EINVAL to userspace. If just one returns -EINVAL, and the 
> other tuner returns 0, then it should return 0. So, it is about the opposite behaviour 
> implemented at v4l2_device_call_until_err().

Sorry, but no, that's not true. You are trying to use the error codes from tuner
subdevs to determine whether none of the tuner subdevs support a certain tuner mode.

E.g., you want to change something for a radio tuner and there are no radio tuner
subdevs. But that's the job of the bridge driver to check. That has the overview,
the lowly subdevs do not. The subdevs just filter the ops and check the mode to see
if they should handle it and ignore it otherwise.

Only if they have to handle it will they return a possible error. The big problem
with trying to use subdev errors codes for this is that you don't see the difference
between a real error of a subdev (e.g. -EIO when an i2c access fails) and a subdev
that returns -EINVAL just because it didn't understand the tuner mode.

So the bridge may return -EINVAL to the application instead of the real error, which
is -EIO.

That's the whole principle behind the sub-device model: sub-devices do not know
about 'the world outside'. So if you pass RADIO mode to S_FREQUENCY and there is no
radio tuner, then the bridge driver is the one that should detect that and return
-EINVAL.

Actually, as mentioned before, it can also be done in video_ioctl2.c by checking
the tuner mode against the device node it's called on. But that requires tightening
of the V4L2 spec first.

Regards,

	Hans

> In order to implement the correct behaviour, the tuner driver should return -EINVAL if
> check_mode/set_mode fails. However, this breaks any bridge that may be using 
> v4l2_device_call_until_err(). That's why the current code returns 0.
> 
> The proper fix for it is:
> 
> 	1) create a call_all function that returns 0 if one of the subdevs returned 0,
> or returns an error code otherwise;
> 	2) change all bridge calls to tuner stuff to the new call_all function;
> 	3) return the check_mode/set_mode error to the bridge.
> 
> One alternative for (1) would be to simply change the v4l2_device_call_all() to return 0 if
> one of the subdrivers returned 0. Something like (not tested):
> 
> 
> #define __v4l2_device_call_subdevs_p(v4l2_dev, sd, cond, o, f, args..$
> ({                                                                      \
>         long __rc = 0, __err = 0;                                       \
>                                                                         \
>         list_for_each_entry((sd), &(v4l2_dev)->subdevs, list) {		\
>                 if ((cond) && (sd)->ops->o && (sd)->ops->o->f) {	\
>                         __err = (sd)->ops->o->f((sd) , ##args);		\
> 			if (_err)					\
> 	                        __rc = __err;                           \
> 		}							\
>         }                                                               \
>         __rc;								\
> })
> 
> 
> #define v4l2_device_call_all(v4l2_dev, grpid, o, f, args...)            \
>         do {                                                            \
>                 struct v4l2_subdev *__sd;				\
>                                                                        	\
>                 __v4l2_device_call_subdevs_p(v4l2_dev, __sd,		\
>                         !(grpid) || __sd->grp_id == (grpid), o, f ,     \
>                         ##args);                                        \
>         } while (0)
> 
> 
> As it currently doesn't return any error, this shouldn't break any driver 
> (as nobody expects an error code there). We'll need to review the bridge 
> drivers anyway, so that they'll return the error code from v4l_device_call().
> 
> Cheers,
> Mauro.
> 
