Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:48930 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaKCXQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 18:16:04 -0500
Received: by mail-oi0-f47.google.com with SMTP id a3so8808285oib.6
        for <linux-media@vger.kernel.org>; Mon, 03 Nov 2014 15:16:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141102225704.GM3136@valkosipuli.retiisi.org.uk>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
	<20141102225704.GM3136@valkosipuli.retiisi.org.uk>
Date: Tue, 4 Nov 2014 01:16:03 +0200
Message-ID: <CANOLnONAsh-M7WvRFOhLo-obkS20ffurr9tD5b==yyHCwVRXoQ@mail.gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
From: Grazvydas Ignotas <notasas@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Nov 3, 2014 at 12:57 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Grazvydas,
>
> On Sun, Nov 02, 2014 at 04:03:55AM +0200, Grazvydas Ignotas wrote:
>> There is periodic stutter (seen in vlc, for example) since 3.9 where
>> the stream stops for around half a second every 3-5 seconds or so.
>> Bisecting points to 1b18e7a0be859911b22138ce27258687efc528b8 "v4l:
>> Tell user space we're using monotonic timestamps". I've verified the
>> problem is there on stock Ubuntu 14.04 kernel, 3.16.7 from kernel.org
>> and when using media_build.git . The commit does not revert on newer
>> kernels as that code changed, but checking out a commit before the one
>> mentioned gives properly working kernel.
>>
>> I'm using Logitech C920 which can do h264 compression and playing the
>> video using vlc:
>> cvlc v4l2:///dev/video0:chroma=h264:width=1280:height=720
>
> I've got Logitech C270 here but I can't reproduce the problem. The frame
> rate with the above command is really low, around 5. With a smaller
> resolution it works quite smoothly. The reason might be that the pixel
> format is still YUYV. The other option appears to be MJPG.

I've tried lower resolution and YUYV with MJPG too, this has the same problem:
cvlc v4l2:///dev/video0:chroma=h264:width=320:height=240
cvlc v4l2:///dev/video0:chroma=yuyv:width=320:height=240

>
> My vlc is of version 2.0.3 (Debian). Which one do you have, and does it use
> libv4l2?

Mine is 2.1.4, my distro is Ubuntu 14.04. I can see libv4l2.so.0.0.0
in maps, but I have no idea what it's used for..

> Have you tried with a different application to see if the problem persists?

Tried mplayer and cheese now, and it seems they are not affected, so
it's an issue with vlc. I wonder why it doesn't like newer flags..

Ohwell, sorry for the noise.

-- 
Gražvydas
