Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37911 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaIZPnO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 11:43:14 -0400
Date: Fri, 26 Sep 2014 12:43:09 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926124309.558c8682@recife.lan>
In-Reply-To: <20140926152228.GA21876@linuxtv.org>
References: <20140926071411.61a011bd@recife.lan>
	<20140926110727.GA880@linuxtv.org>
	<20140926084215.772adce9@recife.lan>
	<20140926090316.5ae56d93@recife.lan>
	<20140926122721.GA11597@linuxtv.org>
	<20140926101222.778ebcaf@recife.lan>
	<20140926132513.GA30084@linuxtv.org>
	<20140926142543.GA3806@linuxtv.org>
	<54257888.90802@osg.samsung.com>
	<20140926150602.GA15766@linuxtv.org>
	<20140926152228.GA21876@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Sep 2014 17:22:28 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Fri, Sep 26, 2014 at 05:06:02PM +0200, Johannes Stezenbach wrote:
> > On Fri, Sep 26, 2014 at 08:30:32AM -0600, Shuah Khan wrote:
> > > On 09/26/2014 08:25 AM, Johannes Stezenbach wrote:
> > > > 
> > > > So, what is happening is that the em28xx driver still async initializes
> > > > while the initramfs already has started resume.  Thus the rootfs in not
> > > > mounted and the firmware is not loadable.  Maybe this is only an issue
> > > > of my qemu test because I compiled a non-modular kernel but don't have
> > > > the firmware in the initramfs for testing simplicity?
> > > > 
> > > > 
> > > 
> > > Right. We have an issue when media drivers are compiled static
> > > (non-modular). I have been debugging that problem for a while.
> > > We have to separate the two cases - if you are compiling em28xx
> > > as static then you will run into the issue.
> > 
> > So I compiled em28xx as modules and installed them in my qemu image.
> > One issue solved, but it still breaks after resume:
> > 
> > [   20.212162] usb 1-1: reset high-speed USB device number 2 using ehci-pci
> > [   20.503868] em2884 #0: Resuming extensions
> > [   20.505275] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
> > [   20.533513] drxk: status = 0x439130d9
> > [   20.534282] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
> > [   23.008852] em2884 #0: writing to i2c device at 0x52 failed (error=-5)
> > [   23.011408] drxk: i2c write error at addr 0x29
> > [   23.013187] drxk: write_block: i2c write error at addr 0x8303b4
> > [   23.015440] drxk: Error -5 while loading firmware
> > [   23.017291] drxk: Error -5 on init_drxk
> > [   23.018835] em2884 #0: fe0 resume 0
> > 
> > Any idea on this?
> 
> I backed out Mauro's test patch, now it seems to work
> (v3.17-rc5-734-g214635f, no patches, em28xx as modules).
> But I'm not 100% sure the above was related to this,
> it seemed the 930C got upset during all the testing
> and I had to unplug it to get it back working.

Could you please test again with the patch? Without it, I suspect that,
if you suspend while streaming, the frontend won't relock again after
resume. Of course, I may be wrong ;)

Regards,
Mauro
