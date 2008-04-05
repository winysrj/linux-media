Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m357rHQv012019
	for <video4linux-list@redhat.com>; Sat, 5 Apr 2008 03:53:17 -0400
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m357r5FC005609
	for <video4linux-list@redhat.com>; Sat, 5 Apr 2008 03:53:05 -0400
Message-ID: <47F72FC1.7020109@hhs.nl>
Date: Sat, 05 Apr 2008 09:52:33 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
References: <47ED68E3.7040400@hhs.nl>
	<20080404184855.963369c5.zaitcev@redhat.com>
In-Reply-To: <20080404184855.963369c5.zaitcev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: fedora-kernel-list@redhat.com, video4linux-list@redhat.com,
	spca50x-devs@lists.sourceforge.net
Subject: Re: [New Driver]: usbvideo2 webcam core + pac207 driver using it.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Pete Zaitcev wrote:
> On Fri, 28 Mar 2008 22:53:39 +0100, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
> 
>> 	u8 users;
> 
> Make it int, too easy to overflow.
> 

The current code doesn't allow simultanious opens, so this can become only 0 or 1 .

>> static u32
>> usbvideo2_request_buffers(struct usbvideo2_device* cam, u32 count)
>> {
>> 		if ((buff = vmalloc_32_user(cam->nbuffers *
>> 						PAGE_ALIGN(cam->imagesize))))
> 
> I think that placing buffers into the lower 4GB is a senseless
> limitation to build into a library. Although today the only system
> which can run DMA between memory above 4GB and USB is Opteron,
> with XHCI it's going to change.

Actually this isn't used for dma at all, so the _32_ can indeed go away.

> 
>> 					spin_unlock(&cam->queue_lock);
>> 					wake_up_interruptible(&cam->wait_frame);
> 
> Why only interruptible

Because there are only interruptable waits done on it and My Linux Device 
Drivers 3th edition (Corbet et All) says to use _interruptible when there are 
only interruptible waiters. Also I took most of this from exisiting v4l2 usb 
drivers which do it the same.

> , and why outside of the lock? Bizarre.

Why would this need to be done inside the lock? The wait_frame queue has its 
own internal locking, no need to keep the queue lock longer then necessary esp 
as its a spinlock.


>> 	urb->dev = cam->usbdev;
>> 	ret = usb_submit_urb(urb, GFP_ATOMIC);
> 
> If you don't plan on using this code on kernel 2.4, don't restore
> urb->dev. This was unnecessary for years. Just set it where you
> fill the URB.
> 

Ok.


>> 			urb->transfer_buffer = usb_buffer_alloc(udev,
>> 							 (psz + 1) *
>> 							 USBVIDEO2_ISO_PACKETS,
>> 							 GFP_KERNEL,
>> 							 &urb->transfer_dma);
> 
> Why are you using usb_buffer_alloc here? Why not use kmalloc?
> 

I took this from gspca, and I believe this is necessary to get a buffer will at 
all the proper attributes for being able todo a dma transfer to it.

> Secondly, let's suppose you're allocating for 512-byte packets
> (actually 513 for some reason). You're above 8KB by a few bytes,
> thus making this an order 2 allocation. I am quite certain this
> is going to fail on loaded systems.
> 

Good point!

> If you ever run across a device with a bigger maximum packet size
> (e.g. a WUSB webcam) this is just going to crash and burn.
> 
> So, why do you need to stuff 16 ISO blocks into one URB? Hardware
> limitation?
> 

No special reason I copied this from gspca, I guess I can just make it 
PAGE_SIZE / (packet_size + 1)

> Any why is this affinity to device's declared packet size? The HC
> transparently merges transfers for you. So, the only thing you
> need to think about is if your buffers are an integral number
> of packets.
> 

Some webcams are so nice as to only put a sof (start of frame) marker/header at 
the start of a packet, so if the packets match actually device packets, then 
one only needs to check the first few bytes for the magic sof marker, instead 
of having to search through the entire packet (as one must do with other less 
nice webcams).

> What is this +1 business, anyway?
> 

The pac207 (and sn109c bayer compression code uses variable length bit 
patterns, the decoder always reads 8 bits and the looks this up in a table 
which tells it amongst other things how much bits where actually used. So if 
the last pixel in a row is coded in say 2 bits, and it happens to also be at 
the end of a packet 6 additional bits will get read (and ignored).

So the buffer gets allocated 1 byte too large to allow safe reading of these 6 
bits.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
