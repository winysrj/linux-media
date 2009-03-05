Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:45704 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbZCEOJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 09:09:29 -0500
Message-ID: <49AFDD0B.80804@maxwell.research.nokia.com>
Date: Thu, 05 Mar 2009 16:09:15 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	saaguirre@ti.com, tuukka.o.toivonen@nokia.com,
	dongsoo.kim@gmail.com
Subject: Re: [PATCH 9/9] omap34xxcam: Add camera driver
References: <49AD0128.5090503@maxwell.research.nokia.com>	 <1236074816-30018-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-7-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-8-git-send-email-sakari.ailus@maxwell.research.nokia.com>	 <1236074816-30018-9-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1236101460.10927.109.camel@tux.localhost>
In-Reply-To: <1236101460.10927.109.camel@tux.localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alexey Klimov wrote:
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *fh,
>> +				struct v4l2_format *f)
>> +{
>> +	struct omap34xxcam_fh *ofh = fh;
>> +	struct omap34xxcam_videodev *vdev = ofh->vdev;
>> +
>> +	if (vdev->vdev_sensor == v4l2_int_device_dummy())
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&vdev->mutex);
>> +	f->fmt.pix = vdev->pix;
>> +	mutex_unlock(&vdev->mutex);
> 
> Hmmmm, you are using mutex_lock to lock reading from vdev structure..
> Well, i don't if this is right approach. I am used to that mutex_lock is
> used to prevent _changing_ of members in structure..

The vdev->mutex is acquired since we want to prevent concurrent access 
to vdev->pix. Otherwise it might change while we are reading it, right?

>> +static int vidioc_s_fmt_vid_cap(struct file *file, void *fh,
>> +				struct v4l2_format *f)
>> +{
>> +	struct omap34xxcam_fh *ofh = fh;
>> +	struct omap34xxcam_videodev *vdev = ofh->vdev;
>> +	struct v4l2_pix_format pix_tmp;
>> +	struct v4l2_fract timeperframe;
>> +	int rval;
>> +
>> +	if (vdev->vdev_sensor == v4l2_int_device_dummy())
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&vdev->mutex);
>> +	if (vdev->streaming) {
>> +		rval = -EBUSY;
>> +		goto out;
>> +	}
> 
> Well, why don't remove goto, place return -EBUSY, and move mutex after
> if (vdev->streaming) check ?

The streaming state may change in the meantime. See vidioc_streamon. 
It's not very likely but possible as far as I understand.

>> +static int vidioc_reqbufs(struct file *file, void *fh,
>> +			  struct v4l2_requestbuffers *b)
>> +{
>> +	struct omap34xxcam_fh *ofh = fh;
>> +	struct omap34xxcam_videodev *vdev = ofh->vdev;
>> +	int rval;
>> +
>> +	if (vdev->vdev_sensor == v4l2_int_device_dummy())
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&vdev->mutex);
>> +	if (vdev->streaming) {
>> +		mutex_unlock(&vdev->mutex);
>> +		return -EBUSY;
>> +	}
> 
> If i'm doing this i prefer to place mutex_lock after this
> if(vdev->streaming) check.

Same here.

>> +static int omap34xxcam_device_register(struct v4l2_int_device *s)
>> +{
>> +	struct omap34xxcam_videodev *vdev = s->u.slave->master->priv;
>> +	struct omap34xxcam_hw_config hwc;
>> +	int rval;
>> +
>> +	/* We need to check rval just once. The place is here. */
> 
> I didn't understand this comment. You doing nothin in next few lines
> with int variable rval(which introduced in this function). Is comment
> talking about struct v4l2_int_device *s ?

Yes. If the g_priv() succeeds now it will succeed in future, too. This 
comes from the platform data through the slave device.

>> +	/* Are we the first slave? */
>> +	if (vdev->slaves == 1) {
>> +		/* initialize the video_device struct */
>> +		vdev->vfd = video_device_alloc();
>> +		if (!vdev->vfd) {
>> +			dev_err(&vdev->vfd->dev,
>> +				"could not allocate video device struct\n");
> 
> Do i understand you code in right way ?
> You call video_device_alloc() to get vdev->vfd. Then if vdev->vfd is
> null(empty) you make message dev_err which based on vdev->vfd->dev but
> dev->vfd allocating is failed.. If i'm not wrong you message will
> provide kernel oops.
> One more point here is that you use dev_err(&vdev->vfd->dev before call
> to video_device_alloc() in this function.

Indeed. Others hit this already. Thanks.

>> +static int __init omap34xxcam_init(void)
>> +{
>> +	struct omap34xxcam_device *cam;
>> +	int i;
>> +
>> +	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
>> +	if (!cam) {
>> +		printk(KERN_ERR "%s: could not allocate memory\n", __func__);
>> +		goto err;
> 
> If kzalloc failed you return -ENODEV; but this is ENOMEM error.

Yes. Will fix.

Thanks again for the comments.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
