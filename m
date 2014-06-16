Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1879 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaFPMFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 08:05:09 -0400
Message-ID: <539EDD60.5020400@xs4all.nl>
Date: Mon, 16 Jun 2014 14:04:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Scott Doty <scott@ponzo.net>
Subject: [PATCH for v3.16] hdpvr: fix two audio bugs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Scott,

Please verify that this solves your problem. It worked for me.

	Hans


When the audio encoding is changed the driver calls hdpvr_set_audio
with the current opt->audio_input value. However, that should have
been opt->audio_input + 1. So changing the audio encoding inadvertently
changes the input as well. This bug has always been there.

The second bug was introduced in kernel 3.10 and that broke the
default_audio_input module option handling: the audio encoding was
never switched to AC3 if default_audio_input was set to 2 (SPDIF input).

In addition, since starting with 3.10 the audio encoding is always set
at the start the first bug now always happens when the driver is loaded.
In the past this bug would only surface if the user would change the
audio encoding after the driver was loaded.

Also fixes a small trivial typo (bufffer -> buffer).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Scott Doty <scott@corp.sonic.net>
Cc: stable@vger.kernel.org      # for v3.10 and up
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0500c417..59f1dd4 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -82,7 +82,7 @@ static void hdpvr_read_bulk_callback(struct urb *urb)
 }
 
 /*=========================================================================*/
-/* bufffer bits */
+/* buffer bits */
 
 /* function expects dev->io_mutex to be hold by caller */
 int hdpvr_cancel_queue(struct hdpvr_device *dev)
-- 
2.0.0

