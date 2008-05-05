Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4513pQh006371
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 21:03:51 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4513d0G004295
	for <video4linux-list@redhat.com>; Sun, 4 May 2008 21:03:39 -0400
From: Andy Walls <awalls@radix.net>
To: Xefur Ragnarok <x3fur@yahoo.com>
In-Reply-To: <652962.17032.qm@web63111.mail.re1.yahoo.com>
References: <652962.17032.qm@web63111.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Sun, 04 May 2008 21:03:39 -0400
Message-Id: <1209949419.3218.41.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: WinTV PVR PCI
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

On Sun, 2008-05-04 at 12:43 -0700, Xefur Ragnarok wrote:
> When you mentioned that there might be a corrupt line in the card's
> hardware, I decided to take it out and remove any dust from it, and
> switched the slot that it was in. It came back up and was recognized
> immediately, and worked immediately as well.

Excellent. :)

> I sincerely appreciate you sticking with me, even though there wasnt
> really anything wrong lol....
> 
> Thanks for your time!
> 
> Timothy

You're welcome.  Glad to help.

-Andy


> Andy Walls <awalls@radix.net> wrote:
>         > I looked through the contents of the bttv driver source, and saw where
>         > the 0070:4500 line is, and what it says it is. But what is still
>         > making me wonder if it is related to the PCI ID is when I do lspci it
>         > says its an unknown board:
>         > 
>         > 01:02.0 Multimedia video controller: Unknown device 009e:036e (rev 11)
>         > 01:02.1 Multimedia controller: Unknown device 009e:0878 (rev 11)
>         
>         Don't worry about lspci, even if it doesn't know, the proper driver can
>         know. The 009e is really supposed to be 109e for Brooktree. Somehow
>         the configuration data on the card got mangled (or maybe the card has a
>         bad data line or some other defect?).
>         
>         
>         > lspci -nv
>         > 
>         > 01:02.0 0400: 009e:036e (rev 11)
>         > Subsystem: 0070:4500
>         > Flags: bus master, medium devsel, latency 32, IRQ 9
>         > Memory at d6afc000 (32-bit, prefetchable) [size=8K]
>         > Capabilities: [44] Vital Product Data
>         > Capabilities: [4c] Power Management version 2
>         > 
>         > 01:02.1 0480: 009e:0878 (rev 11)
>         > Subsystem: 0070:4500
>         > Flags: bus master, medium devsel, latency 32, IRQ 9
>         > Memory at d6afe000 (32-bit, prefetchable) [size=8K]
>         > Capabilities: [44] Vital Product Data
>         > Capabilities: [4c] Power Management version 2
>         > 
>         > The subsystem is right, but the main vendor ID of the card is
>         > unrecognized anywhere. Its not even listed on the PCI-ID's website.
>         
>         The 0070 is Hauppauge's ID. The 009e:0878 is really supposed to be
>         109e:0878 for Brooktree's Bt878 chip. I believe Conexant swallowed up
>         Brooktree; Brooktree is long defunct.
>         
>         > The card I have is apparently ancient. I'm positive that its a winTV
>         > PVR/PCI card though. Maybe I should just buy a new card? lol...
>         
>         Maybe, but not because it's old, but because it's configuration data is
>         slightly corrupt, one has to wonder what other problems the card has.

>         Good luck.
>         
>         -Andy


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
