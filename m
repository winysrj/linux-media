Return-path: <mchehab@pedra>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1CJWla (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 17:41:30 -0500
Subject: [PATCH] saa7134: Fix strange kconfig dependency on RC_CORE
From: Steven Rostedt <rostedt@goodmis.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	Michal Marek <mmarek@suse.cz>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D7918E5.4090104@redhat.com>
References: <1299778653.15854.370.camel@gandalf.stny.rr.com>
	 <4D7918E5.4090104@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 17:41:29 -0500
Message-ID: <1299796889.15854.447.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As the code in saa7134-input is not a module, but the config for it is
set as a boolean instead of a tristate, this causes a strange dependency
on RC_CORE.

VIDEO_SAA7134_RC (which determines if saa7134-input.o is built) depends
on RC_CORE and VIDEO_SAA7134. If VIDEO_SAA7134 is compiled as 'y' but
RC_CORE is compiled as 'm' VIDEO_SAA7134_RC can still be set to 'y'
which causes undefined symbols that it needs from RC_CORE.

The simplest solution is to not allow VIDEO_SAA7134_RC be enabled if
RC_CORE compiled as a module (m) and VIDEO_SA7134 is compiled into the
kernel (y).

Suggested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 drivers/media/video/saa7134/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-test.git/drivers/media/video/saa7134/Kconfig
===================================================================
--- linux-test.git.orig/drivers/media/video/saa7134/Kconfig	2011-03-07 22:01:13.046263327 -0500
+++ linux-test.git/drivers/media/video/saa7134/Kconfig	2011-03-10 16:18:26.426709736 -0500
@@ -28,6 +28,7 @@ config VIDEO_SAA7134_RC
 	bool "Philips SAA7134 Remote Controller support"
 	depends on RC_CORE
 	depends on VIDEO_SAA7134
+	depends on !(RC_CORE=m && VIDEO_SAA7134=y)
 	default y
 	---help---
 	  Enables Remote Controller support on saa7134 driver.


