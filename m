Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3OMHDsN018225
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:17:13 -0400
Received: from mail.bcode.com (mail.bcode.com [150.101.204.108] (may be
	forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3OMGtCd019210
	for <video4linux-list@redhat.com>; Fri, 24 Apr 2009 18:16:56 -0400
Date: Sat, 25 Apr 2009 08:16:54 +1000
From: Erik de Castro Lopo <erik@bcode.com>
To: video4linux-list@redhat.com
Message-Id: <20090425081654.3e9932f1.erik@bcode.com>
In-Reply-To: <412bdbff0904241509r29b0859fl22abe2fe78e59daa@mail.gmail.com>
References: <20090424170352.313f1feb.erik@bcode.com>
	<412bdbff0904240625y3902243em5a643380b036e08f@mail.gmail.com>
	<20090425080356.69e0ed9d.erik@bcode.com>
	<412bdbff0904241509r29b0859fl22abe2fe78e59daa@mail.gmail.com>
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

On Fri, 24 Apr 2009 18:09:17 -0400
Devin Heitmueller <devin.heitmueller@gmail.com> wrote:

> > Ok, but how do I patch the v4l-dvb sources into a linux kernel tree?
> 
> You don't.
> 
> The v4l-dvb sources are maintained out-of-tree, and override whatever
> is in the linux kernel tree.  Periodically, the v4l-dvb maintainer
> syncs with the kernel tree and the changes are pushed upstream into
> the mainline kernel.  This approach allows for the v4l-dvb project to
> be used with kernel releases other than the current bleeding edge
> kernel.

Ok,  but the instructions on http://linuxtv.org/repo compiles the
driver for the current running kernel. How do I compile it for 
another kernel, ie an x86 embedded device that I normally do not
compile on?

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
