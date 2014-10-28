Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48576 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJ1NVJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 09:21:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Hardware for testing Dead Pixel API
Date: Tue, 28 Oct 2014 15:21:14 +0200
Message-ID: <3291269.yV9E63i4de@avalon>
In-Reply-To: <544F95BE.1070608@iki.fi>
References: <CAPybu_2SNomez4K+QOdnhwyMPJ5f6n08=n-cUuM9qTg+624kNQ@mail.gmail.com> <544F95BE.1070608@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 28 October 2014 15:10:22 Sakari Ailus wrote:
> Ricardo Ribalda Delgado wrote:
> > Hello
> > 
> > As we discussed in the mini-summit I am interested in upstreaming an
> > API for Dead Pixels.
> > 
> > Since it is not viable to push my camera code, I would like to add it
> > to an already supported camera.
> > 
> > On the summit somebody mention a board that also has hardware support
> > for Dead Pixels, but the driver did not support it. If my memory is
> > right it was a beagle board plus a sensor board.
> > 
> > Could somebody point me to the right hardware to buy ?
> 
> The OMAP 3 ISP does have dead pixel correction but I'm not sure if it's
> documented well enough to actually implement it in public documentation.
> 
> A used Nokia N9 or N900 would be one possibility. I think the only
> cameras I've seen dead pixels in are either of the front cameras,
> probably the one in N900. At the moment only the N9 main camera works
> for sure however. The N9 or N900 front cameras will need some debugging
> work / DT snippets at least.
> 
> There are cameras for Beagle boards, too. Laurent, do you happen to
> remember if you've seen any with dead pixels in it?

I haven't seen any, but on the other hand I haven't really paid attention. It 
shouldn't be difficult to damage pixels on a sensor :-)

-- 
Regards,

Laurent Pinchart

