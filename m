Return-path: <mchehab@gaivota>
Received: from gateway03.websitewelcome.com ([69.93.216.26]:51985 "HELO
	gateway03.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932645Ab0LTSRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 13:17:09 -0500
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by
 .unlocked_ioctl
From: Pete Eberlein <pete@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-dev@sensoray.com
In-Reply-To: <201012181231.27198.hverkuil@xs4all.nl>
References: <201012181231.27198.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 10:07:25 -0800
Message-ID: <1292868445.2413.2.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, 2010-12-18 at 12:31 +0100, Hans Verkuil wrote:
> Hi all,
> 
> Now that the BKL patch series has been merged in 2.6.37 it is time to work
> on replacing .ioctl by .unlocked_ioctl in all v4l drivers.
> 
> I've made an inventory of all drivers that still use .ioctl and I am looking
> for volunteers to tackle one or more drivers.
> 
> I have CCed this email to the maintainers of the various drivers (if I know
> who it is) in the hope that we can get this conversion done as quickly as
> possible.
> 
> If I have added your name to a driver, then please confirm if you are able to
> work on it or not. If you can't work on it, but you know someone else, then
> let me know as well.

> s2255drv (Pete Eberlein)

I'll work on this one.

> Staging driver list:
> 
> go7007 (Pete Eberlein)

And this one.

Regards,
Pete Eberlein

