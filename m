Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:57661 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbaBFT76 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 14:59:58 -0500
Received: by mail-we0-f172.google.com with SMTP id p61so1690659wes.17
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 11:59:56 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [RFC 0/4] rc: ir-raw: Add encode, implement NEC encode
Date: Thu,  6 Feb 2014 19:59:19 +0000
Message-Id: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent discussion about proposed interfaces for setting up the
hardware wakeup filter lead to the conclusion that it could help to have
the generic capability to encode and modulate scancodes into raw IR
events so that drivers for hardware with a low level wake filter (on the
level of pulse/space durations) can still easily implement the higher
level scancode interface that is proposed.

This patchset is just a quick experiment to suggest how it might work.
I'm not familiar with the hardware that could use it so it could well be
a bit misdesigned in places (e.g. what sort of buffer length would the
hardware have, do we need to support any kind of partial encoding, can
the hardware/driver easily take care of allowing for a margin of
error?).


The first patch adds an encode callback to the existing raw ir handler
struct and a helper function to encode a scancode for a given protocol.

The third patch implements encode for NEC. The modulation is abstracted
to use functions in patch 2 (pulse-distance is used by multiple
protocols).

Finally for debug purposes patch 4 modifies img-ir-raw to loop back the
encoded data when a filter is altered. Should be pretty easy to apply
similarly to any raw ir driver to try it out.

James Hogan (4):
  rc: ir-raw: add scancode encoder callback
  rc: ir-raw: add modulation helpers
  rc: ir-nec-decoder: add encode capability
  DEBUG: rc: img-ir: raw: Add loopback on s_filter

 drivers/media/rc/img-ir/img-ir-raw.c | 30 ++++++++++++
 drivers/media/rc/ir-nec-decoder.c    | 91 ++++++++++++++++++++++++++++++++++++
 drivers/media/rc/ir-raw.c            | 70 +++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h      | 46 ++++++++++++++++++
 include/media/rc-core.h              |  3 ++
 5 files changed, 240 insertions(+)

-- 
1.8.3.2

