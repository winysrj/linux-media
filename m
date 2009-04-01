Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n315e35q006996
	for <video4linux-list@redhat.com>; Wed, 1 Apr 2009 01:40:03 -0400
Received: from smtp.ozonline.com.au (pilbara.ozonline.com.au [203.23.159.213])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n315df0n003666
	for <video4linux-list@redhat.com>; Wed, 1 Apr 2009 01:39:42 -0400
Message-ID: <49D2FE07.5060906@australiaonline.net.au>
Date: Wed, 01 Apr 2009 16:39:19 +1100
From: john knops <jknops@australiaonline.net.au>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <49D20B0B.1030701@australiaonline.net.au>
	<49D227A3.5000601@linuxtv.org>
In-Reply-To: <49D227A3.5000601@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: No scan with DViCo FusionHDTV DVB-T Dual Express
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

Steven Toth wrote:
> Hi John,
>
> john knops wrote:
>> I'm using the DViCo card with  Ubuntu 8.10amd64. I've followed the 
>> various instructions for installing drivers and firmware viz:-
>> loaded the drivers(v4l-dvb-b44a3aed3d1.tar.gz) as suggested on 
>> www.linuxtv.org/wiki/index.php/DViCo_FusionHDTV_DVB-T_Dual_Express 
>> <http://www.linuxtv.org/wiki/index.php/DViCo_FusionHDTV_DVB-T_Dual_Express> 
>> from linuxtv.org/hg/~stoth/v4l-dvb. I also had to load gspca_m5602.ko 
>> in /lib/modules/2.6.27-11-generic/kernel/drivers/media/video/gspca.
>
>
> The wiki url points to a page that doesn't exist.
> You can get to this page via the wiki Main Page -> DVB-T Devices -> 
> DVB-T PCIe cards - Experimental Support.
>
>>
>> The card wasn't auto-loaded until I added "options cx23885 card=11" 
>> to /etc/modprobe.d/options.
>> I obtained xc3028-v27.fw.tar.bz2 via ubuntuforums.org then copied the 
>> untarred file xc3028-v27.fw to /lib/firmware.
>
> It's probably a new rev of the card with a new subid, which is why you 
> have to force load it.
>
> What does lspci -vn look like? (Show the section specific to the 
> cx23885).
> Results of lspci -vn:-
01:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. 
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
    Subsystem: DViCO Corporation Device [18ac:db78]
    Flags: bus master, fast devsel, latency 0, IRQ 28
    Memory at f7e00000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express Endpoint, MSI 00
    Capabilities: [80] Power Management version 2
    Capabilities: [90] Vital Product Data <?>
    Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
    Capabilities: [100] Advanced Error Reporting <?>
    Capabilities: [200] Virtual Channel <?>
    Kernel driver in use: cx23885
    Kernel modules: cx23885

>
>> [34889.915511] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 
>> DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>> [34889.949353] xc2028 0-0061: Incorrect readback of firmware version.
>>
>> Any ideas why I'm getting " Incorrect readback of firmware version" 
>> What have I missed/done wrong?
>
> ... and it may not have a xc3028 onboard, or may have the low power 
> version which is why the firmware fails to load. A few other things 
> come to mind but given that the vendor has switch subid details, it's 
> probably best to cross reference with the wiki to ensure it still has 
> the same parts.
>
> Assuming the wiki entry truly doesn't exist, maybe you could create it 
> with the newer rev details, maybe with some pictures and component 
> details?
>
> - Steve
> I've e-mailed DViCo asking if there have been any recent changes to 
> the board. I'll get photos of the board later tonight.
John..
>
>
>
> ______________________________________________________________________
> This mail has been virus scanned and spam scanned by Australia On Line
> see http://www.australiaonline.net.au/spamscanning
>
> Report this email as spam...
> http://reportspam.australiaonline.net.au/servlet/mail/jknops/1238509492.1368_0.mailscanner2.ozonline.com.au/reportspam 
>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
