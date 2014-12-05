Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37650 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaLEXNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 18:13:18 -0500
Date: Sat, 6 Dec 2014 00:13:13 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
Message-ID: <20141205231313.GA4854@linutronix.de>
References: <20141205200357.GA1586@linutronix.de>
 <20141205211932.GA24249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20141205211932.GA24249@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Greg Kroah-Hartman | 2014-12-05 13:19:32 [-0800]:

>On Fri, Dec 05, 2014 at 09:03:57PM +0100, Sebastian Andrzej Siewior wrote:
>> Consider the following scenario:
>> - plugin a webcam
>> - play the stream via gst-launch-0.10 v4l2src device=/dev/video0…
>> - remove the USB-HCD during playback via "rmmod $HCD"
>> 
>> and now wait for the crash
>
>Which you deserve, why did you ever remove a kernel module?  That's racy
its been found by the testing team and looks legitimate.

>and _never_ recommended, which is why it never happens automatically and
>only root can do it.
I beg your pardon. So it is okay to remove the UVC-driver / plug the
cable and expect that things continue to work but removing the HCD is a
no no? I always assumed that kernel should BUG() no matter what the user
does unless he really begs for it. If there is a race then it is a bug
that deserves to be fixed, right?

>> diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
>> index 506b969ea7fd..01e080a61519 100644
>> --- a/drivers/usb/core/buffer.c
>> +++ b/drivers/usb/core/buffer.c
>> @@ -107,7 +107,7 @@ void hcd_buffer_destroy(struct usb_hcd *hcd)
>>   * better sharing and to leverage mm/slab.c intelligence.
>>   */
>>  
>> -void *hcd_buffer_alloc(
>> +static void *_hcd_buffer_alloc(
>
>Looks like this isn't really needed here, right?

either this or I would have the tree callers if the allocation succeded
or not in order not to take a reference if the allocation failed.

>>  	struct usb_bus		*bus,
>>  	size_t			size,
>>  	gfp_t			mem_flags,
>> @@ -131,7 +131,19 @@ void *hcd_buffer_alloc(
>>  	return dma_alloc_coherent(hcd->self.controller, size, dma, mem_flags);
>>  }
>>  
>> -void hcd_buffer_free(
>> +void *hcd_buffer_alloc(struct usb_bus *bus, size_t size, gfp_t mem_flags,
>> +		       dma_addr_t *dma)
>> +{
>> +	struct usb_hcd *hcd = bus_to_hcd(bus);
>> +	void *ret;
>> +
>> +	ret = _hcd_buffer_alloc(bus, size, mem_flags, dma);
>> +	if (ret)
>> +		usb_get_hcd(hcd);
>
>I'm all for some good reference counting, but this is going to cause a
>_lot_ of churn on this reference count, what is the performance issue
>with doing this for every buffer?
The UVC allocates the buffers once and reuses them. If a driver does
any kind of high-performance transfers and allocates new buffers on each
transfer then I would expect this kref_get() is in the noise area. But
if you want real numbers I would have to go ahead and test it.
A single get() on first allocation and its counter part on cleanup would
be enough if you are too concerned about it on every allocation (it
would be transparent to the user).

>thanks,
>
>greg k-h

Sebastian
