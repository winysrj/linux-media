Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46295 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751174Ab3JAJR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Oct 2013 05:17:26 -0400
Date: Tue, 1 Oct 2013 12:17:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sylwester.nawrocki@gmail.com
Subject: Re: [PATCH 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Message-ID: <20131001091721.GJ3022@valkosipuli.retiisi.org.uk>
References: <1379541668-23085-1-git-send-email-sakari.ailus@iki.fi>
 <2051351.luZaPOfRE8@avalon>
 <20130930232823.GI3022@valkosipuli.retiisi.org.uk>
 <2921276.foMJNxPg5I@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2921276.foMJNxPg5I@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Oct 01, 2013 at 10:55:04AM +0200, Laurent Pinchart wrote:
> On Tuesday 01 October 2013 02:28:23 Sakari Ailus wrote:
> > On Tue, Oct 01, 2013 at 01:21:58AM +0200, Laurent Pinchart wrote:
> > > On Tuesday 01 October 2013 02:08:47 Sakari Ailus wrote:
> > > > On Fri, Sep 20, 2013 at 11:08:47PM +0200, Laurent Pinchart wrote:
> > > > > On Thursday 19 September 2013 01:01:05 Sakari Ailus wrote:
> > > > > > Pads that set this flag must be connected by an active link for the
> > > > > > entity to stream.
> > > > > > 
> > > > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > > > Acked-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> 
> [snip]
> 
> > > What about
> > > 
> > > If the pad is linked to any other pad, at least one of the links must be
> > > enabled for the entity to be able to stream. There could be temporary
> > > reasons (e.g. device configuration dependent) for the pad to need enabled
> > > links; the absence of the flag doesn't imply there is none. The flag has
> > > no effect on pads without connected links.
> > 
> > Thinking about this again, I'd add before the comma: "and this flag is set".
> > 
> > And if you put it like that then the last sentence is redundat --- I'd drop
> > it.
> > 
> > What do you think?
> 
> What about
> 
> "When this flag is set, if the pad is linked to any other pad then at least 

How about:

"If this flag is set and the pad is linked to any other pad, then"...

I think it's cleaner like that.

> one of those links must be enabled for the entity to be able to stream. There 
> could be temporary reasons (e.g. device configuration dependent) for the pad 
> to need enabled links even when this flag isn't set; the absence of the flag 
> doesn't imply there is none. The flag has no effect on pads without connected 
> links."
> 
> Feel free to drop the last sentence.

Thinking about it again, I'm fine keeping it. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
