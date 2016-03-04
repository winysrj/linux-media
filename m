Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37788 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbcCDBB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 20:01:27 -0500
Received: by mail-wm0-f51.google.com with SMTP id p65so11775007wmp.0
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 17:01:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN5YuFYbg0RwhhO3ck1m86PPk+PQrqrM9qNfRsoah==4_VS-SA@mail.gmail.com>
References: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
	<CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
	<CAN5YuFYbg0RwhhO3ck1m86PPk+PQrqrM9qNfRsoah==4_VS-SA@mail.gmail.com>
Date: Thu, 3 Mar 2016 22:01:25 -0300
Message-ID: <CAAEAJfANkWbYRHXb2kcCeFaffQ8UBqofX569So4r0A-NzwazOg@mail.gmail.com>
Subject: Re: STK1160 - no video
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Kevin Fitch <kfitch42@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Philippe Desrochers <desrochers.philippe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3 March 2016 at 21:50, Kevin Fitch <kfitch42@gmail.com> wrote:
> Thank you for the quick response. Hmm, I am not seeing anything about
> the saa7113 or similar chip. I just replugged it, and here is what
> showed up in the log:
>
> Mar  3 19:32:45 home kernel: [122185.832751] usb 2-3: New USB device
> found, idVendor=05e1, idProduct=0408
> Mar  3 19:32:45 home kernel: [122185.832762] usb 2-3: New USB device
> strings: Mfr=1, Product=2, SerialNumber=0
> Mar  3 19:32:45 home kernel: [122185.832769] usb 2-3: Product: USB 2.0
> Video Capture Controller
> Mar  3 19:32:45 home kernel: [122185.832774] usb 2-3: Manufacturer:
> Syntek Semiconductor
> Mar  3 19:32:45 home mtp-probe: checking bus 2, device 4:
> "/sys/devices/pci0000:00/0000:00:04.1/usb2/2-3"
> Mar  3 19:32:45 home mtp-probe: bus: 2, device: 4 was not an MTP device
> Mar  3 19:32:45 home kernel: [122185.885397] usb 2-3: New device
> Syntek Semiconductor USB 2.0 Video Capture Controller @ 480 Mbps
> (05e1:0408, interface 0, class 0)
> Mar  3 19:32:45 home kernel: [122185.885408] usb 2-3: video interface 0 found
> Mar  3 19:32:45 home kernel: [122186.456571] stk1160: driver ver 0.9.5
> successfully loaded
> Mar  3 19:32:46 home kernel: [122186.589683] stk1160: registers to
> NTSC like standard
> Mar  3 19:32:46 home kernel: [122186.590676] stk1160 2-3:1.0: V4L2
> device registered as video0
> Mar  3 19:32:46 home kernel: [122186.591299] usbcore: registered new
> interface driver stk1160
> Mar  3 19:32:46 home pulseaudio[2312]: [pulseaudio]
> module-alsa-card.c: Failed to find a working profile.
> Mar  3 19:32:46 home pulseaudio[2312]: [pulseaudio] module.c: Failed
> to load module "module-alsa-card" (argument: "device_id="3"
> name="usb-Syntek_Semiconductor_USB_2.0_Video_Capture_Controller-00-stk1160mixer"
> card_name="alsa_card.usb-Syntek_Semiconductor_USB_2.0_Video_Capture_Controller-00-stk1160mixer"
> namereg_fail=false tsched=yes fixed_latency_range=no ignore_dB=no
> deferred_volume=yes use_ucm=yes
> card_properties="module-udev-detect.discovered=1""): initialization
> failed.
> Mar  3 19:32:47 home pulseaudio[2312]: [pulseaudio] source.c: Default
> and alternate sample rates are the same.
> Mar  3 19:32:47 home rtkit-daemon[2314]: Successfully made thread
> 15492 of process 2312 (n/a) owned by '1000' RT at priority 5.
> Mar  3 19:32:47 home rtkit-daemon[2314]: Supervising 4 threads of 1
> processes of 1 users.
>
>
> So, I popped the case on the dongle and I did see  a chip (right next
> to the video cables) labelled CJC7113. I would assume(/hope) this is a
> SAA7113 compatible chip. I actually don't care about audio in my
> particular application, but there is a Realtek ALC6555 on the bottom
> as well.
>

Thanks for the information. Philippe Desrochers has reported this,
and found the chip is compatible with SAA7113 [1].

Quoting him:

> I tested with saa7115.c and the problem is in the "saa711x_detect_chip"
> function.
> In fact, the CJC7113 chip seems to returns all '1' when reading register 0.
>  ("1111111111111111" found @ 0x4a (stk1160)))

Guess a bunch of STK1160 devices are now being sold
with the CJC7113 and probably many users are getting hit by this :(

I can try to cook a patch or feel free to do it yourself and post it.

As a quick solution, you can hack saa711x_detect_chip() so it
always returns SAA7113.

We could also add a module parameter to stk1160, to allow
to force the decoder string, but I'd rather have saa7115
autodetection working for all chips.

[1] http://www.spinics.net/lists/linux-media/msg95887.html
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
