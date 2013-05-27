Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2079 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3E0T5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 15:57:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [GIT PULL] go7007 firmware updates
Date: Mon, 27 May 2013 21:56:18 +0200
Cc: David Woodhouse <dwmw2@infradead.org>,
	"linux-media" <linux-media@vger.kernel.org>,
	Pete Eberlein <pete@sensoray.com>
References: <201305231025.31812.hverkuil@xs4all.nl> <1369671872.3469.383.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1369671872.3469.383.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305272156.18975.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 27 2013 18:24:32 Ben Hutchings wrote:
> On Thu, 2013-05-23 at 10:25 +0200, Hans Verkuil wrote:
> > Hi Ben, David,
> > 
> > The go7007 staging driver has been substantially overhauled for kernel 3.10.
> > As part of that process the firmware situation has been improved as well.
> > 
> > While Micronas allowed the firmware to be redistributed, it was never made
> > part of linux-firmware. Only the firmwares for the Sensoray S2250 were added
> > in the past, but those need the go7007*.bin firmwares as well to work.
> > 
> > This pull request collects all the firmwares necessary to support all the
> > go7007 devices into the go7007 directory. With this change the go7007 driver
> > will work out-of-the-box starting with kernel 3.10.
> [...]
> 
> You should not rename files like this.  linux-firmware is not versioned
> and needs to be compatible with old and new kernel versions, so far as
> possible.

I understand, and I wouldn't have renamed these two firmware files if it
wasn't for the fact that 1) it concerns a staging driver, so in my view
backwards compatibility is not a requirement, and 2) the firmware files
currently in linux-firmware were never enough to make the Sensoray S2250
work, you always needed additional external firmwares as well.

> So the filenames in linux-firmware should match whatever the driver has
> used up to now.  If the driver has been changed in 3.10-rc to use
> different filenames, it's not too late to revert this mistake in the
> driver.  But if such a change was made earlier, we'll need to add
> symlinks.

I can revert the rename action, but I would rather not do it. I believe
there are good reasons for doing this, especially since the current
situation is effectively broken anyway due to the missing firmware files.

If you really don't want to rename the two S2250 files, then I'll make
a patch reverting those to the original filename.

Pete, if you have an opinion regarding this, please let us know. After all,
it concerns a Sensoray device.

Regards,

	Hans
