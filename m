Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1ICRRQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 13:17:16 -0400
Message-ID: <4E626116.7050504@redhat.com>
Date: Sat, 03 Sep 2011 14:17:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 15/21] [staging] tm6000: Execute lightweight reset on
 close.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-16-git-send-email-thierry.reding@avionic-design.de> <4E5E9F5C.8030107@redhat.com> <4E5EAA41.4060502@redhat.com> <20110901052443.GE18473@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20110901052443.GE18473@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-09-2011 02:24, Thierry Reding escreveu:
> * Mauro Carvalho Chehab wrote:
>> Em 31-08-2011 17:53, Mauro Carvalho Chehab escreveu:
>>> Em 04-08-2011 04:14, Thierry Reding escreveu:
>>>> When the last user closes the device, perform a lightweight reset of the
>>>> device to bring it into a well-known state.
>>>>
>>>> Note that this is not always enough with the TM6010, which sometimes
>>>> needs a hard reset to get into a working state again.
>>>> ---
>>>>  drivers/staging/tm6000/tm6000-core.c  |   43 +++++++++++++++++++++++++++++++++
>>>>  drivers/staging/tm6000/tm6000-video.c |    8 +++++-
>>>>  drivers/staging/tm6000/tm6000.h       |    1 +
>>>>  3 files changed, 51 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
>>>> index 317ab7e..58c1399 100644
>>>> --- a/drivers/staging/tm6000/tm6000-core.c
>>>> +++ b/drivers/staging/tm6000/tm6000-core.c
>>>> @@ -597,6 +597,49 @@ int tm6000_init(struct tm6000_core *dev)
>>>>  	return rc;
>>>>  }
>>>>  
>>>> +int tm6000_reset(struct tm6000_core *dev)
>>>> +{
>>>> +	int pipe;
>>>> +	int err;
>>>> +
>>>> +	msleep(500);
>>>> +
>>>> +	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 0);
>>>> +	if (err < 0) {
>>>> +		tm6000_err("failed to select interface %d, alt. setting 0\n",
>>>> +				dev->isoc_in.bInterfaceNumber);
>>>> +		return err;
>>>> +	}
>>>> +
>>>> +	err = usb_reset_configuration(dev->udev);
>>>> +	if (err < 0) {
>>>> +		tm6000_err("failed to reset configuration\n");
>>>> +		return err;
>>>> +	}
>>>> +
>>>> +	msleep(5);
>>>> +
>>>> +	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
>>>> +	if (err < 0) {
>>>> +		tm6000_err("failed to select interface %d, alt. setting 2\n",
>>>> +				dev->isoc_in.bInterfaceNumber);
>>>> +		return err;
>>>> +	}
>>>> +
>>>> +	msleep(5);
>>>> +
>>>> +	pipe = usb_rcvintpipe(dev->udev,
>>>> +			dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
>>>> +
>>>> +	err = usb_clear_halt(dev->udev, pipe);
>>>> +	if (err < 0) {
>>>> +		tm6000_err("usb_clear_halt failed: %d\n", err);
>>>> +		return err;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
>>>>  {
>>>>  	int val = 0;
>>>> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
>>>> index 492ec73..70fc19e 100644
>>>> --- a/drivers/staging/tm6000/tm6000-video.c
>>>> +++ b/drivers/staging/tm6000/tm6000-video.c
>>>> @@ -1503,7 +1503,6 @@ static int tm6000_open(struct file *file)
>>>>  	tm6000_get_std_res(dev);
>>>>  
>>>>  	file->private_data = fh;
>>>> -	fh->vdev = vdev;
>>>>  	fh->dev = dev;
>>>>  	fh->radio = radio;
>>>>  	fh->type = type;
>>>> @@ -1606,9 +1605,16 @@ static int tm6000_release(struct file *file)
>>>>  	dev->users--;
>>>>  
>>>>  	res_free(dev, fh);
>>>> +
>>>>  	if (!dev->users) {
>>>> +		int err;
>>>> +
>>>>  		tm6000_uninit_isoc(dev);
>>>>  		videobuf_mmap_free(&fh->vb_vidq);
>>>> +
>>>> +		err = tm6000_reset(dev);
>>>> +		if (err < 0)
>>>> +			dev_err(&vdev->dev, "reset failed: %d\n", err);
>>>>  	}
>>>>  
>>>>  	kfree(fh);
>>>> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
>>>> index cf57e1e..dac2063 100644
>>>> --- a/drivers/staging/tm6000/tm6000.h
>>>> +++ b/drivers/staging/tm6000/tm6000.h
>>>> @@ -311,6 +311,7 @@ int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
>>>>  						u16 index, u16 mask);
>>>>  int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
>>>>  int tm6000_init(struct tm6000_core *dev);
>>>> +int tm6000_reset(struct tm6000_core *dev);
>>>>  
>>>>  int tm6000_init_analog_mode(struct tm6000_core *dev);
>>>>  int tm6000_init_digital_mode(struct tm6000_core *dev);
>>>
>>> Something went wrong with the patchset. Got an OOPS during device probe.
>>> Maybe it were caused due to udev, that opens V4L devices, as soon as they're
>>> registered.
>>
>> int tm6000_reset(struct tm6000_core *dev)
>> {
>> ... 
>>         msleep(5);
>>  
>>         pipe = usb_rcvintpipe(dev->udev,
>>                         dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
>>
>>
>> The bug is on the above line. It seems that usb_rcvintpipe() didn't like to be
>> called before the end of the device registration code.
> 
> I fail to see how this can happen. tm6000_reset() is only called when the
> last user closes the file. Since the file can only be opened in the first
> place when the device has been registered, tm6000_reset() should never be
> called before the device is registered.

It is quite simple: not all tm5600/6000/6010 devices have int_in endpoints.

The enclosed patch fixes it. Tested on a Saphire Wonder TV device (tm5600).

[media] tm6000: Don't try to use a non-existing interface

The dev->int_in USB interfaces is used by some devices for the Remote Controller.
Not all devices seem to define this interface.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 9cef1d1..b3c4e05 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -621,6 +621,12 @@ int tm6000_reset(struct tm6000_core *dev)
 
 	msleep(5);
 
+	/*
+	 * Not all devices have int_in defined
+	 */
+	if (!dev->int_in.endp)
+		return 0;
+
 	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
 	if (err < 0) {
 		tm6000_err("failed to select interface %d, alt. setting 2\n",
