Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:36024 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaDDCFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 22:05:39 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3H00CDWHTEVM70@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Apr 2014 22:05:38 -0400 (EDT)
Date: Thu, 03 Apr 2014 23:05:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 00/49] rc-core: my current patch queue
Message-id: <20140403230531.28e4af1d@samsung.com>
In-reply-to: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:31:15 +0200
David Härdeman <david@hardeman.nu> escreveu:

> The following patches is what I currenly have in my queue:
> 
> Patches 1 - 6 should be ok to be committed right now, they contain
> some fixes and some reverts (of the NEC32 and generic scancode
> functionality).

I did just a very quick look in this series, so my comments
here are subject to changes.

Patch 4 is obviously OK for 3.15, as it fixes a regression.

With regards to patch 6, yes, if we need to change the API,
it should be sent for 3.15, before becoming too late.
Of course, if we change it, we'll also need to patch the
DocBook and the sysfs ABI descriptions accordingly.
I'll review it carefully latter.

The patches that touch on img-ir (patch 5) can also be applied
during -rc, as this is a new driver. So, no regressions. Of
course, we need James ack on such changes.

It sounds likely too late for the other patches for 3.15
(patches 1, 2 and 3), as they're not so obvious, and
some may require tests on those devices they're supposing
to fix.

> Patches 7 - 9 are in no hurry and can wait for 3.16, some testing
> would be nice even though I believe they are ok.
> 
> Patches 10 and 11 are RFC's for the NEC32 scancode handling.
> 
> The remaining patches are more of an FYI. It's basically the same
> patchset that I've posted a long time ago, but respun to apply to
> the current tree. They implement a modern chardev for rc-core which
> allows the functionality that has so far only been available through
> the LIRC bridge to be exposed to userspace and provide a (hopefully)
> sane API for taking advantage of all the features that rc-core
> provides (RX, TX, ioctl) as well as some new features (multiple
> keymaps is probably the most important one). Lots and lots of cleanups
> as well.

Ok, I'll review the remaining patches after the merge window.

> 
> Enjoy :)

