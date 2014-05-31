Return-path: <linux-media-owner@vger.kernel.org>
Received: from serv03.imset.org ([176.31.106.97]:60134 "EHLO serv03.imset.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaEaIq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 04:46:28 -0400
Message-ID: <538994CB.6020205@dest-unreach.be>
Date: Sat, 31 May 2014 10:37:31 +0200
From: Niels Laukens <niels@dest-unreach.be>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
CC: James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	=?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
Subject: [BUG & PATCH] media/rc/ir-nec-decode : phantom keypress
Content-Type: multipart/mixed;
 boundary="------------060904080905060703040906"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060904080905060703040906
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

I believe I've found a bug in the NEC decoder for InfraRed remote
controls. The problem manifests itself as an extra keypress that happens
when pushing different buttons in "rapid" succession.

I can reproduce the problem easily (but not always) by pushing DOWN, DOWN,
UP in "rapid" succession. I put "rapid" in quotes, because I don't have to
hurry in any way, it happens when I use it normally. Depending on the
duration of the presses, I get a number of repeats of DOWN. The bug is
that an additional DOWN keypress happens at the time that I press the UP
key (or so it seams).

Attached is kernel-debug.log, which contains the redacted and annotated
dmesg output, illustrating the problem described above. Especially note
lines 31-36 and 54-59, where more than 200ms pass between the end of the
IR-code and the actual emit of the keydown event.


I've debugged this issue, and believe I've found the cause: The keypress
is only emitted in state 5 (STATE_TRAILER_SPACE). This state is only
executed when the space after the message is received, i.e. when the
next pulse (of the next message) starts. It is only then that the length
of the space is known, and that ir_raw_event will fire an event.

The patch below addresses this issue. This is my first kernel patch.
I've tried to follow all guidelines that I could find, but might have
missed a few.

I've tested this patch with the out-of-tree TBS drivers (which seem to
be based on 3.13), and it solves the bug.
I've compared this TBS-version with the current master (1487385). There
are 8 (non-comment) lines that differ, none affect this patch. This
patch applies cleanly to the current master.

Regards,
Niels




>From 071c316e9315f22a055d6713cc8cdcdc73642193 Mon Sep 17 00:00:00 2001
From: Niels Laukens <niels@dest-unreach.be>
Date: Sat, 31 May 2014 10:30:18 +0200
Subject: [PATCH] drivers/media/rc/ir-nec-decode: fix phantom detect

The IR NEC decoder waited until the TRAILER_SPACE state to emit a
keypress. Since the triggering 'space' event will only be sent at the
beginning of the *next* IR-code, this is way to late.

This patch moves the processing to the TRAILER_PULSE state. Since we
arrived here with a 'pulse' event, we know that the pulse has ended and
thus that the space is there (as of yet with unknown length).

Signed-off-by: Niels Laukens <niels@dest-unreach.be>
---
 drivers/media/rc/ir-nec-decoder.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 35c42e5..955f99d 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -148,16 +148,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT / 2))
 			break;
 
-		data->state = STATE_TRAILER_SPACE;
-		return 0;
-
-	case STATE_TRAILER_SPACE:
-		if (ev.pulse)
-			break;
-
-		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
-			break;
-
 		address     = bitrev8((data->bits >> 24) & 0xff);
 		not_address = bitrev8((data->bits >> 16) & 0xff);
 		command	    = bitrev8((data->bits >>  8) & 0xff);
@@ -190,6 +180,16 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->necx_repeat = true;
 
 		rc_keydown(dev, scancode, 0);
+		data->state = STATE_TRAILER_SPACE;
+		return 0;
+
+	case STATE_TRAILER_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
+			break;
+
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
-- 
1.8.5.2 (Apple Git-48)



--------------060904080905060703040906
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="kernel-debug.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="kernel-debug.log"

