Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:33933 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754998AbcIUJyZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 05:54:25 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] v4l-utils: report rc protocol while testing
Date: Wed, 21 Sep 2016 10:54:23 +0100
Message-Id: <1474451663-29027-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you have a remote and want to see what protocol it uses, simply run
the following. That's enough to write a new keymap.

./ir-keytable  -p rc-5,nec,rc-6,jvc,sony,sanyo,sharp,xmp -t
Testing events. Please, press CTRL-C to abort.
1474415431.689685: event type EV_MSC(0x04): protocol = RC_TYPE_RC6_MCE
1474415431.689685: event type EV_MSC(0x04): scancode = 0x800f040e
1474415431.689685: event type EV_SYN(0x00).
1474415443.857071: event type EV_MSC(0x04): protocol = RC_TYPE_RC5
1474415443.857071: event type EV_MSC(0x04): scancode = 0x1e0f
1474415443.857071: event type EV_SYN(0x00).

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/Makefile.am |  7 +++++++
 utils/keytable/keytable.c  |  6 ++++++
 utils/keytable/parse.h     | 26 ++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 62b90ad..73cd676 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -59,6 +59,13 @@ sync-with-kernel:
 	>> $(srcdir)/parse.h
 	@printf "\t{ NULL, 0}\n};\n" >> $(srcdir)/parse.h
 
+	@printf "struct parse_event rc_type_events[] = {\n" >> $(srcdir)/parse.h
+	@more $(KERNEL_DIR)/usr/include/linux/input-event-codes.h | perl -n \
+	-e 'if (m/^\#define\s+(RC_TYPE_[^\s]+)\s+(0x[\d\w]+|[\d]+)/) ' \
+	-e '{ printf "\t{\"%s\", %s},\n",$$1,$$2; }' \
+	>> $(srcdir)/parse.h
+	@printf "\t{ NULL, 0}\n};\n" >> $(srcdir)/parse.h
+
 	@-mkdir -p $(srcdir)/rc_keymaps
 	@-rm $(srcdir)/rc_keymaps/*
 	@-cp $(srcdir)/rc_keymaps_userspace/* $(srcdir)/rc_keymaps/
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 3922ad2..d4c295b 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -55,6 +55,10 @@ struct input_keymap_entry_v2 {
 #define EVIOCSKEYCODE_V2	_IOW('E', 0x04, struct input_keymap_entry_v2)
 #endif
 
+#ifndef MSC_RC_TYPE
+#define MSC_RC_TYPE 6
+#endif
+
 struct keytable_entry {
 	u_int32_t scancode;
 	u_int32_t keycode;
@@ -1294,6 +1298,8 @@ static void test_event(int fd)
 			case EV_MSC:
 				if (ev[i].code == MSC_SCAN)
 					printf(_(": scancode = 0x%02x\n"), ev[i].value);
+				else if (ev[i].code == MSC_RC_TYPE)
+					printf(_(": protocol = %s\n"), get_event_name(rc_type_events, ev[i].value));
 				else
 					printf(_(": code = %s(0x%02x), value = %d\n"),
 						get_event_name(msc_events, ev[i].code),
diff --git a/utils/keytable/parse.h b/utils/keytable/parse.h
index 67eb1a6..10f58ef 100644
--- a/utils/keytable/parse.h
+++ b/utils/keytable/parse.h
@@ -25,6 +25,7 @@ struct parse_event msc_events[] = {
 	{"MSC_RAW", 0x03},
 	{"MSC_SCAN", 0x04},
 	{"MSC_TIMESTAMP", 0x05},
+	{"MSC_RC_TYPE", 0x06},
 	{"MSC_MAX", 0x07},
 	{ NULL, 0}
 };
@@ -639,3 +640,28 @@ struct parse_event abs_events[] = {
 	{"ABS_MAX", 0x3f},
 	{ NULL, 0}
 };
+struct parse_event rc_type_events[] = {
+	{"RC_TYPE_UNKNOWN", 0},
+	{"RC_TYPE_OTHER", 1},
+	{"RC_TYPE_RC5", 2},
+	{"RC_TYPE_RC5X", 3},
+	{"RC_TYPE_RC5_SZ", 4},
+	{"RC_TYPE_JVC", 5},
+	{"RC_TYPE_SONY12", 6},
+	{"RC_TYPE_SONY15", 7},
+	{"RC_TYPE_SONY20", 8},
+	{"RC_TYPE_NEC", 9},
+	{"RC_TYPE_NECX", 10},
+	{"RC_TYPE_NEC32", 11},
+	{"RC_TYPE_SANYO", 12},
+	{"RC_TYPE_MCE_KBD", 13},
+	{"RC_TYPE_RC6_0", 14},
+	{"RC_TYPE_RC6_6A_20", 15},
+	{"RC_TYPE_RC6_6A_24", 16},
+	{"RC_TYPE_RC6_6A_32", 17},
+	{"RC_TYPE_RC6_MCE", 18},
+	{"RC_TYPE_SHARP", 19},
+	{"RC_TYPE_XMP", 20},
+	{"RC_TYPE_CEC", 21},
+	{ NULL, 0}
+};
-- 
2.7.4

