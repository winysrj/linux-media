Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7GGnMF9004516
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 12:49:23 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7GGnAo5011312
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 12:49:10 -0400
Date: Sat, 16 Aug 2008 18:48:49 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Nakarin Lamangthong <lnakarin@gmail.com>
Message-ID: <20080816164849.GA386@daniel.bse>
References: <443ddfb30808141632l30b6fbefgda1bb2a1f6bbe028@mail.gmail.com>
	<20080815000205.GA1359@daniel.bse>
	<443ddfb30808142020n4694e927r6a14fd095585604a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <443ddfb30808142020n4694e927r6a14fd095585604a@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Commell MP-878D first time error
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

On Fri, Aug 15, 2008 at 10:20:54AM +0700, Nakarin Lamangthong wrote:
> >As your card can't be detected, you need to load the bttv module
> >with pll=28 to be able to decode PAL signals.
> 
> How can i do that?  Please tell me the step that fix it.

It's been some time since I last tried Debian, but I think you can
do this with modconf as mentioned in
http://www.debian.org/doc/FAQ/ch-kernel.en.html#s-modules

Alternatively you can manually add the line
options bttv pll=28
to a new file in /etc/modprobe.d/ as explained in
http://www.mail-archive.com/debian-alpha@lists.debian.org/msg24367.html

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
