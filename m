Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35053 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1KYHKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 02:10:05 -0500
Date: Fri, 25 Nov 2011 09:09:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [RFC/PATCH 2/3] v4l: Document integer menu controls
Message-ID: <20111125070959.GB29342@valkosipuli.localdomain>
References: <20111124161228.GA29342@valkosipuli.localdomain>
 <1322151172-5362-2-git-send-email-sakari.ailus@iki.fi>
 <4ECED0A6.40607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECED0A6.40607@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Nov 25, 2011 at 12:17:58AM +0100, Sylwester Nawrocki wrote:
...
> > @@ -292,6 +313,20 @@ the menu items can be enumerated with the
> >   <constant>VIDIOC_QUERYMENU</constant>  ioctl.</entry>
> >   	</row>
> >   	<row>
> > +	<entry><constant>V4L2_CTRL_TYPE_INTEGER_MENU</constant></entry>
> > +	<entry>&ge; 0</entry>
> > +	<entry>1</entry>
> > +	<entry>N-1</entry>
> > +	<entry>
> > +              The control has a menu of N choices. The names of the
> > +              menu items can be enumerated with the
> 
> Shouldn't it be something along the lines of "The integer values of
> the menu items can be enumerated..." ?

Right. This is left from the original menu control definition I copied. I'll
fix this in the next version of the patchset.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
