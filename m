Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1CGlH0a016053
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 11:47:17 -0500
Received: from www.datavault.us (flatoutfitness.com [66.178.130.209])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1CGkbtO010481
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 11:46:38 -0500
Received: from localhost ([127.0.0.1] helo=www.datavault.us ident=www-data)
	by www.datavault.us with esmtp (Exim 4.68)
	(envelope-from <yan@seiner.com>) id 1JOyIh-0005IB-QA
	for video4linux-list@redhat.com; Tue, 12 Feb 2008 08:48:07 -0800
Message-ID: <36145.199.79.32.17.1202834887.squirrel@www.datavault.us>
Date: Tue, 12 Feb 2008 08:48:07 -0800 (PST)
From: yan@seiner.com
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: cx8800 DMA timeouts
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

[Sorry Alexander, this was meant for the list]

> Hello,
>
> We have setup with Hauppauge WinTV model 34504.
> We using that card only for taking SVideo capture. After few hours of
work it sends the following messages and video capture is not working
until module cx8800 is reloaded.
> Does anybody had such problem or has an idea? Searching via mailinglist and
> google didnt helped. There was few problems but related wrong tuner.
>
> Feb 10 22:46:52 ag kernel: cx88[0]: video y / packed - dma channel
status dump
> Feb 10 22:46:52 ag kernel: cx88[0]:   cmds: initial risc: 0x08d34000 Feb
10 22:46:52 ag kernel: cx88[0]:   cmds: cdt base    : 0x00180440 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: cdt size    : 0x0000000c Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: iq base     : 0x00180400 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: iq size     : 0x00000010 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: risc pc     : 0x00000000 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: iq wr ptr   : 0x00000000 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: iq rd ptr   : 0x00000101 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: cdt current : 0x00000448 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: pci target  : 0x00000000 Feb 10
22:46:52 ag kernel: cx88[0]:   cmds: line / byte : 0x00000000 Feb 10
22:46:52 ag kernel: cx88[0]:   risc0: 0x80008200 [ sync resync count=512
]
> Feb 10 22:46:52 ag kernel: cx88[0]:   risc1: 0x1c0002c0 [ write sol eol
count=704 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   risc2: 0x08d72000 [ INVALID sol 23 22
> 20 18 cnt1 cnt0 13 count=0 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   risc3: 0x1c0002c0 [ write sol eol
count=704 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq 0: 0x80008200 [ sync resync
count=512 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq 1: 0x1c0002c0 [ write sol eol
count=704 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq 2: 0x08d72000 [ arg #1 ] Feb 10
22:46:52 ag kernel: cx88[0]:   iq 3: 0x1c0002c0 [ write sol eol
count=704 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq 4: 0x08d722c0 [ arg #1 ] Feb 10
22:46:52 ag kernel: cx88[0]:   iq 5: 0x1c0002c0 [ write sol eol
count=704 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq 6: 0x08d72580 [ arg #1 ] Feb 10
22:46:52 ag kernel: cx88[0]:   iq 7: 0x1c0002c0 [ write sol eol
count=704 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq 8: 0x08d70280 [ arg #1 ] Feb 10
22:46:52 ag kernel: cx88[0]:   iq 9: 0x1c0002c0 [ write sol eol
count=704 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq a: 0x08d70540 [ arg #1 ] Feb 10
22:46:52 ag kernel: cx88[0]:   iq b: 0x71010000 [ jump irq1 cnt0 count=0
]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq c: 0xd2000001 [ arg #1 ] Feb 10
22:46:52 ag kernel: cx88[0]:   iq d: 0x0031c040 [ INVALID 21 20 cnt0
> resync 14 count=64 ]
> Feb 10 22:46:52 ag kernel: cx88[0]:   iq e: 0x00000000 [ INVALID count=0
] Feb 10 22:46:52 ag kernel: cx88[0]:   iq f: 0x00000011 [ INVALID
count=17 ]
> Feb 10 22:46:52 ag kernel: cx88[0]: fifo: 0x00180c00 -> 0x183400 Feb 10
22:46:52 ag kernel: cx88[0]: ctrl: 0x00180400 -> 0x180460 Feb 10
22:46:52 ag kernel: cx88[0]:   ptr1_reg: 0x00181540
> Feb 10 22:46:52 ag kernel: cx88[0]:   ptr2_reg: 0x00180478
> Feb 10 22:46:52 ag kernel: cx88[0]:   cnt1_reg: 0x0000002c
> Feb 10 22:46:52 ag kernel: cx88[0]:   cnt2_reg: 0x00000000
> Feb 10 22:46:52 ag kernel: cx88[0]/0: [c8ae0780/1] timeout -
> dma=0x08d34000
> Feb 10 22:46:52 ag kernel: cx88[0]/0: [d7df6f00/0] timeout -
> dma=0x08d71000
>

I'm seeing a similar problem.  I've upgraded to 2.6.24 + bleeding edge DVB
drivers; no joy.

At some point - could be hours, could be weeks - the card just quits
sending any data.  There is no error recorded anywhere.  AFAICT myth can
still tune the card; it just gets no data.

It *may* be triggered by high PCI bus activity, but I have not been able
to find any single trigger for this.

It's very frustrating; it may be a recent change as the card worked fine
with older (2.6.20) kernels.

--Yan



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
