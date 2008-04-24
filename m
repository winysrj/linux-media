Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OIBGEc000839
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:11:16 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OIB1oV032759
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:11:02 -0400
Message-ID: <4810CD27.1080209@linuxtv.org>
From: mkrufky@linuxtv.org
To: greg@kroah.com
Date: Thu, 24 Apr 2008 14:10:47 -0400
MIME-Version: 1.0
in-reply-to: <20080424170142.GA20017@kroah.com>
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: video4linux-list@redhat.com
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

Greg KH wrote:
> On Thu, Apr 24, 2008 at 10:40:24AM -0400, Michael Krufky wrote:
>   
>> On Thu, Apr 24, 2008 at 10:32 AM, Jon Lowe <jonlowe@aol.com> wrote:
>>     
>>> While not exactly the same, this bug MAY be related to my hot swap
poblem:
>>>
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/12519
>>>       
>> No relation.  Also, we're in 2.6.26 development, most 2.6.15 bugs are
>> entirely irrelevant.
>>
>> The problem is PCIe hotplugging  -- it doesn't work in Linux, at
>> least, not with Expresscards.  This issue is not specific to the
>> HVR1500 -- you'll see it on other similar Expresscards as well.
>>     
>
> Huh?  We had expresscard hotplugging working in Linux before any other
> operating system ever did.  It works for me just fine here on many
> machines, and does so for many thousands of users.
>
>   
>> I can only get the HVR1500 / HVR1500Q / HVR1400 to come up properly if
>> it is installed in the system when I boot up the PC.  Inserting it
>> after boot does absolutely nothing, and removing it after you booted
>> the system with it installed will leave the system unstable.
>>     
>
> Have you actually loaded the pci hotplug controller driver that is
> needed to get hotplugging of express cards to work properly?  :)
>   

This is what I see upon insertion of an HVR1500 with pciehp loaded:

[  122.798217] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 ss_did 0
[  122.798457] Evaluate _OSC Set fails. Status = 0x0005
[  122.798492] Evaluate _OSC Set fails. Status = 0x0005
[  122.798514] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:01.0
[  122.798662] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 ss_did 0
[  122.798705] Evaluate _OSC Set fails. Status = 0x0005
[  122.798735] Evaluate _OSC Set fails. Status = 0x0005
[  122.798758] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.0
[  122.798798] pciehp: HPC vendor_id 8086 device_id 2841 ss_vid 0 ss_did 0
[  122.798832] Evaluate _OSC Set fails. Status = 0x0005
[  122.798859] Evaluate _OSC Set fails. Status = 0x0005
[  122.798881] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.1
[  122.798919] pciehp: HPC vendor_id 8086 device_id 2845 ss_vid 0 ss_did 0
[  122.798953] Evaluate _OSC Set fails. Status = 0x0005
[  122.798979] Evaluate _OSC Set fails. Status = 0x0005
[  122.799000] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.3
[  122.799038] pciehp: HPC vendor_id 8086 device_id 2849 ss_vid 0 ss_did 0
[  122.799070] Evaluate _OSC Set fails. Status = 0x0005
[  122.799096] Evaluate _OSC Set fails. Status = 0x0005
[  122.799117] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.5
[  122.799135] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[  128.803669] pciehp: PCI Express Hot Plug Controller Driver version: 
0.4 unloaded
[  129.685050] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 ss_did 0
[  129.685304] Evaluate _OSC Set fails. Status = 0x0005
[  129.685338] Evaluate _OSC Set fails. Status = 0x0005
[  129.685361] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:01.0
[  129.685838] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 ss_did 0
[  129.685874] Evaluate _OSC Set fails. Status = 0x0005
[  129.685900] Evaluate _OSC Set fails. Status = 0x0005
[  129.685932] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.0
[  129.686565] pciehp: HPC vendor_id 8086 device_id 2841 ss_vid 0 ss_did 0
[  129.686603] Evaluate _OSC Set fails. Status = 0x0005
[  129.686629] Evaluate _OSC Set fails. Status = 0x0005
[  129.686650] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.1
[  129.687956] pciehp: HPC vendor_id 8086 device_id 2845 ss_vid 0 ss_did 0
[  129.687998] Evaluate _OSC Set fails. Status = 0x0005
[  129.688026] Evaluate _OSC Set fails. Status = 0x0005
[  129.688047] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.3
[  129.689434] pciehp: HPC vendor_id 8086 device_id 2849 ss_vid 0 ss_did 0
[  129.689476] Evaluate _OSC Set fails. Status = 0x0005
[  129.689505] Evaluate _OSC Set fails. Status = 0x0005
[  129.689526] pciehp: Cannot get control of hotplug hardware for pci 
0000:00:1c.5
[  129.689983] pciehp: PCI Express Hot Plug Controller Driver version: 0.4


Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
