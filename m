Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55177 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3I3XVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 19:21:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sylwester.nawrocki@gmail.com
Subject: Re: [PATCH 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
Date: Tue, 01 Oct 2013 01:21:58 +0200
Message-ID: <2051351.luZaPOfRE8@avalon>
In-Reply-To: <20130930230846.GH3022@valkosipuli.retiisi.org.uk>
References: <1379541668-23085-1-git-send-email-sakari.ailus@iki.fi> <30672590.OiMqoca9Fg@avalon> <20130930230846.GH3022@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 01 October 2013 02:08:47 Sakari Ailus wrote:
> On Fri, Sep 20, 2013 at 11:08:47PM +0200, Laurent Pinchart wrote:
> > On Thursday 19 September 2013 01:01:05 Sakari Ailus wrote:
> > > Pads that set this flag must be connected by an active link for the
> > > entity
> > > to stream.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > Acked-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> > > ---
> > > 
> > >  Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |    8 +++++++
> > >  include/uapi/linux/media.h                               |    1 +
> > >  2 files changed, 9 insertions(+)
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> > > b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml index
> > > 355df43..59b212a 100644
> > > --- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> > > +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
> > > @@ -134,6 +134,14 @@
> > >  	    <entry>Output pad, relative to the entity. Output pads source
> > >  	    data and are origins of links.</entry>
> > >  	  </row>
> > > +	  <row>
> > > +	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
> > > +	    <entry>A pad must be connected with an enabled link for the
> > 
> > s/A pad/The pad/ ?
> 
> Fixed.
> 
> > > +	    entity to be able to stream. There could be temporary reasons
> > > +	    (e.g. device configuration dependent) for the pad to need
> > > +	    connecting; the absence of the flag won't say there
> > > +	    may not be any.</entry>
> > 
> > I believe the description doesn't make it very explicit that a
> > MUST_CONNECT pad with no existing link is valid, as opposed to existing
> > links with no enabled link, which would be invalid. Do you think we should
> > fix that ?
> 
> Yes. I propose to add this: "The flag has no effect on pads without
> connected links."

What about

If the pad is linked to any other pad, at least one of the links must be
enabled for the entity to be able to stream. There could be temporary reasons
(e.g. device configuration dependent) for the pad to need enabled links; the 
absence of the flag doesn't imply there is none. The flag has no effect on
pads without connected links.

> > > +	  </row>
> > >  	</tbody>
> > >        </tgroup>
> > >      </table>

-- 
Regards,

Laurent Pinchart

