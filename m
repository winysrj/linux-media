Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZLERaZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 12:30:25 -0500
Message-ID: <4B1A98B4.3050606@infradead.org>
Date: Sat, 05 Dec 2009 15:30:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: VDR User <user.vdr@gmail.com>, LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
References: <20091022211330.6e84c6e7@hyperion.delvare>	 <4B02FDA4.5030508@infradead.org>	 <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>	 <200911201237.31537.julian@jusst.de>	 <1a297b360911200808k12676112lf7a11f3dfd44a187@mail.gmail.com>	 <4B07290B.4060307@jusst.de>	 <a3ef07920912041202u78f4d12av8d7a49f5f91b3d56@mail.gmail.com> <37219a840912041259w499f2347he1b25c16550d671f@mail.gmail.com>
In-Reply-To: <37219a840912041259w499f2347he1b25c16550d671f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Krufky wrote:
> On Fri, Dec 4, 2009 at 3:02 PM, VDR User <user.vdr@gmail.com> wrote:
> I have stated that I like Manu's proposal, but I would prefer that the
> get_property (s2api) interface were used, because it totally provides
> an interface that is sufficient for this feature.
> 
> Manu and I agree that these values should all be read at once.
> 
> I think we all (except Mauro) agree that the behavior within the
> driver should fetch all statistics at once and return it to userspace
> as a single structure with all the information as it all relates to
> each other.

You're contradicting yourself: by using S2API, the userspace API won't
be using a single structure, since S2API will break them into pairs of
attributes/values.

Nothing limits that the in-kernel API will group those values into a struct,
but the internal API should be smart enough to not return to userspace
the values that weren't requested by the call.

Cheers,
Mauro.

