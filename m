Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38159 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbaJ1NK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 09:10:26 -0400
Message-ID: <544F95BE.1070608@iki.fi>
Date: Tue, 28 Oct 2014 15:10:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Hardware for testing Dead Pixel API
References: <CAPybu_2SNomez4K+QOdnhwyMPJ5f6n08=n-cUuM9qTg+624kNQ@mail.gmail.com>
In-Reply-To: <CAPybu_2SNomez4K+QOdnhwyMPJ5f6n08=n-cUuM9qTg+624kNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Ricardo Ribalda Delgado wrote:
> Hello
> 
> As we discussed in the mini-summit I am interested in upstreaming an
> API for Dead Pixels.
> 
> Since it is not viable to push my camera code, I would like to add it
> to an already supported camera.
> 
> On the summit somebody mention a board that also has hardware support
> for Dead Pixels, but the driver did not support it. If my memory is
> right it was a beagle board plus a sensor board.
> 
> Could somebody point me to the right hardware to buy ?

The OMAP 3 ISP does have dead pixel correction but I'm not sure if it's
documented well enough to actually implement it in public documentation.

A used Nokia N9 or N900 would be one possibility. I think the only
cameras I've seen dead pixels in are either of the front cameras,
probably the one in N900. At the moment only the N9 main camera works
for sure however. The N9 or N900 front cameras will need some debugging
work / DT snippets at least.

There are cameras for Beagle boards, too. Laurent, do you happen to
remember if you've seen any with dead pixels in it?

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
