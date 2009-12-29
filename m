Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:57360 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZL2WbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 17:31:11 -0500
Message-Id: <2044EA95-168E-4ACE-A19E-732BB4A34CA7@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH] input: imon driver for SoundGraph iMON/Antec Veris IR devices
Date: Tue, 29 Dec 2009 14:30:51 -0800
Cc: Jarod Wilson <jarod@redhat.com>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 29, 2009 at 12:04:00AM -0500, Jarod Wilson wrote:
> On Dec 28, 2009, at 4:31 AM, Dmitry Torokhov wrote:
>>
>> Hm, will this work on big-endian?
>
> Good question. Not sure offhand. Probably not. Unfortunately, the  
> only devices I have to test with at the moment are integrated into  
> cases with x86 boards in them, so testing isn't particularly  
> straight-forward. I should probably get ahold of one of the plain  
> external usb devices to play with... Mind if I just add a TODO  
> marker near that for now?
>

How about just do le32_to_cpu() instead of memcpy()ing and that's
probably it?

>>> +
>>> +    printk(KERN_INFO "%s: iMON device (intf%d) disconnected\n",
>>> +           __func__, ifnum);
>>
>> dev_dbg().
>
> Ah. I think I was thinking it might not be safe to use at this point  
> in time. Which is what led me to look back at free_imon_context to  
> see what it was doing. Looks like both here and to fix  
> free_imon_context's use-after-free, I'll need to create a local  
> struct device to pass over to dev_dbg().
>
>
>>> +static int imon_resume(struct usb_interface *intf)
>>> +{
>>> +    int rc = 0;
>>> +    struct imon_context *context = usb_get_intfdata(intf);
>>> +    int ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
>>> +
>>> +    if (ifnum == 0) {
>>> +        usb_fill_int_urb(context->rx_urb_intf0, context- 
>>> >usbdev_intf0,
>>> +            usb_rcvintpipe(context->usbdev_intf0,
>>> +                context->rx_endpoint_intf0->bEndpointAddress),
>>> +            context->usb_rx_buf, sizeof(context->usb_rx_buf),
>>> +            usb_rx_callback_intf0, context,
>>> +            context->rx_endpoint_intf0->bInterval);
>>> +
>>> +        rc = usb_submit_urb(context->rx_urb_intf0, GFP_ATOMIC);
>>> +
>>> +    } else {
>>> +        usb_fill_int_urb(context->rx_urb_intf1, context- 
>>> >usbdev_intf1,
>>> +            usb_rcvintpipe(context->usbdev_intf1,
>>> +                context->rx_endpoint_intf1->bEndpointAddress),
>>> +            context->usb_rx_buf, sizeof(context->usb_rx_buf),
>>> +            usb_rx_callback_intf1, context,
>>> +            context->rx_endpoint_intf1->bInterval);
>>> +
>>> +        rc = usb_submit_urb(context->rx_urb_intf1, GFP_ATOMIC);
>>> +    }
>>
>> We have pretty different behavior depending on the interface, maybe  
>> the
>> driver should be split further?
>
> This is what we'll call a "fun" topic... These devices expose two  
> interfaces, and a while back in the lirc_imon days, they actually  
> loaded up as two separate lirc devices. But there's a catch: they  
> can't operate independently. Some keys come in via intf0, some via  
> intf1, even from the very same remote. And the interfaces share a  
> hardware-internal buffer (or something), and if you're only  
> listening to one of the two devices, and a key is decoded and sent  
> via the interface you're not listening to, it wedges the entire  
> device until you flush the other interface. Horribly bad hardware  
> design at play there, imo, but meh. What exactly did you have in  
> mind as far as a split? (And/or does it still apply with the above  
> info taken into consideration? ;).

Ok, fair enough. I'd still want to see larger functions split up a bit  
though.

Thanks.

-- 
Dmitry
