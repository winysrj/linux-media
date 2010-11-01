Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33146 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0KAWIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Nov 2010 18:08:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: New media framework user space usage
Date: Mon, 1 Nov 2010 23:02:02 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com> <AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com> <AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>
In-Reply-To: <AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011012302.03284.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Bastian,

On Friday 29 October 2010 16:06:18 Bastian Hecht wrote:
> Hello Laurant,
> 
> sorry I am flooding a bit here, but now I reached a point where I am
> really stuck.
> 
> In the get_fmt_pad I set the following format
>         *format = mt9p031->format;
> that is defined as
>         mt9p031->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
>         mt9p031->format.width = MT9P031_MAX_WIDTH;
>         mt9p031->format.height = MT9P031_MAX_HEIGHT;
>         mt9p031->format.field = V4L2_FIELD_NONE;
>         mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> 
> I found the different formats in /include/linux/v4l2-mediabus.h. I
> have 12 data bit channels, but there is no enum for that (like
> V4L2_MBUS_FMT_SGRBG10_1X12).
> I am the first guy needing a 12 bit-bus?

Yes you are :-) You will need to implement 12 bit support in the ISP driver, 
or start by hacking the sensor driver to report a 10 bit format (2 bits will 
be lost but you should still be able to capture an image).

> Second thing is, the yavta app now gets stuck while dequeuing a buffer.
> 
> strace ./yavta -f SGRBG10 -s 2592x1944 -n 4 --capture=4 --skip 3 -F
> /dev/video2 ...
> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
> ioctl(3, VIDIOC_STREAMON, 0xbec11154)   = 0
> ioctl(3, VIDIOC_DQBUF
> 
> strace gets stuck in mid of this line.

-- 
Regards,

Laurent Pinchart
