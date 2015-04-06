Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36509 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbbDFL0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 07:26:32 -0400
Subject: [PATCH 0/4] Add protocol support to ir-keytable
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 06 Apr 2015 13:25:58 +0200
Message-ID: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series adds support to ir-keytable for explicitly
setting the protocol of scancode<->keycode mappings (requires
a patched kernel).

The first three patches are cleanups and refactoring which are
probably worthwhile to apply in any case.

The fourth patch adds the actual support (backward compatible) for
set-key and reading the keytable. Separate patches would be necessary
to also support reading keytable files with protocol information.

---

David Härdeman (4):
      ir-keytable: clarify the meaning of ir protocols
      ir-keytable: replace more sysfs if-else code with loops
      ir-keytable: cleanup keytable code
      ir-keytable: allow protocol for scancode-keycode mappings


 utils/keytable/keytable.c |  716 +++++++++++++++++++++++----------------------
 1 file changed, 364 insertions(+), 352 deletions(-)

--
David Härdeman
