Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55650 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab2FYOGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 10:06:45 -0400
Received: by obbuo13 with SMTP id uo13so6500461obb.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 07:06:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACK0K0i53VJVCVsJy2YGX_pWab0QVSkew5tJL5MQ7CcLyGvjMg@mail.gmail.com>
References: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
	<CALF0-+ViQTmGnAS19kOCZPZAj0ZYZX4Ef-+J7A=k1J2OFhFuVg@mail.gmail.com>
	<CALF0-+XoKmw0fe_vpOs-BEZXDZThA5WuNw8CRjohLJojZ2O4Dw@mail.gmail.com>
	<CACK0K0j4mSG=EtU1R-VvvoF_5ZCxrTk4p3niyHBt4tAGVdqLVA@mail.gmail.com>
	<CALF0-+XR_ZE8_52zQKZ9n9x8sGrmJWNpeXnKD_j6Lg1YHta=vQ@mail.gmail.com>
	<CACK0K0i53VJVCVsJy2YGX_pWab0QVSkew5tJL5MQ7CcLyGvjMg@mail.gmail.com>
Date: Mon, 25 Jun 2012 11:06:45 -0300
Message-ID: <CALF0-+Ws+EWs5CjJedJMFL4mLkKx--kg5VZpa=f_+x2iiUiK5Q@mail.gmail.com>
Subject: Re: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,



On Mon, Jun 25, 2012 at 4:09 AM, Gianluca Bergamo
<gianluca.bergamo@gmail.com> wrote:
> Hi Ezequiel,
>
> No problem in patching each new release you made.


Please note I've just send a v3 of stk1160 driver.
It adds support for controlling ac97 and for selecting video inputs.


>
> In my environment this command line gives only one format supported (UYVY)
> and then yavta freezes.
> I suspect it freezes on an ioctl to the driver. I must check it.
>



Weird. I've just tested with yavta and it works perfectly. You should note that
this command is wrong:

./yavta -f YUYV -s 720x576 -n 4 --capture=4 -F /dev/video1

and it should be:

./yavta -f UYVY -s 720x576 -n 4 --capture=4 -F /dev/video1

Since, as you noted the only supported format is UYVY. Some applications take
advantage of libv4l2 wrapper library to increase the output format set.
For instance, if I do ENUM_FMT using v4l2-ctl I get just one supported format:

$ v4l2-ctl --list-formats
ioctl: VIDIOC_ENUM_FMT
	Index       : 0
	Type        : Video Capture
	Pixel Format: 'UYVY'
	Name        : 16 bpp YUY2, 4:2:2, packed

But if I use wrapper library:

$ v4l2-ctl -w --list-formats
ioctl: VIDIOC_ENUM_FMT
	Index       : 0
	Type        : Video Capture
	Pixel Format: 'UYVY'
	Name        : 16 bpp YUY2, 4:2:2, packed

	Index       : 1
	Type        : Video Capture
	Pixel Format: 'RGB3' (emulated)
	Name        : RGB3

	Index       : 2
	Type        : Video Capture
	Pixel Format: 'BGR3' (emulated)
	Name        : BGR3

	Index       : 3
	Type        : Video Capture
	Pixel Format: 'YU12' (emulated)
	Name        : YU12

	Index       : 4
	Type        : Video Capture
	Pixel Format: 'YV12' (emulated)
	Name        : YV12


In case you need it, here's my yavta output:

$ ./yavta --enum-formats /dev/video0
Device /dev/video0 opened.
Device `stk1160' on `usb-0000:00:13.2-2' is a video capture device.
- Available formats:
	Format 0: UYVY (59565955)
	Type: Video capture (1)
	Name: 16 bpp YUY2, 4:2:2, packed

$ ./yavta -f YUYV -s 720x576 -n 4 --capture=4 -F /dev/video0
Device /dev/video0 opened.
Device `stk1160' on `usb-0000:00:13.2-2' is a video capture device.
Unable to set format: Invalid argument (22).
localhost yavta # ./yavta -f UYVY -s 720x576 -n 4 --capture=4 -F /dev/video0
Device /dev/video0 opened.
Device `stk1160' on `usb-0000:00:13.2-2' is a video capture device.
Video format set: UYVY (59565955) 720x480 (stride 1440) buffer size 691200
Video format: UYVY (59565955) 720x480 (stride 1440) buffer size 691200
8 buffers requested.
length: 691200 offset: 0
Buffer 0 mapped at address 0xb7584000.
length: 691200 offset: 692224
Buffer 1 mapped at address 0xb74db000.
length: 691200 offset: 1384448
Buffer 2 mapped at address 0xb7432000.
length: 691200 offset: 2076672
Buffer 3 mapped at address 0xb7389000.
length: 691200 offset: 2768896
Buffer 4 mapped at address 0xb72e0000.
length: 691200 offset: 3461120
Buffer 5 mapped at address 0xb7237000.
length: 691200 offset: 4153344
Buffer 6 mapped at address 0xb718e000.
length: 691200 offset: 4845568
Buffer 7 mapped at address 0xb70e5000.
0 (0) [-] 0 691200 bytes 1340632305.824287 1826.669365 -0.002 fps
1 (1) [-] 1 691200 bytes 1340632305.856350 1826.709943 31.189 fps
2 (2) [-] 1 691200 bytes 1340632305.896222 1826.741385 25.080 fps
3 (3) [-] 2 691200 bytes 1340632305.928226 1826.773354 31.246 fps
Captured 4 frames in 0.199372 seconds (20.062936 fps, 13867501.311552 B/s).
8 buffers released.
