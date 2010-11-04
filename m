Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:35662 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0KDTiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Nov 2010 15:38:25 -0400
Date: Thu, 4 Nov 2010 20:38:24 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101104193823.GA9107@hardeman.nu>
References: <20101029191711.GA12136@hardeman.nu> <20101029192733.GE21604@redhat.com> <20101029195918.GA12501@hardeman.nu> <20101029200937.GG21604@redhat.com> <20101030233617.GA13155@hardeman.nu> <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com> <20101101215635.GA4808@hardeman.nu> <AANLkTi=c_g7nxCFWsVMYM-tJr68V1iMzhSyJ7=g9VLnR@mail.gmail.com> <37bb20b43afce52964a95a72a725b0e4@hardeman.nu> <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimAx+D745-VxoUJ25ii+=Dm6rHb8OXs9_D69S1W@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Nov 04, 2010 at 11:54:25AM -0400, Jarod Wilson wrote:
>Okay, so we seem to be in agreement for an approach to handling this.
>I'll toss something together implementing that RSN... Though I talked
>with Mauro about this a bit yesterday here at LPC, and we're thinking
>maybe we slide this support back over into the nec decoder and make it
>a slightly more generic "use full 32 bits" NEC variant we look for
>and/or enable/disable somehow. I've got another remote here, for a
>Motorola cable box, which is NEC-ish, but always fails decode w/a
>checksum error ("got 0x00000000", iirc), which may also need to use
>the full 32 bits somehow... Probably a very important protocol variant
>to support, particularly once we have native transmit support, as its
>used by plenty of cable boxes on the major carriers here in the US.

I've always found the "checksum" tests in the NEC decoder to be 
unnecessary so I'm all for using a 32 bit scancode in all cases (and 
still using a module param to squash the ID byte of apple remotes, 
defaulting to "yes").

-- 
David Härdeman
