Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m96IPAY7014512
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 14:25:10 -0400
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m96IOLcH025669
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 14:24:22 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: OJ <olejl77@gmail.com>
In-Reply-To: <19619f3b0810060628w5dcea635t8ccb7aeae75d58d7@mail.gmail.com>
References: <19619f3b0810060628w5dcea635t8ccb7aeae75d58d7@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 20:18:00 +0200
Message-Id: <1223317080.2668.6.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Problem with TT-Budget S-1500 DVB-S card (saa7146)
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

Hi OJ,

Am Montag, den 06.10.2008, 17:28 +0400 schrieb OJ:
> I'm running FC9 with the following kernel:
> 2.6.26.5-45.fc9.x86_64
> 
> I had my DVB card up and working "out of box" a couple of months ago.
> Now I am trying again, and things are not working any more.
> 
> There is no dvb0 in my /dev folder. (It used to be when things were working).
> 
> '/sbin/lspci -nn' gives me:
> 00:00.0 Host bridge [0600]: Intel Corporation 82G33/G31/P35/P31
> Express DRAM Controller [8086:29c0] (rev 02)
> 00:01.0 PCI bridge [0604]: Intel Corporation 82G33/G31/P35/P31 Express
> PCI Express Root Port [8086:29c1] (rev 02)
> 00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB UHCI Controller #4 [8086:2937] (rev 02)
> 00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB UHCI Controller #5 [8086:2938] (rev 02)
> 00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB UHCI Controller #6 [8086:2939] (rev 02)
> 00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB2 EHCI Controller #2 [8086:293c] (rev 02)
> 00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD
> Audio Controller [8086:293e] (rev 02)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI
> Express Port 1 [8086:2940] (rev 02)
> 00:1c.4 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI
> Express Port 5 [8086:2948] (rev 02)
> 00:1c.5 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI
> Express Port 6 [8086:294a] (rev 02)
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB UHCI Controller #1 [8086:2934] (rev 02)
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB UHCI Controller #2 [8086:2935] (rev 02)
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB UHCI Controller #3 [8086:2936] (rev 02)
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family)
> USB2 EHCI Controller #1 [8086:293a] (rev 02)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge
> [8086:244e] (rev 92)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801IR (ICH9R) LPC
> Interface Controller [8086:2916] (rev 02)
> 00:1f.2 IDE interface [0101]: Intel Corporation 82801IR/IO/IH
> (ICH9R/DO/DH) 4 port SATA IDE Controller [8086:2920] (rev 02)
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus
> Controller [8086:2930] (rev 02)
> 00:1f.5 IDE interface [0101]: Intel Corporation 82801I (ICH9 Family) 2
> port SATA IDE Controller [8086:2926] (rev 02)
> 01:00.0 VGA compatible controller [0300]: nVidia Corporation NV44
> [GeForce 6200 TurboCache(TM)] [10de:0161] (rev a1)
> 02:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
> 88E8056 PCI-E Gigabit Ethernet Controller [11ab:4364] (rev 12)
> 03:00.0 SATA controller [0106]: JMicron Technologies, Inc. JMicron
> 20360/20363 AHCI Controller [197b:2363] (rev 03)
> 03:00.1 IDE interface [0101]: JMicron Technologies, Inc. JMicron
> 20360/20363 AHCI Controller [197b:2363] (rev 03)
> 05:00.0 Network controller [0280]: Broadcom Corporation BCM4318
> [AirForce One 54g] 802.11g Wireless LAN Controller [14e4:4318] (rev
> 02)
> 05:02.0 Multimedia controller [0480]: Philips Semiconductors SAA7146
> [1131:7146] (rev 01)
> 05:03.0 FireWire (IEEE 1394) [0c00]: Agere Systems FW323 [11c1:5811] (rev 70)
> 05:04.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL-8110SC/8169SC Gigabit Ethernet [10ec:8167] (rev 10)
> 
> (one strange thing is the gap from 05:00.0 to 05:02.0....)
> 
> 'dmesg | grep saa' gives me:
> Audiowerk 2 sound card (saa7146 chipset) detected and managed
> saa7146: register extension 'budget_ci dvb'.
> 
> 'dmesg | grep dvb' gives me:
> saa7146: register extension 'budget_ci dvb'.
> 
> Can someone please help me configure this card properly? I'm running
> out of options... At first I suspected that the card was loose or even
> not working. I have verified that the card is not loose. I have also
> changed PCI slot without success.
> 
> (I just verified that the card is working by installing MediaPortal on
> Windows Vista. The card was detected and I could watch my satellite
> channels.)
> 

quoting Oliver and Michael from the linux-dvb ML might help.


> Complain to the developers of the Audiowerk2 driver for this:
> 
> | static struct pci_device_id snd_aw2_ids[] = {
> |       {PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID,
> PCI_ANY_ID,
> |        0, 0, 0},
> |       {0}
> | };
> 
> This will grab _all_ saa7146-based cards. :-(
> 
> For now you should blacklist that driver.
> 
> CU
> Oliver
> 


> Hi Tom,
> 
> The name of module is snd_aw2. Just add it to
> the /etc/modprobe.d/blacklist

Or remove it and "depmod -a".

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
