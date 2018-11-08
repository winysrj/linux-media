Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbeKIDFY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Nov 2018 22:05:24 -0500
Date: Thu, 8 Nov 2018 12:28:53 -0500
From: Sasha Levin <sashal@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        "for 4.14 and up" <stable@vger.kernel.org>
Subject: Re: [PATCH v4.9 1/1] v4l: event: Add subscription to list before
 calling "add" operation
Message-ID: <20181108172853.GF8097@sasha-vm>
References: <20181108114606.17148-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20181108114606.17148-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 08, 2018 at 01:46:06PM +0200, Sakari Ailus wrote:
>[ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
>
>Patch ad608fbcf166 changed how events were subscribed to address an issue
>elsewhere. As a side effect of that change, the "add" callback was called
>before the event subscription was added to the list of subscribed events,
>causing the first event queued by the add callback (and possibly other
>events arriving soon afterwards) to be lost.
>
>Fix this by adding the subscription to the list before calling the "add"
>callback, and clean up afterwards if that fails.
>
>Fixes: ad608fbcf166 ("media: v4l: event: Prevent freeing event subscriptions while accessed")
>
>Reported-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
>Cc: stable@vger.kernel.org (for 4.14 and up)
>Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Hi Sakari,

For the sake of completeness, can you sign off on the backport too and
indicate it was backported to 4.9 in the commit messge? Otherwise, this
commit message says it's for 4.14+ and will suddenly appear in the 4.9
tree, and if we have issues later it might cause confusion.

--
Thanks,
Sasha
