Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:39279 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbaIZIAm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 04:00:42 -0400
Date: Fri, 26 Sep 2014 10:00:30 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926080030.GB31491@linuxtv.org>
References: <20140925125353.GA5129@linuxtv.org>
 <54241C81.60301@osg.samsung.com>
 <20140925160134.GA6207@linuxtv.org>
 <5424539D.8090503@osg.samsung.com>
 <20140925181747.GA21522@linuxtv.org>
 <542462C4.7020907@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542462C4.7020907@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 25, 2014 at 12:45:24PM -0600, Shuah Khan wrote:
> 
> Revert is good. Just checked 3.16 and we are good
> on that. It needs to be reverted from 3.17 for sure.
> 
> ok now I know why the second path didn't
> apply. It depends on another change that added resume
> function
> 
> 7ab1c07614b984778a808dc22f84b682fedefea1
> 
> You don't need the second patch. The first patch applied
> to 3.17 and fails on 3.16
> 
> http://patchwork.linuxtv.org/patch/26073/

I'm not sure I understand correctly.  I applied the
b89193e0b06f revert plus the 26073 patchwork patch
on top of yesterday's git master (v3.17-rc6-247-g005f800),
the xc5000 request_firmware issue still happens, additionally
a drxk_attach request_firmware warning is printed after resume.

I should mention I just test "boot -> hibernate -> resume",
the device is not opened before hibernate.

The drxk warning trace is:

[    3.762776]  [<ffffffff81320e96>] request_firmware+0x30/0x42
[    3.764538]  [<ffffffff813f2f58>] drxk_attach+0x546/0x656
[    3.766094]  [<ffffffff814ba9d2>] em28xx_dvb_init.part.3+0xa1c/0x1cc6
[    3.767879]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.769825]  [<ffffffff814be27d>] ? mutex_unlock+0x9/0xb
[    3.771379]  [<ffffffff814b96a1>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
[    3.773342]  [<ffffffff8141b7e7>] em28xx_dvb_init+0x1d/0x1f
[    3.774982]  [<ffffffff81415740>] em28xx_init_extension+0x51/0x67
[    3.776670]  [<ffffffff81416d38>] request_module_async+0x19/0x1b

[    3.793013] usb 1-1: firmware: dvb-usb-hauppauge-hvr930c-drxk.fw will not be loaded


Johannes
