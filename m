Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab2FVRht (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 13:37:49 -0400
Message-ID: <4FE4AD64.9060404@redhat.com>
Date: Fri, 22 Jun 2012 14:37:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org, jarod@redhat.com
Subject: Re: [PATCH 00/43] rc-core: feature parity with LIRC
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em 23-05-2012 06:42, David Härdeman escreveu:
> The following patchset provides most of the features necessary for parity with
> the LIRC subsystem that rc-core is intended to replace.
> 
> Most importantly, a chardev is provided which can be used to control RC hardware
> using read (RX), write (TX) and ioctl (setting RX/TX parameters).
> 
> The patchset still needs further testing and I am well aware that patches will
> be necessary to the current userspace tools as well. However, I'd like to get
> the discussion started on whether the API needs any changes before I invest more
> time in testing and patches to other tools.
> 
> Code review is welcome but the most important part is the userspace<->kernel
> interface (i.e. the read/write/ioctl interface).

Didn't have time yet to dig into this big patch series. Also, I'm expecting Jarod's
review on it, as he's the maintainer of the lirc drivers.

Yet, one thing that this patch series is doing is that it is changing the current
interface, and will likely break the existing userspace applications. This is not
allowed. Deprecating existing interfaces in favor of newer ones is possible, but
this will require to mark the affected sysfs nodes to be marked as deprecated at 
Documentation/feature-removal-schedule.txt, and a new set of them to be added with
the new interface.

Before that, however, we need to be convinced why such change is required.

Also, analyzing a 43 patch series require reviewers/maintainers to reserve a big
window just for this series. It is a way better if you break it into smaller
patch series.

Based solely on the patch names, it seems that there are several different things there:
	- RC API changes;
	- LIRC API additions;
	- Some "independent" patches (kmaloc removal, debug cleanup, etc);
	- rc-core improvements.

I suggest you to split the patch series, starting with the more obvious changes.
Then, we can go into RC API changes and lirc API additions.

Regards,
Mauro

> 
> Comments?
> 
> ---
> 
> David Härdeman (43):
>        rc-core: move timeout and checks to lirc
>        rc-core: add separate defines for protocol bitmaps and numbers
>        rc-core: don't throw away protocol information
>        rc-core: use the full 32 bits for NEC scancodes
>        rc-core: merge rc5 and streamzap decoders
>        rc-core: rename ir_input_class to rc_class
>        rc-core: initialize rc-core earlier if built-in
>        rc-core: use a device table rather than an atomic number
>        rc-core: add chardev
>        rc-core: allow chardev to be read
>        mceusb: remove pointless kmalloc
>        redrat: cleanup debug functions
>        rc-core: use a kfifo for TX data
>        rc-core: allow chardev to be written
>        rc-core: add ioctl support to the rc chardev
>        rc-core: add an ioctl for getting IR RX settings
>        rc-loopback: add RCIOCGIRRX ioctl support
>        rc-core: add an ioctl for setting IR RX settings
>        rc-loopback: add RCIOCSIRRX ioctl support
>        rc-core: add an ioctl for getting IR TX settings
>        rc-loopback: add RCIOCGIRTX ioctl support
>        rc-core: add an ioctl for setting IR TX settings
>        rc-loopback: add RCIOCSIRTX ioctl support
>        rc-core: leave the internals of rc_dev alone
>        rc-core: prepare for multiple keytables
>        rc-core: do not take mutex on rc_dev registration
>        rc-core: make the keytable of rc_dev an array
>        rc-core: add ioctls for adding/removing keytables from userspace
>        rc-core: remove redundant spinlock
>        rc-core: make keytable RCU-friendly
>        rc-core: allow empty keymaps
>        rc-core: split IR raw handling to a separate module
>        rc-ir-raw: simplify locking
>        rc-core: rename mutex
>        rc-ir-raw: atomic reads of protocols
>        rc-core: fix various sparse warnings
>        rc-core: don't report scancodes via input devices
>        rc-ir-raw: add various rc_events
>        rc-core: use struct rc_event to signal TX events from userspace
>        rc-core: use struct rc_event for all rc communication
>        rc-core: add keytable events
>        rc-core: move remaining keytable functions
>        rc-core: make rc-core.h userspace friendly
> 
> 
>   Documentation/ioctl/ioctl-number.txt           |    1
>   drivers/media/dvb/dm1105/dm1105.c              |    3
>   drivers/media/dvb/dvb-usb/Kconfig              |    2
>   drivers/media/dvb/dvb-usb/af9015.c             |   38 -
>   drivers/media/dvb/dvb-usb/af9035.c             |   25
>   drivers/media/dvb/dvb-usb/anysee.c             |    4
>   drivers/media/dvb/dvb-usb/az6007.c             |   19
>   drivers/media/dvb/dvb-usb/dib0700_core.c       |   11
>   drivers/media/dvb/dvb-usb/dib0700_devices.c    |  156 +-
>   drivers/media/dvb/dvb-usb/dvb-usb-remote.c     |   11
>   drivers/media/dvb/dvb-usb/dvb-usb.h            |    4
>   drivers/media/dvb/dvb-usb/it913x.c             |   24
>   drivers/media/dvb/dvb-usb/lmedm04.c            |   11
>   drivers/media/dvb/dvb-usb/pctv452e.c           |   15
>   drivers/media/dvb/dvb-usb/rtl28xxu.c           |   32
>   drivers/media/dvb/dvb-usb/technisat-usb2.c     |   17
>   drivers/media/dvb/dvb-usb/ttusb2.c             |    4
>   drivers/media/dvb/mantis/mantis_input.c        |    2
>   drivers/media/dvb/siano/Kconfig                |    2
>   drivers/media/dvb/siano/smsir.c                |   13
>   drivers/media/dvb/siano/smsir.h                |    2
>   drivers/media/dvb/ttpci/budget-ci.c            |    7
>   drivers/media/rc/Kconfig                       |   66 +
>   drivers/media/rc/Makefile                      |    4
>   drivers/media/rc/ati_remote.c                  |   18
>   drivers/media/rc/ene_ir.c                      |   69 -
>   drivers/media/rc/ene_ir.h                      |    9
>   drivers/media/rc/fintek-cir.c                  |   30
>   drivers/media/rc/gpio-ir-recv.c                |   11
>   drivers/media/rc/imon.c                        |   45 -
>   drivers/media/rc/ir-jvc-decoder.c              |   54 -
>   drivers/media/rc/ir-lirc-codec.c               |  191 ++-
>   drivers/media/rc/ir-mce_kbd-decoder.c          |   38 -
>   drivers/media/rc/ir-nec-decoder.c              |   93 +
>   drivers/media/rc/ir-raw.c                      |  374 ------
>   drivers/media/rc/ir-rc5-decoder.c              |   94 +
>   drivers/media/rc/ir-rc5-sz-decoder.c           |  154 --
>   drivers/media/rc/ir-rc6-decoder.c              |  102 +-
>   drivers/media/rc/ir-sanyo-decoder.c            |   62 -
>   drivers/media/rc/ir-sony-decoder.c             |   59 +
>   drivers/media/rc/ite-cir.c                     |   57 -
>   drivers/media/rc/ite-cir.h                     |    2
>   drivers/media/rc/keymaps/rc-imon-mce.c         |    2
>   drivers/media/rc/keymaps/rc-rc6-mce.c          |    2
>   drivers/media/rc/keymaps/rc-streamzap.c        |    4
>   drivers/media/rc/mceusb.c                      |  125 +-
>   drivers/media/rc/nuvoton-cir.c                 |   83 +
>   drivers/media/rc/nuvoton-cir.h                 |    9
>   drivers/media/rc/rc-core-priv.h                |   62 +
>   drivers/media/rc/rc-ir-raw.c                   |  375 ++++++
>   drivers/media/rc/rc-keytable.c                 |  996 +++++++++++++++
>   drivers/media/rc/rc-loopback.c                 |  212 ++-
>   drivers/media/rc/rc-main.c                     | 1575 +++++++++++-------------
>   drivers/media/rc/redrat3.c                     |  336 ++---
>   drivers/media/rc/streamzap.c                   |   80 +
>   drivers/media/rc/winbond-cir.c                 |   61 -
>   drivers/media/video/bt8xx/bttv-input.c         |   15
>   drivers/media/video/cx18/cx18-i2c.c            |    2
>   drivers/media/video/cx231xx/cx231xx-input.c    |    9
>   drivers/media/video/cx23885/Kconfig            |    2
>   drivers/media/video/cx23885/cx23885-input.c    |   21
>   drivers/media/video/cx23885/cx23888-ir.c       |   93 +
>   drivers/media/video/cx25840/cx25840-ir.c       |   96 +
>   drivers/media/video/cx88/Kconfig               |    2
>   drivers/media/video/cx88/cx88-input.c          |   43 -
>   drivers/media/video/em28xx/em28xx-cards.c      |   15
>   drivers/media/video/em28xx/em28xx-input.c      |   38 -
>   drivers/media/video/em28xx/em28xx.h            |    1
>   drivers/media/video/hdpvr/hdpvr-i2c.c          |    2
>   drivers/media/video/ir-kbd-i2c.c               |   30
>   drivers/media/video/ivtv/ivtv-i2c.c            |   10
>   drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    4
>   drivers/media/video/saa7134/Kconfig            |    2
>   drivers/media/video/saa7134/saa7134-input.c    |   12
>   drivers/media/video/saa7134/saa7134.h          |    2
>   drivers/media/video/tm6000/tm6000-cards.c      |    2
>   drivers/media/video/tm6000/tm6000-input.c      |   79 +
>   include/media/ir-kbd-i2c.h                     |    2
>   include/media/rc-core.h                        |  404 +++++-
>   include/media/rc-ir-raw.h                      |   78 +
>   include/media/rc-map.h                         |   88 +
>   81 files changed, 3949 insertions(+), 2960 deletions(-)
>   delete mode 100644 drivers/media/rc/ir-raw.c
>   delete mode 100644 drivers/media/rc/ir-rc5-sz-decoder.c
>   create mode 100644 drivers/media/rc/rc-ir-raw.c
>   create mode 100644 drivers/media/rc/rc-keytable.c
>   create mode 100644 include/media/rc-ir-raw.h
> 


