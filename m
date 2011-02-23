Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52037 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1BWLe0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 06:34:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 12:34:36 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Stan <svarbanov@mm-sol.com>,
	Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102221800.49914.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102221806280.1380@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102221806280.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231234.37051.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 22 February 2011 18:08:40 Guennadi Liakhovetski wrote:
> On Tue, 22 Feb 2011, Hans Verkuil wrote:

[snip]

> > I also think that there is a reasonable chance that such bugs can happen.
> > Take a scenario like this: someone writes a new host driver. Initially
> > there is only support for positive polarity and detection on the rising
> > edge, because that's what the current board on which the driver was
> > developed supports. This is quite typical for an initial version of a
> > driver.
> > 
> > Later someone adds support for negative polarity and falling edge.
> > Suddenly the polarity negotiation on the previous board results in
> > negative instead of positive which was never tested. Now that board
> > starts producing pixel errors every so often. And yes, this type of
> > hardware problems do happen as I know from painful experience.
> > 
> > Problems like this are next to impossible to debug without the aid of an
> > oscilloscope, so this isn't like most other bugs that are relatively easy
> > to debug.
> 
> Well, this is pretty simple to debug with the help of git bisect, as long
> as patches are sufficiently clean and properly broken down into single
> topics.

It won't be that easy, as the problems might not be easily reproduceable. 
Changing the auto-negotiation code will require testing all boards that use 
it, which is something that can't be done by the person submitting the patch. 
We will get hard to detect (and debug) breakages.

> > It is so much easier just to avoid this by putting it in platform data.
> > It's simple, unambiguous and above all, unchanging.
> 
> As I said, this all boils down to who does patches and who accepts them
> for mainlibe.

-- 
Regards,

Laurent Pinchart
