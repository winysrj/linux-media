Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5R30WCZ019255
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 23:00:32 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5R30HdK000860
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 23:00:17 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KC4C4-0000NU-Gf
	for video4linux-list@redhat.com; Fri, 27 Jun 2008 03:00:12 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 03:00:12 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 27 Jun 2008 03:00:12 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Fri, 27 Jun 2008 03:00:01 +0000 (UTC)
Message-ID: <loom.20080627T025843-957@post.gmane.org>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
	<1206573402.3912.50.camel@pc08.localdom.local>
	<653f28469c9babb5326973c119fd78db@gimpelevich.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
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

Daniel Gimpelevich <daniel <at> gimpelevich.san-francisco.ca.us> writes:
> On Mar 26, 2008, at 4:16 PM, hermann pitton wrote:
> 
> > [snip]
> 
> I have since returned the card to its owner, but I did try the 
> composite-over-S setting, and I saw the S-video source when I did that, 
> but in monochrome. Therefore, I can only assume that setting works the 
> way it's designed, because I did not bother to jury-rig an S-video 
> connector that carries a true composite signal. I already had a 
> Signed-off-by in what I submitted, and you're welcome to carry that 
> forward to changes you make to the patch. As far as I'm concerned, 
> 5169/1502 needs to be recognized as card 39, notwithstanding any 
> differences from 5168/1502.

Hermann and Peter, I'm curious as to what remaining objections there were to 
adding the 5169/1502 subsystem ID to saa7134-cards.c, pointing to card #39. I 
can repeat my assurances that that was indeed absolutely the correct card 
definition.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
