Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42085 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaAMJ2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 04:28:21 -0500
Received: by mail-pa0-f45.google.com with SMTP id ld10so2868144pab.18
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 01:28:21 -0800 (PST)
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] Update the README name for libv4l
Date: Mon, 13 Jan 2014 14:58:06 +0530
Message-Id: <1389605286-19642-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

The README for libv4l was renamed from README.lib to
README.libv4l but the reference to it was not fixed.
This patch fixes the above.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 README            |    2 +-
 v4l-utils.spec.in |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/README b/README
index 0cccc00..c4f6c0c 100644
--- a/README
+++ b/README
@@ -9,7 +9,7 @@ http://git.linuxtv.org/v4l-utils.git
 v4l libraries (libv4l)
 ----------------------
 
-See README.lib for more information on libv4l, libv4l is released
+See README.libv4l for more information on libv4l, libv4l is released
 under the GNU Lesser General Public License.
 
 
diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
index 3b6aade..dd8959b 100644
--- a/v4l-utils.spec.in
+++ b/v4l-utils.spec.in
@@ -150,7 +150,7 @@ gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
 
 %files -n libv4l
 %defattr(-,root,root,-)
-%doc COPYING.LIB COPYING ChangeLog README.lib TODO
+%doc COPYING.LIB COPYING ChangeLog README.libv4l TODO
 %{_libdir}/libv4l*.so.*
 %{_libdir}/libv4l
 
-- 
1.7.9.5

