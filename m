Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0LKO27B008232
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 15:24:02 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0LKNfFC016525
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 15:23:41 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1494926ywb.81
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 12:23:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090121192634.5fc27ccf@free.fr>
References: <6dd519ae0901181629m4a79732ala0daa870cefa74cc@mail.gmail.com>
	<20090119092610.65a2a90a@free.fr>
	<6dd519ae0901201251wb924d39k468627b7c778e3bf@mail.gmail.com>
	<20090121192634.5fc27ccf@free.fr>
Date: Wed, 21 Jan 2009 23:23:41 +0300
Message-ID: <6dd519ae0901211223j446fd568ucbca7f2d52b3f5c5@mail.gmail.com>
From: Brian Marete <bgmarete@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Video4linux-list <video4linux-list@redhat.com>
Subject: Re: Problem streaming from gspca_t613 Webcam
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Jan 21, 2009 at 9:26 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Tue, 20 Jan 2009 23:51:27 +0300
> "Brian Marete" <bgmarete@gmail.com> wrote:
>
>> Hello Jean-Francois,
>
> Hello Brian,
>
> From the trace, it seems you do not use the right driver: at connection
> time, I see:
>
> [ 5931.708240] gspca: probing 17a1:0128
> [ 5932.232060] t613: Bad sensor reset 01
>
> with no indication of the sensor. Are you sure you did the
> 'make install' and also removed the old driver from memory after
> unplugging the webcam?

Hello,

It is the right driver -- at any rate the one that is auto-loaded by
gspca . I did `make rminstall' before installing the drivers from your
Hg tree. I forgot to turn on debug before plugging it in. Below now is
a trace with debug=511 option to gspca.ko.

I also sent traces from SniffUSB (Windows, where the device works) and
usbmon (from the linux kernel -- debugfs -- where the device does not
work), to you and this list but it appears that the message to the
list was blocked and is subject to moderation since it is slightly
larger that 1024KB.

You will notice that from the debug trace below, there is mention of
"Unknown Sensor". Notice also the line below that says `probing
17a1:0128", and see the device_table[] array in t613.c. It seems that
this is, indeed the "correct" driver.

Thanks.

