Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:50842 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965247AbbBDQGP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 11:06:15 -0500
Message-ID: <1423065972.2650.1.camel@xs4all.nl>
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Raimonds Cicans <ray@apollo.lv>, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org
Date: Wed, 04 Feb 2015 17:06:12 +0100
In-Reply-To: <54CF4508.9070305@xs4all.nl>
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>
	 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>
	 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
> On 02/01/2015 02:06 PM, Raimonds Cicans wrote:
> > On 29.01.2015 14:12, Hans Verkuil wrote:
> >> On 01/29/15 12:51, Raimonds Cicans wrote:
> >>> On 29.01.2015 09:33, Hans Verkuil wrote:
> >>>> On 01/11/2015 10:33 AM, Raimonds Cicans wrote:
> >>>>> I contacted you because I am hit by regression caused by your commit:
> >>>>> 453afdd "[media] cx23885: convert to vb2"
> >>>>>
> >>>>>
> >>>>> My system:
> >>>>> AMD Athlon(tm) II X2 240e Processor on Asus M5A97 LE R2.0 motherboard
> >>>>> TBS6981 card (Dual DVB-S/S2 PCIe receiver, cx23885 in kernel driver)
> >>>>>
> >>>>> After upgrade from kernel 3.13.10 (do not have commit) to 3.17.7
> >>>>> (have commit) I started receiving following IOMMU related messages:
> >>>>>
> >>>>> 1)
> >>>>> AMD-Vi: Event logged [IO_PAGE_FAULT device=0a:00.0 domain=0x001d
> >>>>> address=0x000000000637c000 flags=0x0000]
> >>>>>
> >>>>> where device=0a:00.0 is TBS6981 card
> >>>> As far as I can tell this has nothing to do with the cx23885 driver but is
> >>>> a bug in the amd iommu/BIOS. See e.g.:
> >>>>
> >>>> https://bbs.archlinux.org/viewtopic.php?pid=1309055
> >>>>
> >>>> I managed to reproduce the Intel equivalent if I enable CONFIG_IOMMU_SUPPORT.
> >>>>
> >>>> Most likely due to broken BIOS/ACPI/whatever information that's read by the
> >>>> kernel. I would recommend disabling this kernel option.
> >>>>
> >>> Maybe...
> >>>
> >>> But on other hand this did not happen on old kernel with old driver.
> >>> And when I did bisection on old kernel + media tree I started to
> >>> receive this message only on new driver.
> >> Was CONFIG_IOMMU_SUPPORT enabled in the old kernel?
> > 
> > zgrep CONFIG_IOMMU_SUPPORT /proc/config.gz
> > CONFIG_IOMMU_SUPPORT=y
> > 
> > 
> > Raimonds Cicans
> > 
> 
> Raimonds and Jurgen,
> 
> Can you both test with the following patch applied to the driver:
Unfortunately the mpeg error is not (completely) gone:

