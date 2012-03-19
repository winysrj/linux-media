Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab2CSVAu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 17:00:50 -0400
Date: Mon, 19 Mar 2012 17:00:11 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Steffen Barszus <steffenbpunkt@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: nuvoton-cir on Intel DH67CL
Message-ID: <20120319210011.GD4230@redhat.com>
References: <20120314071037.43f650e4@grobi>
 <20120314204101.GG3729@redhat.com>
 <20120314223243.62671b44@grobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314223243.62671b44@grobi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 14, 2012 at 10:32:43PM +0100, Steffen Barszus wrote:
> On Wed, 14 Mar 2012 16:41:01 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
> 
> > On Wed, Mar 14, 2012 at 07:10:37AM +0100, Steffen Barszus wrote:
> > > Hi !
> > > 
> > > I'm using above board which has a nuvoton-cir onboard (as most Intel
> > > Media boards) - It shows itself as NTN0530. 
> > > 
> > > The remote function works without a problem (loaded RC6 MCE
> > > keytable). 
> > > 
> > > What doesn't work is wake from S3 and wake from S5. There are some
> > > rumors that installing Windows 7 and corresponding drivers has a
> > > positive effect (for some it seems to be enough to do it one time,
> > > others need to redo this from time to time (power loss?). This
> > > leads me to believe, that some hardware initialization is missing. 
> > > 
> > > I'm about to try latest linux-media tree next days, but i believe
> > > there hasn't been any change on this driver. 
> > > 
> > > My questions: 
> > > - any idea of what i should look at ?
> > > - any change on the driver i could try ? 
> > > - *IF* i go to install Win7 and drivers - anything i could to to
> > > help tracking down what this does in order to make the driver work
> > > out of the box on linux ?
> > > 
> > > As a lot of Sandy Bridge Boards to have this chip lately - it would
> > > be nice if this could just work or is my impression, that this is a
> > > general problem in this hardware wrong ?   
> > 
> > My only nuvoton hardware works perfectly w/resume via IR after commit
> > 3198ed161c9be9bbd15bb2e9c22561248cac6e6a, but its possible what
> > you've got is a newer hardware variant with some slightly different
> > registers to tweak. What does the driver identify your chip as in
> > dmesg?
> 
> I'm on Linux 3.2.0-18-generic #29-Ubuntu SMP (Ubuntu Precise)
> 
> 
> > As of commit 362d3a3a9592598cef1d3e211ad998eb844dc5f3, the driver will
> > bind to anything with the PNP ID of NTN0530, but will spew a warning
> > in dmesg if its not an explicitly recognized chip.
> > 
> 
> From dmesg it seems to be fine. 
> [    0.553258] system 00:02: [io  0x0290-0x029f] has been reserved
> [    0.553261] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.553504] pnp 00:03: [io  0x0240-0x024f]
> [    0.553513] pnp 00:03: [irq 3]
> [    0.553515] pnp 00:03: [io  0x0250-0x025f]
> [    0.553534] pnp 00:03: Plug and Play ACPI device, IDs NTN0530 (active)
> [    0.553544] pnp 00:04: [dma 4]
> [    0.553545] pnp 00:04: [io  0x0000-0x000f]
> [    0.553547] pnp 00:04: [io  0x0081-0x0083]
> [    0.553549] pnp 00:04: [io  0x0087]
> [    0.553550] pnp 00:04: [io  0x0089-0x008b]
> [    0.553552] pnp 00:04: [io  0x008f]
> [    0.553553] pnp 00:04: [io  0x00c0-0x00df]
> 
> Anything to be activated to wakeup on S3/S5 ?  I.e. the key to wake it
> up ? I'm using RC6 remote - operation as already said is without any
> issues, just not wakeup. 

It occurs to me that the box I've got had Windows on it at one point, and
its possible wake via IR works only because someone set a wake key pattern
under Windows. And that your box doesn't wake, because it hasn't had a
wake key pattern set yet. We don't have any UI for setting a wake key
pattern just yet... (Or if we do, I'm just not familiar with it).

-- 
Jarod Wilson
jarod@redhat.com