Thanks!
> 
> ---
> 
> David Härdeman (49):
>       bt8xx: fixup RC5 decoding
>       rc-core: improve ir-kbd-i2c get_key functions
>       rc-core: document the protocol type
>       rc-core: do not change 32bit NEC scancode format for now
>       rc-core: split dev->s_filter
>       rc-core: remove generic scancode filter
>       dib0700: NEC scancode cleanup
>       lmedm04: NEC scancode cleanup
>       saa7134: NEC scancode fix
>       [RFC] rc-core: use the full 32 bits for NEC scancodes
>       [RFC] rc-core: don't throw away protocol information
>       rc-core: simplify sysfs code
>       rc-core: remove protocol arrays
>       rc-core: rename dev->scanmask to dev->scancode_mask
>       rc-core: merge rc5 and streamzap decoders
>       rc-core: use an IDA rather than a bitmap
>       rc-core: add chardev
>       rc-core: allow chardev to be read
>       rc-core: use a kfifo for TX data
>       rc-core: allow chardev to be written
>       rc-core: add ioctl support to the rc chardev
>       rc-core: add an ioctl for getting IR RX settings
>       rc-loopback: add RCIOCGIRRX ioctl support
>       rc-core: add an ioctl for setting IR RX settings
>       rc-loopback: add RCIOCSIRRX ioctl support
>       rc-core: add an ioctl for getting IR TX settings
>       rc-loopback: add RCIOCGIRTX ioctl support
>       rc-core: add an ioctl for setting IR TX settings
>       rc-loopback: add RCIOCSIRTX ioctl support
>       rc-core: leave the internals of rc_dev alone
>       rc-core: split rc-main.c into rc-main.c and rc-keytable.c
>       rc-core: prepare for multiple keytables
>       rc-core: make the keytable of rc_dev an array
>       rc-core: add ioctls for adding/removing keytables from userspace
>       rc-core: remove redundant spinlock
>       rc-core: make keytable RCU-friendly
>       rc-core: allow empty keymaps
>       rc-core: rename ir-raw.c
>       rc-core: make IR raw handling a separate module
>       rc-ir-raw: simplify locking
>       rc-core: rename mutex
>       rc-ir-raw: atomic reads of protocols
>       rc-core: fix various sparse warnings
>       rc-core: don't report scancodes via input devices
>       rc-ir-raw: add various rc_events
>       rc-core: use struct rc_event for all rc communication
>       rc-core: add keytable events
>       rc-core: move remaining keytable functions
>       rc-core: make rc-core.h userspace friendly
> 
> 
>  Documentation/ioctl/ioctl-number.txt        |    1 
>  drivers/hid/hid-picolcd_cir.c               |   20 
>  drivers/media/common/siano/smsir.c          |   14 
>  drivers/media/common/siano/smsir.h          |    2 
>  drivers/media/i2c/cx25840/cx25840-ir.c      |   96 +
>  drivers/media/i2c/ir-kbd-i2c.c              |   99 +
>  drivers/media/pci/bt8xx/bttv-input.c        |   78 +
>  drivers/media/pci/bt8xx/bttvp.h             |    2 
>  drivers/media/pci/cx23885/cx23885-input.c   |   26 
>  drivers/media/pci/cx23885/cx23888-ir.c      |   93 +
>  drivers/media/pci/cx88/cx88-input.c         |   75 +
>  drivers/media/pci/dm1105/dm1105.c           |    4 
>  drivers/media/pci/ivtv/ivtv-i2c.c           |   11 
>  drivers/media/pci/saa7134/saa7134-input.c   |  100 +
>  drivers/media/pci/saa7134/saa7134.h         |    2 
>  drivers/media/pci/ttpci/budget-ci.c         |   10 
>  drivers/media/rc/Kconfig                    |   12 
>  drivers/media/rc/Makefile                   |    4 
>  drivers/media/rc/ati_remote.c               |   11 
>  drivers/media/rc/ene_ir.c                   |   84 +
>  drivers/media/rc/ene_ir.h                   |    9 
>  drivers/media/rc/fintek-cir.c               |   34 
>  drivers/media/rc/gpio-ir-recv.c             |   15 
>  drivers/media/rc/iguanair.c                 |   77 +
>  drivers/media/rc/img-ir/img-ir-hw.c         |   48 -
>  drivers/media/rc/img-ir/img-ir-hw.h         |    3 
>  drivers/media/rc/img-ir/img-ir-jvc.c        |    4 
>  drivers/media/rc/img-ir/img-ir-nec.c        |   80 -
>  drivers/media/rc/img-ir/img-ir-raw.c        |    8 
>  drivers/media/rc/img-ir/img-ir-sanyo.c      |    4 
>  drivers/media/rc/img-ir/img-ir-sharp.c      |    4 
>  drivers/media/rc/img-ir/img-ir-sony.c       |   12 
>  drivers/media/rc/imon.c                     |   33 
>  drivers/media/rc/ir-jvc-decoder.c           |   52 -
>  drivers/media/rc/ir-lirc-codec.c            |  225 ++-
>  drivers/media/rc/ir-mce_kbd-decoder.c       |   36 
>  drivers/media/rc/ir-nec-decoder.c           |   96 -
>  drivers/media/rc/ir-rc5-decoder.c           |  113 +-
>  drivers/media/rc/ir-rc5-sz-decoder.c        |  154 --
>  drivers/media/rc/ir-rc6-decoder.c           |   91 +
>  drivers/media/rc/ir-sanyo-decoder.c         |   60 -
>  drivers/media/rc/ir-sharp-decoder.c         |   53 -
>  drivers/media/rc/ir-sony-decoder.c          |   58 -
>  drivers/media/rc/ite-cir.c                  |   69 -
>  drivers/media/rc/ite-cir.h                  |    2 
>  drivers/media/rc/keymaps/rc-behold.c        |   68 -
>  drivers/media/rc/keymaps/rc-lme2510.c       |  132 +-
>  drivers/media/rc/keymaps/rc-nebula.c        |  112 +-
>  drivers/media/rc/keymaps/rc-streamzap.c     |    4 
>  drivers/media/rc/keymaps/rc-tivo.c          |   95 +
>  drivers/media/rc/mceusb.c                   |   67 +
>  drivers/media/rc/nuvoton-cir.c              |   88 +
>  drivers/media/rc/nuvoton-cir.h              |    9 
>  drivers/media/rc/rc-core-priv.h             |  122 +-
>  drivers/media/rc/rc-ir-raw.c                |  284 ++--
>  drivers/media/rc/rc-keytable.c              |  958 +++++++++++++
>  drivers/media/rc/rc-loopback.c              |  200 ++-
>  drivers/media/rc/rc-main.c                  | 1974 ++++++++++++---------------
>  drivers/media/rc/redrat3.c                  |  156 +-
>  drivers/media/rc/st_rc.c                    |    2 
>  drivers/media/rc/streamzap.c                |   81 -
>  drivers/media/rc/ttusbir.c                  |   42 -
>  drivers/media/rc/winbond-cir.c              |  113 +-
>  drivers/media/usb/cx231xx/cx231xx-input.c   |   31 
>  drivers/media/usb/dvb-usb-v2/af9015.c       |   26 
>  drivers/media/usb/dvb-usb-v2/af9035.c       |   20 
>  drivers/media/usb/dvb-usb-v2/anysee.c       |    3 
>  drivers/media/usb/dvb-usb-v2/az6007.c       |   21 
>  drivers/media/usb/dvb-usb-v2/dvb_usb.h      |    5 
>  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |   14 
>  drivers/media/usb/dvb-usb-v2/lmedm04.c      |   22 
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c     |   30 
>  drivers/media/usb/dvb-usb/dib0700_core.c    |   39 -
>  drivers/media/usb/dvb-usb/dib0700_devices.c |   24 
>  drivers/media/usb/dvb-usb/dvb-usb-remote.c  |   15 
>  drivers/media/usb/dvb-usb/dvb-usb.h         |    5 
>  drivers/media/usb/dvb-usb/dw2102.c          |    7 
>  drivers/media/usb/dvb-usb/m920x.c           |    2 
>  drivers/media/usb/dvb-usb/pctv452e.c        |    8 
>  drivers/media/usb/dvb-usb/technisat-usb2.c  |   17 
>  drivers/media/usb/dvb-usb/ttusb2.c          |    6 
>  drivers/media/usb/em28xx/em28xx-cards.c     |    1 
>  drivers/media/usb/em28xx/em28xx-input.c     |  111 +-
>  drivers/media/usb/tm6000/tm6000-input.c     |   60 +
>  include/media/ir-kbd-i2c.h                  |    6 
>  include/media/rc-core.h                     |  473 ++++--
>  include/media/rc-ir-raw.h                   |   68 +
>  include/media/rc-map.h                      |   28 
>  88 files changed, 4344 insertions(+), 3289 deletions(-)
>  delete mode 100644 drivers/media/rc/ir-rc5-sz-decoder.c
>  rename drivers/media/rc/{ir-raw.c => rc-ir-raw.c} (52%)
>  create mode 100644 drivers/media/rc/rc-keytable.c
>  create mode 100644 include/media/rc-ir-raw.h
> 
> --
> David Härdeman
> 


-- 

Regards,
Mauro
