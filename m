Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53938 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab1FFV4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 17:56:05 -0400
Received: by iyb14 with SMTP id 14so3466021iyb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 14:56:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110604143409.GA75613@triton8.kn-bremen.de>
References: <6C4E9A3B-EDC2-487B-90F9-734A0C349A4B@gmail.com> <20110604143409.GA75613@triton8.kn-bremen.de>
From: Andreas Steinel <a.steinel@googlemail.com>
Date: Mon, 6 Jun 2011 23:55:44 +0200
Message-ID: <BANLkTindHbuKLc-+7orNCb1LqzgwRXAJ6g@mail.gmail.com>
Subject: Re: Remote control TechnoTrend S2-3650 CI not working
To: Juergen Lock <nox@jelal.kn-bremen.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jürgen, Hi List,

Thank you for your answer.

On Sat, Jun 4, 2011 at 4:34 PM, Juergen Lock <nox@jelal.kn-bremen.de> wrote:
> Ok let me try...
>
> 1. Your remote is the same as in this (googled) picture?
>
>        http://4.bp.blogspot.com/_B0OTxmaxXPU/SfL1yGqvGjI/AAAAAAAAABU/GFOklS4R9GM/s320/tt_s2_3650.jpg

At first glance yes, but it is not. Very similar, but yet different.
(also discovered in the source, please see above)

> 2. Do you see remote events logged in dmesg when you modprobe the
>   pctv452e driver with debug=3 and then test the remote?

Oh yes, I can see events from the remote:
[ 8108.169526] pctv452e_rc_query: cmd=0x0d sys=0x18
[ 8108.273332] pctv452e_rc_query: cmd=0x0d sys=0x18
[ 8108.473326] pctv452e_rc_query: cmd=0x0d sys=0x18


> 3. You can also test for events coming in on /dev/input/event8 using
>   evtest, or (if you have up-to-date v4l-utils) using ir-keytable:

None of them showed any keyinput, but it is recognized (now its on event1):

Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0xb48 product 0x300a version 0x101
Input device name: "IR-receiver inside an USB DVB receiver"
Supported events:
  Event type 0 (Sync)
  Event type 1 (Key)
    Event code 2 (1)
    Event code 3 (2)
    Event code 4 (3)
    Event code 5 (4)
    Event code 6 (5)
    Event code 7 (6)
    Event code 8 (7)
    Event code 9 (8)
    Event code 10 (9)
    Event code 11 (0)
    Event code 103 (Up)
    Event code 105 (Left)
    Event code 106 (Right)
    Event code 108 (Down)
    Event code 113 (Mute)
    Event code 114 (VolumeDown)
    Event code 115 (VolumeUp)
    Event code 116 (Power)
    Event code 119 (Pause)
    Event code 128 (Stop)
    Event code 141 (Setup)
    Event code 159 (Forward)
    Event code 167 (Record)
    Event code 168 (Rewind)
    Event code 174 (Exit)
    Event code 207 (Play)
    Event code 352 (Ok)
    Event code 357 (Option)
    Event code 358 (Info)
    Event code 365 (EPG)
    Event code 373 (Mode)
    Event code 388 (Text)
    Event code 398 (Red)
    Event code 399 (Green)
    Event code 400 (Yellow)
    Event code 401 (Blue)
    Event code 402 (ChannelUp)
    Event code 403 (ChannelDown)
    Event code 410 (Shuffle)

But no event is registered there :-/

ir-keytable doesn't found any rc even after triggering the udev rules
(v4l ir-keytable from git and from debian unstable package).

> 4. Do you use the lirc devinput driver and the lircd.conf.devinput
>   config?  Maybe this post helps:
>
>        http://forum.xbmc.org/showthread.php?t=101151

This link is - according to the headline - only for 2.6.35+ and I'
running 2.6.32 (Squeeze default kernel) and the post also builds on
ir-keytable, which is not working properly.

Yet, i further investigated the errors and the source code and turned
on dvb-usb-debugging which yields:

[11423.302006] key mapping failed - no appropriate key found in keymapping
[11423.501806] pctv452e_rc_query: cmd=0x26 sys=0x18
[11423.501815] key mapping failed - no appropriate key found in keymapping
[11423.701615] pctv452e_rc_query: cmd=0x26 sys=0x18
[11423.701628] key mapping failed - no appropriate key found in keymapping
[11424.001763] pctv452e_rc_query: cmd=0x26 sys=0x18
[11424.001775] key mapping failed - no appropriate key found in keymapping
[11424.102026] pctv452e_rc_query: cmd=0x26 sys=0x18
[11424.102034] key mapping failed - no appropriate key found in keymapping
[11424.202030] pctv452e_rc_query: cmd=0x26 sys=0x18
[11424.202038] key mapping failed - no appropriate key found in keymapping

