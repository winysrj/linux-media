Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39705 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992AbbFHHhP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 03:37:15 -0400
Date: Mon, 8 Jun 2015 10:37:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v9 2/8] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20150608073709.GB5904@valkosipuli.retiisi.org.uk>
References: <1432566843-6391-1-git-send-email-j.anaszewski@samsung.com>
 <1432566843-6391-3-git-send-email-j.anaszewski@samsung.com>
 <20150601205921.GH25595@valkosipuli.retiisi.org.uk>
 <556D73D2.20600@samsung.com>
 <20150602153234.GL25595@valkosipuli.retiisi.org.uk>
 <556EB337.4010608@samsung.com>
 <20150603205946.GM25595@valkosipuli.retiisi.org.uk>
 <55754266.2020709@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55754266.2020709@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Mon, Jun 08, 2015 at 09:21:10AM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 06/03/2015 10:59 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Wed, Jun 03, 2015 at 09:56:39AM +0200, Jacek Anaszewski wrote:
> >>Hi Sakari,
> >>
> >>On 06/02/2015 05:32 PM, Sakari Ailus wrote:
> >>>Hi, Jacek!
> >>>
> >>>On Tue, Jun 02, 2015 at 11:13:54AM +0200, Jacek Anaszewski wrote:
> >>>>Hi Sakari,
> >>>>
> >>>>On 06/01/2015 10:59 PM, Sakari Ailus wrote:
> >>>>>Hi Jacek,
> >>>>>
> >>>>>On Mon, May 25, 2015 at 05:13:57PM +0200, Jacek Anaszewski wrote:
> >>>>>>This patch adds helper functions for registering/unregistering
> >>>>>>LED Flash class devices as V4L2 sub-devices. The functions should
> >>>>>>be called from the LED subsystem device driver. In case the
> >>>>>>support for V4L2 Flash sub-devices is disabled in the kernel
> >>>>>>config the functions' empty versions will be used.
> >>>>>>
> >>>>>>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>>>>>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>>>>Cc: Sakari Ailus <sakari.ailus@iki.fi>
> >>>>>>Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>>
> >>>>>Thanks for adding indicator support!
> >>>>>
> >>>>>Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>>>
> >>>>
> >>>>I missed one thing - sysfs interface of the indicator LED class
> >>>>also has to be disabled/enabled of v4l2_flash_open/close.
> >>>
> >>>Good catch.
> >>>
> >>>>
> >>>>I am planning to reimplement the functions as follows,
> >>>>please let me know if you see any issues here:
> >>>>
> >>>>static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> >>>>*fh)
> >>>>{
> >>>>         struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
> >>>>
> >>>>         struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
> >>>>
> >>>>         struct led_classdev *led_cdev = &fled_cdev->led_cdev;
> >>>>         struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev;
> >>>>
> >>>>         struct led_classdev *led_cdev_ind;
> >>>>
> >>>>         int ret = 0;
> >>>
> >>>I think you could spare some newlines above (and below as well).
> >>
> >>There must have been some issue on thunderbird side,
> >>originally there were no newlines above.
> >
> >Ok. I've used Seamonkey, I believe it uses the same editor. Some bugs were
> >unintroduced a few years ago, and since that I've mostly used a different
> >editor (and MUA) when replying to patches.
> >
> >>>>
> >>>>
> >>>>         mutex_lock(&led_cdev->led_access);
> >>>>
> >>>>
> >>>>         if (!v4l2_fh_is_singular(&fh->vfh))
> >>>>
> >>>>                 goto unlock;
> >>>>
> >>>>
> >>>>         led_sysfs_disable(led_cdev);
> >>>>         led_trigger_remove(led_cdev);
> >>>>
> >>>>
> >>>>         if (iled_cdev) {
> >>>>                 led_cdev_ind = &iled_cdev->led_cdev;
> >>>
> >>>You can also declare led_cdev_ind here as you don't need it outside the
> >>>basic block.
> >>
> >>With new approach it will be required also in error path.
> >
> >True.
> >
> >>>>
> >>>>
> >>>>                 mutex_lock(&led_cdev_ind->led_access);
> >>>>
> >>>>
> >>>>                 led_sysfs_disable(led_cdev_ind);
> >>>>                 led_trigger_remove(led_cdev_ind);
> >>>>
> >>>>
> >>>>                 mutex_unlock(&led_cdev_ind->led_access);
> >>>
> >>>Please don't acquire the indicator mutex while holding the flash mutex. I
> >>>don't think there's a need to do so, thus creating a dependency between the
> >>>two.Just remember to check for v4l2_fh_is_singular() in both cases.
> >>
> >>I thought that the code would be simpler this way. Nevertheless I
> >>produced a new version by following your advise.
> >>
> >>>
> >>>>
> >>>>         }
> >>>>
> >>>>
> >>>>         ret = __sync_device_with_v4l2_controls(v4l2_flash);
> >>>
> >>>If ret is < 0 here, you end up disabling the sysfs interface while open()
> >>>fails (and v4l2_flash_close() will not be run). Shouldn't you handle that?
> >>
> >>Good point.
> >>
> >>Please find the new version of v4l2_flash{open|close} functions below:
> >>
> >>static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> >>*fh)
> >>{
> >>         struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
> >>         struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
> >>         struct led_classdev *led_cdev = &fled_cdev->led_cdev;
> >>         struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev;
> >>         struct led_classdev *led_cdev_ind = NULL;
> >>         int ret = 0;
> >>
> >>         mutex_lock(&led_cdev->led_access);
> >>
> >>         if (!v4l2_fh_is_singular(&fh->vfh)) {
> >
> >Hmm. I just realised that this might be a bit broken ---
> >v4l2_fh_is_singular() should return the same value independently of where in
> >subdev's open() handler it is called.
> >
> >But adding file handles to the list and checking how many there are of them
> >is not properly serialised, i.e. another process could change the list in
> >between. I'll try to submit a patch for that. No need to wait for that
> >though.
> >
> >So please ignore my earlier request to check for v4l2_fh_is_singular() for
> >multiple times, it won't help. Once is enough, albeit more than that won't
> >hurt.
> 
> Let's agree on the new shape of the functions then:

Looks good to me. Could you resend once more, please?

> tatic int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> {
>         struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>         struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
>         struct led_classdev *led_cdev = &fled_cdev->led_cdev;
>         struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev;
>         struct led_classdev *led_cdev_ind = NULL;
>         int ret = 0;
> 
>         if (!v4l2_fh_is_singular(&fh->vfh))
>                 return 0;
> 
>         mutex_lock(&led_cdev->led_access);
> 
>         led_sysfs_disable(led_cdev);
>         led_trigger_remove(led_cdev);
> 
>         mutex_unlock(&led_cdev->led_access);
> 
>         if (iled_cdev) {
>                 led_cdev_ind = &iled_cdev->led_cdev;
> 
>                 mutex_lock(&led_cdev_ind->led_access);
> 
>                 led_sysfs_disable(led_cdev_ind);
>                 led_trigger_remove(led_cdev_ind);
> 
>                 mutex_unlock(&led_cdev_ind->led_access);
>         }
> 
>         ret = __sync_device_with_v4l2_controls(v4l2_flash);
>         if (ret < 0)
>                 goto out_sync_device;
> 
>         return 0;
> out_sync_device:
>         mutex_lock(&led_cdev->led_access);
>         led_sysfs_enable(led_cdev);
>         mutex_unlock(&led_cdev->led_access);
> 
>         if (led_cdev_ind) {
>                 mutex_lock(&led_cdev_ind->led_access);
>                 led_sysfs_enable(led_cdev_ind);
>                 mutex_unlock(&led_cdev_ind->led_access);
>         }
> 
>         return ret;
> }
> 
> static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> *fh)
> {
>         struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>         struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
>         struct led_classdev *led_cdev = &fled_cdev->led_cdev;
>         struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev;
>         int ret = 0;
> 
>         if (!v4l2_fh_is_singular(&fh->vfh))
>                 return 0;
> 
>         mutex_lock(&led_cdev->led_access);
> 
>         if (v4l2_flash->ctrls[STROBE_SOURCE])
>                 ret = v4l2_ctrl_s_ctrl(v4l2_flash->ctrls[STROBE_SOURCE],
>                                 V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
>         led_sysfs_enable(led_cdev);
> 
>         mutex_unlock(&led_cdev->led_access);
> 
>         if (iled_cdev) {
>                 struct led_classdev *led_cdev_ind = &iled_cdev->led_cdev;
> 
>                 mutex_lock(&led_cdev_ind->led_access);
>                 led_sysfs_enable(led_cdev_ind);
>                 mutex_unlock(&led_cdev_ind->led_access);
>         }
> 
>         return ret;
> }
> 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
