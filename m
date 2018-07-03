Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59296 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbeGCNAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 09:00:41 -0400
Date: Tue, 3 Jul 2018 16:00:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>, linux-usb@vger.kernel.org,
        Chengguang Xu <cgxu519@gmx.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] cast sizeof to int for comparison
Message-ID: <20180702091834.etunideivmb6p2sf@mwanda>
References: <1530466325-1678-1-git-send-email-Julia.Lawall@lip6.fr>
 <653914f26dc8433a3f682b5e7eb850ab94bd431d.camel@perches.com>
 <alpine.DEB.2.20.1807012050530.2494@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1807012050530.2494@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 01, 2018 at 08:51:55PM +0200, Julia Lawall wrote:
> 
> 
> On Sun, 1 Jul 2018, Joe Perches wrote:
> 
> > On Sun, 2018-07-01 at 19:32 +0200, Julia Lawall wrote:
> > > Comparing an int to a size, which is unsigned, causes the int to become
> > > unsigned, giving the wrong result.
> > >
> > > The semantic match that finds this problem is as follows:
> > > (http://coccinelle.lip6.fr/)
> >
> > Great, thanks.
> >
> > But what about the ones in net/smc like:
> >
> > > net/smc/smc_clc.c:
> > >
> > >         len = kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
> > >                              sizeof(struct smc_clc_msg_decline));
> > >         if (len < sizeof(struct smc_clc_msg_decline))
> >
> > Are those detected by the semantic match and ignored?
> 
> I wasn't sure how to justify that kernel_sendmsg returns a negative value.
> If it is the case, I can send the patch.  I only found this in one file,
> but there were multiple occurrences.
> 

In theory, Smatch is supposed to know return values but kernel_sendmsg()
is too complicated for Smatch.  It's a tricky thing...  That particular
check is correct and deliberate, but there is another check which is
wrong.

net/smc/smc_clc.c
   369          len = kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
   370                               sizeof(struct smc_clc_msg_decline));
   371          if (len < sizeof(struct smc_clc_msg_decline))
   372                  smc->sk.sk_err = EPROTO;
   373          if (len < 0)
   374                  smc->sk.sk_err = -len;

If it's invalid we set an error code, if it's already an error we
preserve the error code.

   375          return sock_error(&smc->sk);

[ snip ]

   442          /* due to the few bytes needed for clc-handshake this cannot block */
   443          len = kernel_sendmsg(smc->clcsock, &msg, vec, i, plen);
   444          if (len < sizeof(pclc)) {
   445                  if (len >= 0) {
                            ^^^^^^^^
This is always true.

   446                          reason_code = -ENETUNREACH;
   447                          smc->sk.sk_err = -reason_code;
   448                  } else {
   449                          smc->sk.sk_err = smc->clcsock->sk->sk_err;
   450                          reason_code = -smc->sk.sk_err;
   451                  }
   452          }

The other two checks are not type promoted so they also work as
intended.

This is an interesting sort of bug I've written a Smatch script inspired
by your work here.  One for the type promotion and one for the
impossible condition.  I'll let you know how it goes.

regards,
dan carpenter
