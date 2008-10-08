Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m982IbCM021070
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 22:18:37 -0400
Received: from mho-01-bos.mailhop.org (mho-01-bos.mailhop.org [63.208.196.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m982IOiB031806
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 22:18:24 -0400
Message-ID: <48EC18D7.3070807@edgehp.net>
Date: Tue, 07 Oct 2008 22:20:07 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <1222651357.2640.21.camel@morgan.walls.org>
In-Reply-To: <1222651357.2640.21.camel@morgan.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: cx18: Fix needs test: more robust solution to get CX23418 based
 cards to work reliably
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

Andy Walls wrote:
> cx18 driver users:
> 
> In this repository:
> 
> http://linuxtv.org/hg/~awalls/cx18-mmio-fixes/
> 
Can't get there from here:

Mercurial Repositories

The specified repository "~awalls" is unknown, sorry. Please go back to
the main repository list page.

I can see that I'm a bit late, and maybe you've migrated
"cx-18-mmio-fixes" to somewhere else, but the error messages seems to
deny your existence at all, and that seems odd.

I've been getting help from you with problems with my HVR-1600, and have
a friend with WinXP machines who can likely help me out testing it, but
he's been on vacation, and shortly I'll be gone for a bit.

In the meantime, since it appears that I've been having i2c problems and
the mmio_ndelay gave me marginally better operation, I'd like to give
this patch a try.  (Or is it folded into the main repository, already.)

Thanks,
Dale Pontius
> is a change to the cx18 driver to (hopefully) improve reliability of
> CX23418 based cards operation in linux.  If all goes will, this change
> will supersede the "mmio_ndelay" hack, which I hope to phase out.
> 
> This change adds checks and retries to all PCI MMIO access to the
> CX23418 chip and adds a new module parameter 'retry_mmio' which is
> enabled by default.
> 
> With this change, the module defaults are set so the following
> statements are equivalent:
> 
> 	# modprobe cx18
> 	# modprobe cx18 retry_mmio=1 mmio_ndelay=0
> 
> 
> With checks and retries enabled, limited experiments have shown a card
> operates properly in my old Intel 82801AA based motherboard with this
> fix in place. I found that the mmio_ndelay parameter has little or no
> effect with these checks and retires enabled.
> 
> Experiments have also shown that, if you have previously had a problem
> with the cx18 driver/CX23418 in your system, then
> 
> 	# modprobe cx18 retry_mmio=0 mmio_delay=(something)
> 
> can put the CX23418 in a state, such that a reset is required to have
> the unit respond properly again when trying to reload cx18 driver
> another time.  (So my advice is don't turn off retry_mmio.)
> 
> If you've had to use the mmio_ndelay parameter in the past to get the
> card to work for you, or your card has never worked for you, please let
> me know how this patch works for you.
> 
> Regards,
> Andy
> 
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