WyAgNTg3LjkzNjI5M10gaXJfbmVjX2RlY29kZTogTkVDIGRlY29kZSBzdGFydGVkIGF0IHN0
YXRlIDAgKDkwNzh1cyBwdWxzZSkKWyAgNTg3LjkzNjI5OF0gaXJfbmVjX2RlY29kZTogTkVD
IGRlY29kZSBzdGFydGVkIGF0IHN0YXRlIDEgKDQ0NDF1cyBzcGFjZSkKWyAgNTg3Ljk1MjI5
OV0gaXJfbmVjX2RlY29kZTogTkVDIGRlY29kZSBzdGFydGVkIGF0IHN0YXRlIDIgKDYyN3Vz
IHB1bHNlKQpbICA1ODcuOTUyMzA0XSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0
ZWQgYXQgc3RhdGUgMyAoNTA0dXMgc3BhY2UpCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIC4uLiBtb3JlIHN0YXRlcyAyfHwzIC4uLgpbICA1ODguMDAwMzUxXSBpcl9uZWNfZGVj
b2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUgMiAoNjI1dXMgcHVsc2UpClsgIDU4
OC4wMDAzNTNdIGlyX25lY19kZWNvZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSAz
ICg1MDN1cyBzcGFjZSkKWyAgNTg4LjAwMDM1NV0gaXJfbmVjX2RlY29kZTogTkVDIGRlY29k
ZSBzdGFydGVkIGF0IHN0YXRlIDQgKDYyM3VzIHB1bHNlKQpbICA1ODguMDQ0Mzc5XSBpcl9u
ZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUgNSAoMzk2ODR1cyBzcGFj
ZSkKWyAgNTg4LjA0NDM4M10gaXJfbmVjX2RlY29kZTogTkVDIHNjYW5jb2RlIDB4MDA4OApb
ICA1ODguMDQ0Mzg2XSByY19nX2tleWNvZGVfZnJvbV90YWJsZTogc2FhNzE2eCBJUiAoVHVy
Ym9TaWdodCBUQlMgNjI4MSk6IHNjYW5jb2RlIDB4MDA4OCBrZXljb2RlIDB4NmMKWyAgNTg4
LjA0NDM5NF0gaXJfZG9fa2V5ZG93bjogc2FhNzE2eCBJUiAoVHVyYm9TaWdodCBUQlMgNjI4
MSk6IGtleSBkb3duIGV2ZW50LCBrZXkgMHgwMDZjLCBzY2FuY29kZSAweDAwODgKCgpbICA1
ODguMDQ0NDIwXSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUg
MCAoOTA4MHVzIHB1bHNlKQpbICA1ODguMDQ0NDIyXSBpcl9uZWNfZGVjb2RlOiBORUMgZGVj
b2RlIHN0YXJ0ZWQgYXQgc3RhdGUgMSAoMjE4NHVzIHNwYWNlKQpbICA1ODguMDQ0NDI2XSBp
cl9uZWNfZGVjb2RlOiBSZXBlYXQgbGFzdCBrZXkKWyAgNTg4LjA0NDQyOF0gaXJfbmVjX2Rl
Y29kZTogTkVDIGRlY29kZSBzdGFydGVkIGF0IHN0YXRlIDQgKDYyNXVzIHB1bHNlKQpbICA1
ODguMTUyNTU2XSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUg
NSAoOTY0MjF1cyBzcGFjZSkKWyAgNTg4LjE1MjU1OV0gaXJfbmVjX2RlY29kZTogTkVDIHNj
YW5jb2RlIDB4MDA4OApbICA1ODguMTUyNTYxXSByY19nX2tleWNvZGVfZnJvbV90YWJsZTog
c2FhNzE2eCBJUiAoVHVyYm9TaWdodCBUQlMgNjI4MSk6IHNjYW5jb2RlIDB4MDA4OCBrZXlj
b2RlIDB4NmMKCgpbICA1ODguMjYwNTcxXSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0
YXJ0ZWQgYXQgc3RhdGUgMCAoOTA3OHVzIHB1bHNlKQpbICA1ODguMjc2NTc3XSBpcl9uZWNf
ZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUgMSAoNDQ0MHVzIHNwYWNlKQpb
ICA1ODguMjc2NTgzXSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3Rh
dGUgMiAoNjI3dXMgcHVsc2UpClsgIDU4OC4yNzY1ODddIGlyX25lY19kZWNvZGU6IE5FQyBk
ZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSAzICg1MDR1cyBzcGFjZSkKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgLi4uIG1vcmUgc3RhdGVzIDJ8fDMgLi4uClsgIDU4OC4zMjQ2MzJd
IGlyX25lY19kZWNvZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSAyICg2MjV1cyBw
dWxzZSkKWyAgNTg4LjMyNDYzNF0gaXJfbmVjX2RlY29kZTogTkVDIGRlY29kZSBzdGFydGVk
IGF0IHN0YXRlIDMgKDUwNXVzIHNwYWNlKQpbICA1ODguMzI0NjM2XSBpcl9uZWNfZGVjb2Rl
OiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUgNCAoNjI0dXMgcHVsc2UpClsgIDU4OC40
MDQ2NTZdIGlyX2RvX2tleXVwOiBrZXl1cCBrZXkgMHgwMDZjClsgIDU4OC41Njg4MzNdIGly
X25lY19kZWNvZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSA1ICgyNDA1NTB1cyBz
cGFjZSkKWyAgNTg4LjU2ODgzN10gaXJfbmVjX2RlY29kZTogTkVDIHNjYW5jb2RlIDB4MDA4
OApbICA1ODguNTY4ODQwXSByY19nX2tleWNvZGVfZnJvbV90YWJsZTogc2FhNzE2eCBJUiAo
VHVyYm9TaWdodCBUQlMgNjI4MSk6IHNjYW5jb2RlIDB4MDA4OCBrZXljb2RlIDB4NmMKWyAg
NTg4LjU2ODg0M10gaXJfZG9fa2V5ZG93bjogc2FhNzE2eCBJUiAoVHVyYm9TaWdodCBUQlMg
NjI4MSk6IGtleSBkb3duIGV2ZW50LCBrZXkgMHgwMDZjLCBzY2FuY29kZSAweDAwODgKCgpb
ICA1ODguNTY4ODYzXSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3Rh
dGUgMCAoOTA3NnVzIHB1bHNlKQpbICA1ODguNTg0ODQ4XSBpcl9uZWNfZGVjb2RlOiBORUMg
ZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUgMSAoNDQ0NXVzIHNwYWNlKQpbICA1ODguNTg0ODUz
XSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUgMiAoNjIxdXMg
cHVsc2UpClsgIDU4OC41ODQ4NTVdIGlyX25lY19kZWNvZGU6IE5FQyBkZWNvZGUgc3RhcnRl
ZCBhdCBzdGF0ZSAzICg1MDd1cyBzcGFjZSkKICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLi4uIG1vcmUgc3RhdGVzIDJ8fDMgLi4uClsgIDU4OC42MzI5MjddIGlyX25lY19kZWNv
ZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSAyICg2MjF1cyBwdWxzZSkKWyAgNTg4
LjYzMjkyOF0gaXJfbmVjX2RlY29kZTogTkVDIGRlY29kZSBzdGFydGVkIGF0IHN0YXRlIDMg
KDUwOXVzIHNwYWNlKQpbICA1ODguNjMyOTMwXSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2Rl
IHN0YXJ0ZWQgYXQgc3RhdGUgNCAoNjIwdXMgcHVsc2UpClsgIDU4OC42NzY5MjddIGlyX25l
Y19kZWNvZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSA1ICgzOTY4M3VzIHNwYWNl
KQpbICA1ODguNjc2OTMxXSBpcl9uZWNfZGVjb2RlOiBORUMgc2NhbmNvZGUgMHgwMDg4Clsg
IDU4OC42NzY5MzhdIHJjX2dfa2V5Y29kZV9mcm9tX3RhYmxlOiBzYWE3MTZ4IElSIChUdXJi
b1NpZ2h0IFRCUyA2MjgxKTogc2NhbmNvZGUgMHgwMDg4IGtleWNvZGUgMHg2YwoKWyAgNTg4
LjY3Njk2M10gaXJfbmVjX2RlY29kZTogTkVDIGRlY29kZSBzdGFydGVkIGF0IHN0YXRlIDAg
KDkwNDh1cyBwdWxzZSkKWyAgNTg4LjY3Njk2Nl0gaXJfbmVjX2RlY29kZTogTkVDIGRlY29k
ZSBzdGFydGVkIGF0IHN0YXRlIDEgKDIyMTJ1cyBzcGFjZSkKWyAgNTg4LjY3Njk3MF0gaXJf
bmVjX2RlY29kZTogUmVwZWF0IGxhc3Qga2V5ClsgIDU4OC42NzY5NzJdIGlyX25lY19kZWNv
ZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSA0ICg1OTd1cyBwdWxzZSkKWyAgNTg4
LjkyOTExMl0gaXJfZG9fa2V5dXA6IGtleXVwIGtleSAweDAwNmMKWyAgNTg4Ljk0OTE2Ml0g
aXJfbmVjX2RlY29kZTogTkVDIGRlY29kZSBzdGFydGVkIGF0IHN0YXRlIDUgKDI2MDMzOHVz
IHNwYWNlKQpbICA1ODguOTQ5MTY2XSBpcl9uZWNfZGVjb2RlOiBORUMgc2NhbmNvZGUgMHgw
MDg4ClsgIDU4OC45NDkxNjldIHJjX2dfa2V5Y29kZV9mcm9tX3RhYmxlOiBzYWE3MTZ4IElS
IChUdXJib1NpZ2h0IFRCUyA2MjgxKTogc2NhbmNvZGUgMHgwMDg4IGtleWNvZGUgMHg2Ywpb
ICA1ODguOTQ5MTcyXSBpcl9kb19rZXlkb3duOiBzYWE3MTZ4IElSIChUdXJib1NpZ2h0IFRC
UyA2MjgxKToga2V5IGRvd24gZXZlbnQsIGtleSAweDAwNmMsIHNjYW5jb2RlIDB4MDA4OAoK
ClsgIDU4OC45NDkxOTJdIGlyX25lY19kZWNvZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBz
dGF0ZSAwICg5MDE0dXMgcHVsc2UpClsgIDU4OC45NjUxNzddIGlyX25lY19kZWNvZGU6IE5F
QyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSAxICg0NTA5dXMgc3BhY2UpClsgIDU4OC45NjUx
ODNdIGlyX25lY19kZWNvZGU6IE5FQyBkZWNvZGUgc3RhcnRlZCBhdCBzdGF0ZSAyICg1ODJ1
cyBwdWxzZSkKWyAgNTg4Ljk2NTE4N10gaXJfbmVjX2RlY29kZTogTkVDIGRlY29kZSBzdGFy
dGVkIGF0IHN0YXRlIDMgKDU3MXVzIHNwYWNlKQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAuLi4gbW9yZSBzdGF0ZXMgMnx8MyAuLi4KWyAgNTg5LjAxMzI2MV0gaXJfbmVjX2Rl
Y29kZTogTkVDIGRlY29kZSBzdGFydGVkIGF0IHN0YXRlIDIgKDU5NHVzIHB1bHNlKQpbICA1
ODkuMDEzMjYzXSBpcl9uZWNfZGVjb2RlOiBORUMgZGVjb2RlIHN0YXJ0ZWQgYXQgc3RhdGUg
MyAoNTM0dXMgc3BhY2UpClsgIDU4OS4wMTMyNjVdIGlyX25lY19kZWNvZGU6IE5FQyBkZWNv
ZGUgc3RhcnRlZCBhdCBzdGF0ZSA0ICg1OTZ1cyBwdWxzZSkKWyAgNTg5LjIwMTM0OF0gaXJf
ZG9fa2V5dXA6IGtleXVwIGtleSAweDAwNmMK
--------------060904080905060703040906--
