Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BDBC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 12:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C98E2173C
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 12:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfBZMyZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:54:25 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59534 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbfBZMyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 07:54:25 -0500
Received: from [IPv6:2001:983:e9a7:1:7cd2:8892:5865:2071] ([IPv6:2001:983:e9a7:1:7cd2:8892:5865:2071])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ycFagSoO14HFnycFbgNkQY; Tue, 26 Feb 2019 13:54:23 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] gspca: do not resubmit URBs when streaming has stopped
Cc:     softwarebugs <softwarebugs@protonmail.com>,
        =?UTF-8?B?TWF0dGkgSMOkbcOkbMOkaW5lbg==?= <ccr@tnsp.org>
Message-ID: <4063d9fc-437d-6b32-6bd6-274f2bba2a60@xs4all.nl>
Date:   Tue, 26 Feb 2019 13:54:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJEAcN2MTpeJmTQFhnNkTMa6JPO5gF9DcZGgcbBeeQyJTRMkoWo3GvpYiMnbC16+nqZsMfyDX3Sb7EDk/sTpgeqXBdQrbfHpfuekLh0WZccKAT60sbFk
 jD9OZllxy/H3yvOQ6LG3FN/Cr37H2cKUXnHipdjnJorbavTsZKGSInCEEgsJJYoS2kcveP+JYZq4HwNuoEZ3mk+wEcY3e7ARer4wE7qwygIAq7yDgNoUlc52
 PFw9PCxobhpptwDK2AxgCw6n9P4aWVIx4mjHeaPdzgPUczkj43kMz5osl9WstOw86Ejrm+A7YMO4gGhiLqtJYwbhJX649o1EtDJLNW8gB1s=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

When streaming is stopped all URBs are killed, but in fill_frame and in
bulk_irq this results in an attempt to resubmit the killed URB. That is
not what you want and causes spurious kernel messages.

So check if streaming has stopped before resubmitting.

Also check against gspca_dev->streaming rather than vb2_start_streaming_called()
since vb2_start_streaming_called() will return true when in stop_streaming,
but gspca_dev->streaming is set to false when stop_streaming is called.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 6992effe5344 ("gspca: Kill all URBs before releasing any of them")
---
Matti and 'softwarebugs', can you test this patch? It should fix the
spurious usb_submit_usb errors that appear in the kernel log.

Matti, I could not reproduce the hard system lockup. Can you test this
patch and see if that lockup still occurs?

Regards,

	Hans
---
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index ac70b36d67b7..9448ac0b8bc9 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -314,6 +314,8 @@ static void fill_frame(struct gspca_dev *gspca_dev,
 	}

 resubmit:
+	if (!gspca_dev->streaming)
+		return;
 	/* resubmit the URB */
 	st = usb_submit_urb(urb, GFP_ATOMIC);
 	if (st < 0)
@@ -330,7 +332,7 @@ static void isoc_irq(struct urb *urb)
 	struct gspca_dev *gspca_dev = (struct gspca_dev *) urb->context;

 	gspca_dbg(gspca_dev, D_PACK, "isoc irq\n");
-	if (!vb2_start_streaming_called(&gspca_dev->queue))
+	if (!gspca_dev->streaming)
 		return;
 	fill_frame(gspca_dev, urb);
 }
@@ -344,7 +346,7 @@ static void bulk_irq(struct urb *urb)
 	int st;

 	gspca_dbg(gspca_dev, D_PACK, "bulk irq\n");
-	if (!vb2_start_streaming_called(&gspca_dev->queue))
+	if (!gspca_dev->streaming)
 		return;
 	switch (urb->status) {
 	case 0:
@@ -367,6 +369,8 @@ static void bulk_irq(struct urb *urb)
 				urb->actual_length);

 resubmit:
+	if (!gspca_dev->streaming)
+		return;
 	/* resubmit the URB */
 	if (gspca_dev->cam.bulk_nurbs != 0) {
 		st = usb_submit_urb(urb, GFP_ATOMIC);
