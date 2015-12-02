Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35420 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbbLBRzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 12:55:55 -0500
Received: by wmuu63 with SMTP id u63so225662505wmu.0
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2015 09:55:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHwmhgGhdH8_+_5abeJZg=sL2nrr3psqzwHz3xrL_u1aV6mNCg@mail.gmail.com>
References: <CAHwmhgFyjLOT6Na6oLXQT+FiUjyjrPX_CmKvQVDP-k9kawnMHw@mail.gmail.com>
	<CALF0-+UtHzo6-vYvUWtvS0hU7jyuPU+Ku4JC85T4gn4AHLgS0w@mail.gmail.com>
	<CAHwmhgGhdH8_+_5abeJZg=sL2nrr3psqzwHz3xrL_u1aV6mNCg@mail.gmail.com>
Date: Wed, 2 Dec 2015 14:55:53 -0300
Message-ID: <CAAEAJfDzpafBTqcTqjvEJWVxOQu7j=zK6m47VhnSVgM4kWhG5Q@mail.gmail.com>
Subject: Re: Sabrent (stk1160) / Easycap driver problem
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Philippe Desrochers <desrochers.philippe@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 December 2015 at 14:43, Philippe Desrochers
<desrochers.philippe@gmail.com> wrote:
> I'm sending the email again (in plain text) since it seems it was blocked by
> the server.
>
> EASYCAP CHINA CLONE (OK):
> [ 8630.596236] usb 2-1: new high-speed USB device number 6 using ehci-pci
> [ 8630.729074] usb 2-1: New USB device found, idVendor=05e1, idProduct=0408
> [ 8630.729084] usb 2-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [ 8630.729091] usb 2-1: Product: USB 2.0 Video Capture Controller
> [ 8630.729097] usb 2-1: Manufacturer: Syntek Semiconductor
> [ 8630.729648] usb 2-1: New device Syntek Semiconductor USB 2.0 Video
> Capture Controller @ 480 Mbps (05e1:0408, interface 0, class 0)
> [ 8630.729656] usb 2-1: video interface 0 found
> [ 8631.242258] saa7115 7-0025: saa7113 found @ 0x4a (stk1160)

Hmm.. seems the bad device doesn't found a decoder chip. Let me
refresh my mind and get back to you.
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
