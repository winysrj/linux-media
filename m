Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E80AC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 11:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1C7208E4
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 11:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfBSL7F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 06:59:05 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:60457 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbfBSL7E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 06:59:04 -0500
Received: from [IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205] ([IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205])
        by smtp-cloud8.xs4all.net with ESMTPA
        id w439ghOj84HFnw43Cg2qsv; Tue, 19 Feb 2019 12:59:02 +0100
Subject: Re: [BUG] Regression caused by "media: gspca: convert to vb2"
To:     =?UTF-8?B?TWF0dGkgSMOkbcOkbMOkaW5lbg==?= <ccr@tnsp.org>,
        linux-media@vger.kernel.org
References: <alpine.DEB.2.20.1902190711130.21189@tnsp.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2e3e8d88-5d7d-c6d6-9fb7-7b5670ed44ef@xs4all.nl>
Date:   Tue, 19 Feb 2019 12:58:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1902190711130.21189@tnsp.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNolZZcYHg5GbspSj6olCOhIAxN6y/cj4sowwotnFa0JFS6RyhVY6xllOb11BIY1cu5RYxvpnm+h+2RZ86WgC0S3SON1GZZzaMstfSFjXG3o1H7pNz9l
 yz8EfULHI+mB48TQsbEjQFIDd1CE80Z1FFhXH1i++6JxbCJMX/MjmAvKMwPO/J34d3q/cq/rJY0zSKHKKsilLYRKr56FKId8gKALEiKoaQZzoIEa7559d9ri
 6o/W50n2YbNpjY51wj/1xQ1Bs2lVKIiqFKph3sk343qZsU0PD9cSwMY/C3Rf0CaewscJtoSdnt+wBY5q6Bv1oQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Matti,

On 2/19/19 6:30 AM, Matti Hämäläinen wrote:
> 
> Hello!
> 
> Last week while testing some webcams that use gspca-based v4l2 drivers, I 
> noticed that the driver was spewing some errors in klog whenever the 
> program using them issued VIDIOC_STREAMOFF ioctl. This seems to be a
> regression caused by commit 1f5965c4dfd7665f2914a1f1095dcc6020656b04
> "media: gspca: convert to vb2" in the mainline kernel.
> 
> The errors were as follows (with gspca_main debug=3):
> [ 2497.147902] gspca_zc3xx 3-9.3.2:1.0: isoc 32 pkts size 768 = bsize:24576
> [ 2498.194657] gspca_zc3xx 3-9.3.2:1.0: probe 2wr ov vga 0x0000
> [ 2499.602538] gspca_zc3xx 3-9.3.2:1.0: found int in endpoint: 0x82, buffer_len=8, interval=10
> [ 2501.785244] gspca_zc3xx 3-9.3.2:1.0: kill transfer
> [ 2501.787218] gspca_zc3xx 3-9.3.2:1.0: urb status: -2
> [ 2501.787223] gspca_main: usb_submit_urb() ret -1
> [ 2501.789217] gspca_zc3xx 3-9.3.2:1.0: urb status: -2
> [ 2501.789222] gspca_main: usb_submit_urb() ret -1
> [ 2501.791218] gspca_zc3xx 3-9.3.2:1.0: urb status: -2
> [ 2501.791223] gspca_main: usb_submit_urb() ret -1
> [ 2501.791226] gspca_zc3xx 3-9.3.2:1.0: releasing urbs
> [ 2501.795919] gspca_zc3xx 3-9.3.2:1.0: found int in endpoint: 0x82, buffer_len=8, interval=10
> [ 2501.870710] gspca_zc3xx 3-9.3.2:1.0: stream off OK
> 
> Additionally I noticed that on another PC I could trigger a complete 
> hard system lockup simply by unplugging the USB camera when a video 
> capture was ongoing AND while running under Xorg. (For some reason
> without Xorg there was no hang.)
> 
> Also, on the same system another gspca camera (again with this commit) 
> results in following errors on "clean" disconnect, e.g. plug on/off and no 
> capture running:
> 
> [ 8492.613643] STV06xx 4-2:1.0: URB error -84, resubmitting
> [ 8492.661638] STV06xx 4-2:1.0: URB error -84, resubmitting
> [ 8492.709638] STV06xx 4-2:1.0: URB error -84, resubmitting
> [ 8492.755542] usb 4-2: USB disconnect, device number 3
> 
> 
> While I am no kernel dev, I believe that the changes to the mutex locking 
> in the aforementioned commit are probably causing some race conditions.
> 
> What I think is happening in the first case (urb status errors) is that 
> when userspace program does ioctl(fd, VIDIOC_STREAMOFF, V4L2_BUF_TYPE_VIDEO_CAPTURE),
> the kernel goes to gspca_stream_off() and through that to destroy_urbs().
> 
> Meanwhile fill_frame() can get called from isoc_irq(), which then results
> in the failures that spew "urb status: -2" to klog, goto resubmit ->
> "usb_submit_urb() ret -1"
> 
> Sorry if I've forgotten to provide some relevant information,
> feel free to ask if something is required.
> 

Which kernel version are you using?

I got other, similar reports as well and I plan to look at it next week.

Regards,

	Hans
