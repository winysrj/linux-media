Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:39711 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeBYITy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 03:19:54 -0500
Received: by mail-lf0-f43.google.com with SMTP id f75so12959944lfg.6
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 00:19:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <46032915.v1itnVjfQo@avalon>
References: <CAKTMqxtRQvZqZGQ0oWSf79b3ZGs6Stpctx9yqi8X1Myq-CY2JA@mail.gmail.com>
 <dd70c226-e7db-e55e-e467-a6b0d1e7849d@ideasonboard.com> <CAKTMqxuF1BNy+xoEnArvc+S_NgucBKna6iOExKj8CxjF0qC2Jw@mail.gmail.com>
 <46032915.v1itnVjfQo@avalon>
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Sun, 25 Feb 2018 03:19:51 -0500
Message-ID: <CAKTMqxvSWQSa=w_6z_XHjMh6s6N+hdj_yi-yW+CEp2NVx0t4Zg@mail.gmail.com>
Subject: Re: Bug: Two device nodes created in /dev for a single UVC webcam
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Sorry for the late reply.

I've been trying to reproduce the issue again. I cloned the entire
media repository later during the week and I haven't been able to
reproduce the issue after I installed the modules. A metadata node is
no longer created for my webcam. The four commits that you've
mentioned are still in the commit log, so it seems that they didn't
break anything.

I'm not sure what could have changed that would have caused it to work
fine this time. I believe that I'm in the correct branch.

$ git status
On branch media_tree/master
Your branch is up-to-date with 'r_media_tree/master'.

I probably did `./build` instead of `./build --main-git` the first time.

Thank you,
Alexandre-Xavier

On Mon, Feb 19, 2018 at 2:10 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Alexandre-Xavier,
>
> On Monday, 19 February 2018 19:29:24 EET Alexandre-Xavier Labont=C3=A9-La=
moureux
> wrote:
>> Hi Kieran,
>>
>> This is how I built the drivers:
>>
>> $ git clone --depth=3D1 git://linuxtv.org/media_build.git
>> $ cd media_build
>> $ ./build --main-git
>>
>> I then installed the newly built kernel modules:
>>
>> $ sudo make install
>>
>> Once the modules were updated, I restarted my computer to make sure
>> every module got reloaded. I didn't make any changes to the code and I
>> found the issues after trying each of those programs individually
>> after I restarted my computer.
>>
>> This was the latest commit when I cloned the repo:
>>
>> commit d144cfe4b3c37ece55ae27778c99765d4943c4fa
>> Author: Jasmin Jessich <jasmin@anw.at>
>> Date:   Fri Feb 16 22:40:49 2018 +0100
>>     Re-generated v3.12_kfifo_in.patch
>>
>> My version of VLC is 2.2.6. Here's a copy of the relevant data of
>> VLC's log file in case it can help: https://paste.debian.net/1011025/
>> In this case, I tried to open /dev/video0 first and /dev/video1 second.
>>
>> I can also try with ffplay:
>> $ ffplay /dev/video0
>>
>> I get this: [video4linux2,v4l2 @ 0x7f2160000920]
>> ioctl(VIDIOC_STREAMON): Message too long
>> /dev/video0: Message too long
>>
>> A new message appears in dmesg: uvcvideo: Failed to submit URB 0 (-90).
>
> That's interesting, and possibly unrelated to the patch series that added
> metadata capture support. Would you be able to revert that patch series a=
nd
> see if the problem still occurs ? The four commits to be reverted are
>
> 088ead25524583e2200aa99111bea2f66a86545a
> 3bc85817d7982ed53fbc9b150b0205beff68ca5c
> 94c53e26dc74744cc4f9a8ddc593b7aef96ba764
> 31a96f4c872e8fb953c853630f69d5de6ec961c9
>
> And if you could bisect the issue it would be even better :-)
>
> Could you also send me the output of lsusb -v for your camera (you can
> restrict it to the camera with -d VID:PID), running as root if possible ?
>
>> $ ffplay /dev/video1
>>
>> I get this:
>> [video4linux2,v4l2 @ 0x7f00ec000920] ioctl(VIDIOC_G_INPUT):
>> Inappropriate ioctl for device
>> /dev/video1: Inappropriate ioctl for device
>>
>> Like Guennadi said, /dev/video1 is a metadata node, so I don't expect
>> it to work. In the case of /dev/video0, I can't tell what could be
>> wrong from the error message.
>
> --
> Regards,
>
> Laurent Pinchart
>
