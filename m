Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab1LEMEZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 07:04:25 -0500
Message-ID: <4EDCB33E.8090100@redhat.com>
Date: Mon, 05 Dec 2011 10:04:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linuxtv@stefanringel.de, linux-media@vger.kernel.org,
	d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: bugfix interrupt reset
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de> <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de> <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-12-2011 05:21, Thierry Reding wrote:
> * linuxtv@stefanringel.de wrote:
>> From: Stefan Ringel<linuxtv@stefanringel.de>
>>
>> Signed-off-by: Stefan Ringel<linuxtv@stefanringel.de>
>
> Your commit message needs more details. Why do you think this is a bugfix?
> Also this commit seems to effectively revert (and then partially reimplement)
> a patch that I posted some months ago.

Thierry,

I noticed this. I tested tm6000 with those changes with both the first gen
tm5600 devices I have and HVR900H and I didn't notice any bad thing with this
approach, and changing from one standard to another is now faster.

So, I decided to apply it (with the remaining patches I've made to
fix audio for PAL/M and NTSC/M).

I also noticed that TM6000_QUIRK_NO_USB_DELAY is not needed anymore
(still, Stefan's patches didn't remove it completely).

Could you please test if the problems you've solved with your approach
are still occurring?

Regards,
Mauro

>
>> ---
>>   drivers/media/video/tm6000/tm6000-core.c  |   49 -----------------------------
>>   drivers/media/video/tm6000/tm6000-video.c |   21 ++++++++++--
>>   2 files changed, 17 insertions(+), 53 deletions(-)
>>
>> diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/video/tm6000/tm6000-core.c
>> index c007e6d..920299e 100644
>> --- a/drivers/media/video/tm6000/tm6000-core.c
>> +++ b/drivers/media/video/tm6000/tm6000-core.c
>> @@ -599,55 +599,6 @@ int tm6000_init(struct tm6000_core *dev)
>>   	return rc;
>>   }
>>
>> -int tm6000_reset(struct tm6000_core *dev)
>> -{
>> -	int pipe;
>> -	int err;
>> -
>> -	msleep(500);
>> -
>> -	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 0);
>> -	if (err<  0) {
>> -		tm6000_err("failed to select interface %d, alt. setting 0\n",
>> -				dev->isoc_in.bInterfaceNumber);
>> -		return err;
>> -	}
>> -
>> -	err = usb_reset_configuration(dev->udev);
>> -	if (err<  0) {
>> -		tm6000_err("failed to reset configuration\n");
>> -		return err;
>> -	}
>> -
>> -	if ((dev->quirks&  TM6000_QUIRK_NO_USB_DELAY) == 0)
>> -		msleep(5);
>> -
>> -	/*
>> -	 * Not all devices have int_in defined
>> -	 */
>> -	if (!dev->int_in.endp)
>> -		return 0;
>> -
>> -	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
>> -	if (err<  0) {
>> -		tm6000_err("failed to select interface %d, alt. setting 2\n",
>> -				dev->isoc_in.bInterfaceNumber);
>> -		return err;
>> -	}
>> -
>> -	msleep(5);
>> -
>> -	pipe = usb_rcvintpipe(dev->udev,
>> -			dev->int_in.endp->desc.bEndpointAddress&  USB_ENDPOINT_NUMBER_MASK);
>> -
>> -	err = usb_clear_halt(dev->udev, pipe);
>> -	if (err<  0) {
>> -		tm6000_err("usb_clear_halt failed: %d\n", err);
>> -		return err;
>> -	}
>> -
>> -	return 0;
>> -}
>>
>>   int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
>>   {
>> diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
>> index 1e5ace0..4db3535 100644
>> --- a/drivers/media/video/tm6000/tm6000-video.c
>> +++ b/drivers/media/video/tm6000/tm6000-video.c
>> @@ -1609,12 +1609,25 @@ static int tm6000_release(struct file *file)
>>
>>   		tm6000_uninit_isoc(dev);
>>
>> +		/* Stop interrupt USB pipe */
>> +		tm6000_ir_int_stop(dev);
>> +
>> +		usb_reset_configuration(dev->udev);
>> +
>> +		if (&dev->int_in)
>
> This check is wrong,&dev->int_in will always be true.
>
>> +			usb_set_interface(dev->udev,
>> +			dev->isoc_in.bInterfaceNumber,
>> +			2);
>> +		else
>> +			usb_set_interface(dev->udev,
>> +			dev->isoc_in.bInterfaceNumber,
>> +			0);
>
> This would need better indentation.
>
>> +
>> +		/* Start interrupt USB pipe */
>> +		tm6000_ir_int_start(dev);
>> +
>
> Why do you restart the IR interrupt pipe when the device is being released?
>
>>   		if (!fh->radio)
>>   			videobuf_mmap_free(&fh->vb_vidq);
>> -
>> -		err = tm6000_reset(dev);
>> -		if (err<  0)
>> -			dev_err(&vdev->dev, "reset failed: %d\n", err);
>>   	}
>>
>>   	kfree(fh);
>
> I think this whole patch should be much shorter. Something along the lines
> of:
>
> @@ -1609,12 +1609,25 @@ static int tm6000_release(struct file *file)
>
>   		tm6000_uninit_isoc(dev);
>
> +		/* Stop interrupt USB pipe */
> +		tm6000_ir_int_stop(dev);
> +
>   		if (!fh->radio)
>   			videobuf_mmap_free(&fh->vb_vidq);
>
>
> Thierry

