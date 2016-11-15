Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35932 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752823AbcKOUxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 15:53:16 -0500
Date: Tue, 15 Nov 2016 22:52:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Edgar Thier <info@edgarthier.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Add bayer 16-bit format patterns
Message-ID: <20161115205240.GA12971@valkosipuli.retiisi.org.uk>
References: <87h97achun.fsf@edgarthier.net>
 <1640565.qtzjRM8HWd@avalon>
 <20161115170402.GY3217@valkosipuli.retiisi.org.uk>
 <4228838.ihduIDFkeB@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4228838.ihduIDFkeB@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 15, 2016 at 09:07:59PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday 15 Nov 2016 19:04:02 Sakari Ailus wrote:
> > On Tue, Nov 15, 2016 at 04:44:04PM +0200, Laurent Pinchart wrote:
> > > Hi Sakari,
> > 
> > ...
> > 
> > >> +Description
> > >> +===========
> > >> +
> > >> +These four pixel formats are raw sRGB / Bayer formats with 16 bits per
> > >> +sample. Each sample is stored in a 16-bit word. Each n-pixel row
> > >> contains
> > >> +n/2 green samples and n/2 blue or red samples, with alternating red and
> > >> blue
> > >> +rows. Bytes are stored in memory in little endian order. They are
> > >> +conventionally described as GRGR... BGBG..., RGRG... GBGB..., etc.
> > >> Below is
> > >> +an example of one of these formats:
> > >
> > > To make it clearer, how about telling which format that is ?
> > 
> > I don't object the change as such, but the text is the same than on other
> > bayer formats as well. The fix should not be done on this one only.
> > 
> > I propose to handle that separately if that's ok for you.
> 
> I'm fine with that, can you submit a patch ? :-)

Sure, likely tomorrow.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
