Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:54230 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADMfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 07:35:00 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 667F8CA94A2
	for <linux-media@vger.kernel.org>; Sun,  4 Jan 2015 13:27:46 +0100 (CET)
From: Romain Naour <romain.naour@openwide.fr>
To: linux-media@vger.kernel.org
Cc: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
Subject: [PATCH 1/3] Fix generate-keynames.sh script for cross-compilation
Date: Sun,  4 Jan 2015 13:27:35 +0100
Message-Id: <1420374457-8633-2-git-send-email-romain.naour@openwide.fr>
In-Reply-To: <1420374457-8633-1-git-send-email-romain.naour@openwide.fr>
References: <1420374457-8633-1-git-send-email-romain.naour@openwide.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>

generate-keynames.sh reads /usr/include/linux to find the keyname
symbols. However, when cross-compiling, the include path points
somewhere else. Allow the user to pass CROSS_ROOT to point to the
root of the cross-compilation environment.

Signed-off-by: Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
---
 util/av7110_loadkeys/generate-keynames.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/util/av7110_loadkeys/generate-keynames.sh b/util/av7110_loadkeys/generate-keynames.sh
index 49d2b71..cb8f5c5 100644
--- a/util/av7110_loadkeys/generate-keynames.sh
+++ b/util/av7110_loadkeys/generate-keynames.sh
@@ -18,7 +18,7 @@ echo "};" >> $1
 echo >> $1
 echo >> $1
 echo "static struct input_key_name key_name [] = {" >> $1
-for x in $(cat /usr/include/linux/input.h input_fake.h | \
+for x in $(cat ${CROSS_ROOT}/usr/include/linux/input.h input_fake.h | \
            egrep "#define[ \t]+KEY_" | grep -v KEY_MAX | \
            cut -f 1 | cut -f 2 -d " " | sort -u) ; do
     echo "        { \"$(echo $x | cut -b 5-)\", $x }," >> $1
@@ -26,7 +26,7 @@ done
 echo "};" >> $1
 echo >> $1
 echo "static struct input_key_name btn_name [] = {" >> $1
-for x in $(cat /usr/include/linux/input.h input_fake.h | \
+for x in $(cat ${CROSS_ROOT}/usr/include/linux/input.h input_fake.h | \
            egrep "#define[ \t]+BTN_" | \
            cut -f 1 | cut -f 2 -d " " | sort -u) ; do
      echo "        { \"$(echo $x | cut -b 5-)\", $x }," >> $1
-- 
1.9.3