[  172.946876] dvb_ca adapter 0: DVB CAM detected and initialised
successfully
[  276.938186] dvb_ca adapter 1: DVB CAM detected and initialised
successfully
[  405.007902] dvb_ca adapter 2: DVB CAM detected and initialised
successfully
[ 8031.928944] traps: polkitd[1017] general protection ip:7f8754445022
sp:7fff3ef612d0 error:0 in libmozjs-17.0.so[7f8754306000+3b3000]
[18977.465763] perf interrupt took too long (2510 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
[60407.000404] cx23885[1]: mpeg risc op code error
[60407.000409] cx23885[1]: TS1 B - dma channel status dump
[60407.000411] cx23885[1]:   cmds: init risc lo   : 0xb8869000
[60407.000414] cx23885[1]:   cmds: init risc hi   : 0x00000000
[60407.000417] cx23885[1]:   cmds: cdt base       : 0x00010580
[60407.000420] cx23885[1]:   cmds: cdt size       : 0x0000000a
[60407.000422] cx23885[1]:   cmds: iq base        : 0x00010400
[60407.000425] cx23885[1]:   cmds: iq size        : 0x00000010
[60407.000427] cx23885[1]:   cmds: risc pc lo     : 0xc9601048
[60407.000430] cx23885[1]:   cmds: risc pc hi     : 0x00000000
[60407.000433] cx23885[1]:   cmds: iq wr ptr      : 0x00004105
[60407.000435] cx23885[1]:   cmds: iq rd ptr      : 0x00004109
[60407.000438] cx23885[1]:   cmds: cdt current    : 0x000105a8
[60407.000441] cx23885[1]:   cmds: pci target lo  : 0xb8988000
[60407.000443] cx23885[1]:   cmds: pci target hi  : 0x00000000
[60407.000445] cx23885[1]:   cmds: line / byte    : 0x00200000
[60407.000448] cx23885[1]:   risc0: 0x1c0002f0 [ write sol eol count=752
]
[60407.000452] cx23885[1]:   risc1: 0xb8988000 [ writerm sol 23 20 19
resync count=0 ]
[60407.000455] cx23885[1]:   risc2: 0x00000000 [ INVALID count=0 ]
[60407.000457] cx23885[1]:   risc3: 0x1c0002f0 [ write sol eol count=752
]
[60407.000460] cx23885[1]:   (0x00010400) iq 0: 0xb89888d0 [ writerm sol
23 20 19 resync count=2256 ]
[60407.000464] cx23885[1]:   iq 1: 0x00000000 [ arg #1 ]
[60407.000466] cx23885[1]:   iq 2: 0x1c0002f0 [ arg #2 ]
[60407.000468] cx23885[1]:   (0x0001040c) iq 3: 0xb8988bc0 [ writerm sol
23 20 19 resync count=3008 ]
[60407.000472] cx23885[1]:   iq 4: 0x00000000 [ arg #1 ]
[60407.000474] cx23885[1]:   iq 5: 0x71000000 [ arg #2 ]
[60407.000476] cx23885[1]:   (0x00010418) iq 6: 0x1c0002f0 [ write sol
eol count=752 ]
[60407.000479] cx23885[1]:   iq 7: 0xb8988000 [ arg #1 ]
[60407.000481] cx23885[1]:   iq 8: 0x00000000 [ arg #2 ]
[60407.000483] cx23885[1]:   (0x00010424) iq 9: 0x1c0002f0 [ write sol
eol count=752 ]
[60407.000486] cx23885[1]:   iq a: 0xb89882f0 [ arg #1 ]
[60407.000488] cx23885[1]:   iq b: 0x00000000 [ arg #2 ]
[60407.000490] cx23885[1]:   (0x00010430) iq c: 0x1c0002f0 [ write sol
eol count=752 ]
[60407.000493] cx23885[1]:   iq d: 0xb89885e0 [ arg #1 ]
[60407.000495] cx23885[1]:   iq e: 0x00000000 [ arg #2 ]
[60407.000497] cx23885[1]:   (0x0001043c) iq f: 0x1c0002f0 [ write sol
eol count=752 ]
[60407.000500] cx23885[1]:   iq 10: 0x6a76032d [ arg #1 ]
[60407.000502] cx23885[1]:   iq 11: 0x3a68baa3 [ arg #2 ]
[60407.000503] cx23885[1]: fifo: 0x00005000 -> 0x6000
[60407.000504] cx23885[1]: ctrl: 0x00010400 -> 0x10460
[60407.000506] cx23885[1]:   ptr1_reg: 0x00005860
[60407.000508] cx23885[1]:   ptr2_reg: 0x000105a8
[60407.000511] cx23885[1]:   cnt1_reg: 0x00000028
[60407.000513] cx23885[1]:   cnt2_reg: 0x00000005
[63048.983736] dvb_ca adapter 2: DVB CAM detected and initialised
successfully
[97553.449010] dvb_ca adapter 0: DVB CAM detected and initialised
successfully

Regards,
Jurgen

