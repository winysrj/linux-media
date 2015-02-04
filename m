Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:38213 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965937AbbBDQT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 11:19:59 -0500
Message-ID: <54D24685.1000708@xs4all.nl>
Date: Wed, 04 Feb 2015 17:19:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jurgen Kramer <gtmkramer@xs4all.nl>
CC: Raimonds Cicans <ray@apollo.lv>, linux-media@vger.kernel.org
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>	 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>	 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl> <1423065972.2650.1.camel@xs4all.nl>
In-Reply-To: <1423065972.2650.1.camel@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/2015 05:06 PM, Jurgen Kramer wrote:
> Hi Hans,
> 
> On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
>> Raimonds and Jurgen,
>>
>> Can you both test with the following patch applied to the driver:
>
> Unfortunately the mpeg error is not (completely) gone:

OK, I suspected that might be the case. Is the UNBALANCED warning
gone with my vb2 patch? When you see this risc error, does anything
break (broken up video) or crash, or does it just keep on streaming?

Raimond, do you still see the AMD iommu faults with this patch?

Regards,

	Hans

> 
> [  172.946876] dvb_ca adapter 0: DVB CAM detected and initialised
> successfully
> [  276.938186] dvb_ca adapter 1: DVB CAM detected and initialised
> successfully
> [  405.007902] dvb_ca adapter 2: DVB CAM detected and initialised
> successfully
> [ 8031.928944] traps: polkitd[1017] general protection ip:7f8754445022
> sp:7fff3ef612d0 error:0 in libmozjs-17.0.so[7f8754306000+3b3000]
> [18977.465763] perf interrupt took too long (2510 > 2500), lowering
> kernel.perf_event_max_sample_rate to 50000
> [60407.000404] cx23885[1]: mpeg risc op code error
> [60407.000409] cx23885[1]: TS1 B - dma channel status dump
> [60407.000411] cx23885[1]:   cmds: init risc lo   : 0xb8869000
> [60407.000414] cx23885[1]:   cmds: init risc hi   : 0x00000000
> [60407.000417] cx23885[1]:   cmds: cdt base       : 0x00010580
> [60407.000420] cx23885[1]:   cmds: cdt size       : 0x0000000a
> [60407.000422] cx23885[1]:   cmds: iq base        : 0x00010400
> [60407.000425] cx23885[1]:   cmds: iq size        : 0x00000010
> [60407.000427] cx23885[1]:   cmds: risc pc lo     : 0xc9601048
> [60407.000430] cx23885[1]:   cmds: risc pc hi     : 0x00000000
> [60407.000433] cx23885[1]:   cmds: iq wr ptr      : 0x00004105
> [60407.000435] cx23885[1]:   cmds: iq rd ptr      : 0x00004109
> [60407.000438] cx23885[1]:   cmds: cdt current    : 0x000105a8
> [60407.000441] cx23885[1]:   cmds: pci target lo  : 0xb8988000
> [60407.000443] cx23885[1]:   cmds: pci target hi  : 0x00000000
> [60407.000445] cx23885[1]:   cmds: line / byte    : 0x00200000
> [60407.000448] cx23885[1]:   risc0: 0x1c0002f0 [ write sol eol count=752
> ]
> [60407.000452] cx23885[1]:   risc1: 0xb8988000 [ writerm sol 23 20 19
> resync count=0 ]
> [60407.000455] cx23885[1]:   risc2: 0x00000000 [ INVALID count=0 ]
> [60407.000457] cx23885[1]:   risc3: 0x1c0002f0 [ write sol eol count=752
> ]
> [60407.000460] cx23885[1]:   (0x00010400) iq 0: 0xb89888d0 [ writerm sol
> 23 20 19 resync count=2256 ]
> [60407.000464] cx23885[1]:   iq 1: 0x00000000 [ arg #1 ]
> [60407.000466] cx23885[1]:   iq 2: 0x1c0002f0 [ arg #2 ]
> [60407.000468] cx23885[1]:   (0x0001040c) iq 3: 0xb8988bc0 [ writerm sol
> 23 20 19 resync count=3008 ]
> [60407.000472] cx23885[1]:   iq 4: 0x00000000 [ arg #1 ]
> [60407.000474] cx23885[1]:   iq 5: 0x71000000 [ arg #2 ]
> [60407.000476] cx23885[1]:   (0x00010418) iq 6: 0x1c0002f0 [ write sol
> eol count=752 ]
> [60407.000479] cx23885[1]:   iq 7: 0xb8988000 [ arg #1 ]
> [60407.000481] cx23885[1]:   iq 8: 0x00000000 [ arg #2 ]
> [60407.000483] cx23885[1]:   (0x00010424) iq 9: 0x1c0002f0 [ write sol
> eol count=752 ]
> [60407.000486] cx23885[1]:   iq a: 0xb89882f0 [ arg #1 ]
> [60407.000488] cx23885[1]:   iq b: 0x00000000 [ arg #2 ]
> [60407.000490] cx23885[1]:   (0x00010430) iq c: 0x1c0002f0 [ write sol
> eol count=752 ]
> [60407.000493] cx23885[1]:   iq d: 0xb89885e0 [ arg #1 ]
> [60407.000495] cx23885[1]:   iq e: 0x00000000 [ arg #2 ]
> [60407.000497] cx23885[1]:   (0x0001043c) iq f: 0x1c0002f0 [ write sol
> eol count=752 ]
> [60407.000500] cx23885[1]:   iq 10: 0x6a76032d [ arg #1 ]
> [60407.000502] cx23885[1]:   iq 11: 0x3a68baa3 [ arg #2 ]
> [60407.000503] cx23885[1]: fifo: 0x00005000 -> 0x6000
> [60407.000504] cx23885[1]: ctrl: 0x00010400 -> 0x10460
> [60407.000506] cx23885[1]:   ptr1_reg: 0x00005860
> [60407.000508] cx23885[1]:   ptr2_reg: 0x000105a8
> [60407.000511] cx23885[1]:   cnt1_reg: 0x00000028
> [60407.000513] cx23885[1]:   cnt2_reg: 0x00000005
> [63048.983736] dvb_ca adapter 2: DVB CAM detected and initialised
> successfully
> [97553.449010] dvb_ca adapter 0: DVB CAM detected and initialised
> successfully
> 
> Regards,
> Jurgen
> 

