Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:36740 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbcCDAu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 19:50:26 -0500
Received: by mail-yk0-f182.google.com with SMTP id 1so16913644ykg.3
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 16:50:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
References: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
	<CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
Date: Thu, 3 Mar 2016 19:50:24 -0500
Message-ID: <CAN5YuFYbg0RwhhO3ck1m86PPk+PQrqrM9qNfRsoah==4_VS-SA@mail.gmail.com>
Subject: Re: STK1160 - no video
From: Kevin Fitch <kfitch42@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for the quick response. Hmm, I am not seeing anything about
the saa7113 or similar chip. I just replugged it, and here is what
showed up in the log:

Mar  3 19:32:45 home kernel: [122185.832751] usb 2-3: New USB device
found, idVendor=05e1, idProduct=0408
Mar  3 19:32:45 home kernel: [122185.832762] usb 2-3: New USB device
strings: Mfr=1, Product=2, SerialNumber=0
Mar  3 19:32:45 home kernel: [122185.832769] usb 2-3: Product: USB 2.0
Video Capture Controller
Mar  3 19:32:45 home kernel: [122185.832774] usb 2-3: Manufacturer:
Syntek Semiconductor
Mar  3 19:32:45 home mtp-probe: checking bus 2, device 4:
"/sys/devices/pci0000:00/0000:00:04.1/usb2/2-3"
Mar  3 19:32:45 home mtp-probe: bus: 2, device: 4 was not an MTP device
Mar  3 19:32:45 home kernel: [122185.885397] usb 2-3: New device
Syntek Semiconductor USB 2.0 Video Capture Controller @ 480 Mbps
(05e1:0408, interface 0, class 0)
Mar  3 19:32:45 home kernel: [122185.885408] usb 2-3: video interface 0 found
Mar  3 19:32:45 home kernel: [122186.456571] stk1160: driver ver 0.9.5
successfully loaded
Mar  3 19:32:46 home kernel: [122186.589683] stk1160: registers to
NTSC like standard
Mar  3 19:32:46 home kernel: [122186.590676] stk1160 2-3:1.0: V4L2
device registered as video0
Mar  3 19:32:46 home kernel: [122186.591299] usbcore: registered new
interface driver stk1160
Mar  3 19:32:46 home pulseaudio[2312]: [pulseaudio]
module-alsa-card.c: Failed to find a working profile.
Mar  3 19:32:46 home pulseaudio[2312]: [pulseaudio] module.c: Failed
to load module "module-alsa-card" (argument: "device_id="3"
name="usb-Syntek_Semiconductor_USB_2.0_Video_Capture_Controller-00-stk1160mixer"
card_name="alsa_card.usb-Syntek_Semiconductor_USB_2.0_Video_Capture_Controller-00-stk1160mixer"
namereg_fail=false tsched=yes fixed_latency_range=no ignore_dB=no
deferred_volume=yes use_ucm=yes
card_properties="module-udev-detect.discovered=1""): initialization
failed.
Mar  3 19:32:47 home pulseaudio[2312]: [pulseaudio] source.c: Default
and alternate sample rates are the same.
Mar  3 19:32:47 home rtkit-daemon[2314]: Successfully made thread
15492 of process 2312 (n/a) owned by '1000' RT at priority 5.
Mar  3 19:32:47 home rtkit-daemon[2314]: Supervising 4 threads of 1
processes of 1 users.


So, I popped the case on the dongle and I did see  a chip (right next
to the video cables) labelled CJC7113. I would assume(/hope) this is a
SAA7113 compatible chip. I actually don't care about audio in my
particular application, but there is a Realtek ALC6555 on the bottom
as well.

Kevin Fitch.



On Thu, Mar 3, 2016 at 6:13 PM, Ezequiel Garcia
<ezequiel@vanguardiasur.com.ar> wrote:
> Hi Kevin,
>
> Thanks for the report.
>
> On 3 March 2016 at 14:20, Kevin Fitch <kfitch42@gmail.com> wrote:
>> I recently purchased a STK1160 based USB video capture device (Sabrent
>> USB-AVCPT). I have tested it on a windows computer and it works fine,
>> but not on any linux box I have tried.
>>
>> lsusb reports:
>> Bus 002 Device 003: ID 05e1:0408 Syntek Semiconductor Co., Ltd STK1160
>> Video Capture Device
>>
>
> Can you send us the kernel log after the dongle is plugged? In particular,
> we are looking for something like this:
>
> saa7115 7-0025: saa7113 found @ 0x4a (stk1160)
>
> STK1160 devices are known to be sold with different decoder chips,
> and sometimes the decoder chip is not detected by the decoder
> driver.
>
> See this thread for more information:
> http://www.spinics.net/lists/linux-media/msg95216.html
> --
> Ezequiel García, VanguardiaSur
> www.vanguardiasur.com.ar
