Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55651 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751242AbdHFI45 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Aug 2017 04:56:57 -0400
Date: Sun, 6 Aug 2017 09:56:55 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] keytable: ensure udev rule fires on rc input device
Message-ID: <20170806085655.dkaq7hqpyzrc3abj@gofer.mess.org>
References: <20170717092038.3e7jbjtx7htu3lda@camel2.lan>
 <20170805213802.ni42iaht5rf5rye2@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170805213802.ni42iaht5rf5rye2@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rc device is created before the input device, so if ir-keytable runs
too early the input device does not exist yet.

Ensure that rule fires on creation of a rc device's input device.

Note that this also prevents udev from starting ir-keytable on an
transmit only device, which has no input device.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/70-infrared.rules | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Matthias, can I have your Signed-off-by please? Thank you.


diff --git a/utils/keytable/70-infrared.rules b/utils/keytable/70-infrared.rules
index afffd951..b3531727 100644
--- a/utils/keytable/70-infrared.rules
+++ b/utils/keytable/70-infrared.rules
@@ -1,4 +1,12 @@
 # Automatically load the proper keymaps after the Remote Controller device
 # creation.  The keycode tables rules should be at /etc/rc_maps.cfg
 
-ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"
+ACTION!="add", SUBSYSTEMS!="rc", GOTO="rc_dev_end"
+
+SUBSYSTEM=="rc", ENV{rc_sysdev}="$name"
+
+SUBSYSTEM=="input", IMPORT{parent}="rc_sysdev"
+
+KERNEL=="event[0-9]*", ENV{rc_sysdev}=="?*", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $env{rc_sysdev}"
+
+LABEL="rc_dev_end"
-- 
2.11.0
