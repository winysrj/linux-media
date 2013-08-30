Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38451 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab3H3EIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 00:08:30 -0400
Date: Thu, 29 Aug 2013 21:00:21 -0700
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
	linux-kernel@vger.kernel.org, m.chehab@samsung.com,
	linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] uvcvideo: quirk PROBE_DEF for Dell SP2008WFP
 monitor.
Message-ID: <20130830040021.GA31290@kroah.com>
References: <cover.1377781889.git.joseph.salisbury@canonical.com>
 <efa845fedf7b2326c7fe6e82c4f90b15055c4a1c.1377781889.git.joseph.salisbury@canonical.com>
 <3172143.JtUQzMAjLG@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3172143.JtUQzMAjLG@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 30, 2013 at 02:41:17AM +0200, Laurent Pinchart wrote:
> Hi Joseph,
> 
> Thank you for the patch.
> 
> On Thursday 29 August 2013 11:17:41 Joseph Salisbury wrote:
> > BugLink: http://bugs.launchpad.net/bugs/1217957
> > 
> > Add quirk for Dell SP2008WFP monitor: 05a9:2641
> > 
> > Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> > Tested-by: Christopher Townsend <christopher.townsend@canonical.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Cc: linux-media@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I've applied it to my tree. Given that we're too close to the v3.12 merge 
> window I will push it for v3.13.

A quirk has to wait that long?  That's not ok, they should go in much
sooner than that...

thanks,

greg k-h
