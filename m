Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:26942 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZCRUJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 16:09:42 -0400
Received: by yw-out-2324.google.com with SMTP id 5so218678ywb.1
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 13:09:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C15289.5070206@august.de>
References: <49C15289.5070206@august.de>
Date: Wed, 18 Mar 2009 16:09:40 -0400
Message-ID: <412bdbff0903181309j24ce115drcecbdacd91d2902c@mail.gmail.com>
Subject: Re: no video device
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Rolf Schumacher <mailinglist@august.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 18, 2009 at 3:59 PM, Rolf Schumacher <mailinglist@august.de> wrote:
> Hi, dvb professionals,
>
> I followed the advices on
> http://www.linuxtv.org/wiki/index.php/How_to_Obtain%2C_Build_and_Install_V4L-DVB_Device_Drivers#Optional_Pre-Compilation_Steps
>
> Build and Installation Instructions
>
> downloaded the v4l sources via mercurial,
> "make" and "sudo make install" finished without error messages.
>
> rebooted the computer
>
> dmesg shows the device:
>
> ---
> usb 2-1: new high speed USB device using ehci_hcd and address 6
> usb 2-1: configuration #1 chosen from 1 choice
> usb 2-1: New USB device found, idVendor=0b48, idProduct=300d
> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-1: Product: TT-USB2.0
> usb 2-1: Manufacturer: TechnoTrend
> usb 2-1: SerialNumber: LHKAMG
> ---
>
> no error if I unplug and plug it on USB again
>
> the connected box is a TechnoTrend CT 3560 CI
> I googled and found chipset names like TDA8274 + TDA10023
> did not find anything in wiki, so I could not determine module or driver
> names to be identified with lsmod.
>
> there is no created /dev/dvb or /dev/video device
>
> google did not help me answering the question "do I need firmware, and
> if so where to get it"
>
> uname -a shows
> Linux rolf9 2.6.28-7.slh.6-sidux-686 #1 SMP PREEMPT Sat Mar 14 02:30:40
> UTC 2009 i686 GNU/Linux
>
> for now I got stuck.
>
> Do you know of a next step towards having tv on my laptop?

I don't think the product is supported.  Just to be clear, you can't
just modprobe the chip driver for whatever components happen to be in
your device and expect it to work.

If you are lucky enough to have a product where all the chipset
drivers are already written, then a developer needs to write a device
profile in the bridge driver.  However, if it uses some components
that are not supported, then it's a lot more work since an entire new
driver needs to be written.

If you want to help make it work, you should start by creating a page
in the linuxtv.org wiki, and include high resolution digital photos of
the circuit board, so people can get an accurate inventory of what
chips are in the device in question.  From there, perhaps a developer
interested in adding the support can do the driver work.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
