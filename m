Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39764 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaLSJK2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 04:10:28 -0500
Received: from dyn3-82-128-190-202.psoas.suomi.net ([82.128.190.202] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Y1tZq-0005JV-Jj
	for linux-media@vger.kernel.org; Fri, 19 Dec 2014 11:10:26 +0200
Message-ID: <5493EB82.5090004@iki.fi>
Date: Fri, 19 Dec 2014 11:10:26 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: cx23885 streaming lockdep error (VB2 related?)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I see thank kind of error when I start streaming cx23885:

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 3 PID: 27959 Comm: dvbv5-scan Tainted: G         C O   3.18.0-rc4+ #12
Hardware name: System manufacturer System Product Name/M5A78L-M/USB3, 
BIOS 2001    09/11/2014
  0000000000000000 00000000d70b2b44 ffff880162013928 ffffffff817a6f52
  0000000000000000 ffff88018d3cc1d0 ffff880162013938 ffffffff817a4802
  ffff880162013a38 ffffffff810e765a ffffffff8102001a ffff88018d3cc1d0
Call Trace:
  [<ffffffff817a6f52>] dump_stack+0x4e/0x68
  [<ffffffff817a4802>] register_lock_class.part.41+0x38/0x3c
  [<ffffffff810e765a>] __lock_acquire+0x156a/0x1f50
  [<ffffffff8102001a>] ? native_sched_clock+0x2a/0xa0
  [<ffffffff810e9069>] lock_acquire+0xc9/0x170
  [<ffffffffa08f898f>] ? cx23885_buf_queue+0x6f/0x150 [cx23885]
  [<ffffffff817b0197>] _raw_spin_lock_irqsave+0x57/0xa0
  [<ffffffffa08f898f>] ? cx23885_buf_queue+0x6f/0x150 [cx23885]
  [<ffffffffa08f7a79>] ? cx23885_risc_databuffer+0xe9/0x160 [cx23885]
  [<ffffffffa08f898f>] cx23885_buf_queue+0x6f/0x150 [cx23885]
  [<ffffffffa08f9f3c>] buffer_queue+0x1c/0x20 [cx23885]
  [<ffffffffa08913d4>] __enqueue_in_driver+0x84/0x90 [videobuf2_core]
  [<ffffffffa0891ee0>] vb2_start_streaming+0x40/0x190 [videobuf2_core]
  [<ffffffffa0892269>] ? __fill_v4l2_buffer+0x119/0x1a0 [videobuf2_core]
  [<ffffffffa0893c95>] vb2_internal_streamon+0x115/0x150 [videobuf2_core]
  [<ffffffffa0895f91>] __vb2_init_fileio+0x361/0x3e0 [videobuf2_core]
  [<ffffffffa08d7220>] ? vb2_dvb_start_feed+0xc0/0xc0 [videobuf2_dvb]
  [<ffffffffa0896e6e>] vb2_thread_start+0xae/0x240 [videobuf2_core]
  [<ffffffffa05e104f>] ? dmx_section_feed_start_filtering+0x2f/0x190 
[dvb_core]
  [<ffffffffa08d71f0>] vb2_dvb_start_feed+0x90/0xc0 [videobuf2_dvb]
  [<ffffffffa05e1102>] dmx_section_feed_start_filtering+0xe2/0x190 
[dvb_core]
  [<ffffffffa05dee9e>] dvb_dmxdev_filter_start+0x20e/0x3e0 [dvb_core]
  [<ffffffffa05dfa80>] dvb_demux_do_ioctl+0x4f0/0x650 [dvb_core]
  [<ffffffffa05dd924>] dvb_usercopy+0x124/0x1a0 [dvb_core]
  [<ffffffff81341a56>] ? avc_has_perm+0x126/0x1f0
  [<ffffffffa05df590>] ? dvb_dmxdev_add_pid+0xb0/0xb0 [dvb_core]
  [<ffffffffa05dde05>] dvb_demux_ioctl+0x15/0x20 [dvb_core]
  [<ffffffff81245590>] do_vfs_ioctl+0x2f0/0x520
  [<ffffffff817b12dc>] ? retint_swapgs+0x13/0x1b
  [<ffffffff81245841>] SyS_ioctl+0x81/0xa0
  [<ffffffff817b06a9>] system_call_fastpath+0x12/0x17

any idea why?

regards
Antti

-- 
http://palosaari.fi/
