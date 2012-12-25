Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1511 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2LYLvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Dec 2012 06:51:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/6] uvcvideo: Set error_idx properly for extended controls API failures
Date: Tue, 25 Dec 2012 12:50:51 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <201212251215.25674.hverkuil@xs4all.nl> <1427386.yhbGQRN2rP@avalon>
In-Reply-To: <1427386.yhbGQRN2rP@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212251250.51838.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue December 25 2012 12:23:00 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 25 December 2012 12:15:25 Hans Verkuil wrote:
> > On Mon December 24 2012 13:27:08 Laurent Pinchart wrote:
> > > On Thursday 27 September 2012 17:16:15 Laurent Pinchart wrote:
> > > > When one of the requested controls doesn't exist the error_idx field
> > > > must reflect that situation. For G_EXT_CTRLS and S_EXT_CTRLS, error_idx
> > > > must be set to the control count. For TRY_EXT_CTRLS, it must be set to
> > > > the index of the unexisting control.
> > > > 
> > > > This issue was found by the v4l2-compliance tool.
> > > 
> > > I'm revisiting this patch as it has been reverted in v3.8-rc1.
> > > 
> > > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > ---
> > > > 
> > > >  drivers/media/usb/uvc/uvc_ctrl.c |   17 ++++++++++-------
> > > >  drivers/media/usb/uvc/uvc_v4l2.c |   19 ++++++++++++-------
> > > >  2 files changed, 22 insertions(+), 14 deletions(-)
> > > 
> > > [snip]
> > > 
> > > > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > > > b/drivers/media/usb/uvc/uvc_v4l2.c index f00db30..e5817b9 100644
> > > > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > > > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > > > @@ -591,8 +591,10 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> > > 
> > > [snip]
> > > 
> > > > @@ -637,8 +639,9 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> > > > unsigned int cmd, void *arg) ret = uvc_ctrl_get(chain, ctrl);
> > > > 
> > > >  			if (ret < 0) {
> > > >  			
> > > >  				uvc_ctrl_rollback(handle);
> > > > 
> > > > -				ctrls->error_idx = i;
> > > > -				return ret;
> > > > +				ctrls->error_idx = ret == -ENOENT
> > > > +						 ? ctrls->count : i;
> > > > +				return ret == -ENOENT ? -EINVAL : ret;
> > > > 
> > > >  			}
> > > >  		
> > > >  		}
> > > >  		ctrls->error_idx = 0;
> > > > 
> > > > @@ -661,8 +664,10 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> > > > unsigned int cmd, void *arg) ret = uvc_ctrl_set(chain, ctrl);
> > > > 
> > > >  			if (ret < 0) {
> > > >  			
> > > >  				uvc_ctrl_rollback(handle);
> > > > 
> > > > -				ctrls->error_idx = i;
> > > > -				return ret;
> > > > +				ctrls->error_idx = (ret == -ENOENT &&
> > > > +						    cmd == VIDIOC_S_EXT_CTRLS)
> > > > +						 ? ctrls->count : i;
> > > > +				return ret == -ENOENT ? -EINVAL : ret;
> > > > 
> > > >  			}
> > > >  		
> > > >  		}
> > > 
> > > I've reread the V4L2 specification, and the least I can say is that the
> > > text is pretty ambiguous. Let's clarify it.
> > > 
> > > Is there a reason to differentiate between invalid control IDs and other
> > > errors as far as error_idx is concerned ? It would be simpler if error_idx
> > > was set to the index of the first error for get and try operations,
> > > regardless of the error type. What do you think ?
> > 
> > There is a good reason for doing this: the G/S_EXT_CTRLS ioctls have to be
> > as atomic as possible, i.e. it should try hard to prevent leaving the
> > hardware in an inconsistent state because not all controls could be set. It
> > can never be fully atomic since writing multiple registers over usb or i2c
> > can always return errors for one of those writes, but it should certainly
> > check for all the obvious errors first that do not require actually writing
> > to the hardware, such as whether all the controls in the control list
> > actually exist.
> > 
> > And for such errors error_idx should be set to the number of controls to
> > indicate that none of the controls were actually set but that there was a
> > problem with the list of controls itself.
> 
> For S_EXT_CTRLS, sure, but G_EXT_CTRLS doesn't modify the hardware state, so 
> it could get all controls up to the erroneous one.

I have thought about that but I decided against it. One reason is to have get
and set behave the same since both access the hardware. The other reason is
that even getting a control value might change the hardware state, for example
by resetting some internal hardware counter when a register is read (it's rare
but there is hardware like that). Furthermore, reading hardware registers can
be slow so why not do the sanity check first?

Regards,

	Hans
