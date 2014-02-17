Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53689 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751254AbaBQX3j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 18:29:39 -0500
Date: Tue, 18 Feb 2014 01:29:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v5 3/7] v4l: Add timestamp source flags, mask and
 document them
Message-ID: <20140217232931.GW15635@valkosipuli.retiisi.org.uk>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
 <1392497585-5084-4-git-send-email-sakari.ailus@iki.fi>
 <5301CE5D.7020002@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5301CE5D.7020002@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your comments.

On Mon, Feb 17, 2014 at 09:54:53AM +0100, Hans Verkuil wrote:
...
> > @@ -1119,6 +1113,31 @@ in which case caches have not been used.</entry>
> >  	    <entry>The CAPTURE buffer timestamp has been taken from the
> >  	    corresponding OUTPUT buffer. This flag applies only to mem2mem devices.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant></entry>
> > +	    <entry>0x00070000</entry>
> > +	    <entry>Mask for timestamp sources below. The timestamp source
> > +	    defines the point of time the timestamp is taken in relation to
> > +	    the frame. Logical and operation between the
> > +	    <structfield>flags</structfield> field and
> > +	    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> produces the
> > +	    value of the timestamp source.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_TSTAMP_SRC_EOF</constant></entry>
> > +	    <entry>0x00000000</entry>
> > +	    <entry>"End of frame." The buffer timestamp has been taken
> 
> More a typographical thing than anything else: I prefer this:
> 
> "End Of Frame": the buffer...
> 
> The capitalization links back to the EOF abbreviation more directly.

Fixed, same for the similar one below.

> > +	    when the last pixel of the frame has been received or the
> 
> I would say: "after the last pixel of the frame has been received or after the"
> 
> The "when" word suggests that it is exactly "when", which is not true in
> practice.

That's the intent nonetheless: to take the timestamp at the end of the
frame, not an unspecified time after the event has taken place. I'd rather
add a note that there's a level of impreciseness in taking the timestamp,
such as:

"In practice, software generated timestamp will typically be read from the
clock a small amount of time after the last pixel has been received,
depending on the system and other activity in it." That would probably be
best put somewhere else in the document, though.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
