Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:36141 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751917AbdCCSku (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 13:40:50 -0500
Date: Fri, 3 Mar 2017 19:37:26 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: SIMRAN SINGHAL <singhalsimran0@gmail.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] Re: [PATCH 1/7] staging: media: Remove
 unnecessary typecast of c90 int constant
In-Reply-To: <CALrZqyOeOK2k1K8Z2Yt3SmvJQ8A+vigNBsd39-paPwkRAY6CVQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1703031936290.2133@hadrien>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com> <20170303174552.GP3220@valkosipuli.retiisi.org.uk> <CALrZqyOeOK2k1K8Z2Yt3SmvJQ8A+vigNBsd39-paPwkRAY6CVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 3 Mar 2017, SIMRAN SINGHAL wrote:

> On Fri, Mar 3, 2017 at 11:15 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Simran,
> >
> > On Fri, Mar 03, 2017 at 01:21:56AM +0530, simran singhal wrote:
> >> This patch removes unnecessary typecast of c90 int constant.
> >>
> >> WARNING: Unnecessary typecast of c90 int constant
> >>
> >> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
> >
> > Which tree are these patches based on?
> Can you please explain what's the problem with this patch. And
> please elaborate your question.

It is probably staging-testing.

julia


>
> >
> > --
> > Regards,
> >
> > Sakari Ailus
> > e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/CALrZqyOeOK2k1K8Z2Yt3SmvJQ8A%2BvigNBsd39-paPwkRAY6CVQ%40mail.gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
