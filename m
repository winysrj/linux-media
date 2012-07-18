Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45273 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2GRMMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 08:12:06 -0400
Subject: Re: [PATCH v3] media: coda: Add driver for Coda video codec.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de
In-Reply-To: <CACKLOr0861rZbOFZ2O0eXuTY7PB1yiFkSt62_4uXvJT+QMZe9A@mail.gmail.com>
References: <1342077100-8629-1-git-send-email-javier.martin@vista-silicon.com>
	 <1342459273.2535.665.camel@pizza.hi.pengutronix.de>
	 <CACKLOr3rOPgwMCRdj3ARR+0655Qp=BfEXq0TsB7TU-hO4NSsqg@mail.gmail.com>
	 <1342600546.2542.101.camel@pizza.hi.pengutronix.de>
	 <CACKLOr1i-iByVtST6sqXqmHHzhJ1mgUdBWjp-jFsYPX-bnAMxQ@mail.gmail.com>
	 <1342603378.2542.149.camel@pizza.hi.pengutronix.de>
	 <CACKLOr0861rZbOFZ2O0eXuTY7PB1yiFkSt62_4uXvJT+QMZe9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jul 2012 14:12:02 +0200
Message-ID: <1342613522.2542.154.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 18.07.2012, 11:26 +0200 schrieb javier Martin:
> On 18 July 2012 11:22, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Hi Javier,
> >
> > Am Mittwoch, den 18.07.2012, 11:01 +0200 schrieb javier Martin:
> >> On 18 July 2012 10:35, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> >> > Hi Javier,
> >> >
> >> > Am Mittwoch, den 18.07.2012, 09:12 +0200 schrieb javier Martin:
> >> > [...]
> >> >> > I see there is a comment about the expected register setting not working
> >> >> > for CODA_REG_BIT_STREAM_CTRL in start_streaming(). Could this be
> >> >> > related?
> >> >>
> >> >> I don't think so. This means that the following line:
> >> >>
> >> >> coda_write(dev, (3 << 3), CODA_REG_BIT_STREAM_CTRL);
> >> >>
> >> >> should be:
> >> >>
> >> >> coda_write(dev, (CODADX6_STREAM_BUF_PIC_RESET |
> >> >> CODADX6_STREAM_BUF_PIC_FLUSH), CODA_REG_BIT_STREAM_CTRL);
> >> >>
> >> >> But the latter does not work.
> >> >
> >> > Looks to me like (3 << 3) == (CODA7_STREAM_BUF_PIC_RESET |
> >> > CODA7_STREAM_BUF_PIC_FLUSH) could be the explanation.
> >>
> >> You mean "!=", don't you?
> >
> > I mean "==". coda.h contains:
> >
> > #define         CODA7_STREAM_BUF_PIC_RESET      (1 << 4)
> > #define         CODA7_STREAM_BUF_PIC_FLUSH      (1 << 3)
> >
> > So maybe those are the correct bits for i.MX27 with the 2.2.5 firmware.
> > If that is the case, you could do s/CODA7_STREAM_BUF_/CODA_STREAM_BUF_/
> > and drop the incorrect CODADX6_STREAM_BUF_ defines.
> 
> Sorry, I didn't catch the 'CODA7' prefix in your defines.
> OK then, I'll do  s/CODA7_STREAM_BUF_/CODA_STREAM_BUF_/ and remove the
> comment too.

Hold on, I just read that there should be a ENC_DYN_BUFALLOC_EN bit
((1 << 5) on i.MX53, (1 << 4) on i.MX27) - so maybe the #defines are
right after all, just that bit needs to be set for the dynamic buffer
handling to work.

regards
Philipp

