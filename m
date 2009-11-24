Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:60312
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbZKXE0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 23:26:18 -0500
Message-ID: <4B0B6193.4060107@wilsonet.com>
Date: Mon, 23 Nov 2009 23:31:15 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 3/3 v2] lirc driver for SoundGraph iMON IR receivers and
 displays
References: <200910200956.33391.jarod@redhat.com> <200910201000.57536.jarod@redhat.com> <4B0A8710.9060104@redhat.com>
In-Reply-To: <4B0A8710.9060104@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2009 07:58 AM, Mauro Carvalho Chehab wrote:
> Jarod Wilson wrote:
>> lirc driver for SoundGraph iMON IR receivers and displays
>>
>> Successfully tested with multiple devices with and without displays.
>>
>
>
>> +static struct usb_device_id imon_usb_id_table[] = {
>> +	/* TriGem iMON (IR only) -- TG_iMON.inf */
>> +	{ USB_DEVICE(0x0aa8, 0x8001) },
> ...
>
> Another set of USB vendor ID's... this time, vendors weren't described. The
> same comment I did on patch 2/3 applies here... IMO, we should really try
> to create a global list of vendors/devices on kernel. Of course this is not
> a non-go issue, as it is already present on several other USB drivers.

My first thought is that a global list shared by everyone would be a 
pain to manage -- which upstream tree would be the entry point for 
additions? I think a global-within-lirc header would be just fine 
though. Most usb lirc drivers don't have very long lists, these two 
(mceusb and imon) are by far the longest ones.

>> +
>> +	/*
>> +	 * Translate received data to pulse and space lengths.
>> +	 * Received data is active low, i.e. pulses are 0 and
>> +	 * spaces are 1.
>> +	 *
>> +	 * My original algorithm was essentially similar to
>> +	 * Changwoo Ryu's with the exception that he switched
>> +	 * the incoming bits to active high and also fed an
>> +	 * initial space to LIRC at the start of a new sequence
>> +	 * if the previous bit was a pulse.
>> +	 *
>> +	 * I've decided to adopt his algorithm.
>> +	 */
>> +
>
> Before digging into all code details, am I wrong or this device has the
> pulse/space decoding inside the chip?

The current generation of imon devices do onboard decoding, but the 
driver supports older imon devices as well, which do NOT do onboard 
decoding, and follow the code referenced by the above comment block.

> In this case, we shouldn't really be converting their IR keystroke events into
> a pseudo set of pulse/space marks, but use the standard events interface.

And that's actually the default mode for the devices that do onboard 
decoding -- the key mappings are all in lirc_imon.h. A modparam can be 
used to override pure input mode and instead pass the decoded hex values 
out to userspace for lircd to handle.

Its entirely possible we could split this driver into two, one that is 
for the older devices, and another for the newer devices that do onboard 
decoding, which is a pure input mode driver (and still usable with lirc 
via its devinput userspace driver). It'd be a lot of extra work at the 
moment though, and I have no older devices to test with, only the newer 
ones.


-- 
Jarod Wilson
jarod@wilsonet.com
