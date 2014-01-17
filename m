Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:48368 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbaAQOAE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:04 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
	Jarod Wilson <jarod@redhat.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
	Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
	Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 00/15] media: rc: ImgTec IR decoder driver
Date: Fri, 17 Jan 2014 13:58:45 +0000
Message-ID: <1389967140-20704-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few generic changes (patches 1-5) and then add a driver for the ImgTec
Infrared decoder block (patches 6-15). Two separate rc input devices are
exposed depending on kernel configuration. One uses the hardware decoder
which is set up with timings for a specific protocol and supports
mask/value filtering and wake events. The other uses raw edge interrupts
and the generic software protocol decoders to allow multiple protocols
to be supported, including those not supported by the hardware decoder.

The hardware decoder timing values, raw data to scan code conversion
function and scan code filter to raw data filter conversion function are
provided in separate files for each protocol which the main driver can
use. The new generic scan code filter interface is made use of to reduce
interrupts and control wake events.

Changes in v2:

Patchset:
- New generic patches 1, 3-5:
  - Patch 1 adds sysfs documentation which is extended by patch 4.
  - Patch 3 adds a raw decoder for the Sharp protocol.
  - Patch 4 adds the scancode filtering sysfs interface generically (bit
    of an RFC really).
  - Patch 5 changes the scancode format for 32-bit NEC (bit of an RFC
    really - can we get away with this?).

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

James Hogan (15):
  media: rc: document rc class sysfs API
  media: rc: add Sharp infrared protocol
  media: rc: add raw decoder for Sharp protocol
  media: rc: add sysfs scancode filtering interface
  media: rc: change 32bit NEC scancode format
  dt: binding: add binding for ImgTec IR block
  media: rc: img-ir: add base driver
  media: rc: img-ir: add raw driver
  media: rc: img-ir: add hardware decoder driver
  media: rc: img-ir: add to build
  media: rc: img-ir: add NEC decoder module
  media: rc: img-ir: add JVC decoder module
  media: rc: img-ir: add Sony decoder module
  media: rc: img-ir: add Sharp decoder module
  media: rc: img-ir: add Sanyo decoder module

 Documentation/ABI/testing/sysfs-class-rc           |   92 ++
 .../devicetree/bindings/media/img-ir1.txt          |   30 +
 drivers/media/rc/Kconfig                           |   11 +
 drivers/media/rc/Makefile                          |    2 +
 drivers/media/rc/img-ir/Kconfig                    |   61 ++
 drivers/media/rc/img-ir/Makefile                   |   11 +
 drivers/media/rc/img-ir/img-ir-core.c              |  176 ++++
 drivers/media/rc/img-ir/img-ir-hw.c                | 1040 ++++++++++++++++++++
 drivers/media/rc/img-ir/img-ir-hw.h                |  269 +++++
 drivers/media/rc/img-ir/img-ir-jvc.c               |   92 ++
 drivers/media/rc/img-ir/img-ir-nec.c               |  148 +++
 drivers/media/rc/img-ir/img-ir-raw.c               |  151 +++
 drivers/media/rc/img-ir/img-ir-raw.h               |   60 ++
 drivers/media/rc/img-ir/img-ir-sanyo.c             |  122 +++
 drivers/media/rc/img-ir/img-ir-sharp.c             |   99 ++
 drivers/media/rc/img-ir/img-ir-sony.c              |  145 +++
 drivers/media/rc/img-ir/img-ir.h                   |  166 ++++
 drivers/media/rc/ir-nec-decoder.c                  |    5 +-
 drivers/media/rc/ir-sharp-decoder.c                |  200 ++++
 drivers/media/rc/keymaps/rc-tivo.c                 |   86 +-
 drivers/media/rc/rc-core-priv.h                    |    6 +
 drivers/media/rc/rc-main.c                         |  137 +++
 include/media/rc-core.h                            |   29 +
 include/media/rc-map.h                             |    4 +-
 24 files changed, 3097 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rc
 create mode 100644 Documentation/devicetree/bindings/media/img-ir1.txt
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
 create mode 100644 drivers/media/rc/ir-sharp-decoder.c

-- 
1.8.3.2


