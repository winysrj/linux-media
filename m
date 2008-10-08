Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m98LZnFe011722
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 17:35:49 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m98LZf5i006365
	for <video4linux-list@redhat.com>; Wed, 8 Oct 2008 17:35:42 -0400
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
In-Reply-To: <48EC18D7.3070807@edgehp.net>
References: <1222651357.2640.21.camel@morgan.walls.org>
	<48EC18D7.3070807@edgehp.net>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 17:35:31 -0400
Message-Id: <1223501731.2807.9.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: cx18: Fix needs test: more robust solution to get CX23418
	based cards to work reliably
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

On Tue, 2008-10-07 at 22:20 -0400, Dale Pontius wrote:
> Andy Walls wrote:
> > cx18 driver users:
> > 
> > In this repository:
> > 
> > http://linuxtv.org/hg/~awalls/cx18-mmio-fixes/
> > 
> Can't get there from here:

Yeah, I nuked that repo once Mauro merged the change into the main repo.


> I've been getting help from you with problems with my HVR-1600, and have
> a friend with WinXP machines who can likely help me out testing it, but
> he's been on vacation, and shortly I'll be gone for a bit.
> 
> In the meantime, since it appears that I've been having i2c problems and
> the mmio_ndelay gave me marginally better operation, I'd like to give
> this patch a try.  (Or is it folded into the main repository, already.)

Yes, it is in the main v4l-dvb repo now.


> Thanks,
> Dale Pontius

You're welcome.  Have fun testing.

Regards,
Andy



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
