Return-path: <mchehab@pedra>
Received: from smtp-roam2.Stanford.EDU ([171.67.219.89]:42142 "EHLO
	smtp-roam.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756100Ab0J2ShF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 14:37:05 -0400
Message-ID: <4CCB1443.9080509@stanford.edu>
Date: Fri, 29 Oct 2010 11:36:51 -0700
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New media framework user space usage
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>	<AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>	<201010290139.10204.laurent.pinchart@ideasonboard.com>	<AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>	<AANLkTimJu-QDToxGNWKPj_B4QM_iO_x6G6eE4U2WnDPB@mail.gmail.com>	<AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com> <AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>
In-Reply-To: <AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 10/29/2010 7:06 AM, Bastian Hecht wrote:
> Hello Laurant,
>
> sorry I am flooding a bit here, but now I reached a point where I am
> really stuck.
>
> In the get_fmt_pad I set the following format
>          *format = mt9p031->format;
> that is defined as
>          mt9p031->format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
>          mt9p031->format.width = MT9P031_MAX_WIDTH;
>          mt9p031->format.height = MT9P031_MAX_HEIGHT;
>          mt9p031->format.field = V4L2_FIELD_NONE;
>          mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
>
> I found the different formats in /include/linux/v4l2-mediabus.h. I
> have 12 data bit channels, but there is no enum for that (like
> V4L2_MBUS_FMT_SGRBG10_1X12).
> I am the first guy needing a 12 bit-bus?

Most of the ISP can't handle more than 10-bit input - unless you're 
streaming raw sensor data straight to memory, you'll have to use the 
bridge lane shifter to decimate the input.
In the new framework, I don't know how that's done, unfortunately.

Also, technically, the mt9p031 output colorspace is not sRGB, although 
I'm not sure how close it is. It's its own sensor-specific space, 
determined by the color filters on it, and you'll want to calibrate for 
it at some point.

Good luck,

Eino-Ville Talvala
Stanford University
