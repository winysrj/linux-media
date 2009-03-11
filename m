Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:35594 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZCKSOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 14:14:49 -0400
Date: Wed, 11 Mar 2009 11:11:53 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 11 (staging/multimedia)
Message-ID: <20090311181153.GA11088@suse.de>
References: <20090311225913.51589223.sfr@canb.auug.org.au> <49B7F107.7030303@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B7F107.7030303@oracle.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 11, 2009 at 10:12:39AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090310:
> 
> 
> drivers/staging/go7007/go7007-v4l2.c:1830: error: 'VID_TYPE_CAPTURE' undeclared here (not in a function)

Odd, nothing has changed in this driver, is this a v4l api change?

thanks,

greg k-h
