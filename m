Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1092 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZC3Mp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 08:45:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: Status of v4l2_subdev conversion
Date: Mon, 30 Mar 2009 14:44:56 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Douglas Landgraf <dougsland@gmail.com>,
	Jean Delvare <khali@linux-fr.org>
References: <200903291422.08806.hverkuil@xs4all.nl> <208cbae30903300537s3b6024d2t5286fd9a1c904f2d@mail.gmail.com>
In-Reply-To: <208cbae30903300537s3b6024d2t5286fd9a1c904f2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301444.57075.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 March 2009 14:37:22 Alexey Klimov wrote:
> Hello, Hans
> 
> On Sun, Mar 29, 2009 at 4:22 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Mauro,
> >
> > For your information, this is the current status:
> >
> > - Steve Toth tested the HVR-1800 for me, so I've posted the pull request for
> > the converted cx23885 driver.
> >
> > - The cx88 driver is also finished. I'm waiting for a last test by Jean
> > Delvare before I post that one as well.
> >
> > - Added support for saa6588 to saa7134: needed to drop the legacy i2c API
> > from saa6588. This is in my pull request for my v4l-dvb tree.
> >
> > - Douglas has almost finished the em28xx driver conversion.
> >
> > - Jean Delvare is working on the ir-kbd-i2c conversion.
> >
> > That last conversion is stand-alone (i.e. has no impact on the internal v4l
> > API) and I don't think it prevents pushing our v4l-dvb changes to 2.6.30.
> >
> > When the first four items are finished and merged into v4l-dvb, then I have
> > a to do a few final cleanup actions to make everything ready for the 2.6.30
> > merge:
> >
> > - Remove v4l2-i2c-drv-legacy.h from the remaining i2c drivers. Remove the
> > files v4l2-i2c-drv-legacy.h and v4l2-common.c since these are no longer
> > used. Cleanup v4l2-common.h since the internal ioctls are no longer needed.
> > Update v4l2-framework.txt, removing any references to the legacy behavior.
> >
> > - Fix two subdev callbacks that are in the wrong place (s_std belongs to the
> > video ops, s_standby belongs to the tuner ops).
> >
> > - Add a load_fw callback to the core ops and use that were appropriate
> > instead of the init callback. Analyze whether the init callback can be
> > removed altogether.
> >
> > - Analyze how the probe addresses are used in the v4l2 drivers and move
> > those lists over to the appropriate i2c driver headers.
> >
> > - Add enum_frameintervals and enum_framesizes callbacks for use with omap.
> >
> > - Check for any remaining uses of I2C_DRIVERID and remove them.
> >
> > This shouldn't take much time to implement.
> 
> So, if you converted pci-isa radio drivers to v4l2_device. Should
> dsbr100, si470x,  and mr800 be converted to v4l2_device too ?
> 

Eventually, yes. But I did those pci-isa radio drivers basically for fun and
because I got hold of two of those ISA cards so I could test it as well.

However, this v4l2_device conversion isn't urgent, unlike the v4l2_subdev
conversion. But it will have to be done eventually, and it is pretty trivial
at the moment. So I'd appreciate it if you could spend a bit of time on it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
