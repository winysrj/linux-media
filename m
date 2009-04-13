Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57494 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZDMBOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 21:14:15 -0400
Received: by bwz17 with SMTP id 17so1841914bwz.37
        for <linux-media@vger.kernel.org>; Sun, 12 Apr 2009 18:14:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904122256.12305.tobias.lorenz@gmx.net>
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
	 <4e1455be0904011754l2c51cf2fi6336d07d591cbb71@mail.gmail.com>
	 <49D4180B.4040805@samsung.com>
	 <200904122256.12305.tobias.lorenz@gmx.net>
Date: Mon, 13 Apr 2009 05:14:13 +0400
Message-ID: <208cbae30904121814i66e2b8b2tc4b8de30321e9617@mail.gmail.com>
Subject: Re: About the radio-si470x driver for I2C interface
From: Alexey Klimov <klimov.linux@gmail.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Tobias

On Mon, Apr 13, 2009 at 12:56 AM, Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
> Hi Joonyoung,
>
> Hi Alexey,
>
> I've split the driver into a couple of segments:
>
> - radio-si470x-common.c is for common functions
>
> - radio-si470x-usb.c are the usb support functions
>
> - radio-si470x-i2c.c is an untested prototyped file for your i2c support
> functions
>
> - radio-si470x.h is a header file with everything required by the c-files
>
> I hope this is a basis we can start on with i2c support. What do you think?
>
> The URL is:
>
> http://linuxtv.org/hg/~tlorenz/v4l-dvb
>
> Bye,
>
> Toby

Great! It's always interesting to see big changes.
I understand i2c interface not so good and have only general questions.

Many (most?) drivers in v4l tree were converted to use new v4l2-
framework. For example, dsbr100 was converted to v4l2_device
http://linuxtv.org/hg/v4l-dvb/rev/77f37ad5dd0c and em28xx was
converted to v4l2_subdev
http://linuxtv.org/hg/v4l-dvb/rev/00525b115901
As i remember, Hans Verkuil said that all v4l drivers should be
converted to new framework. Is it time to switch to this new interface
? Probably, there are a lot of code examples in current tree that can
help..

And second question. About lock/unlock_kernel in open functions.
Please, take a look at
http://www.spinics.net/lists/linux-media/msg04057.html
Well, is it time to do something with this?

Well, my questions about improving functionality, not about mistakes or bugs :)

-- 
Best regards, Klimov Alexey
