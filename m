Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33317 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbbGTNXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:23:24 -0400
Received: by lbbyj8 with SMTP id yj8so95181619lbb.0
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 06:23:23 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 Jul 2015 15:23:23 +0200
Message-ID: <CAJfOKBw4JZTzn2MtpuG+xh-tWuvv1Djx23iwQcPwkJRX04ZHuA@mail.gmail.com>
Subject: V4L2 Xilinx driver state
From: Franck Jullien <franck.jullien@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm very new to video input devices.

I have a new project where I need to get a SDI video stream to a CPU via a FPGA.
I'll use a Xilinx device and Xilinx video IP cores. This is what I (think) need:

            +--------+     +-------------------------+
+----------------+
            | CUSTOM |     | Video In to AXI4 Stream |     |
     |
 SDI +----->+ CORE   +---->+          +-------+      +---->+   AXI
VDMA     +---->...
            |        |     |          |  VTC  |      |     |
     |
            +--------+     +-------------------------+
+----------------+
                                          ^
                                          |
                                          +---------+

>From what I've seen, the AXI VDMA driver is present in the Kernel. The VTC part
of Video In to AXI core is present but does nothing with the "detector" mode
(however, we may want to do nothing with it).

Is this setup now possible with the current drivers ? Do I just need
to configure
my device tree to match this ?

Thanks in advance,

Franck.
