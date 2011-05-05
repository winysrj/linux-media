Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:38839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1EEVJ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 17:09:56 -0400
Subject: Patch "[media] cx88: Fix HVR4000 IR keymap" has been added to the 2.6.38-stable tree
To: lvr@softsystem.dot.uk, greg@kroah.com, jarod@wilsonet.com,
	lawrence@softsystem.co.uk, linux-media@vger.kernel.org,
	mchehab@redhat.com
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Thu, 05 May 2011 14:08:39 -0700
In-Reply-To: <4DC20A86.7010509@redhat.com>
Message-ID: <1304629719470@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


This is a note to let you know that I've just added the patch titled

    [media] cx88: Fix HVR4000 IR keymap

to the 2.6.38-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     cx88-fix-hvr4000-ir-keymap.patch
and it can be found in the queue-2.6.38 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@kernel.org> know about it.


>From mchehab@redhat.com  Thu May  5 13:34:25 2011
From: Lawrence Rust <lvr@softsystem.dot.uk>
Date: Wed, 04 May 2011 23:25:10 -0300
Subject: [media] cx88: Fix HVR4000 IR keymap
To: Greg KH <greg@kroah.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, Lawrence Rust <lawrence@softsystem.co.uk>, Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <4DC20A86.7010509@redhat.com>

From: Lawrence Rust <lvr@softsystem.dot.uk>

[fixed in .39 in a much different way that is too big to backport to
.38 - gregkh]

Fixes the RC key input for Nova-S plus, HVR1100, HVR3000 and HVR4000 in
the 2.6.38 kernel.

Signed-off-by: Lawrence Rust <lvr@softsystem.dot.uk>
Acked-by: Jarod Wilson <jarod@wilsonet.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---
 drivers/media/video/cx88/cx88-input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -283,7 +283,7 @@ int cx88_ir_init(struct cx88_core *core,
 	case CX88_BOARD_PCHDTV_HD3000:
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:


Patches currently in stable-queue which might be from lvr@softsystem.dot.uk are

queue-2.6.38/cx88-fix-hvr4000-ir-keymap.patch
