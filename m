Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:54689 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaLBFay (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 00:30:54 -0500
Received: by mail-wi0-f196.google.com with SMTP id ex7so6800404wid.7
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 21:30:53 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 2 Dec 2014 14:30:53 +0900
Message-ID: <CAEwyzatXZQ57n=SbrX9iM1r-_kB_acKC5WGkyGtWexpRu1eoZA@mail.gmail.com>
Subject: Changing exposure using v4l2
From: Kansai Robot <adapt.robot.lab@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello. This is my first message. Please forgive me if I am making a
mistake since I don't use mailing lists that much.

I am currently writing a program using V4L2 that takes pictures from a
UVC camera. It works fine. I also added some function to set several
camera settings in particular exposure. (Of course I use VIDIOC_S_CTRL
with ioctl for that)

I can see that once I set exposure to manual I can set the exposure
value. However when I take a pic after that the image does not reflect
the settings. For example with a high exposure, the image must be
overexposed but it is not.

Originally I set the settings in the beginning and then I took a number of pics.

But since it was not working I now take one pic and change the setting
and take another pic and set the settings and so on.

Well now, the pics are reflecting the settings it seems correctly. The
problem is that the settings (with VIDIOC_S_CTRL) take effect after 3
additional picture captures.

What I mean is that if I set the exposure to say 4000, and I take an
image the photo is not overexposed (as it should) so I have repeat the
ioctl and take another photo and repeat this three times before I
could get a photo with exposure 4000.

Any idea what could be happening with V4L2 over here? Any help or any
hint will be greatly appreciated.

Thanks a lot