[  754.420108] usb 3-2: new full speed USB device using uhci_hcd and address 8
[  754.582891] usb 3-2: configuration #1 chosen from 1 choice
[  754.585205] gspca: probing 17a1:0128
[  754.588213] t613: unknown sensor 08 03
[  755.120096] t613: Bad sensor reset 01
[  755.123150] t613: Reg 0x06 = 0x08
[  755.124141] t613: Reg 0x07 = 0x03
[  755.125149] t613: Reg 0x0a = 0x00
[  755.126135] t613: Reg 0x0b = 0x00
[  755.127174] t613: Reg 0x66 = 0x00
[  755.128138] t613: Reg 0x80 = 0x3f
[  755.129146] t613: Reg 0x81 = 0x6a
[  755.130174] t613: Reg 0x8e = 0x3a
[  755.131148] t613: Reg 0x8f = 0xa4
[  755.132129] t613: Reg 0xa5 = 0x28
[  755.133914] t613: Reg 0xa6 = 0x4a
[  755.134157] t613: Reg 0xa8 = 0xe8
[  755.135172] t613: Reg 0xbb = 0x44
[  755.137427] t613: Reg 0xbc = 0x4c
[  755.138174] t613: Reg 0xc6 = 0xba
[  755.150154] t613: Gamma: 10
[  755.166394] gspca: probe ok
[  755.172476] gspca: hald-probe-vide open
[  755.172482] gspca: open done
[  755.172492] gspca main driver: VIDIOC_QUERYCAP driver=t613, card=
USB2.0 WebCam, bus=0000:00:1d.0, version=0x00020500,
capabilities=0x05000001
[  755.173471] gspca main driver: VIDIOC_QUERYCAP driver=t613, card=
USB2.0 WebCam, bus=0000:00:1d.0, version=0x00020500,
capabilities=0x05000001
[  755.173483] gspca main driver: VIDIOC_ENUMINPUT index=0, name=t613,
type=2, audioset=0, tuner=0, std=00000000, status=0
[  755.173492] gspca main driver: VIDIOC_ENUMINPUT error -22
[  755.173500] gspca main driver: VIDIOC_ENUM_FMT index=0, type=1,
flags=1, pixelformat=JPEG, description='JPEG'
[  755.173509] gspca main driver: VIDIOC_TRY_FMT type=vid-cap
[  755.173516] gspca: try fmt cap JPEG 10000x10000
[  755.173522] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[  755.174251] gspca: hald-probe-vide close
[  755.174256] gspca: close done
[  790.699822] gspca: svv open
[  790.699828] gspca: open done
[  790.699841] gspca main driver: VIDIOC_QUERYCAP driver=t613, card=
USB2.0 WebCam, bus=0000:00:1d.0, version=0x00020500,
capabilities=0x05000001
[  790.699992] gspca main driver: VIDIOC_ENUM_FMT index=0, type=1,
flags=1, pixelformat=JPEG, description='JPEG'
[  790.703813] gspca main driver: VIDIOC_ENUM_FRAMESIZES error -22
[  790.703825] gspca main driver: VIDIOC_ENUM_FMT error -22
[  790.705748] gspca main driver: VIDIOC_QUERYCAP driver=t613, card=
USB2.0 WebCam, bus=0000:00:1d.0, version=0x00020500,
capabilities=0x05000001
[  790.705785] gspca main driver: VIDIOC_TRY_FMT type=vid-cap
[  790.705794] gspca: try fmt cap JPEG 640x480
[  790.705799] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[  790.705808] gspca main driver: VIDIOC_S_FMT type=vid-cap
[  790.705815] gspca main driver: width=640, height=480, format=JPEG,
field=none, bytesperline=640 sizeimage=115790, colorspace=7
[  790.705821] gspca: try fmt cap JPEG 640x480
[  790.705898] gspca: frame alloc frsz: 115790
[  790.706010] gspca: reqbufs st:0 c:4
[  790.706013] gspca main driver: VIDIOC_REQBUFS count=4,
type=vid-cap, memory=mmap
[  790.706034] gspca main driver: VIDIOC_QUERYBUF 00:00:00.00000000
index=0, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=118784
[  790.706048] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706070] gspca: mmap start:b73ac000 size:118784
[  790.706105] gspca main driver: VIDIOC_QUERYBUF 00:00:00.00000000
index=1, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x0001d000, length=118784
[  790.706117] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706123] gspca: mmap start:b738f000 size:118784
[  790.706151] gspca main driver: VIDIOC_QUERYBUF 00:00:00.00000000
index=2, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x0003a000, length=118784
[  790.706163] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706169] gspca: mmap start:b7372000 size:118784
[  790.706197] gspca main driver: VIDIOC_QUERYBUF 00:00:00.00000000
index=3, type=vid-cap, bytesused=0, flags=0x00000000, field=1,
sequence=0, memory=mmap, offset/userptr=0x00057000, length=118784
[  790.706209] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706215] gspca: mmap start:b7355000 size:118784
[  790.706276] gspca: qbuf 0
[  790.706281] gspca: qbuf q:1 i:0 o:0
[  790.706285] gspca main driver: VIDIOC_QBUF 00:00:00.00000000
index=0, type=vid-cap, bytesused=0, flags=0x00000002, field=0,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=0
[  790.706297] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706302] gspca: qbuf 1
[  790.706306] gspca: qbuf q:2 i:0 o:0
[  790.706310] gspca main driver: VIDIOC_QBUF 00:00:00.00000000
index=1, type=vid-cap, bytesused=0, flags=0x00000002, field=0,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=0
[  790.706321] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706326] gspca: qbuf 2
[  790.706330] gspca: qbuf q:3 i:0 o:0
[  790.706333] gspca main driver: VIDIOC_QBUF 00:00:00.00000000
index=2, type=vid-cap, bytesused=0, flags=0x00000002, field=0,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=0
[  790.706345] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706350] gspca: qbuf 3
[  790.706354] gspca: qbuf q:0 i:0 o:0
[  790.706357] gspca main driver: VIDIOC_QBUF 00:00:00.00000000
index=3, type=vid-cap, bytesused=0, flags=0x00000002, field=0,
sequence=0, memory=mmap, offset/userptr=0x00000000, length=0
[  790.706369] gspca main driver: timecode=00:00:00 type=0,
flags=0x00000000, frames=0, userbits=0x00000000
[  790.706375] gspca main driver: VIDIOC_STREAMON type=vid-cap
[  790.706383] gspca: init transfer alt 3
[  790.706388] gspca: use alt 2 ep 0x81
[  790.714534] gspca: isoc 32 pkts size 1023 = bsize:32736
[  790.764859] gspca: stream on OK JPEG 640x480
[  790.795876] gspca: poll
[  790.795939] gspca: poll
[  790.797322] gspca: poll
[  790.797340] gspca: poll
[  790.797441] gspca: poll
[  790.797459] gspca: poll
[  790.799703] gspca: poll
[  790.799748] gspca: poll
[  790.800313] gspca: poll
[  790.806778] gspca: isoc irq
[  790.810221] gspca: poll
[  790.813771] gspca: poll
[  790.817360] gspca: poll
[  790.817386] gspca: poll
[  790.817507] gspca: poll
[  790.817552] gspca: poll
[  790.818359] gspca: poll
[  790.818383] gspca: poll
[  790.818402] gspca: poll
[  790.818444] gspca: poll
[  790.818456] gspca: poll
[  790.818483] gspca: poll
[  790.819230] gspca: poll
[  790.824355] gspca: poll
[  790.828279] gspca: poll
[  790.828378] gspca: poll
[  790.829931] gspca: poll
[  790.829982] gspca: poll
[  790.838820] gspca: isoc irq
[  790.870815] gspca: isoc irq
[  790.902787] gspca: isoc irq
[  790.912121] gspca: poll
[  790.913454] gspca: poll
[  790.934788] gspca: isoc irq
[  790.966822] gspca: isoc irq
[  790.998818] gspca: isoc irq
[  791.030818] gspca: isoc irq
[  791.062816] gspca: isoc irq
[  791.094813] gspca: isoc irq
[  791.126818] gspca: isoc irq
[  791.158816] gspca: isoc irq
[  791.190786] gspca: isoc irq
[  791.222823] gspca: isoc irq
[  791.254818] gspca: isoc irq
[  791.286817] gspca: isoc irq
[  791.318819] gspca: isoc irq
[  791.350826] gspca: isoc irq
[  791.382826] gspca: isoc irq
[  791.414819] gspca: isoc irq
[  791.446826] gspca: isoc irq
[  791.478792] gspca: isoc irq
[  791.510823] gspca: isoc irq
[  791.542813] gspca: isoc irq
[  791.574828] gspca: isoc irq
[  791.606831] gspca: isoc irq
[  791.638829] gspca: isoc irq
[  791.670830] gspca: isoc irq
[  791.702826] gspca: isoc irq
[  791.734830] gspca: isoc irq
[  791.766831] gspca: isoc irq
[  791.798823] gspca: isoc irq
[  791.830836] gspca: isoc irq
[  791.862832] gspca: isoc irq
[  791.894828] gspca: isoc irq
[  791.926836] gspca: isoc irq
[  791.958832] gspca: isoc irq
[  791.990837] gspca: isoc irq
[  792.022831] gspca: isoc irq
[  792.054826] gspca: isoc irq
[  792.086835] gspca: isoc irq
[  792.118842] gspca: isoc irq
[  792.150839] gspca: isoc irq
[  792.182838] gspca: isoc irq
[  792.214838] gspca: isoc irq
[  792.246837] gspca: isoc irq
[  792.278841] gspca: isoc irq
[  792.310833] gspca: isoc irq
[  792.342838] gspca: isoc irq
[  792.374846] gspca: isoc irq
[  792.406841] gspca: isoc irq
[  792.438839] gspca: isoc irq
[  792.470839] gspca: isoc irq
[  792.502841] gspca: isoc irq
[  792.534834] gspca: isoc irq
[  792.566842] gspca: isoc irq
[  792.598820] gspca: isoc irq
[  792.630849] gspca: isoc irq
[  792.662844] gspca: isoc irq
[  792.694847] gspca: isoc irq
[  792.717648] gspca: poll
[  792.719382] gspca: poll
[  792.726845] gspca: isoc irq
[  792.758848] gspca: isoc irq
[  792.790841] gspca: isoc irq
[  792.822848] gspca: isoc irq
[  792.829529] gspca: poll
[  792.829711] gspca: poll
[  792.854824] gspca: isoc irq
[  792.886850] gspca: isoc irq
[  792.918854] gspca: isoc irq
[  792.950848] gspca: isoc irq
[  792.982852] gspca: isoc irq
[  793.014852] gspca: isoc irq
[  793.046846] gspca: isoc irq
[  793.078852] gspca: isoc irq
[  793.110854] gspca: isoc irq
[  793.142858] gspca: isoc irq
[  793.174858] gspca: isoc irq
[  793.206858] gspca: isoc irq
[  793.238852] gspca: isoc irq
[  793.270858] gspca: isoc irq
[  793.302857] gspca: isoc irq
[  793.334862] gspca: isoc irq
[  793.366857] gspca: isoc irq
[  793.398859] gspca: isoc irq
[  793.430856] gspca: isoc irq
[  793.462859] gspca: isoc irq
[  793.494867] gspca: isoc irq
[  793.526850] gspca: isoc irq
[  793.558865] gspca: isoc irq
[  793.590864] gspca: isoc irq
[  793.622859] gspca: isoc irq
[  793.654864] gspca: isoc irq
[  793.686866] gspca: isoc irq
[  793.702470] gspca: poll
[  793.703259] gspca: poll
[  793.718863] gspca: isoc irq
[  793.750863] gspca: isoc irq
[  793.782862] gspca: isoc irq
[  793.814858] gspca: isoc irq
[  793.846867] gspca: isoc irq
[  793.878863] gspca: isoc irq
[  793.910873] gspca: isoc irq
[  793.942877] gspca: isoc irq
[  793.974872] gspca: isoc irq
[  794.006869] gspca: isoc irq
[  794.038866] gspca: isoc irq
[  794.070867] gspca: isoc irq
[  794.102876] gspca: isoc irq
[  794.134873] gspca: isoc irq
[  794.166871] gspca: isoc irq
[  794.198872] gspca: isoc irq
[  794.230879] gspca: isoc irq
[  794.262877] gspca: isoc irq
[  794.294872] gspca: isoc irq
[  794.326875] gspca: isoc irq
[  794.358846] gspca: isoc irq
[  794.390878] gspca: isoc irq
[  794.422880] gspca: isoc irq
[  794.454878] gspca: isoc irq
[  794.486873] gspca: isoc irq
[  794.518867] gspca: isoc irq
[  794.520688] gspca: poll
[  794.520936] gspca: poll
[  794.520960] gspca: poll
[  794.523963] gspca: poll
[  794.524069] gspca: poll
[  794.526110] gspca: poll
[  794.526181] gspca: poll
[  794.526199] gspca: poll
[  794.550880] gspca: isoc irq
[  794.582882] gspca: isoc irq
[  794.614881] gspca: isoc irq
[  794.646887] gspca: isoc irq
[  794.678882] gspca: isoc irq
[  794.710886] gspca: isoc irq
[  794.742881] gspca: isoc irq
[  794.765945] gspca: poll
[  794.768178] gspca main driver: VIDIOC_STREAMOFF type=vid-cap
[  794.774846] gspca: isoc irq
[  794.806851] gspca: isoc irq
[  794.817887] gspca: kill transfer
[  794.818853] gspca: isoc irq
[  794.820734] gspca: stream off OK
[  794.820845] gspca: svv close
[  794.820849] gspca: frame free
[  794.820911] gspca: close done


-- 
B. Gitonga Marete
Tel: +254-722-151-590

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
