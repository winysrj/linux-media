Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43990 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0KBKb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 06:31:29 -0400
Received: by iwn10 with SMTP id 10so8227207iwn.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 03:31:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201011012302.03284.laurent.pinchart@ideasonboard.com>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
	<AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com>
	<AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>
	<201011012302.03284.laurent.pinchart@ideasonboard.com>
Date: Tue, 2 Nov 2010 11:31:28 +0100
Message-ID: <AANLkTinWo7siGdbmRPNEfOfJHTZLEqxMFHOO9aqijP0d@mail.gmail.com>
Subject: Re: New media framework user space usage
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello Laurent,

>> I am the first guy needing a 12 bit-bus?
>
> Yes you are :-) You will need to implement 12 bit support in the ISP driver,
> or start by hacking the sensor driver to report a 10 bit format (2 bits will
> be lost but you should still be able to capture an image).

Isn't that an "officially" supported procedure to drop the least
significant bits?
You gave me the isp configuration
.bus = { .parallel = {
                       .data_lane_shift        = 1,
...
that instructs the isp to use 10 of the 12 bits.

>> Second thing is, the yavta app now gets stuck while dequeuing a buffer.
>>
>> strace ./yavta -f SGRBG10 -s 2592x1944 -n 4 --capture=4 --skip 3 -F
>> /dev/video2 ...
>> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
>> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
>> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
>> ioctl(3, VIDIOC_QBUF, 0xbec111cc)       = 0
>> ioctl(3, VIDIOC_STREAMON, 0xbec11154)   = 0
>> ioctl(3, VIDIOC_DQBUF
>>
>> strace gets stuck in mid of this line.

Somehow the ISP_ENABLE_IRQ register was reset at some point that is
unclear to me. When I put it on again manually yavta succeeds to read
the frames. Unfortunately the image consists of black pixels only. We
found out that the 2.8V voltage regulator got broken in the course of
development - the 1.8V logic still worked but the ADC did not...

But the heck - I was never that close :)

bye,

 Bastian
