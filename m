Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56400 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMbS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:18 -0400
Subject: [PATCH 00/19] lirc_dev modernisation
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:14 +0200
Message-ID: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series reworks lirc_dev to use a single struct lirc_dev to
keep track of registered lirc devices rather than the current situation
where a combination of a struct lirc_driver and a struct irctl are used.
The fact that two structs are currently used per device makes the current
code harder to read and to analyse (e.g. wrt locking correctness).

The idea started out with this patch:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg112159.html

Which was rejected due to the struct copying. In fixing that issue and
at the same time trying to split up the patch in smaller pieces, I ended
up with quite a bit larger patch series than first expected.

The end result is that struct lirc_dev (which is maintained by lirc_dev)
has proper lifecycle management and that we can avoid the current struct
copying that is performed between struct lirc_driver and struct irctl.

The locking in lirc_dev is also much improved by only having one mutex per
struct lirc_dev which is used to synchronize all operations.

The modifications to lirc_dev and ir-lirc-codec have been tested using
rc-loopback and mceusb. The changes to lirc_zilog are only compile tested.

---

David Härdeman (19):
      lirc_dev: clarify error handling
      lirc_dev: remove support for manually specifying minor number
      lirc_dev: remove min_timeout and max_timeout
      lirc_dev: use cdev_device_add() helper function
      lirc_dev: make better use of file->private_data
      lirc_dev: make chunk_size and buffer_size mandatory
      lirc_dev: remove kmalloc in lirc_dev_fop_read()
      lirc_dev: change irctl->attached to be a boolean
      lirc_dev: sanitize locking
      lirc_dev: use an IDA instead of an array to keep track of registered devices
      lirc_dev: rename struct lirc_driver to struct lirc_dev
      lirc_dev: introduce lirc_allocate_device and lirc_free_device
      lirc_dev: remove the BUFLEN define
      lirc_zilog: add a pointer to the parent device to struct IR
      lirc_zilog: use a dynamically allocated lirc_dev
      lirc_dev: merge struct irctl into struct lirc_dev
      ir-lirc-codec: merge lirc_dev_fop_ioctl into ir_lirc_ioctl
      ir-lirc-codec: move the remaining fops over from lirc_dev
      lirc_dev: consistent device registration printk


 drivers/media/rc/ir-lirc-codec.c        |  404 ++++++++++++++++-----
 drivers/media/rc/lirc_dev.c             |  587 ++++++-------------------------
 drivers/media/rc/rc-core-priv.h         |    2 
 drivers/staging/media/lirc/lirc_zilog.c |  234 +++++-------
 include/media/lirc_dev.h                |  111 ++----
 5 files changed, 570 insertions(+), 768 deletions(-)

--
David Härdeman
