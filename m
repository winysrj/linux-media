Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40923 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2FFB40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2012 21:56:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Janusz Uzycki <janusz.uzycki@elproma.com.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: SH7724, VOU, PAL mode
Date: Wed, 06 Jun 2012 03:56:23 +0200
Message-ID: <2953932.QXraKo8NYI@avalon>
In-Reply-To: <Pine.LNX.4.64.1206051651220.2145@axis700.grange>
References: <1E539FC23CF84B8A91428720570395E0@laptop2> <CEA83F28AF7C47E7B83AE1DBFFBC8514@laptop2> <Pine.LNX.4.64.1206051651220.2145@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 05 June 2012 17:47:50 Guennadi Liakhovetski wrote:
> On Mon, 4 Jun 2012, Janusz Uzycki wrote:

[snip]

> > Do you have any test program for video v4l2 output?
> You can use gstreamer, e.g.:
> 
> gst-launch -v filesrc location=x.avi ! decodebin ! ffmpegcolorspace ! \
> video/x-raw-rgb,bpp=24 ! v4l2sink device=/dev/video0 tv-norm=PAL-B
> 
> I also used a (possibly modified) program by Laurent (cc'ed) which either
> I - with his agreement - can re-send to you, or maybe he'd send you the
> original.

Are you talking about yavta ? If so that's available at 
http://git.ideasonboard.org/, available under the GPL (you're obviously free 
to redistribute your modifications :-)).

-- 
Regards,

Laurent Pinchart

