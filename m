Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48809 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718AbaBPRui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 12:50:38 -0500
Date: Sun, 16 Feb 2014 19:50:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v5 7/7] v4l: Document timestamp buffer flag behaviour
Message-ID: <20140216175032.GR15635@valkosipuli.retiisi.org.uk>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-8-git-send-email-sakari.ailus@iki.fi>
 <52FFD60B.4080308@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FFD60B.4080308@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Feb 15, 2014 at 10:03:07PM +0100, Hans Verkuil wrote:
> On 02/15/2014 09:53 PM, Sakari Ailus wrote:
> > Timestamp buffer flags are constant at the moment. Document them so that 1)
> > they're always valid and 2) not changed by the drivers. This leaves room to
> > extend the functionality later on if needed.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/io.xml |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > index fbd0c6e..4f76565 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -653,6 +653,16 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
> >  In that case, struct <structname>v4l2_buffer</structname> contains an array of
> >  plane structures.</para>
> >  
> > +    <para>Dequeued video buffers come with timestamps. These
> > +    timestamps can be taken from different clocks and at different
> > +    part of the frame, depending on the driver. Please see flags in
> 
> s/part/parts/
> 
> But I think I would write it somewhat differently:
> 
> "The driver decides at which part of the frame and with which clock
> the timestamp is taken."

I'll fix both for the next version.

> > +    the masks <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
> > +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
> > +    linkend="buffer-flags">. These flags are guaranteed to be always
> > +    valid and will not be changed by the driver autonomously. Changes
> > +    in these flags may take place due as a side effect of
> 
> s/due//

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
