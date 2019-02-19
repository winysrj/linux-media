Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303B3C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 05:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03BD1217D7
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 05:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbfBSFfQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 00:35:16 -0500
Received: from tnsp.org ([94.237.36.134]:35852 "EHLO pet8032.tnsp.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfBSFfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 00:35:16 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2019 00:35:15 EST
Received: by pet8032.tnsp.org (Postfix, from userid 1000)
        id 7C6A819690B; Tue, 19 Feb 2019 07:30:07 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
        by pet8032.tnsp.org (Postfix) with ESMTP id 0DCFE19690A;
        Tue, 19 Feb 2019 07:30:07 +0200 (EET)
Date:   Tue, 19 Feb 2019 07:30:07 +0200 (EET)
From:   =?ISO-8859-15?Q?Matti_H=E4m=E4l=E4inen?= <ccr@tnsp.org>
To:     linux-media@vger.kernel.org
cc:     hverkuil@xs4all.nl
Subject: [BUG] Regression caused by "media: gspca: convert to vb2"
Message-ID: <alpine.DEB.2.20.1902190711130.21189@tnsp.org>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


Hello!

Last week while testing some webcams that use gspca-based v4l2 drivers, I 
noticed that the driver was spewing some errors in klog whenever the 
program using them issued VIDIOC_STREAMOFF ioctl. This seems to be a
regression caused by commit 1f5965c4dfd7665f2914a1f1095dcc6020656b04
"media: gspca: convert to vb2" in the mainline kernel.

The errors were as follows (with gspca_main debug=3):
[ 2497.147902] gspca_zc3xx 3-9.3.2:1.0: isoc 32 pkts size 768 = bsize:24576
[ 2498.194657] gspca_zc3xx 3-9.3.2:1.0: probe 2wr ov vga 0x0000
[ 2499.602538] gspca_zc3xx 3-9.3.2:1.0: found int in endpoint: 0x82, buffer_len=8, interval=10
[ 2501.785244] gspca_zc3xx 3-9.3.2:1.0: kill transfer
[ 2501.787218] gspca_zc3xx 3-9.3.2:1.0: urb status: -2
[ 2501.787223] gspca_main: usb_submit_urb() ret -1
[ 2501.789217] gspca_zc3xx 3-9.3.2:1.0: urb status: -2
[ 2501.789222] gspca_main: usb_submit_urb() ret -1
[ 2501.791218] gspca_zc3xx 3-9.3.2:1.0: urb status: -2
[ 2501.791223] gspca_main: usb_submit_urb() ret -1
[ 2501.791226] gspca_zc3xx 3-9.3.2:1.0: releasing urbs
[ 2501.795919] gspca_zc3xx 3-9.3.2:1.0: found int in endpoint: 0x82, buffer_len=8, interval=10
[ 2501.870710] gspca_zc3xx 3-9.3.2:1.0: stream off OK

Additionally I noticed that on another PC I could trigger a complete 
hard system lockup simply by unplugging the USB camera when a video 
capture was ongoing AND while running under Xorg. (For some reason
without Xorg there was no hang.)

Also, on the same system another gspca camera (again with this commit) 
results in following errors on "clean" disconnect, e.g. plug on/off and no 
capture running:

[ 8492.613643] STV06xx 4-2:1.0: URB error -84, resubmitting
[ 8492.661638] STV06xx 4-2:1.0: URB error -84, resubmitting
[ 8492.709638] STV06xx 4-2:1.0: URB error -84, resubmitting
[ 8492.755542] usb 4-2: USB disconnect, device number 3


While I am no kernel dev, I believe that the changes to the mutex locking 
in the aforementioned commit are probably causing some race conditions.

What I think is happening in the first case (urb status errors) is that 
when userspace program does ioctl(fd, VIDIOC_STREAMOFF, V4L2_BUF_TYPE_VIDEO_CAPTURE),
the kernel goes to gspca_stream_off() and through that to destroy_urbs().

Meanwhile fill_frame() can get called from isoc_irq(), which then results
in the failures that spew "urb status: -2" to klog, goto resubmit ->
"usb_submit_urb() ret -1"

Sorry if I've forgotten to provide some relevant information,
feel free to ask if something is required.

-- 
] ccr/TNSP ^ pWp  ::  ccr@tnsp.org  ::  https://tnsp.org/~ccr/
] https://tnsp.org/hg/ -- https://www.openhub.net/accounts/ccr
] PGP key: 7BED 62DE 898D D1A4 FC4A  F392 B705 E735 307B AAE3
