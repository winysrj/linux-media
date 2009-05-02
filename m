Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:11336 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZEBGzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 02:55:53 -0400
Date: Sat, 2 May 2009 08:55:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@isely.net>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pvrusb2: Don't use the internal i2c client list
Message-ID: <20090502085543.6d6920c3@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0905012223040.15541@cnc.isely.net>
References: <20090430173554.4cb2f585@hyperion.delvare>
	<Pine.LNX.4.64.0904301924520.15541@cnc.isely.net>
	<Pine.LNX.4.64.0905012223040.15541@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 1 May 2009 22:25:28 -0500 (CDT), Mike Isely wrote:
> On Thu, 30 Apr 2009, Mike Isely wrote:
> 
> > On Thu, 30 Apr 2009, Jean Delvare wrote:
> > 
> > > The i2c core used to maintain a list of client for each adapter. This
> > > is a duplication of what the driver core already does, so this list
> > > will be removed as part of a future cleanup. Anyone using this list
> > > must stop doing so.
> > > 
> > > For pvrusb2, I propose the following change, which should lead to an
> > > equally informative output. The only difference is that i2c clients
> > > which are not a v4l2 subdev won't show up, but I guess this case is
> > > not supposed to happen anyway.
> > 
> > It will happen for anything i2c used by v4l which itself is not really a 
> > part of v4l.  That would include, uh, lirc.
> > 
> > I will review and test this first chance I get which should be tomorrow.
> > 
> 
> I've merged and tested this patch.  It behaves as expected.
> 
> I'm putting together a bunch of pvrusb2 changesets right now anyway.  
> I've pulled this one into the collection, with appropriate attributions 
> of course.

Excellent, thank you!

-- 
Jean Delvare
