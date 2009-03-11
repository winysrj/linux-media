Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:35906 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZCKS0i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 14:26:38 -0400
Date: Wed, 11 Mar 2009 11:24:11 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 11 (staging/multimedia)
Message-ID: <20090311182411.GA6501@suse.de>
References: <20090311225913.51589223.sfr@canb.auug.org.au> <49B7F107.7030303@oracle.com> <20090311181153.GA11088@suse.de> <49B80140.5000304@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B80140.5000304@oracle.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 11, 2009 at 11:21:52AM -0700, Randy Dunlap wrote:
> Greg KH wrote:
> > On Wed, Mar 11, 2009 at 10:12:39AM -0700, Randy Dunlap wrote:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Changes since 20090310:
> >>
> >> drivers/staging/go7007/go7007-v4l2.c:1830: error: 'VID_TYPE_CAPTURE' undeclared here (not in a function)
> > 
> > Odd, nothing has changed in this driver, is this a v4l api change?
> 
> I don't know if the vl4 API changed, but this error has been around
> for some time now.  Just because it's just now being reported is one
> change.  Surely other people build these drivers.  ???

I do, and don't seem to get this error.

Ah, it's a CONFIG_VIDEO_V4L1_COMPAT issue.  I'll see what needs to do to
fix this up.

thanks,

greg k-h
