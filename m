Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:51666 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbZIUTrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 15:47:02 -0400
Received: by bwz6 with SMTP id 6so2178442bwz.37
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 12:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909212134.48829.martin@marsark.sytes.net>
References: <200909212134.48829.martin@marsark.sytes.net>
Date: Mon, 21 Sep 2009 15:47:04 -0400
Message-ID: <829197380909211247s6a4c5c56l8f8df51cfdf0da7c@mail.gmail.com>
Subject: Re: Gigabyte U8000-RH USB stick oops kernel
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: MarSarK <martin@marsark.sytes.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 21, 2009 at 3:34 PM, MarSarK <martin@marsark.sytes.net> wrote:
> hi, my brand new Gigabyte U8000-RG USB tv oops kernel.
>
> I have tried kernels from 2.6.27 to 2.6.31 everytime with same result (also at
> my notebook).
>
> uname -a:
> Linux vertigo 2.6.31-gentoo #2 SMP PREEMPT Mon Sep 14 20:20:59 CEST 2009 i686
> Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz GenuineIntel GNU/Linux
>
> lsusb:
> Bus 001 Device 005: ID 1044:7002 Chu Yuen Enterprise Co., Ltd
>
> This output is from 2.6.31 kernel and last mercurial snapshot of linuxtv tree.
> Error occure when I try to scan channels in Kaffeine.
>
> dmesg:
> usb 1-4: configuration #1 chosen from 1 choice
> dib0700: loaded with support for 13 different device-types
> dvb-usb: found a 'Gigabyte U8000-RH' in cold state, will try to load a firmware
> usb 1-4: firmware: requesting dvb-usb-dib0700-1.20.fw
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> dib0700: firmware started successfully.
> dvb-usb: found a 'Gigabyte U8000-RH' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Gigabyte U8000-RH)
> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> xc2028 4-0061: creating new instance
> xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
> input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1a.7/usb1/1-4/input/input4
> dvb-usb: schedule remote query interval to 50 msecs.
> dvb-usb: Gigabyte U8000-RH successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_dib0700
> BUG: unable to handle kernel NULL pointer dereference at 00000008
> IP: [<c11f99f3>] _request_firmware+0x3e3/0x440
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/idProduct
> Modules linked in: tuner_xc2028 dvb_usb_dib0700 dib7000p dib7000m dib0070
> dvb_usb dib3000mc dib8000 dibx000_common dvb_core nvidia(P) asus_atk0110
> coretemp sco rfcomm l2cap fuse usb_storage vboxnetadp vboxnetflt vboxdrv
>
> Pid: 9533, comm: kdvb-ad-0-fe-0 Tainted: P           (2.6.31-gentoo #2) P5Q
> DELUXE
> EIP: 0060:[<c11f99f3>] EFLAGS: 00010202 CPU: 0
> EIP is at _request_firmware+0x3e3/0x440
> EAX: 00000000 EBX: f62f5300 ECX: 00000000 EDX: f4933e54
> ESI: c1438ab0 EDI: f4999720 EBP: f62f5300 ESP: f4933d34
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process kdvb-ad-0-fe-0 (pid: 9533, ti=f4932000 task=f4aa6cb0 task.ti=f4932000)
> Stack:
>  f4933d88 00000000 00000000 e8024090 00000000 f4933e54 e8024098 f62f5300
> <0> f67f3000 00000000 f62f5300 c11f9adf 00000001 f89d3107 c12550b0 00069400
> <0> 00000000 00000000 00000003 80000400 f4949400 00000006 00000006 00000006
> Call Trace:
>  [<c11f9adf>] ? request_firmware+0xf/0x20
>  [<f89d3107>] ? generic_set_freq+0xc87/0x1c70 [tuner_xc2028]
>  [<c12550b0>] ? usb_control_msg+0xe0/0x100
>  [<f8880807>] ? dib0700_i2c_xfer+0x157/0x4d0 [dvb_usb_dib0700]
>  [<c127922b>] ? i2c_transfer+0xab/0xd0
>  [<c127922b>] ? i2c_transfer+0xab/0xd0
>  [<f8867068>] ? dib7000p_write_word+0x58/0x70 [dib7000p]
>  [<f89d4456>] ? xc2028_set_params+0x146/0x260 [tuner_xc2028]
>  [<f88684a6>] ? dib7000p_set_frontend+0x56/0xfb0 [dib7000p]
>  [<c10269f7>] ? finish_task_switch+0xa7/0xf0
>  [<c1367f57>] ? schedule+0x317/0x8f0
>  [<c1035537>] ? lock_timer_base+0x27/0x60
>  [<f8842c41>] ? dvb_frontend_swzigzag_autotune+0xc1/0x270 [dvb_core]
>  [<c1035831>] ? del_timer_sync+0x11/0x20
>  [<c13687b6>] ? schedule_timeout+0xe6/0x150
>  [<c10280ad>] ? try_to_wake_up+0x8d/0x1a0
>  [<f8843719>] ? dvb_frontend_swzigzag+0x189/0x2a0 [dvb_core]
>  [<f8843fb7>] ? dvb_frontend_thread+0x3b7/0x650 [dvb_core]
>  [<c103fbb0>] ? autoremove_wake_function+0x0/0x50
>  [<f8843c00>] ? dvb_frontend_thread+0x0/0x650 [dvb_core]
>  [<c103f8c4>] ? kthread+0x84/0x90
>  [<c103f840>] ? kthread+0x0/0x90
>  [<c10039df>] ? kernel_thread_helper+0x7/0x18
> Code: d0 e8 02 7a ff ff 89 5c 24 08 c7 44 24 0c a0 c4 38 c1 89 44 24 04 c7 04 24
> 52 e6 40 c1 e8 7f df 16 00 e9 2e ff ff ff 8b 44 24 10 <8b> 58 08 e8 d5 79 ff ff 89
> 7c 24 0c 89 5c 24 08 89 44 24 04 c7
> EIP: [<c11f99f3>] _request_firmware+0x3e3/0x440 SS:ESP 0068:f4933d34
> CR2: 0000000000000008
> ---[ end trace 3f52e895d964749e ]---
>
>
> Martin

Heh, I know what that is.  It was a result of a change to the
request_firmware() implementation where they actually started
dereferencing the first argument (and the i2c slave in the dib7000
isn't setting the pointer).  I ran into it when doing the PCTV 340e
work

You'll need something comparable to this patch:

http://www.kernellabs.com/hg/~dheitmueller/pctv-340e/rev/ba97460d2b3e

My patch is just a workaround (which is why I had not submitted it
upstream) - we really need to fix the bridge driver to do the work
properly.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
