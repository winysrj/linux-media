Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:36047 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbcCDDL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 22:11:27 -0500
Received: by mail-yw0-f176.google.com with SMTP id i131so21702445ywc.3
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 19:11:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAEAJfANkWbYRHXb2kcCeFaffQ8UBqofX569So4r0A-NzwazOg@mail.gmail.com>
References: <CAN5YuFYiRPDMUFqiiJrLXCH-tZnO9SJ-_TZfLD6_uq-L63OKyQ@mail.gmail.com>
	<CAAEAJfAg=QovDOHgTnh+0Gy5BbSXinc+rPGvTa61r5nyuou2tQ@mail.gmail.com>
	<CAN5YuFYbg0RwhhO3ck1m86PPk+PQrqrM9qNfRsoah==4_VS-SA@mail.gmail.com>
	<CAAEAJfANkWbYRHXb2kcCeFaffQ8UBqofX569So4r0A-NzwazOg@mail.gmail.com>
Date: Thu, 3 Mar 2016 22:11:26 -0500
Message-ID: <CAN5YuFa0kXxym9bq38CCxSXp5HqUbKLYjvRfG5EUGEcoZDZK3w@mail.gmail.com>
Subject: Re: STK1160 - no video
From: Kevin Fitch <kfitch42@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>,
	Philippe Desrochers <desrochers.philippe@gmail.com>
Content-Type: multipart/mixed; boundary=001a11421e4677ec2d052d307897
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a11421e4677ec2d052d307897
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Here is a quick patch that gives me actual video. That being said I
see some curious stuff being logged while video is streaming:

Mar  3 22:04:40 home kernel: [131300.882159] stk1160: streaming started
Mar  3 22:04:49 home kernel: [131309.987118] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987132] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987135] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987138] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987141] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987144] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987147] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987149] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987152] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987155] stk1160: buffer overflow detec=
ted
Mar  3 22:04:49 home kernel: [131309.987158] stk1160: buffer overflow detec=
ted
Mar  3 22:04:51 home kernel: [131312.547028] stk1160: buffer overflow detec=
ted
Mar  3 22:04:52 home kernel: [131312.955081] stk1160: buffer overflow detec=
ted
Mar  3 22:04:52 home kernel: [131313.362920] stk1160: buffer overflow detec=
ted
Mar  3 22:04:52 home kernel: [131313.507093] stk1160: buffer overflow detec=
ted
Mar  3 22:04:55 home kernel: [131315.778953] stk1160: buffer overflow detec=
ted
Mar  3 22:04:55 home kernel: [131315.778962] stk1160_copy_video: 323
callbacks suppressed
Mar  3 22:04:55 home kernel: [131315.778964] stk1160: buffer overflow detec=
ted
Mar  3 22:04:55 home kernel: [131315.778965] stk1160: buffer overflow detec=
ted
Mar  3 22:04:55 home kernel: [131315.778967] stk1160: buffer overflow detec=
ted
...

I haven't taken time to look into them at all yet.

Kevin Fitch

