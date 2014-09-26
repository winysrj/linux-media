Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45600 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbaIZLHg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 07:07:36 -0400
Date: Fri, 26 Sep 2014 13:07:27 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926110727.GA880@linuxtv.org>
References: <20140925125353.GA5129@linuxtv.org>
 <54241C81.60301@osg.samsung.com>
 <20140925160134.GA6207@linuxtv.org>
 <5424539D.8090503@osg.samsung.com>
 <20140925181747.GA21522@linuxtv.org>
 <542462C4.7020907@osg.samsung.com>
 <20140926080030.GB31491@linuxtv.org>
 <20140926080824.GA8382@linuxtv.org>
 <20140926071411.61a011bd@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926071411.61a011bd@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Sep 26, 2014 at 07:14:11AM -0300, Mauro Carvalho Chehab wrote:
> 
> I just pushed the pending patched and added a reverted patch for
> b89193e0b06f at the media_tree.git. Could you please use it to compile
> or, if you prefer to keep using 3.16, you can use the media_build.git[1]
> tree to just use the newest media stack on the top of 3.16.
> 
> [1] http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> 
> I updated the today's tarball for it to have all the patches there.
> 
> > > I should mention I just test "boot -> hibernate -> resume",
> > > the device is not opened before hibernate.
> > 
> > If I run dvb-fe-tool to load the xc5000 firmware before
> > hibernate then the xc5000 issue seems fixed, but the
> > drxk firmware issue still happens.
> 
> Please check if the xc5000 issue disappears with the current patches.

I compiled media_tree.git v3.17-rc5-734-g214635f, the
xc5000 issue is fixed.  I tested both "boot -> hibernate ->resume"
and "boot -> dvb-fe-tool -> hibernate ->resume" in qemu.

> The drxk issue will likely need a similar fix to the one that Shuah
> did to drxj.

The drx-k issue is still present:

[    3.758318] WARNING: CPU: 0 PID: 59 at drivers/base/firmware_class.c:1124 _request_firmware+0x205/0x568()
[    3.760266] Modules linked in:
[    3.760828] CPU: 0 PID: 59 Comm: kworker/0:2 Not tainted 3.17.0-rc5+ #82
[    3.762002] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    3.763890] Workqueue: events request_module_async
[    3.764890]  0000000000000000 ffff88003c90fb38 ffffffff814bcac8 0000000000000000
[    3.766267]  ffff88003c90fb70 ffffffff81032d75 ffffffff81320b3c 00000000fffffff5
[    3.767596]  ffff880039ea1b00 ffff88003ca2be80 ffff88000053c900 ffff88003c90fb80
[    3.768941] Call Trace:
[    3.769414]  [<ffffffff814bcac8>] dump_stack+0x4e/0x7a
[    3.770285]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
[    3.771281]  [<ffffffff81320b3c>] ? _request_firmware+0x205/0x568
[    3.772289]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
[    3.773235]  [<ffffffff81320b3c>] _request_firmware+0x205/0x568
[    3.774162]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[    3.775064]  [<ffffffff81063c2c>] ? lockdep_init_map+0xc4/0x13f
[    3.775973]  [<ffffffff81320ecf>] request_firmware+0x30/0x42
[    3.776854]  [<ffffffff813f974f>] drxk_attach+0x546/0x656
[    3.777675]  [<ffffffff814c22a3>] em28xx_dvb_init.part.3+0xa3e/0x1cdf
[    3.778652]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.779690]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[    3.780615]  [<ffffffff814c5b45>] ? mutex_unlock+0x9/0xb
[    3.781428]  [<ffffffff814c0f50>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
[    3.782487]  [<ffffffff814230cf>] em28xx_dvb_init+0x1d/0x1f
[    3.783335]  [<ffffffff8141cfcb>] em28xx_init_extension+0x51/0x67
[    3.784276]  [<ffffffff8141e5c3>] request_module_async+0x19/0x1b
[    3.785207]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[    3.786133]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[    3.786982]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[    3.787863]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[    3.788616]  [<ffffffff8125d487>] ? debug_smp_processor_id+0x17/0x19
[    3.789594]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.790617]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.791559]  [<ffffffff814c866c>] ret_from_fork+0x7c/0xb0
[    3.792399]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.793314] ---[ end trace 001212d1d98f03c2 ]---
[    3.794014] usb 1-1: firmware: dvb-usb-hauppauge-hvr930c-drxk.fw will not be loaded
[    3.795218] drxk: Could not load firmware file dvb-usb-hauppauge-hvr930c-drxk.fw.


Johannes
