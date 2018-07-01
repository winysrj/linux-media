Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:47114
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752328AbeGASwN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Jul 2018 14:52:13 -0400
Date: Sun, 1 Jul 2018 20:51:55 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Joe Perches <joe@perches.com>
cc: linux-usb@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] cast sizeof to int for comparison
In-Reply-To: <653914f26dc8433a3f682b5e7eb850ab94bd431d.camel@perches.com>
Message-ID: <alpine.DEB.2.20.1807012050530.2494@hadrien>
References: <1530466325-1678-1-git-send-email-Julia.Lawall@lip6.fr> <653914f26dc8433a3f682b5e7eb850ab94bd431d.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 1 Jul 2018, Joe Perches wrote:

> On Sun, 2018-07-01 at 19:32 +0200, Julia Lawall wrote:
> > Comparing an int to a size, which is unsigned, causes the int to become
> > unsigned, giving the wrong result.
> >
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
>
> Great, thanks.
>
> But what about the ones in net/smc like:
>
> > net/smc/smc_clc.c:
> >
> >         len = kernel_sendmsg(smc->clcsock, &msg, &vec, 1,
> >                              sizeof(struct smc_clc_msg_decline));
> >         if (len < sizeof(struct smc_clc_msg_decline))
>
> Are those detected by the semantic match and ignored?

I wasn't sure how to justify that kernel_sendmsg returns a negative value.
If it is the case, I can send the patch.  I only found this in one file,
but there were multiple occurrences.

julia
