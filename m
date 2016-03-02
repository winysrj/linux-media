Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45778 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbcCBLQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 06:16:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Date: Wed, 02 Mar 2016 13:16:47 +0200
Message-ID: <1736605.4kGg8lYGrV@avalon>
In-Reply-To: <20160302081323.36eddba5@recife.lan>
References: <20160226091317.5a07c374@recife.lan> <1753279.MBUKgSvGQl@avalon> <20160302081323.36eddba5@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 02 March 2016 08:13:23 Mauro Carvalho Chehab wrote:
> Em Wed, 02 Mar 2016 12:34:42 +0200 Laurent Pinchart escreveu:
> > On Friday 26 February 2016 09:13:17 Mauro Carvalho Chehab wrote:

[snip]

> >> NOTE:
> >> 
> >> The labels at the PADs currently can't be represented, but the
> >> idea is adding it as a property via the upcoming properties API.
> > 
> > Whether to add labels to pads, and more generically how to differentiate
> > them from userspace, is an interesting question. I'd like to decouple it
> > from the connectors entities discussion if possible, in such a way that
> > using labels wouldn't be required to leave the discussion open on that
> > topic. If we foresee a dependency on labels for pads then we should open
> > that discussion now.
>
> We can postpone such discussion. PAD labels are not needed for
> what we have so far (RF, Composite, S-Video). Still, I think that
> we'll need it by the time we add connector support for more complex
> connector types, like HDMI.

If we don't add pad labels now then they should be optional for future 
connectors too, including HDMI. If you think that HDMI connectors will require 
them then we should discuss them now.

-- 
Regards,

Laurent Pinchart

