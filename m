Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab2EEOoi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 10:44:38 -0400
Message-ID: <4FA53CD2.1010706@redhat.com>
Date: Sat, 05 May 2012 16:44:34 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com> <4FA4DA05.5030001@redhat.com> <201205051114.31531.hverkuil@xs4all.nl>
In-Reply-To: <201205051114.31531.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/05/2012 11:14 AM, Hans Verkuil wrote:
> On Sat May 5 2012 09:43:01 Hans de Goede wrote:
>> Hi,
>>
>> I'm slowly working my way though this series today (both review, as well
>> as some tweaks and testing).
>>
>> More comments inline...
>>
>> On 04/28/2012 05:09 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil<hans.verkuil@cisco.com>
>>>
>>> Make the necessary changes to allow subdrivers to use the control framework.
>>> This does not add control event support, that needs more work.
>>>
>>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>>> ---
>>>    drivers/media/video/gspca/gspca.c |   13 +++++++++----
>>>    1 file changed, 9 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
>>> index ca5a2b1..56dff10 100644
>>> --- a/drivers/media/video/gspca/gspca.c
>>> +++ b/drivers/media/video/gspca/gspca.c
>>> @@ -38,6 +38,7 @@
>>>    #include<linux/uaccess.h>
>>>    #include<linux/ktime.h>
>>>    #include<media/v4l2-ioctl.h>
>>> +#include<media/v4l2-ctrls.h>
>>>
>>>    #include "gspca.h"
>>>
>>> @@ -1006,6 +1007,8 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
>>>
>>>    	/* set the current control values to their default values
>>>    	 * which may have changed in sd_init() */
>>> +	/* does nothing if ctrl_handler == NULL */
>>> +	v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
>>>    	ctrl = gspca_dev->cam.ctrls;
>>>    	if (ctrl != NULL) {
>>>    		for (i = 0;
>>> @@ -1323,6 +1326,7 @@ static void gspca_release(struct video_device *vfd)
>>>    	PDEBUG(D_PROBE, "%s released",
>>>    		video_device_node_name(&gspca_dev->vdev));
>>>
>>> +	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
>>>    	kfree(gspca_dev->usb_buf);
>>>    	kfree(gspca_dev);
>>>    }
>>> @@ -2347,6 +2351,10 @@ int gspca_dev_probe2(struct usb_interface *intf,
>>>    	gspca_dev->sd_desc = sd_desc;
>>>    	gspca_dev->nbufread = 2;
>>>    	gspca_dev->empty_packet = -1;	/* don't check the empty packets */
>>> +	gspca_dev->vdev = gspca_template;
>>> +	gspca_dev->vdev.parent =&intf->dev;
>>> +	gspca_dev->module = module;
>>> +	gspca_dev->present = 1;
>>>
>>>    	/* configure the subdriver and initialize the USB device */
>>>    	ret = sd_desc->config(gspca_dev, id);
>>
>> You also need to move the initialization of the mutexes here, as the
>> v4l2_ctrl_handler_setup will call s_ctrl on all the controls, and s_ctrl
>> should take the usb_lock (see my review of the next patch in this series),
>> I'll make this change myself and merge it into your patch.
>
> Looking at how usb_lock is used I am inclined to just set video_device->lock
> to it and let the v4l2 core do all the locking for me, which will automatically
> fix the missing s_ctrl lock too.

Please don't I've really bad experience with this with pwc (large latencies
on dqbuf), also gspca uses worker-threads which issue usb control requests
in various places, currently these take usb_lock to avoid them fighting with
sd_start or controls, these won't know about the global device lock and if
these start taking that lock too things will become pretty messy pretty quickly.

>
> I've realized that there is a problem if you do your own locking *and* use the
> control framework: if you need to set a control from within the driver, then
> you do that using v4l2_ctrl_s_ctrl. But if s_ctrl has to take the driver's lock,
> then you can't call v4l2_ctrl_s_ctrl with that lock already taken!
>
> So you get:
>
> vidioc_foo()
> 	lock(mylock)
> 	v4l2_ctrl_s_ctrl(ctrl, val)
> 		s_ctrl(ctrl, val)
> 			lock(mylock)

Easy solution here, remove the first lock(mylock), since we are not using v4l2-dev's
locking, we are the one doing the first lock, and if we are going to call v4l2_ctrl_s_ctrl
we should simply not do that!

Now I see that we are doing exactly that in for example vidioc_g_jpegcomp in gspca.c, so
we should stop doing that. We can make vidioc_g/s_jpegcomp only do the usb locking if
gspca_dev->vdev.ctrl_handler == NULL, and once all sub drivers are converted simply remove
it. Actually I'm thinking about making the jpegqual control part of the gspca_dev struct
itself and move all handling of vidioc_g/s_jpegcomp out of the sub drivers and into
the core.

Regards,

Hans

