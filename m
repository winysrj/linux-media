Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30800 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932162AbcKYTU7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 14:20:59 -0500
Date: Fri, 25 Nov 2016 22:20:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: wharms@bfs.de, linux-media@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Sakari Alius <sakari.ailus@iki.fi>
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
Message-ID: <20161125192024.GI6266@mwanda>
References: <20161125102835.GA5856@mwanda>
 <2064794.XNX8XhaLMu@avalon>
 <58384F15.4040207@bfs.de>
 <11316049.HORSOXRmDr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11316049.HORSOXRmDr@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 25, 2016 at 06:02:45PM +0200, Laurent Pinchart wrote:
> Sakari Ailus (CC'ed) has expressed the opinion that we might want to go one 
> step further and treat error pointers the same way we treat NULL or ZERO 
> pointers today, by just returning without logging anything. The reasoning is 
> that accepting a NULL pointer in kfree() was decided before we made extensive 
> use of allocation APIs returning error pointers, so it could be time to update 
> kfree() based on the current allocation usage patterns.

Just don't free things that haven't been allocated.  That honestly seems
like a simple rule to me, whenever I touch error handling code it feels
better and simpler after I fix the bugs.  Error handling doesn't have to
be complicated if you just follow the rules.

regards,
dan carpenter

