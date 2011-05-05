Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1EECZS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 22:25:18 -0400
Message-ID: <4DC20A86.7010509@redhat.com>
Date: Wed, 04 May 2011 23:25:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix cx88 remote control input
References: <1302267045.1749.38.camel@gagarin> <4DBEFD02.70906@redhat.com> <1304407514.1739.22.camel@gagarin> <D7FAB30A-E204-47B9-A7A0-E3BF50EE7FBD@wilsonet.com> <4DC1B41D.9090200@redhat.com> <20110504203613.GA1091@kroah.com>
In-Reply-To: <20110504203613.GA1091@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-05-2011 17:36, Greg KH escreveu:
> Yes, as long as .39 is working properly.  We take patches in -stable for
> stuff like this at times, it just needs to be specified exactly like you
> did above.

OK.

> Want me to take this patch as-is for .38-stable?

Yes, please. I'm forwarding you bellow with the proper authorship/SOB/ack.

This patch fixes RC for 64 bits kernels. The extra fix for 32 bits kernels,
(solves a calculus overflow), were sent today to -next. I generally wait 
for a couple days before asking Linus to pull from it.

-

Subject: [media] cx88: Fix HVR4000 IR keymap
From: Lawrence Rust <lvr@softsystem.dot.uk>

Fixes the RC key input for Nova-S plus, HVR1100, HVR3000 and HVR4000 in 
the 2.6.38 kernel.

Signed-off-by: Lawrence Rust <lvr@softsystem.dot.uk>
Acked-by: Jarod Wilson <jarod@wilsonet.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 06f7d1d..67a2b08 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -283,7 +283,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PCHDTV_HD3000:
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:


