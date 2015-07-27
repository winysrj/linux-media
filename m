Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57324 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbbG0RTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 13:19:55 -0400
Message-ID: <55B66832.3030306@xs4all.nl>
Date: Mon, 27 Jul 2015 19:19:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 8/9] hackrf: add support for transmitter
References: <1437030298-20944-1-git-send-email-crope@iki.fi> <1437030298-20944-9-git-send-email-crope@iki.fi> <55A90E16.5040104@xs4all.nl> <55B65A2E.8020104@iki.fi>
In-Reply-To: <55B65A2E.8020104@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2015 06:19 PM, Antti Palosaari wrote:
> On 07/17/2015 05:15 PM, Hans Verkuil wrote:
>> On 07/16/2015 09:04 AM, Antti Palosaari wrote:
>>> HackRF SDR device has both receiver and transmitter. There is limitation
>>> that receiver and transmitter cannot be used at the same time
>>> (half-duplex operation). That patch implements transmitter support to
>>> existing receiver only driver.
>>>
>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>>> ---
>>>   drivers/media/usb/hackrf/hackrf.c | 787 +++++++++++++++++++++++++++-----------
>>>   1 file changed, 572 insertions(+), 215 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
>>> index 5bd291b..97de9cb6 100644
>>> --- a/drivers/media/usb/hackrf/hackrf.c
>>> +++ b/drivers/media/usb/hackrf/hackrf.c
>>> @@ -731,15 +889,19 @@ static int hackrf_querycap(struct file *file, void *fh,
>>>   		struct v4l2_capability *cap)
>>>   {
>>>   	struct hackrf_dev *dev = video_drvdata(file);
>>> +	struct video_device *vdev = video_devdata(file);
>>>
>>>   	dev_dbg(dev->dev, "\n");
>>>
>>> +	if (vdev->vfl_dir == VFL_DIR_RX)
>>> +		cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
>>> +	else
>>> +		cap->device_caps = V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR;
>>> +	cap->device_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
>>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>
>> The capabilities are those of the whole device, so you should OR this with
>> V4L2_CAP_SDR_CAPTURE | V4L2_CAP_SDR_OUTPUT |
>> V4L2_CAP_TUNER | V4L2_CAP_MODULATOR
>>
>>>   	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
>>> -	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
>>> +	strlcpy(cap->card, dev->rx_vdev.name, sizeof(cap->card));
>>>   	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
>>> -	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
>>> -			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
>>> -	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>>
>>>   	return 0;
>>>   }
> 
> Just to be sure, is it correct that:
> **) cap->device_caps == capabilities of whole device, including all the 
> character nodes
> 
> **) cap->capabilities == capabilities of single character node
> 

cap->device_caps are the caps of the char device node that the filehandle
belongs to.

cap->capabilities is the union of the capabilities of all char device nodes
created by the driver + the V4L2_CAP_DEVICE_CAPS capability.

> 
> Here is how v4l2-ctl now reports:
> 
> [crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/swradio0 --info
> Driver Info (not using libv4l2):
> 	Driver name   : hackrf
> 	Card type     : HackRF One
> 	Bus info      : usb-0000:00:13.2-2
> 	Driver version: 4.2.0
> 	Capabilities  : 0x85310000
> 		SDR Capture
> 		Tuner
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps   : 0x05790000
> 		SDR Capture
> 		SDR Output
> 		Tuner
> 		Modulator
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> [crope@localhost v4l2-ctl]$ ./v4l2-ctl -d /dev/swradio1 --info
> Driver Info (not using libv4l2):
> 	Driver name   : hackrf
> 	Card type     : HackRF One
> 	Bus info      : usb-0000:00:13.2-2
> 	Driver version: 4.2.0
> 	Capabilities  : 0x85680000
> 		SDR Output
> 		Modulator
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps   : 0x05790000
> 		SDR Capture
> 		SDR Output
> 		Tuner
> 		Modulator
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> [crope@localhost v4l2-ctl]$

You mixed up device_caps and capabilities looking at this.

Quick history: device_caps is a relatively new addition. Before that it was never
clearly defined which capabilities the 'capabilities' field actually exposed: that
of the device node, or the capabilities of the device as a whole.

So by adding device_caps you now have both.

Originally when the V4L2 API was designed the intention was that you could use
video ioctls with vbi nodes and vice versa. The video and vbi device nodes were
basically aliases of one another. That also meant that the capabilities exposed by
each were identical since both device nodes could do the same things.

In practice though for most (and eventually all) drivers you could only do video
ioctls with a video node and vbi ioctls with a vbi node and the whole '/dev/vbi is
an alias of /dev/video' idea was just too complex. As a result the meaning of the
capabilities field became ambiguous which was solved by the addition of the
device_caps field.

Regards,

	Hans
