Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44184 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3JCJki (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 05:40:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, a.hajda@samsung.com
Subject: Re: [PATCH v2 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Thu, 03 Oct 2013 11:40:43 +0200
Message-ID: <1797993.sG828KdLkP@avalon>
In-Reply-To: <20131003084301.GM3022@valkosipuli.retiisi.org.uk>
References: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi> <524CD39B.9020400@samsung.com> <20131003084301.GM3022@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 03 October 2013 11:43:01 Sakari Ailus wrote:
> On Thu, Oct 03, 2013 at 11:16:59AM +0900, Sylwester Nawrocki wrote:
> > On 10/03/2013 08:29 AM, Laurent Pinchart wrote:
> > > On Thursday 03 October 2013 02:17:50 Sakari Ailus wrote:
> > >> Pads that set this flag must be connected by an active link for the
> > >> entity to stream.
> > >> 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > >> Acked-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Looks good, I would just like to ask for changing my e-mail address on
> > those patches to s.nawrocki@samsung.com, sorry for not mentioning it
> > earlier. Just one doubt below regarding name of the flag.
> 
> Will do.
> 
> > >> ---
> > >> 
> > >>  Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |   10 ++++++
> > >>  include/uapi/linux/media.h                               |    1 +
> > >>  2 files changed, 11 insertions(+)
> > >> 
> > >> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> > >> b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml index
> > >> 355df43..e357dc9 100644
> > >> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> > >> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> > >> @@ -134,6 +134,16 @@
> > >>  	    <entry>Output pad, relative to the entity. Output pads source
> > >>  	    data and are origins of links.</entry>
> > >>  	  </row>
> > >> +	  <row>
> > >> +	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
> > >> +	    <entry>If this flag is set and the pad is linked to any other
> > >> +	    pad, then at least one of those links must be enabled for the
> > >> +	    entity to be able to stream. There could be temporary reasons
> > >> +	    (e.g. device configuration dependent) for the pad to need
> > >> +	    enabled links even when this flag isn't set; the absence of the
> > >> +	    flag doesn't imply there is none. The flag has no effect on pads
> > >> +	    without connected links.</entry>
> > 
> > Probably MEDIA_PAD_FL_MUST_CONNECT name is fine, but isn't it more
> > something like MEDIA_PAD_FL_NEED_ACTIVE_LINK ? Or presumably
> > MEDIA_PAD_FL_MUST_CONNECT just doesn't make sense on pads without
> > connected links and should never be set on such pads ? From the last
> > sentence it feels the situation where a pad without a connected link has
> > this flags set is allowed and a valid configuration.

If I'm not mistaken, that's a valid configuration. The flag merely says that, 
if a pad has any link, then one of them must be active (Sakari, please correct 
me if I'm wrong).

> > Perhaps the last sentence should be something like:
> > 
> > "The flag should not be used on pads without connected links and has no
> > effect on such pads."
> 
> Hmm. Good question. My assumption was that such cases might appear when an
> external entity could be connected to the pad, but receivers typically have
> just a single pad. So streaming would be out of question in such case
> anyway. But my thought was that we shouldn't burden drivers by forcing them
> to unset the flag if there happens to be nothing connected to an entity.
> 
> How about just that I remove the last sentence, and s/ and the pad is linked
> to any other pad, then at least one of those links must be enabled/, the
> pad must be connected by an enabled link/? :-)
> 
> The purpose is two-fold: to allow automated pipeline validation and also
> hint the user what are the conditions for that configuration.
-- 
Regards,

Laurent Pinchart

