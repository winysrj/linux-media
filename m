Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:56248 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab2LLW27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 17:28:59 -0500
Message-ID: <50C90528.2040602@collabora.co.uk>
Date: Wed, 12 Dec 2012 23:28:56 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: laurent.pinchart@ideasonboard.com, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org,
	Martin Barrett <martin.barrett@collabora.co.uk>
Subject: Re: issue with uvcvideo and xhci
References: <50C86ECC.9050505@collabora.co.uk> <20121212175235.GD21295@xanatos>
In-Reply-To: <20121212175235.GD21295@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2012 06:52 PM, Sarah Sharp wrote:
> On Wed, Dec 12, 2012 at 12:47:24PM +0100, Javier Martinez Canillas wrote:
>> Hello,
>> 
>> We have an issue when trying to use USB cameras on a particular machine using
>> the latest mainline Linux 3.7 kernel. This is not a regression since the same
>> issue is present with older kernels (i.e: 3.5).
>> 
>> The cameras work fine when plugged to an USB2.0 port (using the EHCI HCD host
>> controller driver) but they don't when using the USB3.0 port (using the xHCI
>> HCD host controller driver).
>> 
>> The machine's USB3.0 host controller is a NEC Corporation uPD720200 USB 3.0 Host
>> Controller (rev 04).
>> 
>> When enabling trace on the uvcvideo driver I see that most frames are lost:
>> 
>> Dec 12 11:07:58 thinclient kernel: [ 4965.597637] uvcvideo: USB isochronous
>> frame lost (-18).
>> Dec 12 11:07:58 thinclient kernel: [ 4965.597642] uvcvideo: USB isochronous
>> frame lost (-18).
>> Dec 12 11:07:58 thinclient kernel: [ 4965.597647] uvcvideo: Marking buffer as
>> bad (error bit set).
>> Dec 12 11:07:58 thinclient kernel: [ 4965.597651] uvcvideo: Frame complete (EOF
>> found).
>> Dec 12 11:07:58 thinclient kernel: [ 4965.597655] uvcvideo: EOF in empty payload.
>> Dec 12 11:07:58 thinclient kernel: [ 4965.597661] uvcvideo: Dropping payload
>> (out of sync).
>> Dec 12 11:07:58 thinclient kernel: [ 4965.813294] uvcvideo: frame 486 stats:
>> 0/2/8 packets, 0/0/8 pts
>> 
>> The uvcvideo checks if urb->iso_frame_desc[i].status < 0 on the
>> uvc_video_decode_isoc() function (drivers/media/usb/uvc/uvc_video.c).
>> 
>> I checked on the xhci driver and the only place where this error code (-EXDEV)
>> is assigned to frame->status is inside the skip_isoc_td() function
>> (drivers/usb/host/xhci-ring.c).
>> 
>> At this point I'm not sure if this is a bug on the xhci driver, another quirk
>> needed by the XHCI_NEC_HOST, a camera misconfiguration on the USB Video Class
>> driver or a firmware/hardware bug.
> 
> It's a known performance issue, although it's not clear whether it's on
> the xHCI driver side or the host controller side.  When an interface
> setting is enabled where the isochronous endpoint requires two
> additional transfers per service interval, the NEC host controller
> starts reporting many missed service intervals.  The xHCI driver then
> finds all the frame buffers that were skipped and marks them with the
> -EXDEV status.
>
> An error status of Missed Service Interval means the host controller
> could not access the transfer memory fast enough through the PCI bus to
> service the endpoint in time.  It could be a host hardware issue, or it
> could be software slowing down the system to a crawl.  I lean towards a
> software issue since, as you said, the Windows driver works fine.
> (Although who knows what NEC quirks the Windows driver is working
> around...)
>
> The NEC xHCI host controller is a 0.96 revision, which doesn't support
> the Block Event Interrupt (BEI) flag which cuts down on the number of
> interrupts per URB submitted.  So the xHCI driver's interrupt routine
> gets called on every single service interval, rather than being called
> once per URB.
> 
> Since the Linux xHCI driver isn't really optimized for performance yet,
> the interrupt handler is probably pretty slow and could cause delays in
> submitting future URBs.  The high amount of interrupts is probably
> causing other systems to be starved, possibly leading to the xHCI host
> controller not being able to access memory fast enough to service the
> endpoint.
>

Hi Sarah,

Thanks for the explanation. Now it makes sense to me and I understand why it
works when I decrease either the frame rate or the frame size below certain
thresholds.

>> The cameras are reported to work on the same machine but using another operating
>> system (Windows).
> 
> Windows probably uses Event Data TRBs to cut the interrupts down to one
> per URB.  It would take a major effort to make the xHCI driver use Event
> Data TRBs.
> 
>> I was wondering if you can give me some pointers on how to be sure what's the
>> issue or if this rings any bells to you.
> 
> I don't have time to work on performance issues right now, as I have
> several other critical bugs (mostly around failed S3/S4).  However, if
> you want to try to fix this issue yourself, I suggest you run perf and
> see where the bottle necks in the xHCI interrupt handler are.
> 
> I suspect that part of it is that the interrupt handler reads the xHCI
> status register.  That PCI register read is pretty costly, and it's not
> necessary since 99% of the time the host controller is going to report
> an OK status.  And there's no guarantee that when the host does have an
> error that it will set a bad status.
> 
> But without an analysis by perf, we won't really know where the
> bottlenecks are.
> 
> Sarah Sharp
> 

Ok, I'll try do some performance analysis to figure out where these bottlenecks
could be and if I can do anything to improve them.

Thanks a lot for your help!

Best regards,
Javier
