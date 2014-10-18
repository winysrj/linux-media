Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:36604 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaJRSTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Oct 2014 14:19:05 -0400
Date: Sat, 18 Oct 2014 20:18:56 +0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Tomas Melin <tomas.melin@iki.fi>
Cc: james.hogan@imgtec.com,
	Antti =?ISO-8859-1?B?U2VwcORs5A==?= <a.seppala@gmail.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] [media] rc-core: fix protocol_change regression in
 ir_raw_event_register
Message-id: <20141018201856.6e7a8435.m.chehab@samsung.com>
In-reply-to: <CACraW2pTb0avTdQCLFAZAWNm5ZuTmVDEOPgZGmY+prepLcRANg@mail.gmail.com>
References: <1412879436-7513-1-git-send-email-tomas.melin@iki.fi>
 <20141016204920.GB16402@hardeman.nu>
 <CACraW2pTb0avTdQCLFAZAWNm5ZuTmVDEOPgZGmY+prepLcRANg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 18 Oct 2014 13:10:01 +0300
Tomas Melin <tomas.melin@iki.fi> escreveu:

> On Thu, Oct 16, 2014 at 11:49 PM, David Härdeman <david@hardeman.nu> wrote:
> > I think this is already addressed in this thread:
> > http://www.spinics.net/lists/linux-media/msg79865.html
> The patch in that thread would have broken things since the
> store_protocol function is not changed at the same time. The patch I
> sent also takes that into account.
> 
> My concern is still that user space behaviour changes.
> In my case, lirc simply does not work anymore.

Yeah, lirc should be enabled by default.

> More generically,
> anyone now using e.g. nuvoton-cir with anything other than RC6_MCE
> will not get their devices working without first explictly enabling
> the correct protocol from sysfs or with ir-keytable.

The right behavior here is to enable the protocol as soon as the
new keycode table is written by userspace.

Except for LIRC and the protocol of the current table enabled is
not a good idea because:

	1) It misread the code from some other IR;
	2) It will be just spending power without need, running
	   several tasks (one for each IR type) with no reason, as the
	   keytable won't match the codes for other IRs (and if it is
	   currently matching, then this is a bad behavior).

> Correct me if I'm wrong but the change_protocol function in struct
> rc_dev is meant for changing hardware decoder protocols which means
> only a few drivers actually use it.

Actually, most drivers are for hardware decoders.

> So the added empty function
> change_protocol into rc-ir-raw.c doesnt really make sense in the first
> place.
> 
> Tomas


-- 

Cheers,
Mauro
