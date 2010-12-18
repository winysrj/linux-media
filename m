Return-path: <mchehab@gaivota>
Received: from chybek.jannau.net ([83.169.20.219]:57105 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab0LRMTD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 07:19:03 -0500
Date: Sat, 18 Dec 2010 13:20:40 +0100
From: Janne Grunau <j@jannau.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by .unlocked_ioctl
Message-ID: <20101218122040.GI8381@aniel.fritz.box>
References: <201012181231.27198.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012181231.27198.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On Sat, Dec 18, 2010 at 12:31:26PM +0100, Hans Verkuil wrote:
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

...

> Driver list:

...

> au0828 (Janne Grunau)

I did only two minor cleanups and don't have the hardware. Steven Toth,
Devin Heitmueller or Michael Krufky have done major changes to the
driver.

Added to CC and trimmed

Janne
