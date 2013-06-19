Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34602 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933991Ab3FSKkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 06:40:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] Print parser position on error
Date: Wed, 19 Jun 2013 12:40:29 +0200
Message-ID: <1665015.Jt87nLofNI@avalon>
In-Reply-To: <20130619053054.GD32299@pengutronix.de>
References: <1368019674-25761-1-git-send-email-s.hauer@pengutronix.de> <15767957.U4axePOriY@avalon> <20130619053054.GD32299@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Wednesday 19 June 2013 07:30:54 Sascha Hauer wrote:
> On Wed, Jun 19, 2013 at 02:39:48AM +0200, Laurent Pinchart wrote:
> > On Monday 10 June 2013 15:56:01 Laurent Pinchart wrote:
> > > Hi Sascha,
> > > 
> > > I'm sorry for the late reply.
> > > 
> > > Great patch set, thank you. It's very helpful.
> > 
> > Should I got ahead and apply the patch with the proposed modifications
> > below ?
>
> That'd be nice. I'm a bit out of the loop at the moment and don't have
> a setup handy to test the changes.

Pushed, thank you.
 
> > > No need to cast to a char * here, end is already a char *.
> > > 
> > > What would you think about adding
> > > 
> > > +       /* endp can be NULL. To avoid spreading NULL checks across the
> > > +        * function, set endp to &end in that case.
> > > +        */
> > > +       if (endp == NULL)
> > > +               endp = &end;
> > > 
> > > at the beginning of the function and removing the endp NULL checks that
> > > are
> > > spread across the code below ?
> 
> Good idea. Your other suggestions also look good.

-- 
Regards,

Laurent Pinchart

