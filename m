Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1863 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2EFPvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 11:51:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFCv2 PATCH 13/17] gspca: switch to V4L2 core locking, except for the buffer queuing ioctls.
Date: Sun, 6 May 2012 17:51:03 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl> <4e0d537b1e1baf060981580d93f400a92ecfe427.1336305565.git.hans.verkuil@cisco.com> <4FA69803.20605@redhat.com>
In-Reply-To: <4FA69803.20605@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205061751.03303.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun May 6 2012 17:25:55 Hans de Goede wrote:
> Hi Hans,
> 
> The entire series looks great, I do have a few remarks wrt this
> patch, which I have fixed in my own tree (new version attached,
> note untested sofar).
> 
> On 05/06/2012 02:28 PM, Hans Verkuil wrote:
> > From: Hans Verkuil<hans.verkuil@cisco.com>
> >
> > Due to latency concerns the VIDIOC_QBUF, DQBUF and QUERYBUF do not use the
> > core lock, instead they rely only on queue_lock.
> >
> > Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
> > ---
> >   drivers/media/video/gspca/gspca.c |  203 ++++++++-----------------------------
> >   1 file changed, 41 insertions(+), 162 deletions(-)
> >
> > diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
> > index f840bed..edca4f3 100644
> > --- a/drivers/media/video/gspca/gspca.c
> > +++ b/drivers/media/video/gspca/gspca.c
> > @@ -850,14 +850,6 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
> >   	struct ep_tb_s ep_tb[MAX_ALT];
> >   	int n, ret, xfer, alt, alt_idx;
> >
> > -	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
> > -		return -ERESTARTSYS;
> > -
> > -	if (!gspca_dev->present) {
> > -		ret = -ENODEV;
> > -		goto unlock;
> > -	}
> > -
> >   	/* reset the streaming variables */
> >   	gspca_dev->image = NULL;
> >   	gspca_dev->image_len = 0;
> 
> You're removing a lot of checks for gspca_dev->present, relying on the
> video_is_registered checks in v4l2-dev instead I assume,

Right. It's likely that all the present checks can be removed, but I just
remove the ones that I knew where unnecessary.

> this is a good
> idea, *but* it requires a small hack in disconnect to close a race.
> 
> Currently the end of gspca_disconnect looks like this:
> 
>          gspca_dev->dev = NULL;
>          v4l2_device_disconnect(&gspca_dev->v4l2_dev);
>          mutex_unlock(&gspca_dev->usb_lock);
> 
>          usb_set_intfdata(intf, NULL);
> 
>          /* release the device */
>          /* (this will call gspca_release() immediately or on last close) */
>          video_unregister_device(&gspca_dev->vdev);
> }
> 
> Notice that usb_lock is unlocked before video_unregister_device gets called,
> which means that any ioctl or other fops waiting for usb_lock can run
> before video_unregister_device runs, and thus before they are protected
> against being called on an disconnected device by the
> video_is_registered checks in v4l2-dev.

True, good catch, I missed that one.

> Unfortunately simply moving the unlock down won't work, because if there
> are no open file handles referencing the device, then the memory
> referenced by gspca_dev will be free-ed after the video_unregister_device
> call.

What you should do (refer to the disconnect implementation in radio/dsbr100.c)
is to use the release callback of struct v4l2_device instead. That way the
memory will be released after you call v4l2_device_put() as the last line in
the disconnect(). The advantage of using the v4l2_device release callback is
that it also works if you have more than one video/radio/vbi node. Only when
the very last user of the very last node exits will the release be called.

Actually, that was the main reason I added it since trying to keep track of
multiple device node references in a driver is doomed to fail.

> So I've changed disconnect to the following in my version, to allow the
> present check removal you've did, as I quite like being able to
> remove all those present checks :)   :
> 
>          /* The USB-interface device is freed at exit of this function */
>          gspca_dev->dev = NULL;
>          v4l2_device_disconnect(&gspca_dev->v4l2_dev);
> 
>          /* Ensure gspca_dev sticks around for the usb_lock unlock! */
>          get_device(&gspca_dev->vdev.dev);
>          video_unregister_device(&gspca_dev->vdev);
>          mutex_unlock(&gspca_dev->usb_lock);
>          /* (this will call gspca_release() immediately or on last close) */
>          put_device(&gspca_dev->vdev.dev);
> 
>          usb_set_intfdata(intf, NULL);
> }
> 
> 
> <snip chunks on which I've no comments>
> 
> > @@ -1736,10 +1658,8 @@ static int vidioc_streamoff(struct file *file, void *priv,
> >   	if (mutex_lock_interruptible(&gspca_dev->queue_lock))
> >   		return -ERESTARTSYS;
> >
> > -	if (!gspca_dev->streaming) {
> > -		ret = 0;
> > -		goto out;
> > -	}
> > +	if (!gspca_dev->streaming)
> > +		return 0;
> >
> 
> BAD! queue_lock is held here, so you cannot just change this to a return!

Good catch. I never tested calling STREAMOFF when not streaming :-)

> 
> >   	/* check the capture file */
> >   	if (gspca_dev->capt_file != file) {
> 
> <snip chunks on which I've no comments>
> 
> > @@ -2009,11 +1883,9 @@ static int vidioc_dqbuf(struct file *file, void *priv,
> >   	gspca_dev->fr_o = (i + 1) % GSPCA_MAX_FRAMES;
> >
> >   	if (gspca_dev->sd_desc->dq_callback) {
> > -		mutex_lock(&gspca_dev->usb_lock);
> >   		gspca_dev->usb_err = 0;
> >   		if (gspca_dev->present)
> >   			gspca_dev->sd_desc->dq_callback(gspca_dev);
> > -		mutex_unlock(&gspca_dev->usb_lock);
> >   	}
> >
> >   	frame->v4l2_buf.flags&= ~V4L2_BUF_FLAG_DONE;
> 
> You cannot remove the locking here, as dq_callback expects to be
> called with the usb-lock locked.
> 
> Since usb-lock now is the device lock and thus gets locked before
> the queue_lock, we cannot simply drop this chunk. Instead I've
> moved the dq_callback to the end of vidioc_dqbuf, so after the
> stream_lock has been released (there is no reason to have
> the stream_lock hold when calling the dq_callback).
> 
> The dq_callback is used to do camera control adjustments which
> need to be done after every X frames, and which cannot be done
> from the isoc frame interrupts since they should not be done under
> interrupt. When the drivers using dq_callback are converted to the
> control framework, they will likely end up calling v4l2_ctrl_s_ctrl
> from the dq_callback.

Can't dq_callback be called at the end of the function? After the
mutex_unlock(&queue_lock)? There we can take the usb_lock, call dq_callback
and unlock usb_lock again:

out:
		mutex_unlock(&gspca_dev->queue_lock);
        if (!ret && gspca_dev->sd_desc->dq_callback) {
		        if (mutex_lock_interruptible(&gspca_dev->usb_lock))
            		    return -ERESTARTSYS;
                gspca_dev->usb_err = 0;
                gspca_dev->sd_desc->dq_callback(gspca_dev);
				mutex_unlock(&gspca_dev->usb_lock);
        }
		return ret;

It seems reasonable, but I haven't looked in detail at what dq_callback
does.

Regards,

	Hans


> 
> <snip chunks on which I've no comments>
> 
> Regards,
> 
> Hans
> 
> 
> p.s.
> 
> I've yet to take a good look at the driver conversions other then
> the zc3xx conversion.
> 
