Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:41216 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753937Ab0BHSnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 13:43:47 -0500
Message-ID: <4B705B5E.8060605@epfl.ch>
Date: Mon, 08 Feb 2010 19:43:42 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] MT9T031: write xskip and yskip at each set_params call
References: <1264013696-11315-1-git-send-email-valentin.longchamp@epfl.ch> <Pine.LNX.4.64.1001202010190.4151@axis700.grange> <4B580FE8.8080203@epfl.ch> <Pine.LNX.4.64.1002041514490.19438@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002041514490.19438@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

Guennadi Liakhovetski wrote:
>> First more details about what I do with the camera: I open the device, issue
>> the S_CROP / S_FMT calls and read images, the behaviour is fine, then close
>> the device.
>>
>> Then if I reopen the device, reissue the S_CROP / S_FMT calls with the same
>> params, but the images is not the sames because of different xskip and yskip.
>> From what I have debugged in the driver at the second S_CROP /S_FMT, xskip and
>> yskip are computed by mt9t031_skip (and have the same value that the one
>> stored in the mt9t031 struct) and thus with the current code are not
>> rewritten.
>>
>> However, if I read the register values containing bin and skip values on the
>> camera chip they have been reset (does a open/close do some reset to the cam
>> ?) and thus different than the ones that should be written.
> 
> Yes, if hooks are provided by the platform, on last close we power down 
> cameras, on first open we power on and reset them.
> 
>> I hope this clarifies the problem that I am experiencing. I don't think that
>> the API wants you to get two different images when you open the device and
>> issue the same parameters twice.
> 
> Yes, sorry, this is a different issue. The issue is - too crude power 
> management in soc-camera. What we should do is implement proper (runtime) 
> power-management in soc-camera (ideally, in v4l2-subdev API) and call 
> suspend() to save registers before powering down, and resume() after 
> powering on and resetting.
> 
> I gave it a shot and just posted a patch
> 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/15686
> 
> (hm, would have been smart to cc you, sorry), doing just that. Below is an 
> example dummy implementation for mt9v022. Please, use it as example to 
> implement suspend / resume for mt9t031, for now, I think, it would suffice 
> if you just restore xskip and yskip in restore and skip suspend. If more 
> is needed in the future, we can always extend it.

OK, I agree with your analysis and I have tried to write the part for 
runtime suspend and resume to solve this issue. I however find myself in 
a deadend because of my limited knowledge of the kernel device model.

Here is my attempt with my questions in it (it compiles, but I have not 
tested it yet because I am pretty sure something is wrong):

> /*
>  * Power Management:
>  * This function does nothing for now but must be present for pm to work
>  */
> static int mt9t031_runtime_suspend(struct device *dev)
> {
> 	return 0;
> }

First, can you confirm me that this function is needed even if it does 
nothing ? I have read in the code that if the function is not present, 
__pm_runtime_suspend is going to return -ENOSYS and will set 
runtime_status to RPM_ACTIVE, which is not what we want. That's why I 
left it.

> 
> /*
>  * Power Management:
>  * COLUMN_ADDRESS_MODE and ROW_ADDRESS_MODE are not rewritten if unchanged
>  * they are however changed at reset if the platform hook is present
>  * thus we rewrite them with the values stored by the driver
>  */
> static int mt9t031_runtime_resume(struct device *dev)
> {
> 	struct video_device *vdev = to_video_device(dev);
> 	struct soc_camera_device *icd = container_of(vdev->parent,
> 		struct soc_camera_device, dev);
> 	struct device *i2c_dev = container_of(icd, struct device, 
> 		platform_data);
> 	struct i2c_client *client = to_i2c_client(i2c_dev);
> 	struct mt9t031 *mt9t031 = to_mt9t031(client);

Here I have a problem ... I am pretty sure that the third assignation 
has a problem, because platform_data is a pointer and not a normal 
member of struct device, and I thus cannot use container_of with it. 
What would then be the way to go from the soc_camera_device to the 
i2c_client (I'm a little bit confused with all the different structs and 
layers involved with i2c, soc-camera, v4l2_device and v4l2_subdevice) ? 
Just as a remark, this is the exact reverse path of this that is present 
in your patch to add runtime pm support to soc-camera:

/* This is only temporary here - until v4l2-subdev begins to link to 
video_device */
#include <linux/i2c.h>
static inline struct video_device *soc_camera_i2c_to_vdev(struct 
i2c_client *client)
{
	struct soc_camera_device *icd = client->dev.platform_data;
	return icd->vdev;
}

> 
> 	int ret;
> 	u16 xbin, ybin;
> 
> 	xbin = min(mt9t031->xskip, (u16)3);
> 	ybin = min(mt9t031->yskip, (u16)3);
> 
> 	ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
> 		((xbin-1)<<4) | (mt9t031->xskip-1));
> 	if (ret < 0)
> 		return ret;
> 
> 	ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
> 		((ybin-1)<<4) | (mt9t031->yskip-1));
> 	if (ret < 0)
> 		return ret;
> 
> 	return 0;
> }
> 
> static struct dev_pm_ops mt9t031_dev_pm_ops = {
> 	.runtime_suspend	= mt9t031_runtime_suspend,
> 	.runtime_resume		= mt9t031_runtime_resume,
> };
> 
> static struct device_type mt9t031_dev_type = {
> 	.name	= "MT9T031",
> 	.pm	= &mt9t031_dev_pm_ops,
> };

Thank you in advance for your help.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEB3494, Station 9, CH-1015 Lausanne
