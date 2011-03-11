Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53711 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1CKQrM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 11:47:12 -0500
Message-ID: <4D7A5209.6060500@ti.com>
Date: Fri, 11 Mar 2011 10:47:05 -0600
From: Sergio Aguirre <saaguirre@ti.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"pawel@osciak.com" <pawel@osciak.com>
Subject: Re: [PATCH] V4L: soc-camera: Add support for custom host mmap
References: <1299545691-917-1-git-send-email-saaguirre@ti.com> <Pine.LNX.4.64.1103080809120.3903@axis700.grange> <4D762C9F.1010707@ti.com> <Pine.LNX.4.64.1103081429140.3903@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103081429140.3903@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On 03/08/2011 07:45 AM, Guennadi Liakhovetski wrote:
> On Tue, 8 Mar 2011, Sergio Aguirre wrote:
>
>> Hi Guennadi,
>>
>> On 03/08/2011 01:17 AM, Guennadi Liakhovetski wrote:
>>> Hi Sergio
>>>
>>> On Mon, 7 Mar 2011, Sergio Aguirre wrote:
>>>
>>>> This helps redirect mmap calls to custom memory managers which
>>>> already have preallocated space to use by the device.
>>>>
>>>> Otherwise, device might not support the allocation attempted
>>>> generically by videobuf.
>>>>
>>>> Signed-off-by: Sergio Aguirre<saaguirre@ti.com>
>>>> ---
>>>>    drivers/media/video/soc_camera.c |    7 ++++++-
>>>>    include/media/soc_camera.h       |    2 ++
>>>>    2 files changed, 8 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/soc_camera.c
>>>> b/drivers/media/video/soc_camera.c
>>>> index 59dc71d..d361ba0 100644
>>>> --- a/drivers/media/video/soc_camera.c
>>>> +++ b/drivers/media/video/soc_camera.c
>>>> @@ -512,6 +512,7 @@ static ssize_t soc_camera_read(struct file *file, char
>>>> __user *buf,
>>>>    static int soc_camera_mmap(struct file *file, struct vm_area_struct
>>>> *vma)
>>>>    {
>>>>    	struct soc_camera_device *icd = file->private_data;
>>>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>>>
>>> This doesn't seem to be needed
>>
>> It's needed to call the custom mmaper.
>>
>> ici->ops->mmap
>
> Oops, sorry, diff context has confused me "@@ -512,6 +512,7 @@ static
> ssize_t soc_camera_read(";-)

No worries. :)

>
>>
>> Otherwise, how can I access the soc camera host ops?
>>
>>>
>>>>    	int err;
>>>>
>>>>    	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
>>>> @@ -519,7 +520,11 @@ static int soc_camera_mmap(struct file *file, struct
>>>> vm_area_struct *vma)
>>>>    	if (icd->streamer != file)
>>>>    		return -EBUSY;
>>>>
>>>> -	err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
>>>> +	/* Check for an interface custom mmaper */
>>>
>>> mmapper - double 'p'
>>
>> Oops. Will fix.
>>
>>>
>>>> +	if (ici->ops->mmap)
>>>> +		err = ici->ops->mmap(&icd->vb_vidq, icd, vma);
>>>> +	else
>>>> +		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
>>>
>>> You're patching an old version of soc-camera. Please use a current one
>>> with support for videobuf2. Further, wouldn't it be possible for you to
>>> just replace the videobuf mmap_mapper() (videobuf2 q->mem_ops->mmap())
>>> method? I am not sure how possible this is, maybe one of videobuf2 experts
>>> could help us? BTW, you really should be using the videobuf2 API.
>>
>> I'm basing this patches on mainline, commit:
>>
>> commit 214d93b02c4fe93638ad268613c9702a81ed9192
>> Merge: ad4a4a8 077f8ec
>> Author: Linus Torvalds<torvalds@linux-foundation.org>
>> Date:   Mon Mar 7 13:15:02 2011 -0800
>>
>>      Merge branch 'omap-fixes-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6
>>
>> And i don't see videobuf2 there.
>>
>> Should I rebase my patches on another tree?
>
> Yes, please use
>
> git://linuxtv.org/media_tree.git	staging/for_v2.6.39

Ok, I'll do this later on. I'm currently developing my driver on an 
internal TI tree, based on 2.6.35.6 Android kernel, and rebasing just 
generic v4l2 changes to send for review.

I still need to try this driver out in mainline for the Pandaboard, and 
then I'll rebase everything on top of videobuf2 framework.

Bottom line: Holding this patch for now :)

Thanks for your time!

Sergio

>
> otherwise you can also base on linux-next if you like.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

