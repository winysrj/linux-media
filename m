Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50528 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2L0MD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 07:03:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/6] uvcvideo: Set error_idx properly for extended controls API failures
Date: Thu, 27 Dec 2012 13:04:51 +0100
Message-ID: <5539720.Eg8gGvO6Bf@avalon>
In-Reply-To: <201212271259.15502.hverkuil@xs4all.nl>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <22611337.csYnEZHssR@avalon> <201212271259.15502.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 27 December 2012 12:59:15 Hans Verkuil wrote:
> On Wed December 26 2012 12:33:58 Laurent Pinchart wrote:
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
> > > > > > that
> > > > > > the text is pretty ambiguous. Let's clarify it.
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
> > 
> > What bothers me with the current G_EXT_CTRLS implementation (beside that
> > it's very slightly more complex for the uvcvideo driver than the one I
> > propose) is that an application will have no way to know for which
> > control G_EXT_CTRLS failed. This is especially annoying during
> > development.
> 
> For S_EXT_CTRLS you can call TRY_EXT_CTRLS first to check which control
> failed, but you don't have that option for G_EXT_CTRLS. That's actually
> something I hadn't considered.
> 
> > Maybe we could leave this behaviour as driver-specific ?
> 
> I need to think about this some more. Is this urgent or can it wait until
> January 7th? I'm back at work by then. I am actually attempting to touch my
> computer as little as possible this vacation :-)

There's a v3.8 related regression in uvcvideo that I need to fix, but that can 
certainly wait until January the 7th.

Enjoy your holidays and get away from the keyboard now :-)

-- 
Regards,

Laurent Pinchart

