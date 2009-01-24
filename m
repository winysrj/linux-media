Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0O9YPQv026627
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 04:34:25 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0O9Y7QQ025768
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 04:34:07 -0500
Received: by rv-out-0506.google.com with SMTP id f6so5598777rvb.51
	for <video4linux-list@redhat.com>; Sat, 24 Jan 2009 01:34:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232717666.3271.1.camel@palomino.walls.org>
References: <c57f98ff0901211908y72160a7fx745b747d271ba80c@mail.gmail.com>
	<1232717666.3271.1.camel@palomino.walls.org>
Date: Sat, 24 Jan 2009 17:34:06 +0800
Message-ID: <c57f98ff0901240134q28480e22x465141e47e5b7e85@mail.gmail.com>
From: Alissa Harrison <alissa.m.harrison@gmail.com>
To: Andy Walls <awalls@radix.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: bttv driver not initializing card
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

Thanks, it is working now.  Actually I already had cleaned the computer
thoroughly before testing the first time.  But after getting your advice.  I
dusted once more, and used some rubbing alcohol on the connections.  And it
just worked. *shrug*  Dust is evil.

On Fri, Jan 23, 2009 at 9:34 PM, Andy Walls <awalls@radix.net> wrote:

> On Thu, 2009-01-22 at 11:08 +0800, Alissa Harrison wrote:
> > I cannot get the bttv driver to initialize my TV tuner card with
> mythbuntu
> > (Hardy Heron). The TV tuner is Leadtek WinFast 2000 XP and should be
> > supported by the bttv driver according to
> >
> http://linuxtv.org/hg/v4l-dvb/file/tip/linux/Documentation/video4linux/CARDLIST.bttv
> >
> > The card is listed in the output of lspci:
> >
> > 02:0d.0 Multimedia video controller: Brooktree Corporation Unknown device
> > 034e (rev 11)
> > Subsystem: LeadTek Research Inc. Unknown device 6609
> > Flags: bus master, medium devsel, latency 64, IRQ 5
> > Memory at faf00000 (32-bit, prefetchable) [size=4K]
> > Capabilities: <access denied>
> >
> > 02:0d.1 Multimedia controller: Brooktree Corporation Unknown device 0858
> > (rev 11)
> > Subsystem: LeadTek Research Inc. Unknown device 6609
> > Flags: bus master, medium devsel, latency 64, IRQ 5
> > Memory at faf01000 (32-bit, prefetchable) [size=4K]
> > Capabilities: <access denied>
> >
> > But when I attempt to modprobe bttv, it does not detect any card. No
> device
> > is assigned. The relevant output from dmesg is only two lines:
> >
> > [ 757.695711] bttv: driver version 0.9.17 loaded
> > [ 757.695721] bttv: using 8 buffers with 2080k (520 pages) each for
> capture
> >
> > I believe I should get output like
> >
> http://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_2000#Making_it_Work
> >
> > I have already tried plugging the card into other PCI slots. However, it
> is
> > not even detected by lspci in other slots. I am wondering if there is
> > something wrong with the motherboard here? The board is an ASUS P4P800.
> Can
> > anyone explain why the driver fails to initialize the card, or why lspci
> > fails to detect the card in other PCI slots?
>
> Remove your PCI cards, blow the dust out of the slots, reseat the cards,
> test again.
>
> Regards,
> Andy
>
> > Thanks,
> > Alissa
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com
> ?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
