Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw1.zacglen.com ([220.233.85.112]:44093 "EHLO zacglen.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751013Ab2IIBjt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Sep 2012 21:39:49 -0400
Received: (from jw@localhost)
	by zacglen.com (8.14.3/8.14.3) id q891XcmZ020470
	for linux-media@vger.kernel.org; Sun, 9 Sep 2012 11:33:38 +1000
Date: Sun, 9 Sep 2012 11:33:38 +1000
Message-Id: <201209090133.q891XcmZ020470.zacglen.com@localhost>
To: linux-media@vger.kernel.org
Subject: dvb bug
From: yvahk-xreary@zacglen.net
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


With recent kernels I get system freeze when running with
the following hardware:

    Intel DX58S02 motherboard
    Xeon W5520 cpu
    Hauppauge HVR-1700 PCIe DVB-T
    Technisat SkyStar2 DVB-T PCI card

If I run either DVB-T card on its own then everything is ok.
Or if I run both cards on different motherboard and cpu then
everything is ok. So seems to related to DX58S02 and/or CPU
and/or some timing issue.

But with both dvb cards and debug kernel, I get:

    ? printk + 14/18
    valid_state + 131/144
    mark_lock + f2/1e1
    ? check_usage_backwards + 0/65
    __lock_acquire + 2dc/b91
    ? sched_clock + 9/d
    ? sched_clock_cpu + 46/13b
    ? trace_hardirqs_off + b/d
    ? cpu_clock + 3b/53
    lock_acquire + 93/b1
    ? dvb_dmx_swfilter + 26/104
    _spin_lock + 23/53
    ? dvb_dmx_swfilter + 26/104
    dvb_dmx_swfilter + 26/104
    videobuf_dvb_thread + b3/135
    ? videobuf_dvb_thread + 0/135
    kthread + 64/69
    ? kthread + 0/69
    kernel_thread_helper + 7/10

And at that point everything freezes (the INFO printk
wasn't visible on screen but I would have thought that this
should have just been an informative trace and not something
which would cause system to freeze).

Without debug kernel I get either system freeze or
other oops. And if there is any oops then the cx23885
module is always in the trace.

The user space application runs as two completely seperate instances
and opens two completely (supposedly) independent devices.

Can anybody make sense of the trace and point out what
exactly is happening?

