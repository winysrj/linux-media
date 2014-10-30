Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42600 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758311AbaJ3JGe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 05:06:34 -0400
Date: Thu, 30 Oct 2014 07:06:28 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] si2157: Add support for delivery system SYS_ATSC
Message-ID: <20141030070628.4f52e9da@recife.lan>
In-Reply-To: <CAAZRmGxSDQhKERhMeRqae-8RBsjjuDq0kN6HmEiLfodz7dhCMg@mail.gmail.com>
References: <1408253089-9487-1-git-send-email-olli.salonen@iki.fi>
	<20141029070849.0a1c6d56@recife.lan>
	<CAAZRmGxSDQhKERhMeRqae-8RBsjjuDq0kN6HmEiLfodz7dhCMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Oct 2014 08:04:29 +0200
Olli Salonen <olli.salonen@iki.fi> escreveu:

> Hi Mauro,
> 
> No, for ClearQAM the delivery_system should be set to 0x10 and this
> patch does not include that. At the time of submission of that patch I
> only had the trace from the ATSC case.

Ah, ok. Are you planning to submit a patch for it, and the patches adding
support for HVR-955Q?

> 
> ATSC & ClearQAM USB sniffs here:
> http://trsqr.net/olli/hvr955q/

Thanks!

Regards,
Mauro

> 
> Cheers,
> -olli
> 
> On 29 October 2014 11:08, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> > Hi Olli,
> >
> > Em Sun, 17 Aug 2014 08:24:49 +0300
> > Olli Salonen <olli.salonen@iki.fi> escreveu:
> >
> >> Set the property for delivery system also in case of SYS_ATSC. This
> >> behaviour is observed in the sniffs taken with Hauppauge HVR-955Q
> >> Windows driver.
> >>
> >> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> >> ---
> >>  drivers/media/tuners/si2157.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> >> index 6c53edb..3b86d59 100644
> >> --- a/drivers/media/tuners/si2157.c
> >> +++ b/drivers/media/tuners/si2157.c
> >> @@ -239,6 +239,9 @@ static int si2157_set_params(struct dvb_frontend *fe)
> >>               bandwidth = 0x0f;
> >>
> >>       switch (c->delivery_system) {
> >> +     case SYS_ATSC:
> >> +                     delivery_system = 0x00;
> >> +                     break;
> >
> > Did you check if it uses the same delivery system also for clear-QAM?
> >
> > If so, this patch is missing SYS_DVBC_ANNEX_B inside this case.
> >
> > Ah, FYI, I merged the demod used on HVR-955Q at a separate topic branch
> > upstream:
> >         http://git.linuxtv.org/cgit.cgi/media_tree.git/log/?h=lgdt3306a
> >
> > Regards,
> > Mauro
