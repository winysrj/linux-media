Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60509 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbZKDOmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 09:42:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 5/8] drivers/media/video/uvc: Use %pUl to print UUIDs
Date: Wed, 4 Nov 2009 15:42:30 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org
References: <1254890742-28245-1-git-send-email-joe@perches.com> <200910312010.39785.laurent.pinchart@ideasonboard.com> <1257017258.1917.138.camel@Joe-Laptop.home>
In-Reply-To: <1257017258.1917.138.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041542.30543.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joe,

On Saturday 31 October 2009 20:27:38 Joe Perches wrote:
> On Sat, 2009-10-31 at 20:10 +0100, Laurent Pinchart wrote:
> > On Saturday 31 October 2009 10:07:01 Mauro Carvalho Chehab wrote:
> > > I'm assuming that those printk patches from Joe to uvc will go via your
> > >  tree, so please submit a pull request when they'll be ready for
> > > upstream.
> >
> > I'll submit the pull request as soon as the printk core patch hits
> > upstream.
> 
> I believe Andrew Morton has picked up the patches for
> his mm-commits set.  If you do nothing, these should
> show up in Linus' tree after awhile.

Thanks for the notice.

Andrew, could you please drop drivers-media-video-uvc-use-%pul-to-print-
uuids.patch ? I will push it through the v4l-dvb tree as I need to add 
backward compatibility support.

-- 
Regards,

Laurent Pinchart
