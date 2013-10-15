Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46623 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3JOU15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 16:27:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.13] OMAP4 ISS driver
Date: Tue, 15 Oct 2013 22:28:13 +0200
Message-ID: <3340388.WzMqmsftLK@avalon>
In-Reply-To: <20131015200345.GB11731@mwanda>
References: <25127151.1ba0aYdzI6@avalon> <20131015163530.GA19058@kroah.com> <20131015200345.GB11731@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

On Tuesday 15 October 2013 23:03:45 Dan Carpenter wrote:
> On Tue, Oct 15, 2013 at 09:35:30AM -0700, Greg Kroah-Hartman wrote:
> > On Tue, Oct 15, 2013 at 06:13:04PM +0200, Laurent Pinchart wrote:
> > > Hello,
> > > 
> > > Here's a pull request for v3.13 that adds a driver for the OMAP4 ISS
> > > (camera interface).
> > 
> > I don't take pull requests for staging drivers.
> 
> Yeah...  Pull request get far less review.  I never bother reviewing
> them, honestly.  I feel bad for that.

That's why I've posted the patches for review two weeks ago. As noted in the 
pull request, I will address all comments received (there was quite a lot of 
small interesting comments but no show-stopper) as part of the driver cleanup 
work to move it out of staging.

-- 
Regards,

Laurent Pinchart

