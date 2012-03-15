Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52894 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761821Ab2CONBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 09:01:00 -0400
Date: Thu, 15 Mar 2012 15:00:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 09/35] v4l: Add subdev selections documentation
Message-ID: <20120315130054.GI4220@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-9-git-send-email-sakari.ailus@iki.fi>
 <4F61BC8D.7060900@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F61BC8D.7060900@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the comment!

On Thu, Mar 15, 2012 at 10:55:25AM +0100, Sylwester Nawrocki wrote:
...
> > +	<tbody valign="top">
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>which</structfield></entry>
> > +	    <entry>Active or try selection, from
> > +	    &v4l2-subdev-format-whence;.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>pad</structfield></entry>
> > +	    <entry>Pad number as reported by the media framework.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>target</structfield></entry>
> > +	    <entry>Target selection rectangle. See
> > +	    <xref linkend="v4l2-subdev-selection-targets">.</xref>.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>flags</structfield></entry>
> > +	    <entry>Flags. See
> > +	    <xref linkend="v4l2-subdev-selection-flags">.</xref></entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>&v4l2-rect;</entry>
> > +	    <entry><structfield>rect</structfield></entry>
> > +	    <entry>Crop rectangle boundaries, in pixels.</entry>
> 
> Shouldn't it be "Selection rectangle, in pixels." ?

Indeed. Fixed and pushed to my git.linuxtv.org tree. Nothing changes in the
pull req so I won't send a new one. :-)

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
