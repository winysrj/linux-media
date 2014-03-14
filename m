Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58915 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaCNXGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:06:54 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so166394wiv.7
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:06:52 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2 0/9] rc: Add IR encode based wakeup filtering
Date: Fri, 14 Mar 2014 23:04:10 +0000
Message-Id: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent discussion about proposed interfaces for setting up the
hardware wakeup filter lead to the conclusion that it could help to have
the generic capability to encode and modulate scancodes into raw IR
events so that drivers for hardware with a low level wake filter (on the
level of pulse/space durations) can still easily implement the higher
level scancode interface that is proposed.

I posted an RFC patchset showing how this could work, and Antti Seppälä
posted additional patches to support rc5-sz and nuvoton-cir. This
patchset improves the original RFC patches and combines & updates
Antti's patches.

I'm happy these patches are a good start at tackling the problem, as
long as Antti is happy with them and they work for him of course.

Future work could include:
 - Encoders for more protocols.
 - Carrier signal events (no use unless a driver makes use of it).

Patch 1 adds the new encode API.
Patches 2-3 adds some modulation helpers.
Patches 4-6 adds some raw encode implementations.
Patch 7 adds some rc-core support for encode based wakeup filtering.
Patch 8 adds debug loopback of encoded scancode when filter set.
Patch 9 (untested) adds encode based wakeup filtering to nuvoton-cir.

Changes in v2:

Patchset:
 - Alter encode API to return -ENOBUFS when there isn't enough buffer
   space. When this occurs all buffer contents must have been written
   with the partial encoding of the scancode. This is to allow drivers
   such as nuvoton-cir to provide a shorter buffer and still get a
   useful partial encoding for the wakeup pattern.
 - Added RC-5 & RC-5X encoder.
 - Add encode_wakeup support which keeps allowed wakeup protocols in
   sync with registered encoders.

Pulse-distance modulation helper:
 - Update ir_raw_gen_pd() with a kerneldoc comment and individual buffer
   full checks rather than a single one at the beginning, in order to
   support -ENOBUFS properly.
 - Update ir_raw_gen_pulse_space() to check the number of free slots and
   fill as many as possible before returning -ENOBUFS.
 - Fix brace placement for timings struct.

Manchester encoding helper:
 - Add kerneldoc comment.
 - Add individual buffer full checks, in order to support -ENOBUFS
   properly.
 - Make i unsigned to theoretically support all 32bits of data.
 - Increment *ev at end so caller can calculate correct number of
   events (during the loop *ev points to the last written event to allow
   it to be extended in length).
 - Make start/leader pulse optional, continuing from (*ev)[-1] if
   disabled. This helps support rc-5x which has a space in the middle of
   the bits.

rc5-sz encoder:
 - Turn ir_rc5_sz_encode() comment into kerneldoc and update to reflect
   new API.
 - Be more flexible around accepted scancode masks, as long as all the
   important bits are set (0x2fff) and none of the unimportant bits are
   set in the data. Also mask off the unimportant bits before passing to
   ir_raw_gen_manchester().
 - Explicitly enable leader bit in Manchester modulation timings.

rc-loopback:
 - Move img-ir-raw test code to rc-loopback.
 - Set encode_wakeup so that the set of allowed wakeup protocols matches
   the set of raw IR encoders.

nuvoton-cir:
 - Change reference to rc_dev::enabled_protocols to
   enabled_protocols[type] since it has been converted to an array.
 - Fix IR encoding buffer loop condition to be i < ret rather than i <=
   ret. The return value of ir_raw_encode_scancode is the number of
   events rather than the last event.
 - Set encode_wakeup so that the set of allowed wakeup protocols matches
   the set of raw IR encoders.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Hans Verkuil <hans.verkuil@cisco.com>

Antti Seppälä (3):
  rc: ir-raw: Add Manchester encoder (phase encoder) helper
  rc: ir-rc5-sz-decoder: Add ir encoding support
  rc: nuvoton-cir: Add support for writing wakeup samples via sysfs
    filter callback

James Hogan (6):
  rc: ir-raw: Add scancode encoder callback
  rc: ir-raw: Add pulse-distance modulation helper
  rc: ir-nec-decoder: Add encode capability
  rc: ir-rc5-decoder: Add encode capability
  rc: rc-core: Add support for encode_wakeup drivers
  rc: rc-loopback: Add loopback of filter scancodes

 drivers/media/rc/ir-nec-decoder.c    |  93 +++++++++++++++++
 drivers/media/rc/ir-raw.c            | 191 +++++++++++++++++++++++++++++++++++
 drivers/media/rc/ir-rc5-decoder.c    | 103 +++++++++++++++++++
 drivers/media/rc/ir-rc5-sz-decoder.c |  45 +++++++++
 drivers/media/rc/nuvoton-cir.c       | 123 ++++++++++++++++++++++
 drivers/media/rc/nuvoton-cir.h       |   1 +
 drivers/media/rc/rc-core-priv.h      |  85 ++++++++++++++++
 drivers/media/rc/rc-loopback.c       |  39 +++++++
 drivers/media/rc/rc-main.c           |  11 +-
 include/media/rc-core.h              |   7 ++
 10 files changed, 695 insertions(+), 3 deletions(-)

-- 
1.8.3.2

