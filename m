Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59442 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbbFBJN6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 05:13:58 -0400
Message-id: <556D73D2.20600@samsung.com>
Date: Tue, 02 Jun 2015 11:13:54 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v9 2/8] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1432566843-6391-1-git-send-email-j.anaszewski@samsung.com>
 <1432566843-6391-3-git-send-email-j.anaszewski@samsung.com>
 <20150601205921.GH25595@valkosipuli.retiisi.org.uk>
In-reply-to: <20150601205921.GH25595@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/01/2015 10:59 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Mon, May 25, 2015 at 05:13:57PM +0200, Jacek Anaszewski wrote:
>> This patch adds helper functions for registering/unregistering
>> LED Flash class devices as V4L2 sub-devices. The functions should
>> be called from the LED subsystem device driver. In case the
>> support for V4L2 Flash sub-devices is disabled in the kernel
>> config the functions' empty versions will be used.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>
> Thanks for adding indicator support!
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>

I missed one thing - sysfs interface of the indicator LED class
also has to be disabled/enabled of v4l2_flash_open/close.

I am planning to reimplement the functions as follows,
please let me know if you see any issues here:

static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh 
*fh)
{
         struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd); 

         struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev; 

         struct led_classdev *led_cdev = &fled_cdev->led_cdev;
         struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev; 

         struct led_classdev *led_cdev_ind; 

         int ret = 0; 


         mutex_lock(&led_cdev->led_access); 


         if (!v4l2_fh_is_singular(&fh->vfh)) 

                 goto unlock; 


         led_sysfs_disable(led_cdev);
         led_trigger_remove(led_cdev); 


         if (iled_cdev) {
                 led_cdev_ind = &iled_cdev->led_cdev; 


                 mutex_lock(&led_cdev_ind->led_access); 


                 led_sysfs_disable(led_cdev_ind);
                 led_trigger_remove(led_cdev_ind); 


                 mutex_unlock(&led_cdev_ind->led_access); 

         } 


         ret = __sync_device_with_v4l2_controls(v4l2_flash); 


unlock:
         mutex_unlock(&led_cdev->led_access); 

         return ret; 

} 


static int v4l2_flash_close(struct v4l2_subdev *sd, struct 
v4l2_subdev_fh *fh)
{
         struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd); 

         struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev; 

         struct led_classdev *led_cdev = &fled_cdev->led_cdev;
         struct led_classdev_flash *iled_cdev = v4l2_flash->iled_cdev; 

         struct led_classdev *led_cdev_ind; 

         int ret = 0; 


         mutex_lock(&led_cdev->led_access); 


         if (v4l2_fh_is_singular(&fh->vfh)) {
                 if (v4l2_flash->ctrls[STROBE_SOURCE])
                         ret = 
v4l2_ctrl_s_ctrl(v4l2_flash->ctrls[STROBE_SV4L2_FLASH_STROBE_SOURCE_SOFTWARE); 

                 led_sysfs_enable(led_cdev); 


                 if (iled_cdev) {
                         led_cdev_ind = &iled_cdev->led_cdev; 


                         mutex_lock(&led_cdev_ind->led_access); 


                         led_sysfs_enable(led_cdev_ind); 


                         mutex_unlock(&led_cdev_ind->led_access); 

                 } 


         } 


         mutex_unlock(&led_cdev->led_access); 


         return ret; 

}


-- 
Best Regards,
Jacek Anaszewski
