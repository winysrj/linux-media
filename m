Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37913 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbaIZPs4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 11:48:56 -0400
Date: Fri, 26 Sep 2014 12:48:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926124851.56a24d6b@recife.lan>
In-Reply-To: <20140926154227.GA22194@linuxtv.org>
References: <20140926110727.GA880@linuxtv.org>
	<20140926084215.772adce9@recife.lan>
	<20140926090316.5ae56d93@recife.lan>
	<20140926122721.GA11597@linuxtv.org>
	<20140926101222.778ebcaf@recife.lan>
	<20140926132513.GA30084@linuxtv.org>
	<20140926142543.GA3806@linuxtv.org>
	<54257888.90802@osg.samsung.com>
	<20140926150602.GA15766@linuxtv.org>
	<542584CD.6060507@osg.samsung.com>
	<20140926154227.GA22194@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Sep 2014 17:42:27 +0200
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Fri, Sep 26, 2014 at 09:22:53AM -0600, Shuah Khan wrote:
> > > 
> > > [   20.212162] usb 1-1: reset high-speed USB device number 2 using ehci-pci
> > > [   20.503868] em2884 #0: Resuming extensions
> > > [   20.505275] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
> > > [   20.533513] drxk: status = 0x439130d9
> > > [   20.534282] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
> > > [   23.008852] em2884 #0: writing to i2c device at 0x52 failed (error=-5)
> > > [   23.011408] drxk: i2c write error at addr 0x29
> > > [   23.013187] drxk: write_block: i2c write error at addr 0x8303b4
> > > [   23.015440] drxk: Error -5 while loading firmware
> > > [   23.017291] drxk: Error -5 on init_drxk
> > > [   23.018835] em2884 #0: fe0 resume 0
> > > 
> > > Any idea on this?
> > > 
> > 
> > Looks like this is what's happening:
> > during suspend:
> > 
> > drxk_sleep() gets called and marks state->m_drxk_state == DRXK_UNINITIALIZED
> > 
> > init_drxk() does download_microcode() and this step fails
> > because the conditions in which init_drxk() gets called
> > from drxk_attach() are different.
> > 
> > i2c isn't ready.
> > 
> > Is it possible for you to test this without power loss
> > on usb assuming this test run usb bus looses power?
> > 
> > If you could do the following tests and see if there is
> > a difference:
> > 
> > echo mem > /sys/power/state
> > vs
> > echo disk > /sys/power/state
> > 
> > If it is possible, with and without reset_resume hook.
> 
> My testing time is up for today, I'll look into it
> maybe tomorrow.

Ok.

> BTW, what about 3.17?  The patches in media_tree.git are for
> 3.18, right?  If so, and you have patches for 3.17 or
> 3.16-stable to test, let me know.

Yes, those patches are for 3.18. Don't remember if they were
tagged with c/c stable. If not, we'll need to rebase them to
-stable after being merged for 3.18-rc1.

Regards,
Mauro
