Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46328 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbcCBXXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 18:23:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Date: Thu, 03 Mar 2016 01:23:49 +0200
Message-ID: <1669183.6VCYcO1s7n@avalon>
In-Reply-To: <20160302093226.260bfe00@recife.lan>
References: <20160226091317.5a07c374@recife.lan> <1736605.4kGg8lYGrV@avalon> <20160302093226.260bfe00@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 02 March 2016 09:32:26 Mauro Carvalho Chehab wrote:
> Em Wed, 02 Mar 2016 13:16:47 +0200 Laurent Pinchart escreveu:
> > On Wednesday 02 March 2016 08:13:23 Mauro Carvalho Chehab wrote:
> >> Em Wed, 02 Mar 2016 12:34:42 +0200 Laurent Pinchart escreveu:
> >>> On Friday 26 February 2016 09:13:17 Mauro Carvalho Chehab wrote:
> >
> > [snip]
> > 
> >>>> NOTE:
> >>>> 
> >>>> The labels at the PADs currently can't be represented, but the
> >>>> idea is adding it as a property via the upcoming properties API.
> >>> 
> >>> Whether to add labels to pads, and more generically how to differentiate
> >>> them from userspace, is an interesting question. I'd like to decouple it
> >>> from the connectors entities discussion if possible, in such a way that
> >>> using labels wouldn't be required to leave the discussion open on that
> >>> topic. If we foresee a dependency on labels for pads then we should open
> >>> that discussion now.
> >> 
> >> We can postpone such discussion. PAD labels are not needed for
> >> what we have so far (RF, Composite, S-Video). Still, I think that
> >> we'll need it by the time we add connector support for more complex
> >> connector types, like HDMI.
> > 
> > If we don't add pad labels now then they should be optional for future
> > connectors too, including HDMI.
> 
> Why? Future features will require future discussions. We can't
> foresee all future needs without having someone actually working
> to implement the code that would support such feature.

That's called design or architecture, and that's how APIs and protocols are 
developed ;-) While we indeed can't foresee everything, we have to invest a 
reasonable amount of effort into making the overall design sound and stable, 
and that involves planning future development to some extent. The development 
can then be phased, that's not an issue.

> Also, we can't add now anything using the media properties API without
> having the patches for it.
> 
> Sakari,
> 
> When you'll have the media property API patches ready for us to test?
> 
> > If you think that HDMI connectors will require them then we should discuss
> > them now.
> 
> I'm ok if you want to start discussing the future needs earlier.
> I already answered why I think this will be needed on a previous
> e-mail.

I propose concentrating on connectors first, I believe the pad labels (and/or 
types or anything else) will come from that.

-- 
Regards,

Laurent Pinchart

