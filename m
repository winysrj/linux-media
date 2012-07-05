Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab2GEW2C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 18:28:02 -0400
Message-ID: <4FF614E5.6080602@redhat.com>
Date: Thu, 05 Jul 2012 19:27:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
References: <4FD50223.4030501@iki.fi> <4FF5FF3F.6030909@redhat.com> <4FF60566.5070802@iki.fi> <CALF0-+XLj9RaEaovkVXu0hqs0YE3jwtFdUMqsUCXVoncPSH5jg@mail.gmail.com>
In-Reply-To: <CALF0-+XLj9RaEaovkVXu0hqs0YE3jwtFdUMqsUCXVoncPSH5jg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2012 18:31, Ezequiel Garcia escreveu:
> On Thu, Jul 5, 2012 at 6:21 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>
>> There was a discussion between Ezequiel and Hans that in my understanding
>> led to a conclusion there's no such use case, at least one which would be
>> properly supported by the hardware. (Please correct me if I'm mistaken.)
>>
> 
> Concerning stk1160 devices with several video input (I own one with
> four video inputs),
> I can say that this is currently handled throught ioctl
> VIDIOC_S_INPUT. I.e, user must
> explicitly select one (and only one) input.
> 
> In my very humble opinion (and assuming I understand this discussion properly)
> I think that if there is no hardware support for streaming multiple
> inputs at the same time,
> it's not kernel job to "simulate it" and cycle through several inputs
> and several buffer queues.

Sorry, but I don't agree: some devices are clearly targeted to be used with
multiple inputs being cycled.

For example, this one [1]:
	http://www.geovision.com.tw/PT/Prod_GV800.asp

has only 4 BT878 chips, but each one can switch up to 4 cameras, and this
very same card is used on several commercial solutions for surveillance.

As far as I know, the input switching should be commanded externally, as
the hardware doesn't do that automatically. Even so, it has a high-speed
switch, so it should be fine to do it at vertical refresh time.

Implementing support for it using VIDIOC_S_INPUT is a very poor solution,
as an ioctl call may happen after the vertical retrace, causing artifacts.

The proper solution would be for the Kernel to switch to the next input during
the IRQ handler. So, when a frame for input 0 is received, the driver should be
switching to the next active input as soon as possible, in order to avoid
artifacts.

[1] Sorry, I were unable to discover the English version of this specific page.

Regards,
Mauro
