Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42942 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab2LZRXa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:23:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/6] uvcvideo: Set error_idx properly for extended controls API failures
Date: Wed, 26 Dec 2012 18:24:55 +0100
Message-ID: <3834685.337VIDFL8D@avalon>
In-Reply-To: <20121226120035.237e242f@redhat.com>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <22611337.csYnEZHssR@avalon> <20121226120035.237e242f@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 26 December 2012 12:00:35 Mauro Carvalho Chehab wrote:
> Em Wed, 26 Dec 2012 12:33:58 +0100 Laurent Pinchart escreveu:
> > On Tuesday 25 December 2012 12:50:51 Hans Verkuil wrote:
> > > On Tue December 25 2012 12:23:00 Laurent Pinchart wrote:
> > > > On Tuesday 25 December 2012 12:15:25 Hans Verkuil wrote:
> > > > > On Mon December 24 2012 13:27:08 Laurent Pinchart wrote:
> > > > > > On Thursday 27 September 2012 17:16:15 Laurent Pinchart wrote:
> > > > > > > When one of the requested controls doesn't exist the error_idx
> > > > > > > field must reflect that situation. For G_EXT_CTRLS and
> > > > > > > S_EXT_CTRLS, error_idx must be set to the control count. For
> > > > > > > TRY_EXT_CTRLS, it must be set to the index of the unexisting
> > > > > > > control.
> > > > > > > 
> > > > > > > This issue was found by the v4l2-compliance tool.
> > > > > > 
> > > > > > I'm revisiting this patch as it has been reverted in v3.8-rc1.
> > > > > > 
> > > > > > > Signed-off-by: Laurent Pinchart
> > > > > > > <laurent.pinchart@ideasonboard.com>
> > > > > > > ---
> > > > > > > 
> > > > > > >  drivers/media/usb/uvc/uvc_ctrl.c |   17 ++++++++++-------
> > > > > > >  drivers/media/usb/uvc/uvc_v4l2.c |   19 ++++++++++++-------
> > > > > > >  2 files changed, 22 insertions(+), 14 deletions(-)
> > > > > > 
> > > > > > [snip]
> > > > > > 
> > > > > > > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > > > > > > b/drivers/media/usb/uvc/uvc_v4l2.c index f00db30..e5817b9 100644
> > > > > > > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > > > > > > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > > > > > > @@ -591,8 +591,10 @@ static long uvc_v4l2_do_ioctl(struct file
> > > > > > > *file,
> > > > > > 
> > > > > > [snip]
> > > > > > 
> > > > > > > @@ -637,8 +639,9 @@ static long uvc_v4l2_do_ioctl(struct file
> > > > > > > *file,
> > > > > > > unsigned int cmd, void *arg) ret = uvc_ctrl_get(chain, ctrl);
> > > > > > > 
> > > > > > >  			if (ret < 0) {
> > > > > > >  			
> > > > > > >  				uvc_ctrl_rollback(handle);
> > > > > > > 
> > > > > > > -				ctrls->error_idx = i;
> > > > > > > -				return ret;
> > > > > > > +				ctrls->error_idx = ret == -ENOENT
> > > > > > > +						 ? ctrls->count : i;
> > > > > > > +				return ret == -ENOENT ? -EINVAL : ret;
> > > > > > > 
> > > > > > >  			}
> > > > > > >  		
> > > > > > >  		}
> > > > > > >  		ctrls->error_idx = 0;
> > > > > > > 
> > > > > > > @@ -661,8 +664,10 @@ static long uvc_v4l2_do_ioctl(struct file
> > > > > > > *file,
> > > > > > > unsigned int cmd, void *arg) ret = uvc_ctrl_set(chain, ctrl);
> > > > > > > 
> > > > > > >  			if (ret < 0) {
> > > > > > >  			
> > > > > > >  				uvc_ctrl_rollback(handle);
> > > > > > > 
> > > > > > > -				ctrls->error_idx = i;
> > > > > > > -				return ret;
> > > > > > > +				ctrls->error_idx = (ret == -ENOENT &&
> > > > > > > +						    cmd == VIDIOC_S_EXT_CTRLS)
> > > > > > > +						 ? ctrls->count : i;
> > > > > > > +				return ret == -ENOENT ? -EINVAL : ret;
> > > > > > > 
> > > > > > >  			}
> > > > > > >  		
> > > > > > >  		}
> > > > > > 
> > > > > > I've reread the V4L2 specification, and the least I can say is
> > > > > > that the text is pretty ambiguous. Let's clarify it.
> > > > > > 
> > > > > > Is there a reason to differentiate between invalid control IDs and
> > > > > > other errors as far as error_idx is concerned ? It would be
> > > > > > simpler if error_idx was set to the index of the first error for
> > > > > > get and try operations, regardless of the error type. What do you
> > > > > > think ?
> > > > > 
> > > > > There is a good reason for doing this: the G/S_EXT_CTRLS ioctls have
> > > > > to be as atomic as possible, i.e. it should try hard to prevent
> > > > > leaving the hardware in an inconsistent state because not all
> > > > > controls could be set. It can never be fully atomic since writing
> > > > > multiple registers over usb or i2c can always return errors for one
> > > > > of those writes, but it should certainly check for all the obvious
> > > > > errors first that do not require actually writing to the hardware,
> > > > > such as whether all the controls in the control list actually exist.
> > > > > 
> > > > > And for such errors error_idx should be set to the number of
> > > > > controls to indicate that none of the controls were actually set but
> > > > > that there was a problem with the list of controls itself.
> > > > 
> > > > For S_EXT_CTRLS, sure, but G_EXT_CTRLS doesn't modify the hardware
> > > > state, so it could get all controls up to the erroneous one.
> > > 
> > > I have thought about that but I decided against it. One reason is to
> > > have get and set behave the same since both access the hardware. The
> > > other reason is that even getting a control value might change the
> > > hardware state, for example by resetting some internal hardware counter
> > > when a register is read (it's rare but there is hardware like that).
> > > Furthermore, reading hardware registers can be slow so why not do the
> > > sanity check first?
> > 
> > Get can indeed change the device state in rare cases, but the information
> > won't be lost, as the value of all controls before error_idx will be
> > returned.
>
> Huh? reading a control should never alter the device's state. If the
> hardware is resetting a register, then such register should be shadowed,
> and some other way to explicitly reset its value should be used.

The hardware can expose a read-only counter in such a way that the counter is 
reset when read. That would be pretty rare for V4L devices though, I'm not 
aware of any such implementation in any of the devices we support. A common 
way to handle those registers is to turn then in software into a counter that 
is never reset, so we have a solution anyway (this is getting a bit out of 
scope).

> > What bothers me with the current G_EXT_CTRLS implementation (beside that
> > it's very slightly more complex for the uvcvideo driver than the one I
> > propose) is that an application will have no way to know for which
> > control G_EXT_CTRLS failed. This is especially annoying during
> > development.
> > 
> > Maybe we could leave this behaviour as driver-specific ?
> 
> driver-specific behavior for IOCTL's should be avoided, as applications will
> fail if they see something it doesn't expect.

I'm not asking for an unspecified behaviour here, but for giving freedom to 
drivers to choose among the specified behaviours. The V4L specification 
explains that the error_idx can be set to the total number of controls, in 
which case no control was read or written, or to the index of the first 
erroneous control, in which case all controls before that index are read or 
written successfully. For get operations I believe that getting all controls 
up to the first error is the best behaviour (even when we can detect errors 
such as invalid control IDs up front), but I'm not opposed to drivers 
returning error_idx set to the total number of controls without getting any 
control.

-- 
Regards,

Laurent Pinchart

