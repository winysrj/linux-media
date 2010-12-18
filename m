Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4350 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab0LRMXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 07:23:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Janne Grunau <j@jannau.net>
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by .unlocked_ioctl
Date: Sat, 18 Dec 2010 13:23:21 +0100
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201012181231.27198.hverkuil@xs4all.nl> <20101218122040.GI8381@aniel.fritz.box>
In-Reply-To: <20101218122040.GI8381@aniel.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012181323.21950.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, December 18, 2010 13:20:40 Janne Grunau wrote:
> Hi,
> 
> On Sat, Dec 18, 2010 at 12:31:26PM +0100, Hans Verkuil wrote:
> > 
> > Now that the BKL patch series has been merged in 2.6.37 it is time to work
> > on replacing .ioctl by .unlocked_ioctl in all v4l drivers.
> > 
> > I've made an inventory of all drivers that still use .ioctl and I am looking
> > for volunteers to tackle one or more drivers.
> > 
> > I have CCed this email to the maintainers of the various drivers (if I know
> > who it is) in the hope that we can get this conversion done as quickly as
> > possible.
> > 
> > If I have added your name to a driver, then please confirm if you are able to
> > work on it or not. If you can't work on it, but you know someone else, then
> > let me know as well.
> 
> ...
> 
> > Driver list:
> 
> ...
> 
> > au0828 (Janne Grunau)
> 
> I did only two minor cleanups and don't have the hardware. Steven Toth,
> Devin Heitmueller or Michael Krufky have done major changes to the
> driver.
> 
> Added to CC and trimmed

Hi Janne,

My apologies, for some reason I had it in my head that you maintained that
driver. But I confused au0828 with hdpvr :-(

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
