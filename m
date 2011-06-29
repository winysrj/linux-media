Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58620 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab1F2Dxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 23:53:51 -0400
Subject: Re: HVR-1250/CX23885 IR Rx
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 28 Jun 2011 23:54:12 -0400
In-Reply-To: <810E4A6F-80BA-417F-9F9E-3B1274DAFD1B@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin>
	 <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
	 <1302276147.1749.46.camel@gagarin>
	 <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com>
	 <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com>
	 <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com>
	 <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com>
	 <CDB2A354-8564-447E-99A3-66502E83E4CB@wilsonet.com>
	 <8f1c0f8a-e4cd-4e3b-8ad4-f58212dfd9d4@email.android.com>
	 <099D978B-BC30-4527-870E-85ECEE74501D@wilsonet.com>
	 <1302476895.2282.12.camel@localhost>
	 <679F6706-8E38-4DF4-9F06-65EC3747339E@wilsonet.com>
	 <444047a2-87a6-4823-a1cd-961493f6680f@email.android.com>
	 <8450B359-034A-4DE2-BD8D-50DA6BE98A17@wilsonet.com>
	 <1309300374.2377.6.camel@palomino.walls.org>
	 <810E4A6F-80BA-417F-9F9E-3B1274DAFD1B@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1309319653.2359.37.camel@palomino.walls.org>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-06-28 at 22:17 -0400, Jarod Wilson wrote:
> On Jun 28, 2011, at 6:32 PM, Andy Walls wrote:
> 
> > On Tue, 2011-06-28 at 17:39 -0400, Jarod Wilson wrote:
> > 
> >> I'm thinking that in the
> >> short-term, we should probably make sure msi doesn't get enabled in
> >> the cx23885 driver, and longer-term, we can look at fixing it.
> > 
> > Sounds fine.  But fixcing the cx23885 driver to deal with both PCIe
> > emulation of legacy PCI INTx and PCIe MSI will likely be very involved.
> > (Maybe I'm wrong?)
> 
> I'm not sure either, but I know a few PCI gurus at work who could
> probably lend some insight.
> 
> 
> > Taking a trip down memory lane to 2 Dec 2010...
> > http://www.spinics.net/lists/linux-media/msg25956.html
> 
> Man. I really gotta learn to search the list archive (and bugzillas
> assigned to me...) before sending mail to the list, eh? ;)

You seem to stumble across things that I happened to run across about
6-7 months ago.  So use that as your starting search window. ;)


> > On Wed, 2010-12-01 at 21:52 -0800, David Liontooth wrote:
> >> On 11/29/2010 04:38 AM, Andy Walls wrote:
> >>> On Sun, 2010-11-28 at 23:49 -0800, David Liontooth wrote:
> > 
> >>> For a quick band-aid, use "pci=nomsi" on your kernel command line, and
> >>> reboot to reset the CX23888 hardware.
> >>> 
> >>> The problem is MSI.  The cx23885 driver isn't ready for it.  The patch
> >>> that enabled MSI for cx23885 probably needs to be reverted until some of
> >>> these issues are sorted out.
> > 
> >> -- what do we lose by removing the MSI support patch?
> > 
> > Problems mostly. The driver was written to work with emulated legacy PCI
> > INTx interrupts, which are to be treated as level triggered, and not
> > PCIe MSI, which are to be treated as edge triggered.  That's why I say
> > the cx23885 driver isn't ready for MSI, but I'm not sure how involved an
> > audit and conversion would be.  I know an audit will take time and
> > expertise.
> 
> Dropping msi support looks to be quite trivial,

It is trivial.

>  I got the card behaving
> after only a few lines of change in cx23885-core.c without having to pass
> in pci=nomsi, but I *only* tried IR, I haven't tried video capture. I'll
> see if I can give that a spin tomorrow, and if that behaves, I can send
> along the diff.

It should.  MSI was an ill tested addition to cx23885 IMHO.

BTW, IR interrupts with the CX23885 IR unit are tricky.  The CX23885
(CX25843) A/V core is I2C connected.  Getting the A/V core to clear it's
INT_N line (wired to the main core of the CX23885) requires clearing all
the audio, video, and IR interrupts in the A/V core unit.  The video and
audio interrupts from the A/V core are currently masked.  The IR
interrupts have to be cleared by actually servicing the IR unit.

To deal with that headache, when an A/V core interrupt comes in, I
masked the PCI_AVCORE_INT (or whatever) interuupt on the CX23885 bridge
until the IR unit can be serviced.  Since the A/V core is I2C connected,
the IR unit is serviced in a workqueue work handler thread, where
sleeping is allowed.

I'm not sure how MSI can get a storming or stuck interrupt from the
CX23885 with me masking the PCI_AVCORE_INT.

IIRC the cx23885_irq handler calls some functions that might take a long
time to execute.  Maybe that matters with MSI enabled.  With MSI
disabled, you might want to set up ftrace on the cx23885 driver
functions and look to see if there are any slow paths being encountered
by the cx23885_irq handler.  I suspect the cx23885_irq handler should be
deferring some work other than just IR handling.

http://www.spinics.net/lists/linux-media/msg15762.html

Or, of course, my IR handling could be just so f---ed up that it fails
to clear the IR interrupt.  ;) ftrace might let you see that too.
(I don't have a CX23885 chip, only CX23888's, so I can't experiment.)

>  If we wanted to get really fancy, I could add a modparam
> to let people turn msi back on. (Never had a single issue with this card
> recording with msi enabled, only IR seems busted).

Getting the driver to properly support both MSI and INTx emulation might
take a few changes.  (a bunch of if statements maybe?)  I don't think
letting users choose without the driver being inspected and/or corrected
to handle both is a good idea.


> Just had another thought though... I have an HVR-1800 that *does* have
> issues recording, and the way the video is corrupted, its possible that
> its msi-related... Will have to keep that in mind next time I poke at it.

Uh, huh.

Regards,
Andy

