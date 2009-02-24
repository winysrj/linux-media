Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbZBXV6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 16:58:04 -0500
Date: Tue, 24 Feb 2009 13:57:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-media@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, nm127@freemail.hu
Subject: Re: [Bugme-new] [Bug 12768] New: usb_alloc_urb() leaks memory
 together with uvcvideo driver
Message-Id: <20090224135720.9e752fee.akpm@linux-foundation.org>
In-Reply-To: <bug-12768-10286@http.bugzilla.kernel.org/>
References: <bug-12768-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon, 23 Feb 2009 22:08:37 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12768

There's additional info at the link.

>            Summary: usb_alloc_urb() leaks memory together with uvcvideo
>                     driver
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.28
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: nm127@freemail.hu
> 
> 
> Latest working kernel version:
> Earliest failing kernel version:
> Distribution:
> Hardware Environment: EeePC 901
> Software Environment: Debian 5.0
> Problem Description:
> 
> Steps to reproduce:
> 1. Boot the system
> 2. start an xterm window and execute the following command:
> 
> $ while true; do clear; cat /proc/slab_allocators |grep usb_alloc; sleep 1;
> done
> 
> This will print out similar lines each second:
> 
> size-2048: 18 usb_alloc_dev+0x1d/0x212 [usbcore]
> size-2048: 2280 usb_alloc_urb+0xc/0x2b [usbcore]
> size-1024: 85 usb_alloc_urb+0xc/0x2b [usbcore]
> size-128: 10 usb_alloc_urb+0xc/0x2b [usbcore]
> 
> 3. Start xawtv, this will show the picture of the webcam
> 4. Exit xawtv
> 
> Current result:
> In the output of /proc/slab_allocators the number of blocks allocated by
> usb_alloc_urb() increases, however, the xawtv is no longer running:
> 
> size-2048: 18 usb_alloc_dev+0x1d/0x212 [usbcore]
> size-2048: 2280 usb_alloc_urb+0xc/0x2b [usbcore]
> size-1024: 100 usb_alloc_urb+0xc/0x2b [usbcore]
> size-128: 10 usb_alloc_urb+0xc/0x2b [usbcore]
> 
> Each time xawtv is started and stopped the value increases at the
> usb_alloc_urb().
> 
> Expected result: the same memory usage is reached again after xawtv exited.
> 

I assume this is a v4l bug and not a USB core bug?

