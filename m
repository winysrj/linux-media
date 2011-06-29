Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39115 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1F2CRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 22:17:54 -0400
Received: by qwk3 with SMTP id 3so401985qwk.19
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 19:17:54 -0700 (PDT)
Subject: Re: HVR-1250/CX23885 IR Rx
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1309300374.2377.6.camel@palomino.walls.org>
Date: Tue, 28 Jun 2011 22:17:52 -0400
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <810E4A6F-80BA-417F-9F9E-3B1274DAFD1B@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin> <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com> <1302276147.1749.46.camel@gagarin> <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com> <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com> <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com> <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com> <CDB2A354-8564-447E-99A3-66502E83E4CB@wilsonet.com> <8f1c0f8a-e4cd-4e3b-8ad4-f58212dfd9d4@email.android.com> <099D978B-BC30-4527-870E-85ECEE74501D@wilsonet.com> <1302476895.2282.12.camel@localhost> <679F6706-8E38-4DF4-9F06-65EC3747339E@wilsonet.com> <444047a2-87a6-4823-a1cd-961493f6680f@email.android.com> <8450B359-034A-4DE2-BD8D-50DA6BE98A17@wilsonet.com> <1309300374.2377.6.camel@palomino.walls.org>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 28, 2011, at 6:32 PM, Andy Walls wrote:

> On Tue, 2011-06-28 at 17:39 -0400, Jarod Wilson wrote:
> 
>> Up and running on 3.0-rc5 now, and I'm not seeing the panic, but the
>> box keeps hard-locking after some number of keypresses. Can't get a
>> peep out of it with sysrq, nmi watchdog doesn't seem to fire, etc.
>> 
>> At the suggestion of "Dark Shadow", I've also tried booting the box
>> with pci=nomsi. Works a treat then. Since his HVR-1270 and my HVR-1250
>> both behave much better with pci=nomsi, I'm thinking that in the
>> short-term, we should probably make sure msi doesn't get enabled in
>> the cx23885 driver, and longer-term, we can look at fixing it.
> 
> Sounds fine.  But fixcing the cx23885 driver to deal with both PCIe
> emulation of legacy PCI INTx and PCIe MSI will likely be very involved.
> (Maybe I'm wrong?)

I'm not sure either, but I know a few PCI gurus at work who could
probably lend some insight.


> Taking a trip down memory lane to 2 Dec 2010...
> http://www.spinics.net/lists/linux-media/msg25956.html

Man. I really gotta learn to search the list archive (and bugzillas
assigned to me...) before sending mail to the list, eh? ;)


> On Wed, 2010-12-01 at 21:52 -0800, David Liontooth wrote:
>> On 11/29/2010 04:38 AM, Andy Walls wrote:
>>> On Sun, 2010-11-28 at 23:49 -0800, David Liontooth wrote:
> 
>>> For a quick band-aid, use "pci=nomsi" on your kernel command line, and
>>> reboot to reset the CX23888 hardware.
>>> 
>>> The problem is MSI.  The cx23885 driver isn't ready for it.  The patch
>>> that enabled MSI for cx23885 probably needs to be reverted until some of
>>> these issues are sorted out.
> 
>> -- what do we lose by removing the MSI support patch?
> 
> Problems mostly. The driver was written to work with emulated legacy PCI
> INTx interrupts, which are to be treated as level triggered, and not
> PCIe MSI, which are to be treated as edge triggered.  That's why I say
> the cx23885 driver isn't ready for MSI, but I'm not sure how involved an
> audit and conversion would be.  I know an audit will take time and
> expertise.

Dropping msi support looks to be quite trivial, I got the card behaving
after only a few lines of change in cx23885-core.c without having to pass
in pci=nomsi, but I *only* tried IR, I haven't tried video capture. I'll
see if I can give that a spin tomorrow, and if that behaves, I can send
along the diff. If we wanted to get really fancy, I could add a modparam
to let people turn msi back on. (Never had a single issue with this card
recording with msi enabled, only IR seems busted).

Just had another thought though... I have an HVR-1800 that *does* have
issues recording, and the way the video is corrupted, its possible that
its msi-related... Will have to keep that in mind next time I poke at it.

-- 
Jarod Wilson
jarod@wilsonet.com