On Thu, Mar 3, 2016 at 8:01 PM, Ezequiel Garcia
<ezequiel@vanguardiasur.com.ar> wrote:
> On 3 March 2016 at 21:50, Kevin Fitch <kfitch42@gmail.com> wrote:
>> Thank you for the quick response. Hmm, I am not seeing anything about
>> the saa7113 or similar chip. I just replugged it, and here is what
>> showed up in the log:
>>
>> Mar  3 19:32:45 home kernel: [122185.832751] usb 2-3: New USB device
>> found, idVendor=3D05e1, idProduct=3D0408
>> Mar  3 19:32:45 home kernel: [122185.832762] usb 2-3: New USB device
>> strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
>> Mar  3 19:32:45 home kernel: [122185.832769] usb 2-3: Product: USB 2.0
>> Video Capture Controller
>> Mar  3 19:32:45 home kernel: [122185.832774] usb 2-3: Manufacturer:
>> Syntek Semiconductor
>> Mar  3 19:32:45 home mtp-probe: checking bus 2, device 4:
>> "/sys/devices/pci0000:00/0000:00:04.1/usb2/2-3"
>> Mar  3 19:32:45 home mtp-probe: bus: 2, device: 4 was not an MTP device
>> Mar  3 19:32:45 home kernel: [122185.885397] usb 2-3: New device
>> Syntek Semiconductor USB 2.0 Video Capture Controller @ 480 Mbps
>> (05e1:0408, interface 0, class 0)
>> Mar  3 19:32:45 home kernel: [122185.885408] usb 2-3: video interface 0 =
found
>> Mar  3 19:32:45 home kernel: [122186.456571] stk1160: driver ver 0.9.5
>> successfully loaded
>> Mar  3 19:32:46 home kernel: [122186.589683] stk1160: registers to
>> NTSC like standard
>> Mar  3 19:32:46 home kernel: [122186.590676] stk1160 2-3:1.0: V4L2
>> device registered as video0
>> Mar  3 19:32:46 home kernel: [122186.591299] usbcore: registered new
>> interface driver stk1160
>> Mar  3 19:32:46 home pulseaudio[2312]: [pulseaudio]
>> module-alsa-card.c: Failed to find a working profile.
>> Mar  3 19:32:46 home pulseaudio[2312]: [pulseaudio] module.c: Failed
>> to load module "module-alsa-card" (argument: "device_id=3D"3"
>> name=3D"usb-Syntek_Semiconductor_USB_2.0_Video_Capture_Controller-00-stk=
1160mixer"
>> card_name=3D"alsa_card.usb-Syntek_Semiconductor_USB_2.0_Video_Capture_Co=
ntroller-00-stk1160mixer"
>> namereg_fail=3Dfalse tsched=3Dyes fixed_latency_range=3Dno ignore_dB=3Dn=
o
>> deferred_volume=3Dyes use_ucm=3Dyes
>> card_properties=3D"module-udev-detect.discovered=3D1""): initialization
>> failed.
>> Mar  3 19:32:47 home pulseaudio[2312]: [pulseaudio] source.c: Default
>> and alternate sample rates are the same.
>> Mar  3 19:32:47 home rtkit-daemon[2314]: Successfully made thread
>> 15492 of process 2312 (n/a) owned by '1000' RT at priority 5.
>> Mar  3 19:32:47 home rtkit-daemon[2314]: Supervising 4 threads of 1
>> processes of 1 users.
>>
>>
>> So, I popped the case on the dongle and I did see  a chip (right next
>> to the video cables) labelled CJC7113. I would assume(/hope) this is a
>> SAA7113 compatible chip. I actually don't care about audio in my
>> particular application, but there is a Realtek ALC6555 on the bottom
>> as well.
>>
>
> Thanks for the information. Philippe Desrochers has reported this,
> and found the chip is compatible with SAA7113 [1].
>
> Quoting him:
>
>> I tested with saa7115.c and the problem is in the "saa711x_detect_chip"
>> function.
>> In fact, the CJC7113 chip seems to returns all '1' when reading register=
 0.
>>  ("1111111111111111" found @ 0x4a (stk1160)))
>
> Guess a bunch of STK1160 devices are now being sold
> with the CJC7113 and probably many users are getting hit by this :(
>
> I can try to cook a patch or feel free to do it yourself and post it.
>
> As a quick solution, you can hack saa711x_detect_chip() so it
> always returns SAA7113.
>
> We could also add a module parameter to stk1160, to allow
> to force the decoder string, but I'd rather have saa7115
> autodetection working for all chips.
>
> [1] http://www.spinics.net/lists/linux-media/msg95887.html
> --
> Ezequiel Garc=C3=ADa, VanguardiaSur
> www.vanguardiasur.com.ar

--001a11421e4677ec2d052d307897
Content-Type: text/x-patch; charset=US-ASCII; name="cjc7113-detect.patch"
Content-Disposition: attachment; filename="cjc7113-detect.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ild4ju3d0

LS0tIGRyaXZlcnMvbWVkaWEvaTJjL3NhYTcxMTUuYwkyMDE1LTA4LTMwIDE0OjM0OjA5LjAwMDAw
MDAwMCAtMDQwMAorKysgZHJpdmVycy9tZWRpYS9pMmMvc2FhNzExNS5jCTIwMTYtMDMtMDMgMjI6
MDc6MjAuNDg5NTQxMDAwIC0wNTAwCkBAIC0xNzk0LDYgKzE3OTQsMTcgQEAKIAkJcmV0dXJuIEdN
NzExM0M7CiAJfQogCisJLyogQ2hlY2sgaWYgaXQgaXMgYSBDSkM3MTEzICovCisJaWYgKCFtZW1j
bXAobmFtZSwgIjExMTExMTExMTExMTExMTEiLCAxNikpIHsKKwkJc3RybGNweShuYW1lLCAiY2pj
NzExMyIsIENISVBfVkVSX1NJWkUpOworCisJCWlmICghYXV0b2RldGVjdCAmJiBzdHJjbXAobmFt
ZSwgaWQtPm5hbWUpKQorCQkJcmV0dXJuIC1FSU5WQUw7CisKKwkJLyogVGhlIENKQzcxMTMgaXMg
U0FBNzExMyBjb21wYXRpYmxlLiAqLworCQlyZXR1cm4gU0FBNzExMzsKKwl9CisKIAkvKiBDaGlw
IHdhcyBub3QgZGlzY292ZXJlZC4gUmV0dXJuIGl0cyBJRCBhbmQgZG9uJ3QgYmluZCAqLwogCXY0
bF9kYmcoMSwgZGVidWcsIGNsaWVudCwgImNoaXAgJSpwaCBAIDB4JXggaXMgdW5rbm93bi5cbiIs
CiAJCTE2LCBjaGlwX3ZlciwgY2xpZW50LT5hZGRyIDw8IDEpOwo=
--001a11421e4677ec2d052d307897--
