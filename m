Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47331 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbeJRT1x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 15:27:53 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Benjamin Valentin <benpicco@googlemail.com>
Subject: [PATCH v4l-utils] keytable: bpf decoder and keymap for XBox DVD Remote
Date: Thu, 18 Oct 2018 12:27:16 +0100
Message-Id: <20181018112717.8361-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This uses a modified nec protocol, where 24 bits are sent and the first
12 bits are inverted.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/bpf_protocols/Makefile.am      |   2 +-
 utils/keytable/bpf_protocols/xbox.c           | 129 ++++++++++++++++++
 .../rc_keymaps_userspace/xbox_dvd.toml        |  31 +++++
 3 files changed, 161 insertions(+), 1 deletion(-)
 create mode 100644 utils/keytable/bpf_protocols/xbox.c
 create mode 100644 utils/keytable/rc_keymaps_userspace/xbox_dvd.toml

diff --git a/utils/keytable/bpf_protocols/Makefile.am b/utils/keytable/bpf_protocols/Makefile.am
index 8887b897..2d005b1f 100644
--- a/utils/keytable/bpf_protocols/Makefile.am
+++ b/utils/keytable/bpf_protocols/Makefile.am
@@ -10,7 +10,7 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
 %.o: %.c bpf_helpers.h
 	$(CLANG) $(CLANG_SYS_INCLUDES) -I$(top_srcdir)/include -target bpf -O2 -c $<
 
-PROTOCOLS = grundig.o pulse_distance.o pulse_length.o rc_mm.o manchester.o
+PROTOCOLS = grundig.o pulse_distance.o pulse_length.o rc_mm.o manchester.o xbox.o
 
 all: $(PROTOCOLS)
 
diff --git a/utils/keytable/bpf_protocols/xbox.c b/utils/keytable/bpf_protocols/xbox.c
new file mode 100644
index 00000000..e48e0a79
--- /dev/null
+++ b/utils/keytable/bpf_protocols/xbox.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0+
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+#include <linux/lirc.h>
+#include <linux/bpf.h>
+
+#include "bpf_helpers.h"
+
+enum state {
+	STATE_INACTIVE,
+	STATE_HEADER_SPACE,
+	STATE_BITS_SPACE,
+	STATE_BITS_PULSE,
+	STATE_TRAILER,
+};
+
+struct decoder_state {
+	unsigned long bits;
+	enum state state;
+	unsigned int count;
+};
+
+struct bpf_map_def SEC("maps") decoder_state_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(unsigned int),
+	.value_size = sizeof(struct decoder_state),
+	.max_entries = 1,
+};
+
+// These values can be overridden in the rc_keymap toml
+//
+// We abuse elf relocations. We cast the address of these variables to
+// an int, so that the compiler emits a mov immediate for the address
+// but uses it as an int. The bpf loader replaces the relocation with the
+// actual value (either overridden or taken from the data segment).
+int margin = 200;
+int header_pulse = 4000;
+int header_space = 3900;
+int bit_pulse = 550;
+int bit_0_space = 900;
+int bit_1_space = 1900;
+int trailer_pulse = 550;
+int bits = 24;
+int rc_protocol = 68;
+
+#define BPF_PARAM(x) (int)(&(x))
+
+static inline int eq_margin(unsigned d1, unsigned d2)
+{
+	return ((d1 > (d2 - BPF_PARAM(margin))) && (d1 < (d2 + BPF_PARAM(margin))));
+}
+
+SEC("xbox")
+int bpf_decoder(unsigned int *sample)
+{
+	unsigned int key = 0;
+	struct decoder_state *s = bpf_map_lookup_elem(&decoder_state_map, &key);
+
+	if (!s)
+		return 0;
+
+	switch (*sample & LIRC_MODE2_MASK) {
+	case LIRC_MODE2_SPACE:
+	case LIRC_MODE2_PULSE:
+	case LIRC_MODE2_TIMEOUT:
+		break;
+	default:
+		// not a timing events
+		return 0;
+	}
+
+	int duration = LIRC_VALUE(*sample);
+	int pulse = LIRC_IS_PULSE(*sample);
+
+	switch (s->state) {
+	case STATE_HEADER_SPACE:
+		if (!pulse && eq_margin(BPF_PARAM(header_space), duration))
+			s->state = STATE_BITS_PULSE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_INACTIVE:
+		if (pulse && eq_margin(BPF_PARAM(header_pulse), duration)) {
+			s->bits = 0;
+			s->state = STATE_HEADER_SPACE;
+			s->count = 0;
+		}
+		break;
+	case STATE_BITS_PULSE:
+		if (pulse && eq_margin(BPF_PARAM(bit_pulse), duration))
+			s->state = STATE_BITS_SPACE;
+		else
+			s->state = STATE_INACTIVE;
+		break;
+	case STATE_BITS_SPACE:
+		if (pulse) {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		s->bits <<= 1;
+
+		if (eq_margin(BPF_PARAM(bit_1_space), duration))
+			s->bits |= 1;
+		else if (!eq_margin(BPF_PARAM(bit_0_space), duration)) {
+			s->state = STATE_INACTIVE;
+			break;
+		}
+
+		s->count++;
+		if (s->count == BPF_PARAM(bits))
+			s->state = STATE_TRAILER;
+		else
+			s->state = STATE_BITS_PULSE;
+		break;
+	case STATE_TRAILER:
+		if (pulse && eq_margin(BPF_PARAM(trailer_pulse), duration)) {
+			if (((s->bits >> 12) ^ (s->bits & 0xfff)) == 0xfff)
+				bpf_rc_keydown(sample, BPF_PARAM(rc_protocol), s->bits & 0xfff, 0);
+		}
+
+		s->state = STATE_INACTIVE;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/utils/keytable/rc_keymaps_userspace/xbox_dvd.toml b/utils/keytable/rc_keymaps_userspace/xbox_dvd.toml
new file mode 100644
index 00000000..4f86c73c
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/xbox_dvd.toml
@@ -0,0 +1,31 @@
+[[protocols]]
+name = 'XBox DVD'
+protocol = 'xbox'
+[protocols.scancodes]
+0xad5 = 'KEY_ANGLE'
+0xae2 = 'KEY_REWIND'
+0xaea = 'KEY_PLAY'
+0xae3 = 'KEY_FORWARD'
+0xadd = 'KEY_PREVIOUSSONG'
+0xae0 = 'KEY_STOP'
+0xae6 = 'KEY_PAUSE'
+0xadf = 'KEY_NEXTSONG'
+0xae5 = 'KEY_TITLE'
+0xac3 = 'KEY_INFO'
+0xaa6 = 'KEY_UP'
+0xaa9 = 'KEY_LEFT'
+0xaa8 = 'KEY_RIGHT'
+0xaa7 = 'KEY_DOWN'
+0xa0b = 'KEY_SELECT'
+0xaf7 = 'KEY_MENU'
+0xad8 = 'KEY_BACK'
+0xace = 'KEY_1'
+0xacd = 'KEY_2'
+0xacc = 'KEY_3'
+0xacb = 'KEY_4'
+0xaca = 'KEY_5'
+0xac9 = 'KEY_6'
+0xac8 = 'KEY_7'
+0xac7 = 'KEY_8'
+0xac6 = 'KEY_9'
+0xacf = 'KEY_0'
-- 
2.17.2
