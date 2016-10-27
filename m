Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:52689 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935350AbcJ0PQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 11:16:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] dvb: avoid warning in dvb_net
Date: Thu, 27 Oct 2016 17:09:28 +0200
Message-ID: <20018611.sQONvMWYdP@wuerfel>
In-Reply-To: <20161027141327.GE42084@redhat.com>
References: <20161027140835.2345937-1-arnd@arndb.de> <20161027141327.GE42084@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, October 27, 2016 10:13:27 AM CEST Jarod Wilson wrote:
> On Thu, Oct 27, 2016 at 03:57:41PM +0200, Arnd Bergmann wrote:
> > With gcc-5 or higher on x86, we can get a bogus warning in the
> > dvb-net code:
> > 
> > drivers/media/dvb-core/dvb_net.c: In function ‘dvb_net_ule’:
> > arch/x86/include/asm/string_32.h:77:14: error: ‘dest_addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
> > drivers/media/dvb-core/dvb_net.c:633:8: note: ‘dest_addr’ was declared here
> > 
> > The problem here is that gcc doesn't track all of the conditions
> > to prove it can't end up copying uninitialized data.
> > This changes the logic around so we zero out the destination
> > address earlier when we determine that it is not set here.
> > This allows the compiler to figure it out.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/media/dvb-core/dvb_net.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> > index 088914c4623f..f1b416de9dab 100644
> > --- a/drivers/media/dvb-core/dvb_net.c
> > +++ b/drivers/media/dvb-core/dvb_net.c
> > @@ -688,6 +688,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
> >                                                             ETH_ALEN);
> >                                               skb_pull(priv->ule_skb, ETH_ALEN);
> >                                       }
> > +                             } else {
> > +                                      /* othersie use zero destination address */
> 
> I'm assuming you meant "otherwise" there instead of "othersie".
> 

Yes, I sent a v2 now, thanks for taking a look. I assume this means
you have no other objections to the patch?

	Arnd

