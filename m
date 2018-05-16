Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752309AbeEPNhJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 09:37:09 -0400
Date: Wed, 16 May 2018 10:36:56 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
Message-ID: <20180516103656.208043d4@vento.lan>
In-Reply-To: <20180516131108.xcvsw6m4qrmqgykh@mwanda>
References: <20180423152455.363d285c@vento.lan>
        <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
        <20180423161742.66f939ba@vento.lan>
        <99e158c0-1273-2500-da9e-b5ab31cba889@embeddedor.com>
        <20180426204241.03a42996@vento.lan>
        <df8010f1-6051-7ff4-5f0e-4a436e900ec5@embeddedor.com>
        <20180515085953.65bfa107@vento.lan>
        <20180515141655.idzuh2jfdkuu5grs@mwanda>
        <f342d8d6-b5e6-0cbf-d002-9561b79c90e4@embeddedor.com>
        <20180515160033.156f119c@vento.lan>
        <20180516131108.xcvsw6m4qrmqgykh@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 May 2018 16:11:08 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> On Tue, May 15, 2018 at 04:00:33PM -0300, Mauro Carvalho Chehab wrote:
> > Yeah, that's the same I'm getting from media upstream.
> >   
> > > drivers/media/cec/cec-pin-error-inj.c:170 cec_pin_error_inj_parse_line() 
> > > warn: potential spectre issue 'pin->error_inj_args'  
> > 
> > This one seems a false positive, as the index var is u8 and the
> > array has 256 elements, as the userspace input from 'op' is 
> > initialized with:
> > 
> > 	u8 v;
> > 	u32 op;
> > 
> > 	if (!kstrtou8(token, 0, &v))
> > 		op = v;
> >   
> 
> It's hard to silence this because Smatch stores the current user
> controlled range list, not what it was initially.  I wrote all this code
> to detect bounds checking errors, so there wasn't any need to save the
> range list before the bounds check.  Since "op" is a u32, I can't even
> go by the type of the index....

Yeah, I was thinking that is would be harder to clean this up on
smatch. I proposed a patch to the ML that simplifies the logic,
making easier for both humans and Smatch to better understand how
the arrays are indexed.

> 
> > > drivers/media/dvb-core/dvb_ca_en50221.c:1479 dvb_ca_en50221_io_write() 
> > > warn: potential spectre issue 'ca->slot_info' (local cap)  
> > 
> > This one seems a real issue to me. Sent a patch for it.
> >   
> > > drivers/media/dvb-core/dvb_net.c:252 handle_one_ule_extension() warn: 
> > > potential spectre issue 'p->ule_next_hdr'  
> > 
> > I failed to see what's wrong here, or if this is exploited.   
> 
> Oh...  Huh.  This is a bug in smatch.  That line looks like:
> 
> 	p->ule_sndu_type = ntohs(*(__be16 *)(p->ule_next_hdr + ((p->ule_dbit ? 2 : 3) * ETH_ALEN)));
> 
> Smatch see the ntohs() and marks everything inside it as untrusted
> network data.  I'll fix this.

Thanks!

Regards,
Mauro
