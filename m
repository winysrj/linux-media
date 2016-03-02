Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57108 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbcCBMcc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 07:32:32 -0500
Date: Wed, 2 Mar 2016 09:32:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160302093226.260bfe00@recife.lan>
In-Reply-To: <1736605.4kGg8lYGrV@avalon>
References: <20160226091317.5a07c374@recife.lan>
	<1753279.MBUKgSvGQl@avalon>
	<20160302081323.36eddba5@recife.lan>
	<1736605.4kGg8lYGrV@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 02 Mar 2016 13:16:47 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Wednesday 02 March 2016 08:13:23 Mauro Carvalho Chehab wrote:
> > Em Wed, 02 Mar 2016 12:34:42 +0200 Laurent Pinchart escreveu:  
> > > On Friday 26 February 2016 09:13:17 Mauro Carvalho Chehab wrote:  
> 
> [snip]
> 
> > >> NOTE:
> > >> 
> > >> The labels at the PADs currently can't be represented, but the
> > >> idea is adding it as a property via the upcoming properties API.  
> > > 
> > > Whether to add labels to pads, and more generically how to differentiate
> > > them from userspace, is an interesting question. I'd like to decouple it
> > > from the connectors entities discussion if possible, in such a way that
> > > using labels wouldn't be required to leave the discussion open on that
> > > topic. If we foresee a dependency on labels for pads then we should open
> > > that discussion now.  
> >
> > We can postpone such discussion. PAD labels are not needed for
> > what we have so far (RF, Composite, S-Video). Still, I think that
> > we'll need it by the time we add connector support for more complex
> > connector types, like HDMI.  
> 
> If we don't add pad labels now then they should be optional for future 
> connectors too, including HDMI.

Why? Future features will require future discussions. We can't
foresee all future needs without having someone actually working
to implement the code that would support such feature.

Also, we can't add now anything using the media properties API without
having the patches for it.

Sakari,

When you'll have the media property API patches ready for us to test?

> If you think that HDMI connectors will require 
> them then we should discuss them now.
> 

I'm ok if you want to start discussing the future needs earlier. 
I already answered why I think this will be needed on a previous
e-mail.

Regards,
Mauro
