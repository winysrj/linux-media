Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:7077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab0KBVMS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 17:12:18 -0400
Date: Tue, 2 Nov 2010 17:12:14 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] mceusb: fix up reporting of trailing space
Message-ID: <20101102211214.GC20631@redhat.com>
References: <20101029030545.GA17238@redhat.com>
 <20101029030810.GC17238@redhat.com>
 <20101029192121.GB12136@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101029192121.GB12136@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 09:21:21PM +0200, David Härdeman wrote:
> On Thu, Oct 28, 2010 at 11:08:10PM -0400, Jarod Wilson wrote:
> > We were storing a bunch of spaces at the end of each signal, rather than
> > a single long space. The in-kernel decoders were actually okay with
> > this, but lirc isn't. Both are happy again with this change, which
> > starts accumulating data upon seeing an 0x7f space, and then stores it
> > when we see the next non-space, non-0x7f space, or an 0x80 end of signal
> > command. To get to that final 0x80 properly, we also need to support
> > proper parsing of 0x9f 0x01 commands, support for which is also added.
> 
> I think the driver could be further simplified by using 
> ir_raw_event_store_with_filter(), right?

And in fact, it is. I've got a new series of patches redone atop your
rc-core patch series that includes usage of _with_filter in mceusb.

http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-ir.git;a=shortlog;h=refs/heads/staging

And more specifically, the update of this patch:

http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-ir.git;a=commitdiff;h=bc3d1300cd2d51dc8d877be343382d8932320dfc

Still a bit of testing to do before I send v2 off to the list, plus I'd
like to know where we're at w/your patches first wrt getting them
committed, just in case I need to rework them slightly.

-- 
Jarod Wilson
jarod@redhat.com

