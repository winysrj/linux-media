Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53690 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750749AbdCHPH1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 10:07:27 -0500
Date: Wed, 8 Mar 2017 14:39:47 +0100
From: Greg KH <greg@kroah.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] atomisp2: unify some ifdef cases caused by format changes
Message-ID: <20170308133947.GB5221@kroah.com>
References: <148879924465.10733.17814546240558419917.stgit@acox1-desk1.ger.corp.intel.com>
 <90583522-0afb-e556-b1a6-dea0efc5392d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90583522-0afb-e556-b1a6-dea0efc5392d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 08, 2017 at 01:49:23PM +0100, Hans Verkuil wrote:
> OK, so I discovered that these patches are for a driver added to linux-next
> without it ever been cross-posted to linux-media.
> 
> To be polite, I think that's rather impolite.

They were, but got rejected due to the size :(

Mauro was cc:ed directly, he knew these were coming...

I can take care of the cleanup patches for now, you don't have to review
them if you don't want to.

thanks,

greg k-h
