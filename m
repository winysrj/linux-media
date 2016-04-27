Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcD0UaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 16:30:22 -0400
Date: Wed, 27 Apr 2016 22:30:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, sakari.ailus@iki.fi,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160427203019.GA19070@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <572048AC.7050700@gmail.com>
 <572062EF.7060502@gmail.com>
 <20160427164256.GA8156@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160427164256.GA8156@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> On Wed, Apr 27, 2016 at 09:57:51AM +0300, Ivaylo Dimitrov wrote:
> > >>https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/log/?h=n900-camera-ivo
> > >
> > >Ok, going to diff with my tree to see what I have missed to send in the
> > >patchset
> > 
> > Now, that's getting weird.
> 
> [...]
> 
> > I you want to try it, zImage and initrd are on
> > http://46.249.74.23/linux/camera-n900/
> 
> The zImage + initrd works with the steps you described below. I
> received a completly black image, but at least there are interrupts
> and yavta is happy (=> it does not hang).

Ok, thanks for all the help. I switched from =y to =m, and it started
to work.

sudo insmod videobuf2-core.ko
sudo insmod videobuf2-v4l2.ko
sudo insmod videobuf2-memops.ko
sudo insmod video-bus-switch.ko
sudo insmod smiaregs.ko
sudo insmod smiapp-pll.ko
sudo insmod smiapp.ko
sudo insmod /my/modules/videobuf2-dma-contig.ko
sudo insmod /my/modules/omap3-isp.ko

So far I tested front camera only, and used a rather bright light to
get something... but that's a start :-).

Ok, and these seem to get some image that is dark, but not completely
dark:

YA=/my/tui/yavta/yavta
sudo $YA --set-control '0x009e0903 240'  /dev/v4l-subdev8
sudo $YA --set-control '0x00980911 485'  /dev/v4l-subdev8

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
