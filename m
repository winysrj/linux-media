Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49643 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbLIKv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2015 05:51:59 -0500
References: <20151207102519.6c6d850a@gandalf.local.home> <20151207153119.GA31513@kroah.com>
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	stable <stable@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Failed to build on 4.2.6
In-reply-to: <20151207153119.GA31513@kroah.com>
Date: Wed, 09 Dec 2015 10:51:55 +0000
Message-ID: <87io47rj1w.fsf@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Greg Kroah-Hartman writes:

> On Mon, Dec 07, 2015 at 10:25:19AM -0500, Steven Rostedt wrote:
>> Hi,
>>
>> The attached config doesn't build on 4.2.6, but changing it to the
>> following:
>>
>>  VIDEO_V4L2_SUBDEV_API n -> y
>> +V4L2_FLASH_LED_CLASS n
>>
>> does build.
>
> Did this work on older kernels (4.2.5?  .4?  older?)
>
> thanks,
>
> greg k-h

Hi all,

The problem was:

drivers/media/i2c/adv7604.c: In function ‘adv76xx_get_format’:
drivers/media/i2c/adv7604.c:1861:3: error: implicit declaration of function ‘v4l2_subdev_get_try_format’ [-Werror=implicit-function-declaration]
   fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);

As Randy mentioned, this if fixed by commit
fc88dd16a0e430f57458e6bd9b62a631c6ea53a1

I backported it locally to test this and build worked fine.

Luis
