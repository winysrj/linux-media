Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbeKZSZt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 13:25:49 -0500
Date: Mon, 26 Nov 2018 08:32:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        "for 4.14 and up" <stable@vger.kernel.org>
Subject: Re: [PATCH v4.4 1/1] v4l: event: Add subscription to list before
 calling "add" operation
Message-ID: <20181126073233.GD18375@kroah.com>
References: <20181108114632.17194-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108114632.17194-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 08, 2018 at 01:46:32PM +0200, Sakari Ailus wrote:
> [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
> 
> Patch ad608fbcf166 changed how events were subscribed to address an issue
> elsewhere. As a side effect of that change, the "add" callback was called
> before the event subscription was added to the list of subscribed events,
> causing the first event queued by the add callback (and possibly other
> events arriving soon afterwards) to be lost.
> 
> Fix this by adding the subscription to the list before calling the "add"
> callback, and clean up afterwards if that fails.
> 
> Fixes: ad608fbcf166 ("media: v4l: event: Prevent freeing event subscriptions while accessed")
> 
> Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vger.kernel.org (for 4.14 and up)
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/v4l2-core/v4l2-event.c | 43 ++++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 19 deletions(-)

Now applied, thanks.

greg k-h
