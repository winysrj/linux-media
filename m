Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37879 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaIZNM2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 09:12:28 -0400
Date: Fri, 26 Sep 2014 10:12:22 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926101222.778ebcaf@recife.lan>
In-Reply-To: <20140926122721.GA11597@linuxtv.org>
References: <20140925160134.GA6207@linuxtv.org>
	<5424539D.8090503@osg.samsung.com>
	<20140925181747.GA21522@linuxtv.org>
	<542462C4.7020907@osg.samsung.com>
	<20140926080030.GB31491@linuxtv.org>
	<20140926080824.GA8382@linuxtv.org>
	<20140926071411.61a011bd@recife.lan>
	<20140926110727.GA880@linuxtv.org>
	<20140926084215.772adce9@recife.lan>
	<20140926090316.5ae56d93@recife.lan>
	<20140926122721.GA11597@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Sep 2014 14:27:21 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Fri, Sep 26, 2014 at 09:03:16AM -0300, Mauro Carvalho Chehab wrote:
> > 
> > The patch I sent you (or some fixed version of it) is part of the
> > solution, but this still bothers me:
> > 
> > > > [    3.776854]  [<ffffffff813f974f>] drxk_attach+0x546/0x656
> > > > [    3.777675]  [<ffffffff814c22a3>] em28xx_dvb_init.part.3+0xa3e/0x1cdf
> > > > [    3.778652]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
> > > > [    3.779690]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
> > > > [    3.780615]  [<ffffffff814c5b45>] ? mutex_unlock+0x9/0xb
> > > > [    3.781428]  [<ffffffff814c0f50>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
> > > > [    3.782487]  [<ffffffff814230cf>] em28xx_dvb_init+0x1d/0x1f
> > 
> > Why em28xx_dvb_init() is being called?
> > 
> > That should only happen if the device is re-probed again, but
> > the reset_resume code should have been preventing it.
> 
> Well, I stuck a WARN_ON(1) into drxk_release(), it is not called
> during hibernate+resume.

Well, it shouldn't be called at hibernate, but, at resume, the
reset_resume callback at em28xx should have been called, but I'm
not seeing any message indicating it.

Try to add a WARN_ON or printk at em28xx_usb_resume().


> Do you have a better suggestion to debug it?
> 
> Johannes
