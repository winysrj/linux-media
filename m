Return-path: <mchehab@pedra>
Received: from gateway04.websitewelcome.com ([67.18.21.5]:56391 "HELO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753179Ab1DBAbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Apr 2011 20:31:09 -0400
Subject: [PATCH] s2255drv: atomic submit urb in completion handler
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: linux-dev@sensoray.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 17:21:26 -0700
Message-ID: <1301703686.9785.12.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

An usb_submit_urb should be atomic in a completion handler. This fixes
"BUG: scheduling while atomic" messages.

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index f5a46c4..85c3158 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -2406,7 +2406,7 @@ static void read_pipe_completion(struct urb *purb)
                          read_pipe_completion, pipe_info);
 
        if (pipe_info->state != 0) {
-               if (usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL)) {
+               if (usb_submit_urb(pipe_info->stream_urb, GFP_ATOMIC)) {
                        dev_err(&dev->udev->dev, "error submitting urb\n");
                }
        } else {


