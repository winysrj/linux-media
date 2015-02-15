Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50117 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876AbbBOHxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 02:53:30 -0500
Message-ID: <1423986807.2688.1.camel@xs4all.nl>
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Raimonds Cicans <ray@apollo.lv>, linux-media@vger.kernel.org
Date: Sun, 15 Feb 2015 08:53:27 +0100
In-Reply-To: <54DDC2B7.2080503@xs4all.nl>
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>
			 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>
			 <54CE24F2.7090400@apollo.lv> <54CF4508.9070305@xs4all.nl>
		 <1423065972.2650.1.camel@xs4all.nl> <54D24685.1000708@xs4all.nl>
	 <1423070484.2650.3.camel@xs4all.nl> <54DDC00D.209@xs4all.nl>
	 <54DDC2B7.2080503@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 2015-02-13 at 10:24 +0100, Hans Verkuil wrote:
> Jurgen, Raimond,
> 
> On 02/13/2015 10:12 AM, Hans Verkuil wrote:
> > Hi Jurgen,
> > 
> > On 02/04/2015 06:21 PM, Jurgen Kramer wrote:
> >> On Wed, 2015-02-04 at 17:19 +0100, Hans Verkuil wrote:
> >>> On 02/04/2015 05:06 PM, Jurgen Kramer wrote:
> >>>> Hi Hans,
> >>>>
> >>>> On Mon, 2015-02-02 at 10:36 +0100, Hans Verkuil wrote:
> >>>>> Raimonds and Jurgen,
> >>>>>
> >>>>> Can you both test with the following patch applied to the driver:
> >>>>
> >>>> Unfortunately the mpeg error is not (completely) gone:
> >>>
> >>> OK, I suspected that might be the case. Is the UNBALANCED warning
> >>> gone with my vb2 patch?
> > 
> >>> When you see this risc error, does anything
> >>> break (broken up video) or crash, or does it just keep on streaming?
> > 
> > Can you comment on this question?
> > 
> >>
> >> The UNBALANCED warnings have not reappeared (so far).
> > 
> > And they are still gone? If that's the case, then I'll merge the patch
> > fixing this for 3.20.
> > 
> > With respect to the risc error: the only reason I can think of is that it
> > is a race condition when the risc program is updated. I'll see if I can
> > spend some time on this today or on Monday. Can you give me an indication
> > how often you see this risc error message?
> 
> Can you both apply this patch and let me know what it says the next time you
> get a risc error message? I just realized that important information was never
> logged, so with luck this might help me pinpoint the problem.
> 
So far I got one mpeg error:
[81639.485605] cx23885[2]: mpeg risc op code error 10001 0
[81639.485610] cx23885[2]: TS1 B - dma channel status dump
[81639.485612] cx23885[2]:   cmds: init risc lo   : 0x053aa000
[81639.485615] cx23885[2]:   cmds: init risc hi   : 0x00000000
[81639.485617] cx23885[2]:   cmds: cdt base       : 0x00010580
[81639.485620] cx23885[2]:   cmds: cdt size       : 0x0000000a
[81639.485622] cx23885[2]:   cmds: iq base        : 0x00010400
[81639.485625] cx23885[2]:   cmds: iq size        : 0x00000010
[81639.485628] cx23885[2]:   cmds: risc pc lo     : 0x048e5048
[81639.485630] cx23885[2]:   cmds: risc pc hi     : 0x00000000
[81639.485633] cx23885[2]:   cmds: iq wr ptr      : 0x00004105
[81639.485636] cx23885[2]:   cmds: iq rd ptr      : 0x00004109
[81639.485638] cx23885[2]:   cmds: cdt current    : 0x000105a8
[81639.485640] cx23885[2]:   cmds: pci target lo  : 0xadc44000
[81639.485642] cx23885[2]:   cmds: pci target hi  : 0x00000000
[81639.485645] cx23885[2]:   cmds: line / byte    : 0x00200000
[81639.485648] cx23885[2]:   risc0: 0x1c0002f0 [ write sol eol count=752
]
[81639.485651] cx23885[2]:   risc1: 0xadc44000 [ readc sol eol irq1 23
22 18 14 count=0 ]
[81639.485655] cx23885[2]:   risc2: 0x00000000 [ INVALID count=0 ]
[81639.485658] cx23885[2]:   risc3: 0x1c0002f0 [ write sol eol count=752
]
[81639.485661] cx23885[2]:   (0x00010400) iq 0: 0xadc448d0 [ readc sol
eol irq1 23 22 18 14 count=2256 ]
[81639.485665] cx23885[2]:   (0x00010404) iq 1: 0x00000000 [ INVALID
count=0 ]
[81639.485667] cx23885[2]:   (0x00010408) iq 2: 0x1c0002f0 [ write sol
eol count=752 ]
[81639.485670] cx23885[2]:   iq 3: 0xadc44bc0 [ arg #1 ]
[81639.485672] cx23885[2]:   iq 4: 0x00000000 [ arg #2 ]
[81639.485674] cx23885[2]:   (0x00010414) iq 5: 0x71000000 [ jump irq1
count=0 ]
[81639.485677] cx23885[2]:   iq 6: 0x1c0002f0 [ arg #1 ]
[81639.485679] cx23885[2]:   iq 7: 0xadc44000 [ arg #2 ]
[81639.485682] cx23885[2]:   (0x00010420) iq 8: 0x00000000 [ INVALID
count=0 ]
[81639.485684] cx23885[2]:   (0x00010424) iq 9: 0x1c0002f0 [ write sol
eol count=752 ]
[81639.485687] cx23885[2]:   iq a: 0xadc442f0 [ arg #1 ]
[81639.485689] cx23885[2]:   iq b: 0x00000000 [ arg #2 ]
[81639.485691] cx23885[2]:   (0x00010430) iq c: 0x1c0002f0 [ write sol
eol count=752 ]
[81639.485694] cx23885[2]:   iq d: 0xadc445e0 [ arg #1 ]
[81639.485696] cx23885[2]:   iq e: 0x00000000 [ arg #2 ]
[81639.485698] cx23885[2]:   (0x0001043c) iq f: 0x1c0002f0 [ write sol
eol count=752 ]
[81639.485701] cx23885[2]:   iq 10: 0x3efdbb2f [ arg #1 ]
[81639.485704] cx23885[2]:   iq 11: 0xbb1ae8fd [ arg #2 ]
[81639.485704] cx23885[2]: fifo: 0x00005000 -> 0x6000
[81639.485705] cx23885[2]: ctrl: 0x00010400 -> 0x10460
[81639.485707] cx23885[2]:   ptr1_reg: 0x00005700
[81639.485709] cx23885[2]:   ptr2_reg: 0x000105a8
[81639.485711] cx23885[2]:   cnt1_reg: 0x00000012
[81639.485714] cx23885[2]:   cnt2_reg: 0x00000005

Best regards,
Jurgen

