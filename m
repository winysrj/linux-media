Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34747 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933588AbcAaUfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2016 15:35:09 -0500
Received: by mail-io0-f181.google.com with SMTP id 9so58208003iom.1
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2016 12:35:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 31 Jan 2016 22:35:08 +0200
Message-ID: <CAJ2oMh+yZ4KEpq36HgrdHW4FkvQmZ4T_tD7XUGKs0a9K=otMnw@mail.gmail.com>
Subject: OS freeze after queue_setup
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Maybe someone will have some idea about the following:
I am using a pci card (not video card, just some dummy pci card), to
check v4l2 template for PCIe card (I used solo6x10 as template for the
driver and moved all hardware related to video into remarks).
I don't use any register read/write to hardware (just dummy functions).

I get that load/unload of module is successful.
But on trying to start reading video frames (using read method with
v4l API userspace example), I get that the whole operating system is
freezed, and I must reboot the machine.
This is the queue_setup callback:

static int test_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
  unsigned int *num_buffers, unsigned int *num_planes,
  unsigned int sizes[], void *alloc_ctxs[])
{
struct test_dev *solo_dev = vb2_get_drv_priv(q);
dev_info(&test_dev->pdev->dev,"test_queue_setup\n");
sizes[0] = test_image_size(test_dev);
alloc_ctxs[0] = solo_dev->alloc_ctx;
*num_planes = 1;

if (*num_buffers < MIN_VID_BUFFERS)
*num_buffers = MIN_VID_BUFFERS;

return 0;
}

static const struct vb2_ops test_video_qops = {
.queue_setup = test_queue_setup,
.buf_queue = test_buf_queue,
.start_streaming = test_start_streaming, <- does nothing
.stop_streaming = test_stop_streaming, <- does nothing
.wait_prepare = vb2_ops_wait_prepare,
.wait_finish = vb2_ops_wait_finish,
};


I didn't find anything suspicious in the videobuf2 callback that can
explain these freeze.( start_streaming,stop_streaming contains just
printk with function name).
I also can't know where it got stuck (The system is freezed without
any logging on screen, all log is in dmesg).

Thank for any idea,
Ran
