Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:33277 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1FKEO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 00:14:56 -0400
Date: Fri, 10 Jun 2011 23:17:21 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Xiaofan Chen <xiaofanc@gmail.com>
cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	libusb-devel@lists.sourceforge.net
Subject: Re: Improving kernel -> userspace (usbfs) usb device hand off
In-Reply-To: <BANLkTinAfB_jiS+6f8Dqt4ZEK19ndv_nDA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1106102314000.11975@banach.math.auburn.edu>
References: <20110610002103.GA7169@xanatos> <4DF1CDE1.4080303@redhat.com> <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu> <20110610183452.GV31396@legolas.emea.dhcp.ti.com> <alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu>
 <BANLkTinAfB_jiS+6f8Dqt4ZEK19ndv_nDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Sat, 11 Jun 2011, Xiaofan Chen wrote:

> On Sat, Jun 11, 2011 at 6:43 AM, Theodore Kilgore
> <kilgota@banach.math.auburn.edu> wrote:
> > I do not believe that we have found the optimal solution, yet. The ideal
> > thing would be some kind of hack which allows the kernel to be used when
> > it is needed, and when it is not needed it does not interfere.
> 
> Just wondering if you can use libusb-1.0 for the user space still image
> functionality.
> 
> libusb-1.0 offers the following functions to do that for you under Linux.
> 
> int 	libusb_kernel_driver_active (libusb_device_handle *dev, int interface)
>  	Determine if a kernel driver is active on an interface.
> int 	libusb_detach_kernel_driver (libusb_device_handle *dev, int interface)
>  	Detach a kernel driver from an interface.
> int 	libusb_attach_kernel_driver (libusb_device_handle *dev, int interface)
>  	Re-attach an interface's kernel driver, which was previously
> detached using libusb_detach_kernel_driver().
> 
> So you can detach the kernel v4l2 driver at the beginning and later
> re-attach it when you finish.

Well, then, this solves the problem, doesn't it? Of course, those who deal 
with creating those "simple" and "user-friendly" GUI environments would 
probably still do well if they would open a dialog box for dual-mode 
hardware.

Theodore Kilgore
