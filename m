Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4126 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab3E1Gmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 02:42:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [GIT PULL] go7007 firmware updates
Date: Tue, 28 May 2013 08:42:01 +0200
Cc: David Woodhouse <dwmw2@infradead.org>,
	"linux-media" <linux-media@vger.kernel.org>,
	Pete Eberlein <pete@sensoray.com>, mchehab@redhat.com
References: <201305231025.31812.hverkuil@xs4all.nl> <201305272156.18975.hverkuil@xs4all.nl> <1369691595.3469.404.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1369691595.3469.404.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305280842.01068.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 27 2013 23:53:15 Ben Hutchings wrote:
> On Mon, 2013-05-27 at 21:56 +0200, Hans Verkuil wrote:
> > On Mon May 27 2013 18:24:32 Ben Hutchings wrote:
> > > On Thu, 2013-05-23 at 10:25 +0200, Hans Verkuil wrote:
> > > > Hi Ben, David,
> > > > 
> > > > The go7007 staging driver has been substantially overhauled for kernel 3.10.
> > > > As part of that process the firmware situation has been improved as well.
> > > > 
> > > > While Micronas allowed the firmware to be redistributed, it was never made
> > > > part of linux-firmware. Only the firmwares for the Sensoray S2250 were added
> > > > in the past, but those need the go7007*.bin firmwares as well to work.
> > > > 
> > > > This pull request collects all the firmwares necessary to support all the
> > > > go7007 devices into the go7007 directory. With this change the go7007 driver
> > > > will work out-of-the-box starting with kernel 3.10.
> > > [...]
> > > 
> > > You should not rename files like this.  linux-firmware is not versioned
> > > and needs to be compatible with old and new kernel versions, so far as
> > > possible.
> > 
> > I understand, and I wouldn't have renamed these two firmware files if it
> > wasn't for the fact that 1) it concerns a staging driver, so in my view
> > backwards compatibility is not a requirement,
> 
> This driver (or set of drivers) has been requesting go7007fw.bin,
> go7007tv.bin, s2250.fw and s2250_loader.fw for nearly 5 years.  It's a
> bit late to say those were just temporary filenames.

Why not? It is a staging driver for good reasons. Just because it is in staging
for a long time (because nobody found the time to actually work on it until
3.10) doesn't mean it magically becomes non-staging. The Kconfig in staging
says:

          This option allows you to select a number of drivers that are
          not of the "normal" Linux kernel quality level.  These drivers
          are placed here in order to get a wider audience to make use of
          them.  Please note that these drivers are under heavy
          development, may or may not work, and may contain userspace
          interfaces that most likely will be changed in the near
          future.

In other words, there are no guarantees. That's the whole point of staging.
Once it is moved out of staging everything changes, of course.

Note that it is not just the firmware loading that has changed in 3.10, also
several custom ioctls were removed, thus changing the userspace API, and for
3.11/12 I will add new ioctls to support motion detection. Once that's done
the driver can move out of staging.

> > and 2) the firmware files
> > currently in linux-firmware were never enough to make the Sensoray S2250
> > work, you always needed additional external firmwares as well.
> > 
> > > So the filenames in linux-firmware should match whatever the driver has
> > > used up to now.  If the driver has been changed in 3.10-rc to use
> > > different filenames, it's not too late to revert this mistake in the
> > > driver.  But if such a change was made earlier, we'll need to add
> > > symlinks.
> > 
> > I can revert the rename action, but I would rather not do it. I believe
> > there are good reasons for doing this, especially since the current
> > situation is effectively broken anyway due to the missing firmware files.
> 
> Were the 'new' files unavailable to the public, or only available from a
> manufacturer web site?

They have been available from various websites where people hosted their own
version of the out-of-tree driver from before the driver was moved to staging.
They originated from the manufacturer, which no longer exists. To my knowledge
there isn't any 'canonical' site containing the firmwares.

Loading the firmware was actually quite complex for some go7007 devices,
requiring a userspace utility and special udev rules. That's all changed in
3.10.

Also note that some of the firmware files on those websites were in a hex
format. Starting with 3.10 these files are converted to a smaller binary
format and now use a standard cypress loader kernel module instead of requiring
in-kernel hex parsing.

Regards,

	Hans

> 
> Ben.
> 
> > If you really don't want to rename the two S2250 files, then I'll make
> > a patch reverting those to the original filename.
> > 
> > Pete, if you have an opinion regarding this, please let us know. After all,
> > it concerns a Sensoray device.
> 
> 
