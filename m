Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61087 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761501Ab0J2OGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 10:06:19 -0400
Received: by yxk8 with SMTP id 8so1635182yxk.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 07:06:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
	<AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
	<201010290139.10204.laurent.pinchart@ideasonboard.com>
	<AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>
	<AANLkTimJu-QDToxGNWKPj_B4QM_iO_x6G6eE4U2WnDPB@mail.gmail.com>
	<AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com>
Date: Fri, 29 Oct 2010 16:06:18 +0200
Message-ID: <AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>
Subject: Re: New media framework user space usage
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Laurant,

sorry I am flooding a bit here, but now I reached a point where I am
really stuck.

In the get_fmt_pad I set the following format
        *format = mt9p031->format;
that is defined as
        mt9p031->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
        mt9p031->format.width = MT9P031_MAX_WIDTH;
        mt9p031->format.height = MT9P031_MAX_HEIGHT;
        mt9p031->format.field = V4L2_FIELD_NONE;
        mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;

I found the different formats in /include/linux/v4l2-mediabus.h. I
have 12 data bit channels, but there is no enum for that (like
V4L2_MBUS_FMT_SGRBG10_1X12).
I am the first guy needing a 12 bit-bus?

Second thing is, the yavta app now gets stuck while dequeuing a buffer.

strace ./yavta -f SGRBG10 -s 2592x1944 -n 4 --capture=4 --skip 3 -F /dev/video2
...
ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
ioctl(3, VIDIOC_STREAMON, 0xbec11154)   = 0
ioctl(3, VIDIOC_DQBUF

strace gets stuck in mid of this line.

cheers,

 Bastian
