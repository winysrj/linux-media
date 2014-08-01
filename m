Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1692 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaHAGrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 02:47:09 -0400
Message-ID: <53DB37D7.7080306@xs4all.nl>
Date: Fri, 01 Aug 2014 08:46:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, it@sca-uk.com, =stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] cx23885: fix UNSET/TUNER_ABSENT confusion.
References: <1403878542-1230-1-git-send-email-hverkuil@xs4all.nl> <1403878542-1230-2-git-send-email-hverkuil@xs4all.nl> <20140717194556.5b6e8636.m.chehab@samsung.com> <53C8546D.6000809@xs4all.nl> <53C8AEC6.4040209@xs4all.nl>
In-Reply-To: <53C8AEC6.4040209@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

What is the status of this patch? 

https://patchwork.linuxtv.org/patch/24553/

I actually thought it was merged, but I just found out it isn't.

You did merge https://patchwork.linuxtv.org/patch/24552/, but that's pointless
without fixing the UNSET/TUNER_ABSENT mess in this driver. The new board won't
work correctly without it.

Regards,

	Hans

On 07/18/2014 07:21 AM, Hans Verkuil wrote:
> On 07/18/2014 12:55 AM, Hans Verkuil wrote:
>> On 07/18/2014 12:45 AM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 27 Jun 2014 16:15:41 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Sometimes dev->tuner_type is compared to UNSET, sometimes to TUNER_ABSENT,
>>>> but these defines have different values.
>>>>
>>>> Standardize to TUNER_ABSENT.
>>>
>>> That patch looks wrong. UNSET has value -1, while TUNER_ABSENT has value 4.
>>
>> Well, yes. That's the whole problem. Both values were used to indicate an
>> absent tuner, and the 'if's to test whether a tuner was there also checked
>> against different values. I standardized here to TUNER_ABSENT, which is what
>> tveeprom uses as well (not that this driver looks uses that information from
>> tveeprom).
>>
>> Without this change you cannot correctly model a board without a tuner like
>> the one that I'm adding since the logic is all over the place in this driver.
>>
>> tuner_type should either be a proper tuner or TUNER_ABSENT, but never UNSET.
>>
>> That's what this patch changes.
> 
> Note that in cx23885-cards.c all boards without a tuner set tuner_type to
> TUNER_ABSENT. So it makes no sense for the code elsewhere to check against
> UNSET. UNSET is never set for tuner_type.
> 
> As an aside: some of the board definition leave tuner_type at 0 when I
> think it should be TUNER_ABSENT as well (or an actual proper tuner). It's
> unclear what happens then, but clearly this patch won't change those boards
> (e.g. CX23885_BOARD_MPX885 is one of them).
> 
> Regards,
> 
> 	Hans
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>> The only way that this patch won't be causing regressions is if none
>>> was used, with is not the case, IMHO.
>>>
>>> A patch removing either one would be a way more complex, and should likely
>>> touch on other cx23885 files:
>>>
>>> $ git grep -e UNSET --or -e TUNER_ABSENT -l drivers/media/pci/cx23885/ 
>>> drivers/media/pci/cx23885/cx23885-417.c
>>> drivers/media/pci/cx23885/cx23885-cards.c
>>> drivers/media/pci/cx23885/cx23885-core.c
>>> drivers/media/pci/cx23885/cx23885-video.c
>>> drivers/media/pci/cx23885/cx23885.h
>>>
>>> and also on tveeprom.
>>>
>>> However, touching at tveeprom would require touching also on all
>>> other drivers that support Hauppauge devices.
>>>
>>> Regards,
>>> Mauro
>>>
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  drivers/media/pci/cx23885/cx23885-417.c   |  8 ++++----
>>>>  drivers/media/pci/cx23885/cx23885-video.c | 10 +++++-----
>>>>  2 files changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
>>>> index 95666ee..bf89fc8 100644
>>>> --- a/drivers/media/pci/cx23885/cx23885-417.c
>>>> +++ b/drivers/media/pci/cx23885/cx23885-417.c
>>>> @@ -1266,7 +1266,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>>>>  	struct cx23885_fh  *fh  = file->private_data;
>>>>  	struct cx23885_dev *dev = fh->dev;
>>>>  
>>>> -	if (UNSET == dev->tuner_type)
>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>  		return -EINVAL;
>>>>  	if (0 != t->index)
>>>>  		return -EINVAL;
>>>> @@ -1284,7 +1284,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>>>>  	struct cx23885_fh  *fh  = file->private_data;
>>>>  	struct cx23885_dev *dev = fh->dev;
>>>>  
>>>> -	if (UNSET == dev->tuner_type)
>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>  		return -EINVAL;
>>>>  
>>>>  	/* Update the A/V core */
>>>> @@ -1299,7 +1299,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>>>>  	struct cx23885_fh  *fh  = file->private_data;
>>>>  	struct cx23885_dev *dev = fh->dev;
>>>>  
>>>> -	if (UNSET == dev->tuner_type)
>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>  		return -EINVAL;
>>>>  	f->type = V4L2_TUNER_ANALOG_TV;
>>>>  	f->frequency = dev->freq;
>>>> @@ -1347,7 +1347,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>>>>  		V4L2_CAP_READWRITE     |
>>>>  		V4L2_CAP_STREAMING     |
>>>>  		0;
>>>> -	if (UNSET != dev->tuner_type)
>>>> +	if (dev->tuner_type != TUNER_ABSENT)
>>>>  		cap->capabilities |= V4L2_CAP_TUNER;
>>>>  
>>>>  	return 0;
>>>> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
>>>> index e0a5952..2a890e9 100644
>>>> --- a/drivers/media/pci/cx23885/cx23885-video.c
>>>> +++ b/drivers/media/pci/cx23885/cx23885-video.c
>>>> @@ -1156,7 +1156,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>>>>  		V4L2_CAP_READWRITE     |
>>>>  		V4L2_CAP_STREAMING     |
>>>>  		V4L2_CAP_VBI_CAPTURE;
>>>> -	if (UNSET != dev->tuner_type)
>>>> +	if (dev->tuner_type != TUNER_ABSENT)
>>>>  		cap->capabilities |= V4L2_CAP_TUNER;
>>>>  	return 0;
>>>>  }
>>>> @@ -1474,7 +1474,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>>>>  {
>>>>  	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
>>>>  
>>>> -	if (unlikely(UNSET == dev->tuner_type))
>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>  		return -EINVAL;
>>>>  	if (0 != t->index)
>>>>  		return -EINVAL;
>>>> @@ -1490,7 +1490,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>>>>  {
>>>>  	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
>>>>  
>>>> -	if (UNSET == dev->tuner_type)
>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>  		return -EINVAL;
>>>>  	if (0 != t->index)
>>>>  		return -EINVAL;
>>>> @@ -1506,7 +1506,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>>>>  	struct cx23885_fh *fh = priv;
>>>>  	struct cx23885_dev *dev = fh->dev;
>>>>  
>>>> -	if (unlikely(UNSET == dev->tuner_type))
>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>  		return -EINVAL;
>>>>  
>>>>  	/* f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV; */
>>>> @@ -1522,7 +1522,7 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
>>>>  {
>>>>  	struct v4l2_control ctrl;
>>>>  
>>>> -	if (unlikely(UNSET == dev->tuner_type))
>>>> +	if (dev->tuner_type == TUNER_ABSENT)
>>>>  		return -EINVAL;
>>>>  	if (unlikely(f->tuner != 0))
>>>>  		return -EINVAL;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

