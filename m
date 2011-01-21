Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38207 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AUKWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 05:22:05 -0500
Received: by qwa26 with SMTP id 26so1623737qwa.19
        for <linux-media@vger.kernel.org>; Fri, 21 Jan 2011 02:22:03 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 21 Jan 2011 11:22:03 +0100
Message-ID: <AANLkTinT9k0XNEekzDmkqrpbAoz-YVwH=nhFzoccwOcB@mail.gmail.com>
Subject: [PATCH] Fix dependencies for Technisat USB2.0 DVB-S/S2
From: Oleg Roitburd <oroitburd@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Device is based on STV0903 demod and STV6110x tuner

Signed-off-by: Oleg Roitburd <oroitburd@gmail.com>

diff -Nur linux-media-LATEST-orig/drivers/media/dvb/dvb-usb/Kconfig
linux-media-LATEST-patched/drivers/media/dvb/dvb-usb/Kconfig
--- linux-media-LATEST-orig/drivers/media/dvb/dvb-usb/Kconfig
2011-01-11 05:45:22.000000000 +0100
+++ linux-media-LATEST-patched/drivers/media/dvb/dvb-usb/Kconfig
 2011-01-21 11:05:46.000000000 +0100
@@ -362,7 +362,7 @@
 config DVB_USB_TECHNISAT_USB2
        tristate "Technisat DVB-S/S2 USB2.0 support"
        depends on DVB_USB
-       select DVB_STB0899 if !DVB_FE_CUSTOMISE
-       select DVB_STB6100 if !DVB_FE_CUSTOMISE
+       select DVB_STV090x if !DVB_FE_CUSTOMISE
+       select DVB_STV6110x if !DVB_FE_CUSTOMISE
        help
          Say Y here to support the Technisat USB2 DVB-S/S2 device
