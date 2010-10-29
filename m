Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902Ab0J2Tg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 15:36:56 -0400
Date: Fri, 29 Oct 2010 15:36:53 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] mceusb: fix up reporting of trailing space
Message-ID: <20101029193652.GF21604@redhat.com>
References: <20101029030545.GA17238@redhat.com>
 <20101029030810.GC17238@redhat.com>
 <20101029192121.GB12136@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101029192121.GB12136@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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

Hm, yeah, it probably would. Hadn't even thought to look at that. I'll
give that a closer look...

-- 
Jarod Wilson
jarod@redhat.com

