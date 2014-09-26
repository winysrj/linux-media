Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37866 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbaIZMDV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 08:03:21 -0400
Date: Fri, 26 Sep 2014 09:03:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926090316.5ae56d93@recife.lan>
In-Reply-To: <20140926084215.772adce9@recife.lan>
References: <20140925125353.GA5129@linuxtv.org>
	<54241C81.60301@osg.samsung.com>
	<20140925160134.GA6207@linuxtv.org>
	<5424539D.8090503@osg.samsung.com>
	<20140925181747.GA21522@linuxtv.org>
	<542462C4.7020907@osg.samsung.com>
	<20140926080030.GB31491@linuxtv.org>
	<20140926080824.GA8382@linuxtv.org>
	<20140926071411.61a011bd@recife.lan>
	<20140926110727.GA880@linuxtv.org>
	<20140926084215.772adce9@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Sep 2014 08:42:15 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 26 Sep 2014 13:07:27 +0200
> Johannes Stezenbach <js@linuxtv.org> escreveu:
> 
> > Hi Mauro,
> > 
> > On Fri, Sep 26, 2014 at 07:14:11AM -0300, Mauro Carvalho Chehab wrote:
> > > 
> > > I just pushed the pending patched and added a reverted patch for
> > > b89193e0b06f at the media_tree.git. Could you please use it to compile
> > > or, if you prefer to keep using 3.16, you can use the media_build.git[1]
> > > tree to just use the newest media stack on the top of 3.16.
> > > 
> > > [1] http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> > > 
> > > I updated the today's tarball for it to have all the patches there.
> > > 
> > > > > I should mention I just test "boot -> hibernate -> resume",
> > > > > the device is not opened before hibernate.
> > > > 
> > > > If I run dvb-fe-tool to load the xc5000 firmware before
> > > > hibernate then the xc5000 issue seems fixed, but the
> > > > drxk firmware issue still happens.
> > > 
> > > Please check if the xc5000 issue disappears with the current patches.
> > 
> > I compiled media_tree.git v3.17-rc5-734-g214635f, the
> > xc5000 issue is fixed.  I tested both "boot -> hibernate ->resume"
> > and "boot -> dvb-fe-tool -> hibernate ->resume" in qemu.
> > 
> > > The drxk issue will likely need a similar fix to the one that Shuah
> > > did to drxj.
> > 
> > The drx-k issue is still present:


The patch I sent you (or some fixed version of it) is part of the
solution, but this still bothers me:

> > [    3.776854]  [<ffffffff813f974f>] drxk_attach+0x546/0x656
> > [    3.777675]  [<ffffffff814c22a3>] em28xx_dvb_init.part.3+0xa3e/0x1cdf
> > [    3.778652]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
> > [    3.779690]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
> > [    3.780615]  [<ffffffff814c5b45>] ? mutex_unlock+0x9/0xb
> > [    3.781428]  [<ffffffff814c0f50>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
> > [    3.782487]  [<ffffffff814230cf>] em28xx_dvb_init+0x1d/0x1f

Why em28xx_dvb_init() is being called?

That should only happen if the device is re-probed again, but
the reset_resume code should have been preventing it.

Regards,
Mauro
