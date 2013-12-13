Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4527 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3LMN0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 08:26:49 -0500
Message-ID: <52AB0B00.5090202@xs4all.nl>
Date: Fri, 13 Dec 2013 14:26:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Dinesh.Ram@cern.ch,
	edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 06/11] si4713: Added the USB driver for Si4713
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl> <1386325034-19344-7-git-send-email-hverkuil@xs4all.nl> <20131209134737.1a2f19c4@samsung.com>
In-Reply-To: <20131209134737.1a2f19c4@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 12/09/2013 04:47 PM, Mauro Carvalho Chehab wrote:
> Em Fri,  6 Dec 2013 11:17:09 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Dinesh Ram <Dinesh.Ram@cern.ch>
>>
>> This is the USB driver for the Silicon Labs development board.
>> It contains the Si4713 FM transmitter chip.
>>
>> Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Tested-by: Eduardo Valentin <edubezval@gmail.com>
>> Acked-by: Eduardo Valentin <edubezval@gmail.com>
>> ---
>>  drivers/media/radio/si4713/Kconfig            |  15 +
>>  drivers/media/radio/si4713/Makefile           |   1 +
>>  drivers/media/radio/si4713/radio-usb-si4713.c | 540 ++++++++++++++++++++++++++
>>  3 files changed, 556 insertions(+)
>>  create mode 100644 drivers/media/radio/si4713/radio-usb-si4713.c
>>

<snip>

>> diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
>> new file mode 100644
>> index 0000000..d978844
>> --- /dev/null
>> +++ b/drivers/media/radio/si4713/radio-usb-si4713.c

<snip>

>> +		if (time_is_before_jiffies(until_jiffies))
>> +			return -EIO;
> 
> According with include/linux/jiffies.h:
> 
> 	time_is_before_jiffies(a) return true if a is before jiffies.
> 
> I suspect that you want to do just the opposite here: to return -EIO if
> you passed the timeout given by until_jiffies.

Don't confuse me :-)

Using before_jiffies is correct. If 'until_jiffies < jiffies', then we give up
and return -EIO. So until_jiffies is before jiffies. Or in other words:
jiffies is after until_jiffies.

I think that a macro like "jiffies_is_after_time(a)" would be easier to
understand.

<snip>

>> +static int si4713_i2c_read(struct si4713_usb_device *radio, char *data, int len)
>> +{
>> +	unsigned long until_jiffies = jiffies + usecs_to_jiffies(USB_RESP_TIMEOUT) + 1;
>> +	int retval;
>> +
>> +	/* receive the response */
>> +	for (;;) {
>> +		retval = usb_control_msg(radio->usbdev,
>> +					usb_rcvctrlpipe(radio->usbdev, 0),
>> +					0x01, 0xa1, 0x033f, 0, radio->buffer,
>> +					BUFFER_LENGTH, USB_TIMEOUT);
>> +		if (retval < 0)
>> +			return retval;
>> +
>> +		/*
>> +		 * Check that we get a valid reply back (buffer[1] == 0) and
>> +		 * that CTS is set before returning, otherwise we wait and try
>> +		 * again. The i2c driver also does the CTS check, but the timeouts
>> +		 * used there are much too small for this USB driver, so we wait
>> +		 * for it here.
>> +		 */
>> +		if (radio->buffer[1] == 0 && (radio->buffer[2] & SI4713_CTS)) {
>> +			memcpy(data, radio->buffer + 2, len);
>> +			return 0;
>> +		}
>> +		if (time_is_before_jiffies(until_jiffies)) {
>> +			/* Zero the status value, ensuring CTS isn't set */
>> +			data[0] = 0;
>> +			return 0;
>> +		}
> 
> Again, I think that the timeout condition is wrong here.

Ditto, the code is correct.

> 
>> +		msleep(3);
>> +	}
>> +}

Regards,

	Hans

