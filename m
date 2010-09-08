Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:47164 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab0IHHl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 03:41:59 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3/6] Input: hid-input - switch to using new keycode interface
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Date: Wed, 08 Sep 2010 00:41:55 -0700
Message-ID: <20100908074155.32365.15268.stgit@hammer.corenet.prv>
In-Reply-To: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Switch HID code to use new style of getkeycode and setkeycode
methods to allow retrieving and setting keycodes not only by
their scancodes but also by index.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/hid/hid-input.c |  103 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 6c03dcc..b12c07e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -68,39 +68,49 @@ static const struct {
 #define map_key_clear(c)	hid_map_usage_clear(hidinput, usage, &bit, \
 		&max, EV_KEY, (c))
 
-static inline int match_scancode(unsigned int code, unsigned int scancode)
+static bool match_scancode(struct hid_usage *usage,
+			   unsigned int cur_idx, unsigned int scancode)
 {
-	if (scancode == 0)
-		return 1;
-
-	return (code & (HID_USAGE_PAGE | HID_USAGE)) == scancode;
+	return (usage->hid & (HID_USAGE_PAGE | HID_USAGE)) == scancode;
 }
 
-static inline int match_keycode(unsigned int code, unsigned int keycode)
+static bool match_keycode(struct hid_usage *usage,
+			  unsigned int cur_idx, unsigned int keycode)
 {
-	if (keycode == 0)
-		return 1;
+	return usage->code == keycode;
+}
 
-	return code == keycode;
+static bool match_index(struct hid_usage *usage,
+			unsigned int cur_idx, unsigned int idx)
+{
+	return cur_idx == idx;
 }
 
+typedef bool (*hid_usage_cmp_t)(struct hid_usage *usage,
+				unsigned int cur_idx, unsigned int val);
+
 static struct hid_usage *hidinput_find_key(struct hid_device *hid,
-					   unsigned int scancode,
-					   unsigned int keycode)
+					   hid_usage_cmp_t match,
+					   unsigned int value,
+					   unsigned int *usage_idx)
 {
-	int i, j, k;
+	unsigned int i, j, k, cur_idx = 0;
 	struct hid_report *report;
 	struct hid_usage *usage;
 
 	for (k = HID_INPUT_REPORT; k <= HID_OUTPUT_REPORT; k++) {
 		list_for_each_entry(report, &hid->report_enum[k].report_list, list) {
 			for (i = 0; i < report->maxfield; i++) {
-				for ( j = 0; j < report->field[i]->maxusage; j++) {
+				for (j = 0; j < report->field[i]->maxusage; j++) {
 					usage = report->field[i]->usage + j;
-					if (usage->type == EV_KEY &&
-						match_scancode(usage->hid, scancode) &&
-						match_keycode(usage->code, keycode))
-						return usage;
+					if (usage->type == EV_KEY) {
+						if (match(usage, cur_idx, value)) {
+							if (usage_idx)
+								*usage_idx = cur_idx;
+							return usage;
+						}
+						cur_idx++;
+					}
 				}
 			}
 		}
@@ -108,39 +118,66 @@ static struct hid_usage *hidinput_find_key(struct hid_device *hid,
 	return NULL;
 }
 
+static struct hid_usage *hidinput_locate_usage(struct hid_device *hid,
+					const struct input_keymap_entry *ke,
+					unsigned int *index)
+{
+	struct hid_usage *usage;
+	unsigned int scancode;
+
+	if (ke->flags & INPUT_KEYMAP_BY_INDEX)
+		usage = hidinput_find_key(hid, match_index, ke->index, index);
+	else if (input_scancode_to_scalar(ke, &scancode) == 0)
+		usage = hidinput_find_key(hid, match_scancode, scancode, index);
+	else
+		usage = NULL;
+
+	return usage;
+}
+
 static int hidinput_getkeycode(struct input_dev *dev,
-			       unsigned int scancode, unsigned int *keycode)
+			       struct input_keymap_entry *ke)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct hid_usage *usage;
+	unsigned int scancode, index;
 
-	usage = hidinput_find_key(hid, scancode, 0);
+	usage = hidinput_locate_usage(hid, ke, &index);
 	if (usage) {
-		*keycode = usage->code;
+		ke->keycode = usage->code;
+		ke->index = index;
+		scancode = usage->hid & (HID_USAGE_PAGE | HID_USAGE);
+		ke->len = sizeof(scancode);
+		memcpy(ke->scancode, &scancode, sizeof(scancode));
 		return 0;
 	}
+
 	return -EINVAL;
 }
 
 static int hidinput_setkeycode(struct input_dev *dev,
-			       unsigned int scancode, unsigned int keycode)
+			       const struct input_keymap_entry *ke,
+			       unsigned int *old_keycode)
 {
 	struct hid_device *hid = input_get_drvdata(dev);
 	struct hid_usage *usage;
-	int old_keycode;
 
-	usage = hidinput_find_key(hid, scancode, 0);
+	usage = hidinput_locate_usage(hid, ke, NULL);
 	if (usage) {
-		old_keycode = usage->code;
-		usage->code = keycode;
+		*old_keycode = usage->code;
+		usage->code = ke->keycode;
 
-		clear_bit(old_keycode, dev->keybit);
+		clear_bit(*old_keycode, dev->keybit);
 		set_bit(usage->code, dev->keybit);
-		dbg_hid(KERN_DEBUG "Assigned keycode %d to HID usage code %x\n", keycode, scancode);
-		/* Set the keybit for the old keycode if the old keycode is used
-		 * by another key */
-		if (hidinput_find_key (hid, 0, old_keycode))
-			set_bit(old_keycode, dev->keybit);
+		dbg_hid(KERN_DEBUG "Assigned keycode %d to HID usage code %x\n",
+			usage->code, usage->hid);
+
+		/*
+		 * Set the keybit for the old keycode if the old keycode is used
+		 * by another key
+		 */
+		if (hidinput_find_key(hid, match_keycode, *old_keycode, NULL))
+			set_bit(*old_keycode, dev->keybit);
 
 		return 0;
 	}
@@ -748,8 +785,8 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 					hid->ll_driver->hidinput_input_event;
 				input_dev->open = hidinput_open;
 				input_dev->close = hidinput_close;
-				input_dev->setkeycode = hidinput_setkeycode;
-				input_dev->getkeycode = hidinput_getkeycode;
+				input_dev->setkeycode_new = hidinput_setkeycode;
+				input_dev->getkeycode_new = hidinput_getkeycode;
 
 				input_dev->name = hid->name;
 				input_dev->phys = hid->phys;

