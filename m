Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:53524 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1CHNS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 08:18:28 -0500
Message-ID: <4D762C9F.1010707@ti.com>
Date: Tue, 8 Mar 2011 07:18:23 -0600
From: Sergio Aguirre <saaguirre@ti.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"pawel@osciak.com" <pawel@osciak.com>
Subject: Re: [PATCH] V4L: soc-camera: Add support for custom host mmap
References: <1299545691-917-1-git-send-email-saaguirre@ti.com> <Pine.LNX.4.64.1103080809120.3903@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103080809120.3903@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On 03/08/2011 01:17 AM, Guennadi Liakhovetski wrote:
> Hi Sergio
>
> On Mon, 7 Mar 2011, Sergio Aguirre wrote:
>
>> This helps redirect mmap calls to custom memory managers which
>> already have preallocated space to use by the device.
>>
>> Otherwise, device might not support the allocation attempted
>> generically by videobuf.
>>
>> Signed-off-by: Sergio Aguirre<saaguirre@ti.com>
>> ---
>>   drivers/media/video/soc_camera.c |    7 ++++++-
>>   include/media/soc_camera.h       |    2 ++
>>   2 files changed, 8 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
>> index 59dc71d..d361ba0 100644
>> --- a/drivers/media/video/soc_camera.c
>> +++ b/drivers/media/video/soc_camera.c
>> @@ -512,6 +512,7 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
>>   static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
>>   {
>>   	struct soc_camera_device *icd = file->private_data;
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>
> This doesn't seem to be needed

It's needed to call the custom mmaper.

ici->ops->mmap

Otherwise, how can I access the soc camera host ops?

>
>>   	int err;
>>
>>   	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
>> @@ -519,7 +520,11 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
>>   	if (icd->streamer != file)
>>   		return -EBUSY;
>>
>> -	err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
>> +	/* Check for an interface custom mmaper */
>
> mmapper - double 'p'

Oops. Will fix.

>
>> +	if (ici->ops->mmap)
>> +		err = ici->ops->mmap(&icd->vb_vidq, icd, vma);
>> +	else
>> +		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
>
> You're patching an old version of soc-camera. Please use a current one
> with support for videobuf2. Further, wouldn't it be possible for you to
> just replace the videobuf mmap_mapper() (videobuf2 q->mem_ops->mmap())
> method? I am not sure how possible this is, maybe one of videobuf2 experts
> could help us? BTW, you really should be using the videobuf2 API.

I'm basing this patches on mainline, commit:

commit 214d93b02c4fe93638ad268613c9702a81ed9192
Merge: ad4a4a8 077f8ec
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Mar 7 13:15:02 2011 -0800

     Merge branch 'omap-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6

And i don't see videobuf2 there.

Should I rebase my patches on another tree?

Regards,
Sergio


>
>>
>>   	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
>>   		(unsigned long)vma->vm_start,
>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>> index de81370..11350c2 100644
>> --- a/include/media/soc_camera.h
>> +++ b/include/media/soc_camera.h
>> @@ -87,6 +87,8 @@ struct soc_camera_host_ops {
>>   	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
>>   	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
>>   	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
>> +	int (*mmap)(struct videobuf_queue *, struct soc_camera_device *,
>> +		     struct vm_area_struct *);
>>   	unsigned int (*poll)(struct file *, poll_table *);
>>   	const struct v4l2_queryctrl *controls;
>>   	int num_controls;
>> --
>> 1.7.1
>>
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

