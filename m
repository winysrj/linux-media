Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:50385 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZHSNmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 09:42:01 -0400
Received: by yxe5 with SMTP id 5so5392834yxe.33
        for <linux-media@vger.kernel.org>; Wed, 19 Aug 2009 06:42:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250679685.14727.14.camel@McM>
References: <1250679685.14727.14.camel@McM>
Date: Wed, 19 Aug 2009 09:42:01 -0400
Message-ID: <829197380908190642sfabee2ahe599dda1df39678c@mail.gmail.com>
Subject: Re: USB Wintv HVR-900 Hauppauge
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Miguel <mcm@moviquity.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 19, 2009 at 7:01 AM, Miguel<mcm@moviquity.com> wrote:
>
> Hello,
>
> I am trying to set up the dvb-t device in my ubuntu 9.04.
> As far as i can see , this device has tm6000 chipset but I don't get it
> works. I have followed the guide of tvlinux.org:
> http://www.linuxtv.org/wiki/index.php/Trident_TM6000#TM6000_based_Devices
>
> I have compile v4l-dvb, make, and make install and it seems that the
> modules are loaded:
>
>
> em28xx                 90668  0
> ir_common              57732  1 em28xx
> v4l2_common            25600  1 em28xx
> videobuf_vmalloc       14724  1 em28xx
> videobuf_core          26244  2 em28xx,videobuf_vmalloc
> tveeprom               20228  1 em28xx
> videodev               44832  3 em28xx,v4l2_common,uvcvideo
>
>
> But by the moment, I don't know which driver  I should you. Actually,
> when I switch the usb wintv on , my so doesn't recognize it:
>
> [11107.449900] usb 1-3: new high speed USB device using ehci_hcd and
> address 8
> [11107.593094] usb 1-3: configuration #1 chosen from 1 choice
>
>
> how can I get this device run?
>
> thank you in advance.
>
> Miguel

Hello Miguel,

Can you confirm the exact model number of the device (or provide the
USB ID)?  I suspect you probably have what is often referred to as an
HVR-900 R2, which is not currently supported under Linux.

I've got it working here but still need to write the firmware extract
script so I can release it, but the work has been delayed due to other
priorities.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
