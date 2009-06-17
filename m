Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765573AbZFQN3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 09:29:16 -0400
Date: Wed, 17 Jun 2009 10:29:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Andy Walls" <awalls@radix.net>,
	"Hans de Goede" <hdegoede@redhat.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
Message-ID: <20090617102910.2d51e95e@pedra.chehab.org>
In-Reply-To: <16165.62.70.2.252.1245238018.squirrel@webmail.xs4all.nl>
References: <16165.62.70.2.252.1245238018.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2009 13:26:58 +0200 (CEST)
"Hans Verkuil" <hverkuil@xs4all.nl> escreveu:

> 
> > On Wed, 2009-06-17 at 09:43 +0200, Hans Verkuil wrote:
> >
> >> > I personally think that loosing support for the parallel port
> >> > version is ok given that the parallel port itslef is rapidly
> >> > disappearing, what do you think ?
> >>
> >> I agree wholeheartedly. If we remove pp support, then we can also remove
> >> the bw-qcam and c-qcam drivers since they too use the parallel port.
> >
> > Maybe I just like keeping old hardware up and running, but...
> >
> > I think it may be better to remove camera drivers when a majority of the
> > actual camera hardware is likely to reach EOL, as existing parallel
> > ports will likely outlive the cameras.

Parallel port will still be there for some time. However, Parallel port webcams
are less common.

> For sure. But these are really old webcams with correspondingly very poor
> resolutions. I haven't been able to track one down on ebay and as far as I
> know nobody has one of these beasts to test with. I can't see anyone using
> parallel port webcams. I actually wonder whether these drivers still work.
> And converting to v4l2 without having the hardware is very hard indeed.

Maybe Alan Cox might still have some of those cams. Some of those old cameras
were used on specialized hardware, like microscopes. Maybe it still could make
sense to support them, but somebody with the hardware should convert to V4L2
and test with the real hardware. Otherwise, I agree that the better is just to
remove the parallel port camera drivers from newer kernels.



Cheers,
Mauro
