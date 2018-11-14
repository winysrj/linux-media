Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:33086 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbeKNTAE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 14:00:04 -0500
Date: Wed, 14 Nov 2018 10:57:39 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v4.9 1/1] v4l: event: Add subscription to list before
 calling "add" operation
Message-ID: <20181114085738.yitidcf5a2nt6fva@paasikivi.fi.intel.com>
References: <20181108114606.17148-1-sakari.ailus@linux.intel.com>
 <20181108172853.GF8097@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108172853.GF8097@sasha-vm>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sasha,

On Thu, Nov 08, 2018 at 12:28:53PM -0500, Sasha Levin wrote:
> On Thu, Nov 08, 2018 at 01:46:06PM +0200, Sakari Ailus wrote:
> > [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
> > 
> > Patch ad608fbcf166 changed how events were subscribed to address an issue
> > elsewhere. As a side effect of that change, the "add" callback was called
> > before the event subscription was added to the list of subscribed events,
> > causing the first event queued by the add callback (and possibly other
> > events arriving soon afterwards) to be lost.
> > 
> > Fix this by adding the subscription to the list before calling the "add"
> > callback, and clean up afterwards if that fails.
> > 
> > Fixes: ad608fbcf166 ("media: v4l: event: Prevent freeing event subscriptions while accessed")
> > 
> > Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: stable@vger.kernel.org (for 4.14 and up)
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
> Hi Sakari,
> 
> For the sake of completeness, can you sign off on the backport too and
> indicate it was backported to 4.9 in the commit messge? Otherwise, this
> commit message says it's for 4.14+ and will suddenly appear in the 4.9
> tree, and if we have issues later it might cause confusion.

Yes; I'll fix the above issues and resend.

Thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
