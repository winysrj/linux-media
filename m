Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2143 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2GWMBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:01:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v7] media: coda: Add driver for Coda video codec.
Date: Mon, 23 Jul 2012 13:59:30 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de,
	p.zabel@pengutronix.de
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com> <201207231338.05141.hverkuil@xs4all.nl> <CACKLOr14X3WsBov1caLJgt2m6Yk5ddp5-Ccq2bCZAkuDZ_1YDg@mail.gmail.com>
In-Reply-To: <CACKLOr14X3WsBov1caLJgt2m6Yk5ddp5-Ccq2bCZAkuDZ_1YDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231359.31057.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon July 23 2012 13:56:49 javier Martin wrote:
> On 23 July 2012 13:38, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Mon July 23 2012 13:31:01 Javier Martin wrote:
> >> Coda is a range of video codecs from Chips&Media that
> >> support H.264, H.263, MPEG4 and other video standards.
> >>
> >> Currently only support for the codadx6 included in the
> >> i.MX27 SoC is added. H.264 and MPEG4 video encoding
> >> are the only supported capabilities by now.
> >>
> >> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> >> ---
> >> Changes since v6:
> >>  - Cosmetic fixes pointed out by Sakari.
> >>  - Now passes 'v4l2-compliance'.
> >
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > Regards,
> >
> >         Hans
> 
> Thank you Hans.
> Do you plan to make a new release of libv4l?

No, but v4l2-compliance doesn't decide that.

I think it is Hans de Goede anyway who (co-?)decides when a new release is made.

Regards,

	Hans
