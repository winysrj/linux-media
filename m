Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OJx56I019880
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 15:59:05 -0400
Received: from imr-d04.mx.aol.com (imr-d04.mx.aol.com [205.188.157.42])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OJwpws023499
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 15:58:51 -0400
References: <20080424182147.GA28661@kroah.com>	<4810D4EA.409@linuxtv.org>
	<20080424120254.39ec53e8@appleyard>
To: kristen.c.accardi@intel.com, mkrufky@linuxtv.org
Date: Thu, 24 Apr 2008 15:27:03 -0400
In-Reply-To: <20080424120254.39ec53e8@appleyard>
MIME-Version: 1.0
From: Jon Lowe <jonlowe@aol.com>
Message-Id: <8CA74584F6427A7-9C8-1BE5@mblk-d14.sysops.aol.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: greg@kroah.com, video4linux-list@redhat.com
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,
I started this mess.? Is there anything I can/should do wth my ASUS laptop to test the Expresscard slot as you are trying to do?? It works under Vista.? I will need instructions on how to install either the pciehp or aciphp driver.? I assume that these don't auto install under Ubuntu 8.04?

Also, my original problem was removing the card, and my laptop crashing.


Jon Lowe


-----Original Message-----
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: mkrufky@linuxtv.org
Cc: greg@kroah.com; jonlowe@aol.com; stoth@linuxtv.org; brandon@ifup.org; video4linux-list@redhat.com
Sent: Thu, 24 Apr 2008 2:02 pm
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup



On Thu, 24 Apr 2008 14:43:54 -0400
mkrufky@linuxtv.org wrote:

> Greg KH wrote:
> > On Thu, Apr 24, 2008 at 02:10:47PM -0400, mkrufky@linuxtv.org wrote:
> >   
> >> Greg KH wrote:
> >>     
> >>> On Thu, Apr 24, 2008 at 10:40:24AM -0400, Michael Krufky wrote:
> >>>   
> >>>       
> >>>> On Thu, Apr 24, 2008 at 10:32 AM, Jon Lowe <jonlowe@aol.com> wrote:
> >>>>     
> >>>>         
> >>>>> While not exactly the same, this bug MAY be related to my hot swap
> >>>>>           
> >> poblem:
> >>     
> >> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/12519
> >>     
> >>>>>       
> >>>>>           
> >>>> No relation.  Also, we're in 2.6.26 development, most 2.6.15 bugs are
> >>>> entirely irrelevant.
> >>>>
> >>>> The problem is PCIe hotplugging  -- it doesn't work in Linux, at
> >>>> least, not with Expresscards.  This issue is not specific to the
> >>>> HVR1500 -- you'll see it on other similar Expresscards as well.
> >>>>     
> >>>>         
> >>> Huh?  We had expresscard hotplugging working in Linux before any other
> >>> operating system ever did.  It works for me just fine here on many
> >>> machines, and does so for many thousands of users.
> >>>
> >>>   
> >>>       
> >>>> I can only get the HVR1500 / HVR1500Q / HVR1400 to come up properly if
> >>>> it is installed in the system when I boot up the PC.  Inserting it
> >>>> after boot does absolutely nothing, and removing it after you booted
> >>>> the system with it installed will leave the system unstable.
> >>>>     
> >>>>         
> >>> Have you actually loaded the pci hotplug controller driver that is
> >>> needed to get hotplugging of express cards to work properly?  :)
> >>>   
> >>>       
> >> This is what I see upon insertion of an HVR1500 with pciehp loaded:
> >>
> >> [  122.798217] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 ss_did
> 0
> >> [  122.798457] Evaluate _OSC Set fails. Status = 0x0005
> >> [  122.798492] Evaluate _OSC Set fails. Status = 0x0005
> >> [  122.798514] pciehp: Cannot get control of hotplug hardware for pci
> 0000:00:01.0
> >> [  122.798662] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 ss_did
> 0
> >> [  122.798705] Evaluate _OSC Set fails. Status = 0x0005
> >> [  122.798735] Evaluate _OSC Set fails. Status = 0x0005
> >> [  122.798758] pciehp: Cannot get control of hotplug hardware for pci
> 0000:00:1c.0
> >>     
> >
> > This really looks like your BIOS does not support PCI Hotplug of your
> > express cards.
> >
> > But I'm adding Kristen to the CC: as she is the PCI Hotplug maintainer
> > of the kernel, and she knows this way better than I do.
> >
> > Also, have you tried the acpiphp driver?  That might be the one your
> > hardware needs instead.
> >
> > thanks,
> >
> > greg k-h
> >   
> acpiphp gives me the following:
> 
> [  264.251609] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [  264.282563] acpiphp_glue: can't get bus number, assuming 0
> [  264.282729] decode_hpp: Could not get hotplug parameters. Use defaults
> [  264.282783] acpiphp: Slot [1] registered
> [  265.125349] cx23885 driver version 0.0.1 loaded
> 
> I loaded the cx23885 driver, but it did not pick up on the hardware, nor 
> do I see the expresscard listed in lspci.
> 
> The BIOS on my laptop definitely does support hotplug of my 
> expresscards.  It works in Windows Vista (yuck)
> 
> To get a better idea about my Dell Latitude D830 laptop configuration, 
> I've included full dmesg dump (please see attached)
> 
> Thank you for looking into this.
> 
> Regards,
> 
> Mike
> 

Hi - it does look like your laptop might only supports acpi based hotplug, 
since it looks like the pciehp driver is failing to switch into native pcie 
mode due to lack of firmware support.  please send your acpi DSDT table
so I can confirm that native pcie is not supported - and then we can
debug why acpiphp isn't working for you.

Kristen

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
