Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34229
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750780AbdHLJto (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 05:49:44 -0400
Date: Sat, 12 Aug 2017 06:49:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-compat-ioctl32.c: make ctrl_is_pointer generic
Message-ID: <20170812064935.534562dd@vento.lan>
In-Reply-To: <838eb18a-b7e0-4d2c-f42b-549488b519b6@xs4all.nl>
References: <3814fe88-647e-dc2d-2b5f-fcb1c925228b@xs4all.nl>
        <20170811180818.2fc408b5@vento.lan>
        <838eb18a-b7e0-4d2c-f42b-549488b519b6@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Aug 2017 10:22:07 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 11/08/17 23:08, Mauro Carvalho Chehab wrote:
> > Em Fri, 11 Aug 2017 15:26:03 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> The ctrl_is_pointer used a hard-coded list of control IDs that besides being
> >> outdated also wouldn't work for custom driver controls.
> >>
> >> Replaced by calling queryctrl and checking if the V4L2_CTRL_FLAG_HAS_PAYLOAD
> >> flag was set.
> >>
> >> Note that get_v4l2_ext_controls32() will set the v4l2_ext_control 'size' field
> >> to 0 if the control has no payload before passing it to the kernel. This
> >> helps in put_v4l2_ext_controls32() since that function can just look at the
> >> 'size' field instead of having to call queryctrl again. The reason we set
> >> 'size' explicitly for non-pointer controls is that 'size' is ignored by the
> >> kernel in that case. That makes 'size' useless as an indicator of a pointer
> >> type in the put function since it can be any value. But setting it to 0 here
> >> turns it into a useful indicator.
> >>
> >> Also added proper checks for the compat_alloc_user_space return value which
> >> can be NULL, this was never done for some reason.  
> > 
> > On a quick preview, please split those extra checks you added on
> > a separate patch.
> > 
> > The logic for the remaining parts of this patch is not trivial. I'll look 
> > into it later.
> >   
> >>
> >> Tested with a 32-bit build of v4l2-ctl and the vivid driver.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> >> index af8b4c5b0efa..a16338cc216e 100644
> >> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> >> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c  
> 
> <snip>
> 
> >> -/* The following function really belong in v4l2-common, but that causes
> >> -   a circular dependency between modules. We need to think about this, but
> >> -   for now this will do. */
> >>
> >> -/* Return non-zero if this control is a pointer type. Currently only
> >> -   type STRING is a pointer type. */
> >> -static inline int ctrl_is_pointer(u32 id)
> >> +/* Return non-zero if this control is a pointer type. */
> >> +static inline int ctrl_is_pointer(struct file *file, u32 id)
> >>  {
> >> -	switch (id) {
> >> -	case V4L2_CID_RDS_TX_PS_NAME:
> >> -	case V4L2_CID_RDS_TX_RADIO_TEXT:
> >> -		return 1;
> >> -	default:
> >> +	struct video_device *vfd = video_devdata(file);
> >> +	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
> >> +	void *fh = file->private_data;
> >> +	struct v4l2_fh *vfh =
> >> +		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
> >> +	struct v4l2_queryctrl qctrl = { id };
> >> +	int err;
> >> +
> >> +	if (!test_bit(_IOC_NR(VIDIOC_QUERYCTRL), vfd->valid_ioctls))
> >> +		err = -ENOTTY;
> >> +	else if (vfh && vfh->ctrl_handler)
> >> +		err = v4l2_queryctrl(vfh->ctrl_handler, &qctrl);
> >> +	else if (vfd->ctrl_handler)
> >> +		err = v4l2_queryctrl(vfd->ctrl_handler, &qctrl);
> >> +	else if (ops->vidioc_queryctrl)
> >> +		err = ops->vidioc_queryctrl(file, fh, &qctrl);
> >> +	else
> >> +		err = -ENOTTY;
> >> +
> >> +	if (err)
> >>  		return 0;
> >> -	}
> >> +
> >> +	return qctrl.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD;
> >>  }  
> 
> Mauro,
> 
> I'd like your opinion on something: the code to call queryctrl is identical to
> the v4l_queryctrl() function in v4l2-ioctl.c. I have been debating with myself
> whether or not to drop the 'static' from that v4l2-ioctl.c function and call
> it from here. It's a bit unexpected to have this source calling a function in
> v4l2-ioctl.c, but on the other hand it avoids having a copy of that function.
> 
> I'm leaning towards calling v4l_queryctrl from here, but I wonder what you
> think.

I would drop "static" from the function and call it directly here.

On my quick look on this patch yesterday, it came to my mind that
there is a lot of things there that, IMHO, doesn't belong to the
compat code (as it shouldn't know the dirty details about control
handling).

As both v4l2-ioctl and v4l2-compat-ioctl32 belongs to the same module
(videodev), you don't even need to make it exportable. 

IMHO, doing it let the code more clear and easier to review. As a side
effect, it prevents us to change both codes if the implementation of
v4l_queryctrl() changes.

Regards,
Mauro
