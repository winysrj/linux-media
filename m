Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52840 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1FFKFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 06:05:38 -0400
Date: Mon, 6 Jun 2011 13:05:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 08/11] v4l2-ctrls: simplify event subscription.
Message-ID: <20110606100534.GI6073@valkosipuli.localdomain>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
 <2993c04b0ba330b3f634e281a6b50ee8cd7e6f7c.1306329390.git.hans.verkuil@cisco.com>
 <201106032155.10808.laurent.pinchart@ideasonboard.com>
 <201106041228.04249.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106041228.04249.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jun 04, 2011 at 12:28:04PM +0200, Hans Verkuil wrote:
> On Friday, June 03, 2011 21:55:10 Laurent Pinchart wrote:
[clip]
> > > +{
> > > +	int ret = 0;
> > > +
> > > +	if (!fh->events)
> > > +		ret = v4l2_event_init(fh);
> > > +	if (!ret)
> > > +		ret = v4l2_event_alloc(fh, n);
> > > +	if (!ret)
> > > +		ret = v4l2_event_subscribe(fh, sub);
> > 
> > I tend to return errors when they occur instead of continuing to the end of 
> > the function. Handling errors on the spot makes code easier to read in my 
> > opinion, as I expect the main code flow to be the error-free path.
> 
> Hmmm, I rather like the way the code looks in this particular case. But it;s
> no big deal and I can change it.

The M5MOLS driver uses this pattern extensively in I2C access error
handling. I agree with Laurent in principle, but on the other hand I think
using this pattern makes sense. The error handling takes much less code and
the test for continuing always is "if (!ret)" it is relatively readable as
well.

I'm fine with either resolution.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
