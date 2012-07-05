Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51358 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab2GEVbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 17:31:34 -0400
Received: by wibhm11 with SMTP id hm11so115624wib.1
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 14:31:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF60566.5070802@iki.fi>
References: <4FD50223.4030501@iki.fi>
	<4FF5FF3F.6030909@redhat.com>
	<4FF60566.5070802@iki.fi>
Date: Thu, 5 Jul 2012 18:31:33 -0300
Message-ID: <CALF0-+XLj9RaEaovkVXu0hqs0YE3jwtFdUMqsUCXVoncPSH5jg@mail.gmail.com>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 5, 2012 at 6:21 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> There was a discussion between Ezequiel and Hans that in my understanding
> led to a conclusion there's no such use case, at least one which would be
> properly supported by the hardware. (Please correct me if I'm mistaken.)
>

Concerning stk1160 devices with several video input (I own one with
four video inputs),
I can say that this is currently handled throught ioctl
VIDIOC_S_INPUT. I.e, user must
explicitly select one (and only one) input.

In my very humble opinion (and assuming I understand this discussion properly)
I think that if there is no hardware support for streaming multiple
inputs at the same time,
it's not kernel job to "simulate it" and cycle through several inputs
and several buffer queues.

My two cents,
Ezequiel.
