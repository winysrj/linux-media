Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37870 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbaIZMLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 08:11:10 -0400
Date: Fri, 26 Sep 2014 09:11:05 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926091105.24ddf929@recife.lan>
In-Reply-To: <20140926120233.GA2063@linuxtv.org>
References: <54241C81.60301@osg.samsung.com>
	<20140925160134.GA6207@linuxtv.org>
	<5424539D.8090503@osg.samsung.com>
	<20140925181747.GA21522@linuxtv.org>
	<542462C4.7020907@osg.samsung.com>
	<20140926080030.GB31491@linuxtv.org>
	<20140926080824.GA8382@linuxtv.org>
	<20140926071411.61a011bd@recife.lan>
	<20140926110727.GA880@linuxtv.org>
	<20140926084215.772adce9@recife.lan>
	<20140926120233.GA2063@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Sep 2014 14:02:33 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Fri, Sep 26, 2014 at 08:42:15AM -0300, Mauro Carvalho Chehab wrote:
> > Could you please try this patch (untested):
> > 
> > [media] drxk: load firmware again at resume
> 
> No joy.  I think you need to keep the firmware around
> for reuse after resume instead of requesting it again.

Well, it should be kept with the patch I sent. However, the issue is
that, despite the reset_resume, the device is being removed/reinserted
at the USB hotplug. Perhaps reset_resume on em28xx is returning a
wrong return code.

> 
> [    2.521597] PM: Image loading progress:  80%
> [    2.535627] PM: Image loading progress:  90%
> [    2.552505] PM: Image loading done.
> [    2.553169] PM: Read 107920 kbytes in 0.50 seconds (215.84 MB/s)
> [    2.562310] em2884 #0: Suspending extensions
> [    2.969484] Switched to clocksource tsc
> [    3.792296] ------------[ cut here ]------------
> [    3.794177] WARNING: CPU: 0 PID: 38 at drivers/base/firmware_class.c:1124 _request_firmware+0x205/0x568()
> [    3.796157] Modules linked in:
> [    3.796723] CPU: 0 PID: 38 Comm: kworker/0:1 Not tainted 3.17.0-rc5-00734-g214635f-dirty #84
> [    3.798197] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.800121] Workqueue: events request_module_async
> [    3.801115]  0000000000000000 ffff88003dfefb38 ffffffff814bcae8 0000000000000000
> [    3.802533]  ffff88003dfefb70 ffffffff81032d75 ffffffff81320b3c 00000000fffffff5
> [    3.803900]  ffff880039e63de0 ffff88003cfaf880 ffff8800363aa900 ffff88003dfefb80
> [    3.805283] Call Trace:
> [    3.805723]  [<ffffffff814bcae8>] dump_stack+0x4e/0x7a
> [    3.806617]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
> [    3.807636]  [<ffffffff81320b3c>] ? _request_firmware+0x205/0x568
> [    3.808673]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
> [    3.809638]  [<ffffffff81320b3c>] _request_firmware+0x205/0x568
> [    3.810611]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
> [    3.811545]  [<ffffffff81063c2c>] ? lockdep_init_map+0xc4/0x13f
> [    3.812477]  [<ffffffff81320ecf>] request_firmware+0x30/0x42
> [    3.813399]  [<ffffffff813f974f>] drxk_attach+0x546/0x651
> [    3.814233]  [<ffffffff814c22c3>] em28xx_dvb_init.part.3+0xa3e/0x1cdf
> [    3.815235]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
> [    3.816341]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
> [    3.817280]  [<ffffffff814c5b65>] ? mutex_unlock+0x9/0xb
> [    3.818127]  [<ffffffff814c0f70>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
> [    3.819176]  [<ffffffff814230f4>] em28xx_dvb_init+0x1d/0x1f
> [    3.820078]  [<ffffffff8141cff0>] em28xx_init_extension+0x51/0x67
> [    3.821026]  [<ffffffff8141e5e8>] request_module_async+0x19/0x1b
> [    3.821966]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
> [    3.822884]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
> [    3.823752]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
> [    3.824697]  [<ffffffff81049c09>] kthread+0xc7/0xcf
> [    3.825451]  [<ffffffff8125d487>] ? debug_smp_processor_id+0x17/0x19
> [    3.826430]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
> [    3.827501]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
> [    3.828449]  [<ffffffff814c866c>] ret_from_fork+0x7c/0xb0
> [    3.829315]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
> [    3.830228] ---[ end trace 9c556ab09f9d1814 ]---
> [    3.830932] usb 1-1: firmware: dvb-usb-hauppauge-hvr930c-drxk.fw will not be loaded
> [    3.832134] drxk: Could not load firmware file dvb-usb-hauppauge-hvr930c-drxk.fw.
> 
> 
> Johannes
