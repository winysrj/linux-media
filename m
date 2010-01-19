Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59112 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0ASJtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 04:49:09 -0500
Received: by fxm25 with SMTP id 25so349317fxm.21
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 01:49:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381001180716v59b84ee2ia8ca2d9be4be5b22@mail.gmail.com>
References: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
	<829197380912220750j116894baw8343010b123f929@mail.gmail.com>
	<ad6681df0912220841n2f77f2c3v7aad0604575b5564@mail.gmail.com>
	<ad6681df1001180701s26584cdfua9e413d9bb843a35@mail.gmail.com>
	<829197381001180716v59b84ee2ia8ca2d9be4be5b22@mail.gmail.com>
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Tue, 19 Jan 2010 10:48:47 +0100
Message-ID: <ad6681df1001190148v3f8add9csa726c2e275947234@mail.gmail.com>
Subject: Re: em28xx driver - xc3028 tuner - readreg error
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/1/18 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Mon, Jan 18, 2010 at 10:01 AM, Valerio Bontempi
> <valerio.bontempi@gmail.com> wrote:
>> Hi all,
>>
>> I am still having problem using v4l-dvb drivers with Terratec Cinergy T USB XS.
>> As reported in first mail, I am using the last version of v4l-dvb
>> drivers with few lines adjustment in order to make this driver to
>> enable dvb for my dvb only device (this because official v4l-dvb
>> driver actually doesn't support my device at all)
>> I have cleaned my distro (openSuse 11.2 x86-64) about all the v4l
>> modules provided by distro's repositories, and I compiled modified
>> v4l-dvb source.
>> So acutally I am using a cleaned version of v4l-dvb.
>>
>> But the
>> [ 1483.314420] zl10353_read_register: readreg error (reg=127, ret==-19)
>> [ 1483.315166] mt352_read_register: readreg error (reg=127, ret==-19)
>> error isn't solved yet.
>> Could it be related to the firmware I am using?
>
> No, this has nothing to do with firmware.  It is probably an issue
> where the gpio configuration is wrong and the demod is being held in
> reset (hence it won't respond to i2c commands).
>
> The 0ccd:0043 is on my todo list of devices to work on (they sent me a
> sample board), although it's not the highest priority on my list given
> how old it is.
>
> Cheers,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Hi Devin,

maybe it could be useful: today, without any change from yesterday,
the device has been fully initialized at boot time.
>From dmesg

  10.252753] xc2028 2-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   10.286264] xc2028 2-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[   11.674270] xc2028 2-0061: Loading firmware for type=(0), id
000000000000b700.
[   11.701412] SCODE (20000000), id 000000000000b700:
[   11.701419] xc2028 2-0061: Loading SCODE for type=MONO SCODE
HAS_IF_4320 (60008000), id 0000000000008000.
[   11.824268] em28xx #0: v4l2 driver version 0.1.2
[   11.829157] em28xx #0: V4L2 video device registered as video1
[   11.830312] usbcore: registered new interface driver em28xx
[   11.830316] em28xx driver loaded
[   11.997659] xc2028 2-0061: attaching existing instance
[   11.997665] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   11.997667] em28xx #0: em28xx #0/2: xc3028 attached
[   11.997671] DVB: registering new adapter (em28xx #0)
[   11.997675] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   11.998086] em28xx #0: Successfully loaded em28xx-dvb
[   11.998090] Em28xx: Initialized (Em28xx dvb Extension) extension

instead of (from /var/log/messages)

Jan 18 16:53:04 gandalf kernel: [ 4894.539028] xc2028 2-0061: Loading
80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Jan 18 16:53:04 gandalf kernel: [ 4894.575016] xc2028 2-0061: Loading
firmware for type=BASE (1), id 0000000000000000.
Jan 18 16:53:05 gandalf kernel: [ 4895.972018] xc2028 2-0061: Loading
firmware for type=(0), id 000000000000b700.
Jan 18 16:53:05 gandalf kernel: [ 4895.998010] SCODE (20000000), id
000000000000b700:
Jan 18 16:53:05 gandalf kernel: [ 4895.998022] xc2028 2-0061: Loading
SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
Jan 18 16:53:05 gandalf kernel: [ 4896.122024] em28xx #0: v4l2 driver
version 0.1.2
Jan 18 16:53:05 gandalf kernel: [ 4896.127126] em28xx #0: V4L2 video
device registered as video1
Jan 18 16:53:05 gandalf kernel: [ 4896.129142] usbcore: registered new
interface driver em28xx
Jan 18 16:53:05 gandalf kernel: [ 4896.129157] em28xx driver loaded
Jan 18 16:53:05 gandalf kernel: [ 4896.155171] zl10353_read_register:
readreg error (reg=127, ret==-19)
Jan 18 16:53:05 gandalf kernel: [ 4896.155914] mt352_read_register:
readreg error (reg=127, ret==-19)
Jan 18 16:53:05 gandalf kernel: [ 4896.156419] em28xx #0: /2: dvb
frontend not attached. Can't attach xc3028
Jan 18 16:53:05 gandalf kernel: [ 4896.156434] Em28xx: Initialized
(Em28xx dvb Extension) extension

Is there a reason of this behaviour?

Valerio
