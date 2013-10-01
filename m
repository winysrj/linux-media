Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58139 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3JAJWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 05:22:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sylwester.nawrocki@gmail.com
Subject: Re: [PATCH 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Tue, 01 Oct 2013 11:22:17 +0200
Message-ID: <6335539.G4F0qhLrTU@avalon>
In-Reply-To: <20131001091721.GJ3022@valkosipuli.retiisi.org.uk>
References: <1379541668-23085-1-git-send-email-sakari.ailus@iki.fi> <2921276.foMJNxPg5I@avalon> <20131001091721.GJ3022@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 01 October 2013 12:17:21 Sakari Ailus wrote:
> On Tue, Oct 01, 2013 at 10:55:04AM +0200, Laurent Pinchart wrote:
> > On Tuesday 01 October 2013 02:28:23 Sakari Ailus wrote:
> > > On Tue, Oct 01, 2013 at 01:21:58AM +0200, Laurent Pinchart wrote:
> > > > On Tuesday 01 October 2013 02:08:47 Sakari Ailus wrote:
> > > > > On Fri, Sep 20, 2013 at 11:08:47PM +0200, Laurent Pinchart wrote:
> > > > > > On Thursday 19 September 2013 01:01:05 Sakari Ailus wrote:
> > > > > > > Pads that set this flag must be connected by an active link for
> > > > > > > the  entity to stream.
> > > > > > > 
> > > > > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > > > > Acked-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> > 
> > [snip]
> > 
> > > > What about
> > > > 
> > > > If the pad is linked to any other pad, at least one of the links must
> > > > be enabled for the entity to be able to stream. There could be
> > > > temporary reasons (e.g. device configuration dependent) for the pad to
> > > > need enabled links; the absence of the flag doesn't imply there is
> > > > none. The flag has no effect on pads without connected links.
> > > 
> > > Thinking about this again, I'd add before the comma: "and this flag is
> > > set".
> > > 
> > > And if you put it like that then the last sentence is redundat --- I'd
> > > drop it.
> > > 
> > > What do you think?
> > 
> > What about
> > 
> > "When this flag is set, if the pad is linked to any other pad then at
> > least
> 
> How about:
> 
> "If this flag is set and the pad is linked to any other pad, then"...
> 
> I think it's cleaner like that.

Fine with me.

> > one of those links must be enabled for the entity to be able to stream.
> > There could be temporary reasons (e.g. device configuration dependent)
> > for the pad to need enabled links even when this flag isn't set; the
> > absence of the flag doesn't imply there is none. The flag has no effect
> > on pads without connected links."
> > 
> > Feel free to drop the last sentence.
> 
> Thinking about it again, I'm fine keeping it. :-)

-- 
Regards,

Laurent Pinchart

