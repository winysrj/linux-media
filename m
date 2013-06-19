Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47772 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3FSFaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 01:30:55 -0400
Date: Wed, 19 Jun 2013 07:30:54 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] Print parser position on error
Message-ID: <20130619053054.GD32299@pengutronix.de>
References: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de>
 <1368019674-25761-3-git-send-email-s.hauer@pengutronix.de>
 <2088324.Z7uO2ssh1O@avalon>
 <15767957.U4axePOriY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15767957.U4axePOriY@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Jun 19, 2013 at 02:39:48AM +0200, Laurent Pinchart wrote:
> Hi Sascha,
> 
> On Monday 10 June 2013 15:56:01 Laurent Pinchart wrote:
> > Hi Sascha,
> > 
> > I'm sorry for the late reply.
> > 
> > Great patch set, thank you. It's very helpful.
> 
> Should I got ahead and apply the patch with the proposed modifications below ?

That'd be nice. I'm a bit out of the loop at the moment and don't have
a setup handy to test the changes.

> > No need to cast to a char * here, end is already a char *.
> > 
> > What would you think about adding
> > 
> > +       /* endp can be NULL. To avoid spreading NULL checks across the
> > +        * function, set endp to &end in that case.
> > +        */
> > +       if (endp == NULL)
> > +               endp = &end;
> > 
> > at the beginning of the function and removing the endp NULL checks that are
> > spread across the code below ?

Good idea. Your other suggestions also look good.

Regards
 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
