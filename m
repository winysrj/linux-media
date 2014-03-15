Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbaCONoI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 09:44:08 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC PATCH 0/3] Fix compilation breakages with dib7000p
Date: Sat, 15 Mar 2014 10:43:11 -0300
Message-Id: <1394890994-29185-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those patches are meant to fix a long-stanging compilation bug that
happens when
        CONFIG_DVB_DIB7000P=m
and one of the bridge drivers that use this frontend is compiled builtin
(cxusb, cx23885-dvb and/or dib0700).

Those bugs are due to the fact that those drivers use dvb_attach() but
have more than one exported symbol.

When a frontend is compiled as a module, dvb_attach() does three
things:
- It lookups for the module that has the given symbol name.
  If found, it requests such module;
- It increments the module usage (anonymously - so lsmod
  doesn't print who loaded the module);
- after loading the module, it runs the function associated
  with the dynamic symbol.

As dvb_attach() increments refcount, it can't be (easily)
called more than once for the same module, or the kernel
will deny to remove the module, because refcount will never
be zeroed.

In other words, the function name given to dvb_attach()
should be the single symbol that will always be called
before any other function on that module to be used,
and it should be called only once.

For almost all DVB frontends, that's the case. However,
dib0700 frontends provide hardware filters and have some
weird initialization. So, the frontend drivers currently
export multiple functions.

In the case of dib7000p, the dib7000p initialization can require
up to 3 functions to be called:
        - dib7000p_get_i2c_master;
        - dib7000p_i2c_enumeration;
        - dib7000p_init (before this patchset dib7000_attach).

(plus a bunch of other functions that the bridge driver will
need to call).

So, instead of having a standard foo_attach() function that
returns a frontend, let's add, instead, one function that
fills an structure with callbacks to the loaded frontend.

That allows that the dynamic function call made by dvb_attach()
to work. The other functions (including the above three
initialization ones) are always called via the callbacks
provided by the ops structure.

This way, there's no more hard-dependency between the
bridges and the frontend. All is dynamically resolved.

For now, this was compile tested only. Also, it is not
enouh to solve all issues, as there are other frontends
that do the same.

Please someone with a dib7000p test it and provide us some
feedback.

Thanks!
Mauro

Mauro Carvalho Chehab (3):
  dvbdev: add a dvb_dettach() macro
  dib7000p: rename dvb_attach to dvb_init
  dib7000: export just one symbol

 drivers/media/dvb-core/dvb_frontend.c       |   8 +-
 drivers/media/dvb-core/dvbdev.h             |   4 +
 drivers/media/dvb-frontends/dib7000p.c      |  42 ++--
 drivers/media/dvb-frontends/dib7000p.h      | 130 ++----------
 drivers/media/pci/cx23885/cx23885-dvb.c     |   7 +-
 drivers/media/usb/dvb-usb/cxusb.c           |  38 ++--
 drivers/media/usb/dvb-usb/dib0700_devices.c | 312 ++++++++++++++++++----------
 7 files changed, 288 insertions(+), 253 deletions(-)

-- 
1.8.5.3