Which explains the error. I further debugged the problem and found this:

[13242.485965] key mapping failed - no appropriate key found in keymapping
[13242.585948] pctv452e_rc_query: cmd=0x26 sys=0x18
[13242.585955]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x01
[13242.585960]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x02
[13242.585964]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x03
[13242.585968]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x04
[13242.585972]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x05
[13242.585976]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x06
[13242.585980]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x07
[13242.585983]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x08
[13242.585987]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x09
[13242.585991]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0a
[13242.585995]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0b
[13242.585999]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0c
[13242.586003]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0d
[13242.586007]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0e
[13242.586010]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0f
[13242.586014]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x10
[13242.586018]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x11
[13242.586022]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x12
[13242.586026]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x13
[13242.586030]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x14
[13242.586034]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x15
[13242.586037]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x16
[13242.586041]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x17
[13242.586045]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x18
[13242.586049]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x19
[13242.586053]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x1a
[13242.586057]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x21
[13242.586061]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x22
[13242.586064]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x23
[13242.586068]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x24
[13242.586072]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x25
[13242.586076]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x26
[13242.586080]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x27
[13242.586084]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3a
[13242.586088]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3b
[13242.586092]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3c
[13242.586095]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3d
[13242.586099]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3e
[13242.586103]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3f
[13242.586106] key mapping failed - no appropriate key found in keymapping

I patched the file to get one key responding, but unfortunately
failed. The problem is not obvious to me:

diff -r 41388e396e0f linux/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-remote.c  Mon May 23
00:50:21 2011 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-remote.c  Mon Jun 06
23:53:27 2011 +0200
@@ -272,6 +272,8 @@
                        }
                        /* See if we can match the raw key code. */
                        for (i = 0; i < d->props.rc_key_map_size; i++)
+        printk(" keycode is [1]=0x%02x vs rc5_custom=0x%02x,
[3]=0x%02x vs rc5_custom=0x%02x\n",
+                keybuf[1], rc5_custom(&keymap[i]), keybuf[3],
rc5_data(&keymap[i]));
                                if (rc5_custom(&keymap[i]) == keybuf[1] &&
                                        rc5_data(&keymap[i]) == keybuf[3]) {
                                        *event = keymap[i].event;
diff -r 41388e396e0f linux/drivers/media/dvb/dvb-usb/pctv452e.c
--- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c        Mon May 23
00:50:21 2011 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c        Mon Jun 06
23:53:27 2011 +0200
@@ -604,7 +604,8 @@
        {0x153c, KEY_STOP},
        {0x153d, KEY_REWIND},
        {0x153e, KEY_PAUSE},
-       {0x153f, KEY_FORWARD}
+       {0x153f, KEY_FORWARD},
+       {0x1826, KEY_OK}
 };

Leads to

[13902.063002] pctv452e_rc_query: cmd=0x26 sys=0x18
[13902.063013]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x01
[13902.063017]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x02
[13902.063021]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x03
[13902.063025]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x04
[13902.063029]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x05
[13902.063033]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x06
[13902.063037]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x07
[13902.063041]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x08
[13902.063045]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x09
[13902.063048]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0a
[13902.063052]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0b
[13902.063056]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0c
[13902.063060]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0d
[13902.063063]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0e
[13902.063067]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x0f
[13902.063071]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x10
[13902.063075]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x11
[13902.063078]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x12
[13902.063082]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x13
[13902.063086]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x14
[13902.063090]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x15
[13902.063094]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x16
[13902.063098]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x17
[13902.063101]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x18
[13902.063105]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x19
[13902.063109]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x1a
[13902.063113]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x21
[13902.063117]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x22
[13902.063120]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x23
[13902.063124]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x24
[13902.063128]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x25
[13902.063132]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x26
[13902.063136]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x27
[13902.063139]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3a
[13902.063143]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3b
[13902.063147]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3c
[13902.063151]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3d
[13902.063154]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3e
[13902.063158]  keycode is [1]=0x18 vs rc5_custom=0x15, [3]=0x26 vs
rc5_custom=0x3f
[13902.063162]  keycode is [1]=0x18 vs rc5_custom=0x18, [3]=0x26 vs
rc5_custom=0x26
[13902.063166] key mapping failed - no appropriate key found in keymapping

Any further ideas?

Best,
Andreas
