Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48457 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab3KZWAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 17:00:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Valentine <valentine.barshak@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
Date: Tue, 26 Nov 2013 23:00:45 +0100
Message-ID: <692757747.1f4Evv5u9p@avalon>
In-Reply-To: <52951604.2050603@metafoo.de>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <52951270.9040804@cogentembedded.com> <52951604.2050603@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

On Tuesday 26 November 2013 22:43:32 Lars-Peter Clausen wrote:
> On 11/26/2013 10:28 PM, Valentine wrote:
> > On 11/20/2013 07:53 PM, Valentine wrote:
> >> On 11/20/2013 07:42 PM, Hans Verkuil wrote:
> >>> Hi Valentine,
> > 
> > Hi Hans,
> > 
> >>> Did you ever look at this adv7611 driver:
> >>> 
> >>> https://github.com/Xilinx/linux-xlnx/commit/610b9d5de22ae7c0047c65a07e4a
> >>> fa42af2daa12
> >> No, I missed that one somehow, although I did search for the adv7611/7612
> >> before implementing this one.
> >> I'm going to look closer at the patch and test it.
> > 
> > I've tried the patch and I doubt that it was ever tested on adv7611.
> 
> It was and it works.
> 
> > I haven't been able to make it work so far. Here's the description of some
> > of the issues I've encountered.
> > 
> > The patch does not apply cleanly so I had to make small adjustments just
> > to make it apply without changing the functionality.
> 
> I have an updated version of the patch, which I intend to submit soon.

Is it publicly available already ?

> [...]
> 
> >>> It adds adv761x support to the adv7604 in a pretty clean way.
> > 
> > Doesn't seem that clean to me after having a look at it.
> > It tries to handle both 7604 and 7611 chips in the same way, though,
> > I'm not exactly sure if it's a good idea since 7611/12 is a pure HDMI
> > receiver with no analog inputs.
> 
> It is the same HDMI core (with minor modifications) though. So you end end
> up with largely the same code for the 7604 and the 7611.

-- 
Regards,

Laurent Pinchart

