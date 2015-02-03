Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55987 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965999AbbBCPzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 10:55:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 6/8] WmT: adv7604 driver compatibility
Date: Tue, 03 Feb 2015 17:56:22 +0200
Message-ID: <2547273.SthZRtqIzA@avalon>
In-Reply-To: <54D0E975.8060205@metafoo.de>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <54D0E823.2070803@xs4all.nl> <54D0E975.8060205@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 February 2015 16:29:57 Lars-Peter Clausen wrote:
> On 02/03/2015 04:24 PM, Hans Verkuil wrote:
> > On 02/03/15 16:22, Laurent Pinchart wrote:

[snip]

> >> I can't help you much with that, but I could test changes using the
> >> rcar-vin driver with the adv7180 if needed (does the adv7180 generate an
> >> image if no analog source is connected ?).
> > 
> > I expect so, most SDTV receivers do that.
> 
> It has a freerun mode, in which it can output various kinds of patterns, see
> https://patchwork.linuxtv.org/patch/27894/

Thank you.

-- 
Regards,

Laurent Pinchart

