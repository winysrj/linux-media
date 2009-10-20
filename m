Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZJTN7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 09:59:05 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v2] linux infrared remote control drivers
Date: Tue, 20 Oct 2009 09:56:33 -0400
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910200956.33391.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This here is a second go at submitting linux infrared remote control
(lirc) drivers for kernel inclusion, with a much smaller patch set that
includes only the core lirc driver and two device drivers, all three of
which have been heavily updated since the last submission, based on
feedback received.

Never meant for it to be more than a year before the second attempt at
submitting lirc drivers, but day jobs and life tend to get in the way.
Development work has been ongoing despite all that, just took a bit
longer than anticipated to address as much of the review comments as
possible and get up the guts for another submission. ;)

For those not in the know, lirc has existed out-of-tree at lirc.org for
years and years, and is currently patched into the kernels or provided
as add-on kernel module packages in a number of distributions (its been
patched into Fedora kernels going on 2.5 years now), so the code is in
fairly wide use and is reasonably well tested, despite not being in the
upstream kernel itself.

The drivers included in this submission are for the Windows MCE USB IR
transceivers and the SoundGraph iMON USB receivers/displays. I have
multiple devices driven by each of these drivers, and have done fairly
extensive testing on them, currently primarily on 2.6.31 and 2.6.32.

The MCE transceiver can handle just about any IR protocol you can throw
at it on the RX side, thus it passes raw IR through to the userspace
lircd daemon for processing. An lircd.conf file maps IR codes to key 
codes, and they can be consumed by the system either via applications
with lirc client support, or they can be fed back into the input subsys
via uinput. The transmit side has no input subsys interaction. Note
that this driver now handles both generations of MCE transceivers.

The iMON receivers come in two flavors, an early version that passes
raw IR, and all more recent versions that do onboard decoding of IR
signals. The iMON driver now supports running as a pure input device on
devices with onboard decoding, as well as "classic" lirc mode for the
ones that don't decode onboard and includes a modparam option to let
the onboard decode devices continue to operate in "classic" mode, for
those who prefer it.

There's been talk about a raw IR input device type/ioctls/whatever. But
it doesn't yet exist, and I know *I* don't have time to write it up...
lircd and lirc drivers could be adapted to use such a thing if/when it
sees the light of day, but for now, the lirc_dev ("classic" lirc mode)
interface is quite well battle-tested, and very capable for both raw IR
receive and transmit. There's also been a patchset proposed to do raw
IR decoding in the kernel. I'm fine with that idea too, but only if
there is *also* a way to get the raw IR out to userspace (lircd), as
there are some esoteric IR protocols out there and we can be a lot more
nimble about adding support for decoding new and different protocols
in userspace than we can in the kernel -- and lircd can now feed all
the resulting key codes back into the input subsystem via uinput too.

The hope is that we can get lirc_dev (upon which all other lirc drivers
depend) merged, along with these initial two drivers, then we can start
reviewing the additional 15 or so lirc drivers for inclusion as well.

Combined diffstat:

 MAINTAINERS                      |    9 +
 drivers/input/Kconfig            |    2 +
 drivers/input/Makefile           |    1 +
 drivers/input/lirc/Kconfig       |   26 +
 drivers/input/lirc/Makefile      |    8 +
 drivers/input/lirc/lirc.h        |  100 ++
 drivers/input/lirc/lirc_dev.c    |  837 +++++++++++++
 drivers/input/lirc/lirc_dev.h    |  194 +++
 drivers/input/lirc/lirc_imon.c   | 2471 ++++++++++++++++++++++++++++++++++++++
 drivers/input/lirc/lirc_imon.h   |  209 ++++
 drivers/input/lirc/lirc_mceusb.c | 1235 +++++++++++++++++++
 11 files changed, 5092 insertions(+), 0 deletions(-)

Git tree:
* git://git.wilsonet.com/linux-2.6-lirc.git/
Git web:
* http://git.wilsonet.com/linux-2.6-lirc.git/
Upstream lirc project:
* http://www.lirc.org/

(If you're going to clone, I'd highly suggest adding it as a remote
to a linus' tree checkout rather than clone'ing directly, as I don't
have nearly as much bandwidth at home as kernel.org... ;)

-- 
Jarod Wilson
jarod@redhat.com
