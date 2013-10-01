Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:46452 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3JAVQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 17:16:10 -0400
Message-ID: <524B3B94.8060806@gmail.com>
Date: Wed, 02 Oct 2013 00:16:04 +0300
From: Xenia Ragiadakou <burzalodowa@gmail.com>
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: New USB core API to change interval and max packet size
References: <524B1BF4.6000305@gmail.com> <20131001204554.GB15395@xanatos>
In-Reply-To: <20131001204554.GB15395@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2013 11:45 PM, Sarah Sharp wrote:
> On Tue, Oct 01, 2013 at 10:01:08PM +0300, Xenia Ragiadakou wrote:
>> Hi Sarah,
>>
>> I read the mail on 'possible conflict between xhci_hcd and a patched
>> usbhid'.
> For reference to others:
> http://marc.info/?l=linux-usb&m=138064948726038&w=2
> http://marc.info/?l=linux-usb&m=138065201426880&w=2
>
>> I looked in xhci and the problem arises in xhci_queue_intr_tx() when
>> if (xhci_interval != ep_interval) {
>>      ...
>>      urb->interval = xhci_interval;
>> }
>>
>> right?
> Yes.  The underlying problem is that the xHCI host sets up the endpoint
> contexts during the Configure Endpoint command, using the interval from
> the device's endpoint descriptors.  It also uses the endpoint descriptor
> wMaxPacketSize, which can be wrong as well.  If the device driver wants
> to use a different urb->interval than is in the endpoint descriptor, the
> xHCI driver will simply ignore it.
>
> (I'm Ccing the linux-media list, as I've discussed some of these devices
> with broken descriptors before.)
>
>> When you say a new API, what do you mean? New functions in usbcore
>> to be used by usb device drivers?
> Yes.  You would export the function in the USB core, and put a prototype
> in a USB include file (probably in include/linux/usb.h).  Let's say that
> function is called usb_change_ep_bandwidth.
>
> Drivers could call into that function when they needed to change either
> the bInterval or wMaxPacketSize of a particular endpoint.  This could be
> during the driver's probe function, or before switching alternate
> interface settings, or even after the alt setting is in place, but
> userspace dictates the driver use a different bandwidth.
>
> Drivers should pass usb_change_ep_bandwidth a pointer to the endpoint
> they need to change, along with the bInterval and wMaxPacketSize values
> they would like the endpoint to have.  Those values could be stored as
> new values in struct usb_host_endpoint.
>
> usb_change_ep_bandwidth would then call into the xHCI driver to drop the
> endpoint, re-add it, and then issue a bandwidth change.  The xHCI driver
> would have to be changed to look at the new fields in usb_host_endpoint,
> and set up the endpoint contexts with the interval and packet size from
> those fields, instead of the endpoint descriptor.
>
> We should probably set the new values in usb_host_endpoint to zero after
> the driver unbinds from the device.  Not sure if they should be reset
> after the driver switches interfaces.  I would have to see the use cases
> in the driver.
>
>> Here, it is needed to change the endpoint descriptors with the new
>> value in urb so that xhci takes the correct value?
>> I mean the fix should be made in usbcore and xhci shall remain intact?
> No, we need to fix both the xHCI driver and the USB core.
>
>> I have time to work on that but i 'm not sure that i understood.
> Sure.  I would actually suggest you first finish up the patch to issue a
> configure endpoint if userspace wants to clear a halt, but the endpoint
> isn't actually halted.  Did your most current patch work?  I can't
> remember what the status was.
>
> Sarah Sharp

Thanks for the clarification, I understand better now.
As far as concerns the reset endpoint fix, I am not sure if it works I 
have to send an RFC so that it can be further tested but I have a lot of 
pending RFCs for xhci on the mailing list so i was waiting for those to 
be reviewed before sending new ones. Or it is not necessary to wait and 
just send the RFC based on current usb-next tree?

regards,
ksenia
