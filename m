Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:56711 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaB1X3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 18:29:44 -0500
Received: by mail-we0-f172.google.com with SMTP id u56so1124512wes.31
        for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 15:29:43 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
	Jarod Wilson <jarod@redhat.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
	Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v4 00/10] media: rc: ImgTec IR decoder driver
Date: Fri, 28 Feb 2014 23:28:50 +0000
Message-Id: <1393630140-31765-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a driver for the ImgTec Infrared decoder block. Two separate rc
input devices are exposed depending on kernel configuration. One uses
the hardware decoder which is set up with timings for a specific
protocol and supports mask/value filtering and wake events. The other
uses raw edge interrupts and the generic software protocol decoders to
allow multiple protocols to be supported, including those not supported
by the hardware decoder.

The hardware decoder timing values, raw data to scan code conversion
function and scan code filter to raw data filter conversion function are
provided in separate files for each protocol which the main driver can
use. The new generic scan code filter interface is made use of to reduce
interrupts and control wake events.

This patchset depends on the "rc: scancode filtering improvements"
patchset.

Changes in v4:

Patchset:
- Rebase on RC filtering improvements patchset, and fix to use new
  allowed/enabled protocol abstractions.
- Drop first 5 patches for generic scancode filtering, which have
  already been applied.

Hardware Decoder:
- Depend on generic code to update normal filter on a protocol change.
- Minimal support for wakeup_protocols by setting allowed and enabled
  wakeup protocols to match the enabled normal protocol on a protocol
  change (but only if the protocol has filtering support in the driver).
  Supporting a different wakeup protocol to the normal protocol is left
  as a task for another day.

Changes in v3:

DT bindings:
- Rename compatible string to "img,ir-rev1" (Rob Herring).
- Specify ordering of clocks explicitly (Rob Herring).

Changes in v2:

DT bindings:
- Future proof compatible string from "img,ir" to "img,ir1", where the 1
  corresponds to the major revision number of the hardware (Tomasz
  Figa).
- Added clock-names property and three specific clock names described in
  the manual, only one of which is used by the current driver (Tomasz
  Figa).

Misc:
- Use spin_lock_irq() instead of spin_lock_irqsave() in various bits of
  code that aren't accessible from hard interrupt context.
- Add io.h include to img-ir.h.

Raw Decoder:
- Echo the last sample after 150ms if no edges have been detected. This
  allows the soft decoder state machines to recognise the final space
  when no repeat code is received.
- Avoid removal race by checking for RC device in ISR.

Hardware Decoder:
- Remove the dynamic registration and unregistration of protocol decoder
  timings. It didn't really get us much and it complicated locking and
  load ordering.
- Simplify locking of decoders, they're now only modified when
  preprocessed, and all other use is after that, so preprocessing is the
  only place locking is required.
- Use the new generic filtering interface rather than creating the sysfs
  files in the driver. This rearranges the code a bit, so as to use an
  array of 2 filters (normal and wake) rather than separate struct
  members for each, and passes the array index around between functions
  rather than the pointer to the filter.
- Extend the scancode() decoder callback to handle full 32bit scancodes.
  Previously negative scancodes were treated specially, and indicated
  repeat codes or invalid raw data, but 32bit NEC may result in a
  scancode with the top bit set. Therefore change the scancode() return
  value to simply indicate success/fail/repeat, and add an extra
  scancode output pointer parameter that must have been written by the
  callback if it returns IMG_IR_SCANCODE.
- Separate clock rate specific data in the decoder timings structure so
  that it can be more easily shared between instantiations of the
  driver. A new struct img_ir_reg_timings stores the calculated clock
  rate specific register values for the timings. This allows us to make
  more widespread use of const on decoder timings.
- Make tolerance of hardware decoder timings configurable per protocol
  rather than being fixed at 10% for all protocols. This allows the
  tolerance of the Sharp protocol timings in particular to be increased.
- Fix typo in img_ir_enable_wake (s/RC_FILTER_WAKUP/RC_FILTER_WAKEUP/).
- Fix change_protocol to accept a zero protocol mask (for when "none" is
  written to /sys/class/rc/rcX/protocols).
- Stop the end_timer (for keyups after repeat code timeout) safely on
  removal and protocol switch.
- Fix rc_map.rc_type initialisation to use __ffs64(proto_mask).
- Fix img_ir_allowed_protos() to return a protocol mask in a u64 rather
  than an unsigned long.
- Use setup_timer() macro for the end timer rather than using
  init_timer() and setting function pointer and data explicitly.
- Add a debug message for when the scancode() callback rejects the data.
- Minor cosmetic changes (variable naming e.g. s/ir_dev/rdev/ in
  img_ir_set_protocol).

NEC decoder:
- Update scancode and filter callbacks to handle 32-bit NEC as used by
  Apple and TiVo remotes (the new 32-bit NEC scancode format is used,
  with the correct bit orientation).
- Make it possible to set the filter to extended NEC even when the high
  bits of the scancode value aren't set, by taking the mask into account
  too. My TV remote happens to use extended NEC with address 0x7f00,
  which unfortunately maps to scancodes 0x007f** which looks like normal
  NEC and couldn't previously be filtered.

Sharp decoder:
- Fix typo in logic 1 pulse width comment.
- Set tolerance to 20%, which seemed to be needed for the cases I have.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Cc: Tomasz Figa <tomasz.figa@gmail.com>

James Hogan (10):
  dt: binding: add binding for ImgTec IR block
  rc: img-ir: add base driver
  rc: img-ir: add raw driver
  rc: img-ir: add hardware decoder driver
  rc: img-ir: add to build
  rc: img-ir: add NEC decoder module
  rc: img-ir: add JVC decoder module
  rc: img-ir: add Sony decoder module
  rc: img-ir: add Sharp decoder module
  rc: img-ir: add Sanyo decoder module

 .../devicetree/bindings/media/img-ir-rev1.txt      |   34 +
 drivers/media/rc/Kconfig                           |    2 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/img-ir/Kconfig                    |   61 ++
 drivers/media/rc/img-ir/Makefile                   |   11 +
 drivers/media/rc/img-ir/img-ir-core.c              |  176 ++++
 drivers/media/rc/img-ir/img-ir-hw.c                | 1053 ++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir-hw.h                |  269 +++++
 drivers/media/rc/img-ir/img-ir-jvc.c               |   92 ++
 drivers/media/rc/img-ir/img-ir-nec.c               |  148 +++
 drivers/media/rc/img-ir/img-ir-raw.c               |  151 +++
 drivers/media/rc/img-ir/img-ir-raw.h               |   60 ++
 drivers/media/rc/img-ir/img-ir-sanyo.c             |  122 +++
 drivers/media/rc/img-ir/img-ir-sharp.c             |   99 ++
 drivers/media/rc/img-ir/img-ir-sony.c              |  145 +++
 drivers/media/rc/img-ir/img-ir.h                   |  166 +++
 16 files changed, 2590 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/img-ir-rev1.txt
 create mode 100644 drivers/media/rc/img-ir/Kconfig
 create mode 100644 drivers/media/rc/img-ir/Makefile
 create mode 100644 drivers/media/rc/img-ir/img-ir-core.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-hw.h
 create mode 100644 drivers/media/rc/img-ir/img-ir-jvc.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-nec.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-raw.h
 create mode 100644 drivers/media/rc/img-ir/img-ir-sanyo.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-sharp.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-sony.c
 create mode 100644 drivers/media/rc/img-ir/img-ir.h

-- 
1.8.3.2

