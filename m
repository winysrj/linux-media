Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45418 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab1FKBaZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 21:30:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu>
References: <20110610002103.GA7169@xanatos>
	<4DF1CDE1.4080303@redhat.com>
	<alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu>
	<20110610183452.GV31396@legolas.emea.dhcp.ti.com>
	<alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu>
Date: Sat, 11 Jun 2011 09:30:24 +0800
Message-ID: <BANLkTinAfB_jiS+6f8Dqt4ZEK19ndv_nDA@mail.gmail.com>
Subject: Re: Improving kernel -> userspace (usbfs) usb device hand off
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	libusb-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jun 11, 2011 at 6:43 AM, Theodore Kilgore
<kilgota@banach.math.auburn.edu> wrote:
> I do not believe that we have found the optimal solution, yet. The ideal
> thing would be some kind of hack which allows the kernel to be used when
> it is needed, and when it is not needed it does not interfere.

Just wondering if you can use libusb-1.0 for the user space still image
functionality.

libusb-1.0 offers the following functions to do that for you under Linux.

int 	libusb_kernel_driver_active (libusb_device_handle *dev, int interface)
 	Determine if a kernel driver is active on an interface.
int 	libusb_detach_kernel_driver (libusb_device_handle *dev, int interface)
 	Detach a kernel driver from an interface.
int 	libusb_attach_kernel_driver (libusb_device_handle *dev, int interface)
 	Re-attach an interface's kernel driver, which was previously
detached using libusb_detach_kernel_driver().

So you can detach the kernel v4l2 driver at the beginning and later
re-attach it when you finish.

-- 
Xiaofan
