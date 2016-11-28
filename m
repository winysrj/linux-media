Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52212 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933080AbcK1OtY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 09:49:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Sakari Alius <sakari.ailus@iki.fi>, wharms@bfs.de,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
Date: Mon, 28 Nov 2016 16:49:36 +0200
Message-ID: <13737175.iVr8OcoHqv@avalon>
In-Reply-To: <alpine.DEB.2.10.1611281453100.2967@hadrien>
References: <20161125102835.GA5856@mwanda> <20161128134358.GS6266@mwanda> <alpine.DEB.2.10.1611281453100.2967@hadrien>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia and Dan,

On Monday 28 Nov 2016 14:54:58 Julia Lawall wrote:
> On Mon, 28 Nov 2016, Dan Carpenter wrote:
> > I understand the comparison, but I just think it's better if people
> > always keep track of what has been allocated and what has not.  I tried
> > so hard to get Markus to stop sending those hundreds of patches where
> > he's like "this function has a sanity check so we can pass pointers
> > that weren't allocated"...  It's garbage code.
> > 
> > But I understand that other people don't agree.
> 
> In my opinion, it is good for code understanding to only do what is useful
> to do.  It's not a hard and fast rule, but I think it is something to take
> into account.

On the other hand it complicates the error handling code by increasing the 
number of goto labels, and it then becomes pretty easy when reworking code to 
goto the wrong label. This is even more of an issue when the rework doesn't 
touch the error handling code, in which case the reviewers can easily miss the 
issue if they don't open the original source file to check the goto labels.

-- 
Regards,

Laurent Pinchart

