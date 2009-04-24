Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3OMTP5B022669
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:29:25 -0400
Received: from mail.bcode.com (mail.bcode.com [150.101.204.108] (may be
	forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3OMT8wl025345
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:29:08 -0400
Date: Sat, 25 Apr 2009 08:29:06 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: video4linux-list@redhat.com
Message-Id: <20090425082906.a1a3b872.erik@bcode.com>
In-Reply-To: <412bdbff0904241522s4466fe3dh3fadd3b21113e60@mail.gmail.com>
References: <20090424170352.313f1feb.erik@bcode.com>
	<412bdbff0904240625y3902243em5a643380b036e08f@mail.gmail.com>
	<20090425080356.69e0ed9d.erik@bcode.com>
	<412bdbff0904241509r29b0859fl22abe2fe78e59daa@mail.gmail.com>
	<20090425081654.3e9932f1.erik@bcode.com>
	<412bdbff0904241522s4466fe3dh3fadd3b21113e60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: Compling drivers from v4l-dvb hg tree
Reply-To: video4linux-list@redhat.com
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

On Fri, 24 Apr 2009 18:22:40 -0400
Devin Heitmueller <devin.heitmueller@gmail.com> wrote:

> Yeah, that's a bit harder.  I did it a couple of months ago for ARM.
> I had to change the path to ensure the path to the cross-compiler's
> version of strip was ahead of the base operating system's version.

Well both my compile machine and my target are running x86 Ubuntu.
The only really relevant difference is that they have different 
kernels, 2.6.26 on the compile machine and 2.6.29 on the target.

I've looked at the top level Makefile but there doesn't seem to be
a way os specifying compiling against another kernel.

Erik
-- 
=======================
erik de castro lopo
senior design engineer

bCODE
level 2, 2a glen street
milsons point
sydney nsw 2061
australia

tel +61 (0)2 9954 4411
fax +61 (0)2 9954 4422
www.bcode.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
