Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45121 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbeKZS1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 13:27:38 -0500
Date: Mon, 26 Nov 2018 08:34:22 +0100
From: Greg KH <greg@kroah.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        "for 4.14 and up" <stable@vger.kernel.org>
Subject: Re: [PATCH v3.16 2/2] v4l: event: Add subscription to list before
 calling "add" operation
Message-ID: <20181126073422.GF18375@kroah.com>
References: <20181108120350.17266-1-sakari.ailus@linux.intel.com>
 <20181108120350.17266-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108120350.17266-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 08, 2018 at 02:03:50PM +0200, Sakari Ailus wrote:
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

Now applied, thanks.

greg k-h
