Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:38654 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753318AbeBSR31 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 12:29:27 -0500
Received: by mail-lf0-f51.google.com with SMTP id g72so522716lfg.5
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 09:29:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com>
 <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com>
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Mon, 19 Feb 2018 12:29:24 -0500
Message-ID: <CAKTMqxuF1BNy+xoEnArvc+S_NgucBKna6iOExKj8CxjF0qC2Jw@mail.gmail.com>
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

This is how I built the drivers:

$ git clone --depth=3D1 git://linuxtv.org/media_build.git
$ cd media_build
$ ./build --main-git

I then installed the newly built kernel modules:

$ sudo make install

Once the modules were updated, I restarted my computer to make sure
every module got reloaded. I didn't make any changes to the code and I
found the issues after trying each of those programs individually
after I restarted my computer.

This was the latest commit when I cloned the repo:

commit d144cfe4b3c37ece55ae27778c99765d4943c4fa
Author: Jasmin Jessich <jasmin@anw.at>
Date:   Fri Feb 16 22:40:49 2018 +0100
    Re-generated v3.12_kfifo_in.patch

My version of VLC is 2.2.6. Here's a copy of the relevant data of
VLC's log file in case it can help: https://paste.debian.net/1011025/
In this case, I tried to open /dev/video0 first and /dev/video1 second.

I can also try with ffplay:
$ ffplay /dev/video0

I get this: [video4linux2,v4l2 @ 0x7f2160000920]
ioctl(VIDIOC_STREAMON): Message too long
/dev/video0: Message too long

A new message appears in dmesg: uvcvideo: Failed to submit URB 0 (-90).

$ ffplay /dev/video1

I get this:
[video4linux2,v4l2 @ 0x7f00ec000920] ioctl(VIDIOC_G_INPUT):
Inappropriate ioctl for device
/dev/video1: Inappropriate ioctl for device

Like Guennadi said, /dev/video1 is a metadata node, so I don't expect
it to work. In the case of /dev/video0, I can't tell what could be
wrong from the error message.

Alexandre-Xavier

On Mon, Feb 19, 2018 at 8:52 AM, Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
> Hi Alexandre,
>
> Thankyou for your bug report,
>
> On 17/02/18 20:47, Alexandre-Xavier Labont=C3=A9-Lamoureux wrote:
>> Hi,
>>
>> I'm running Linux 4.9.0-5-amd64 on Debian. I built the drivers from
>> the latest git and installed the modules.
>
> Could you please be specific here?
>
> Are you referring to linux-media/master branch or such? The latest from L=
inus' tree?
>
> Please also detail the steps you have taken to reproduce this issue - and=
 of
> course - if you have made any code changes to make the latest UVC module =
compile
> against a v4.9 kernel...
>
> Building the latest git tree and installing as a module on a v4.9 kernel =
is
> quite a leap... I wouldn't have expected that to work.
>
> The code would have to be compiled against a v4.9 kernel directly, and I =
didn't
> think compiling the UVC driver against older kernels worked.
>
> (at least it didn't work cleanly when I tried to compile v4.15 against a =
v4.14
> kernel last month)
>
>> Now, two device nodes are
>> created for my webcam. This is not normal as it has never happened to
>> me before. If I connect another webcam to my laptop, two more device
>> nodes will be created for this webcam. So two new device nodes are
>> created for a single webcam.
>
> I believe Guennadi's latest work for handling meta-data (in the latest v4=
.16-rc1
> I think) will create two device nodes.
>
>
>> The name of my webcam appears twice in the device comobox in Guvcview
>> because of this. One of them will not work if I select it.
>
> It would be expected that only the device with video functions as a strea=
ming
> camera device, while the other would not.
>
>
>> My webcam has completely stopped working with Cheese and VLC.
>
> This part is of particular concern however.
>
> Guennadi - Have you tested Cheese/VLC with your series?
>
> Are there any known issues that need looking at ?
>
>>> v4l2-ctl --list-devices
>> Laptop_Integrated_Webcam_E4HD:  (usb-0000:00:1a.0-1.5):
>>     /dev/video0
>>     /dev/video1
>>
>>> ls /dev/video*
>> /dev/video0  /dev/video1
>>
>> Have a nice day,
>> Alexandre-Xavier
>
> Regards
>
> Kieran Bingham
>
>
