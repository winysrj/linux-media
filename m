Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50820 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbbDFO1y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 10:27:54 -0400
Date: Mon, 6 Apr 2015 11:27:43 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	dri-devel@lists.freedesktop.org, virtio-dev@lists.oasis-open.org,
	mst@redhat.com, open list <linux-kernel@vger.kernel.org>,
	airlied@redhat.com,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] break kconfig dependency loop
Message-ID: <20150406112743.40d5b5cf@recife.lan>
In-Reply-To: <1428313821.634.116.camel@x220>
References: <1427894130-14228-1-git-send-email-kraxel@redhat.com>
	<1427894130-14228-2-git-send-email-kraxel@redhat.com>
	<87wq1wot9b.fsf@intel.com>
	<1428313821.634.116.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 06 Apr 2015 11:50:21 +0200
Paul Bolle <pebolle@tiscali.nl> escreveu:

> On Wed, 2015-04-01 at 16:47 +0300, Jani Nikula wrote:
> > I think part of the problem is that "select" is often used not as
> > documented [1] but rather as "show my config in menuconfig for
> > convenience even if my dependency is not met, and select the dependency
> > even though I know it can screw up the dependency chain".
> 
> Perhaps people use select because it offers, given the problem they
> face, a reasonable way to make the kconfig tools generate a
> sensible .config. It helps them to spend less time fiddling with Kconfig
> files. And they expect that it helps others to configure their build
> more easily, as it might save those others some work.

At least on media, the main usage of select is to handle complex hardware
where lots of drivers are needed in order to have support for all
boards supported by a given board.

On a practical example, let's take a look at em28xx driver. This is a
bridge driver for media boards. It supports ~100 different boards.
Each board may have different tuners, different analog TV demods,
different digital TV demods, eeproms attached into one of its I2C buses.

As this is an USB stick, the normal user will never know what are the
other components of the board without some hard work (by opening the USB
stick by seeking for the information at the Internet until he discovers
all the components).

Even after knowing the hardware components, he has to figure out what
drivers implement support for each component.

So, for the normal user, we offer a way for the user to select all
possible combinations via MEDIA_SUBDRV_AUTOSELECT. This way, he'll know
for sure that all boards supported by em28xx will be available.

For those that would embedded em28xx on some hardware (like a TV
PVR box), he can disable such option and manually select the specific
components his hardware uses.

For obvious reasons, we recommend distros to always enable
MEDIA_SUBDRV_AUTOSELECT.

So, yes, select saves a lot of work to configure the build what they
want on an easy and sane way.

That's said, while it would be possible to convert select into
depends on, the result would be really ugly, and very hard to be
maintained, as I2C drivers that don't actually depend on the bridge
drivers would need a fake depends on list:

config DVB_MB86A20S
	tristate "Fujitsu mb86a20s"
	# real dependency chain
	depends on DVB_CORE && I2C
	# fake dependency chain
	depends on (!MEDIA_SUBDRV_AUTOSELECT || CONFIG_VIDEO_CX23885_DVB || CONFIG_VIDEO_CX231XX_DVB || CONFIG_VIDEO_EM28xx_DVB)

I got here an easy example of an ISDB-T driver, with is not used on
many boards. There are other I2C drivers that are used by almost all
media drivers, with would result on a very complex fake dependency chain.

The worse thing with such ugly fake dependency chain is that people adding
a new driver (or support for a new board) would need to remember to dig
into drivers that weren't touched, adding new stuff on their Kconfig.

> > In the big picture, it feels like menuconfig needs a way to display
> > items whose dependencies are not met, and a way to recursively enable
> > said items and all their dependencies when told.

I believe so.

> How could that work its way through (multiple levels of) things like:
>     depends on FOO || (BAZ && BAR)

At least for our typical use case, the dependency chain should not have
things like the above, as we use this mainly for I2C drivers, and the
bridge drivers also depend on I2C.

I would say that, if Kconfig adds a recursive select implementation, such
implementation should:

- stop recursion if the depends condition was met;
- if the depends condition is unmet and has two or more possible options
  to satisfy (like on your above example), it should prompt the user about
  what option it would want. If it can't do it (for example, for a "silent"
  type of config, where it shouldn't be expected any userspace interaction),
  it should print a warning and not enable the driver.

Granted, this is easier said than done. We have this problem mapped
for a long time, but none was brave enough (or had enough time) to
actually try to implement something like that. So, what we generally
do, as a workaround, is to try to simplify the Kconfig stuff to avoid
complex use cases. We do that by adding fake dependencies to drivers
that might require another driver for some board to work. For example,
several USB media drivers now depends on I2C_MUX just because a few of
the possible drivers it may need should select I2C_MUX.

Btw, I2C_MUX is an optional feature of the I2C core. There's no way
for a normal user to know if a driver would need such feature or not,
as it basically depends on how the device was internally wired and if
the Kernel driver would use it (older drivers have their own solution
without using the I2C_MUX new way).

There are a few other such options at the I2C sub-system. All of them
depends on I2C only (with is a mandatory option for any I2C driver),
so select works fine for such features.

> 
> > This would reduce the
> > resistance to sticking with "select" when clearly "depends" is what's
> > meant.
> 
> I had drafted a rather verbose response to this. But I think I'm not
> really sure what you're saying here, probably because "select" and
> "depends on" are rather different. How would you know that the actual
> intention was to use "depends on"?
> 
> 
> Paul Bolle

Regards,
Mauro
