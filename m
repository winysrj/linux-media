Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946068AbbHHPnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2015 11:43:01 -0400
Date: Sat, 8 Aug 2015 08:42:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Junsu Shin <jjunes0@gmail.com>, devel@driverdev.osuosl.org,
	boris.brezillon@free-electrons.com, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org, prabhakar.csengg@gmail.com,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: media: davinci_vpfe: fix over 80 characters
 coding style issue.
Message-ID: <20150808154259.GD11851@kroah.com>
References: <1438916154-5840-1-git-send-email-jjunes0@gmail.com>
 <20150807044505.GB3537@sudip-pc>
 <55C5A7C6.9080006@gmail.com>
 <20150808101218.GA1301@sudip-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150808101218.GA1301@sudip-pc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 08, 2015 at 03:42:18PM +0530, Sudip Mukherjee wrote:
> On Sat, Aug 08, 2015 at 01:55:02AM -0500, Junsu Shin wrote:
> > 
> > On 08/06/2015 11:45 PM, Sudip Mukherjee wrote:
> > > On Thu, Aug 06, 2015 at 09:55:54PM -0500, Junsu Shin wrote:
> > > 
> <snip>
> > 
> > Thanks for pointing it out.
> > Again, this is a patch to the dm365_ipipe.c that fixes over 80 characters warning detected by the script.
> > This time I fixed up the indentation issue claimed in the previous one.
> > Signed-off-by: Junsu Shin <jjunes0@gmail.com>
> > ---
> Greg will not accept patches like this way. please send it as v2.

Greg does not accept drivers/staging/media/* patches, but anyway, no one
will accept a patch in this format, as you say.

thanks,

greg k-h
