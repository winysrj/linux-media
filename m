Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54423 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1KYMCx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 07:02:53 -0500
Date: Fri, 25 Nov 2011 14:02:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, snjw23@gmail.com, hverkuil@xs4all.nl
Subject: Re: [RFC/PATCH 2/3] v4l: Document integer menu controls
Message-ID: <20111125120250.GD29342@valkosipuli.localdomain>
References: <20111124161228.GA29342@valkosipuli.localdomain>
 <1322151172-5362-2-git-send-email-sakari.ailus@iki.fi>
 <201111251130.33210.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111251130.33210.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2011 at 11:30:32AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.

Hi Laurent,

Thanks for the comments!

> On Thursday 24 November 2011 17:12:51 Sakari Ailus wrote:
...
> > @@ -292,6 +313,20 @@ the menu items can be enumerated with the
> >  <constant>VIDIOC_QUERYMENU</constant> ioctl.</entry>
> >  	  </row>
> >  	  <row>
> > +	    <entry><constant>V4L2_CTRL_TYPE_INTEGER_MENU</constant></entry>
> > +	    <entry>&ge; 0</entry>
> > +	    <entry>1</entry>
> > +	    <entry>N-1</entry>
> > +	    <entry>
> > +              The control has a menu of N choices. The names of the
> > +              menu items can be enumerated with the
> > +              <constant>VIDIOC_QUERYMENU</constant> ioctl. This is
> > +              similar to <constant>V4L2_CTRL_TYPE_MENU</constant>
> > +              except that instead of integers, the menu items are
> 
> Do you mean "instead of strings" ?

Yes, I do. Will fix this.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
