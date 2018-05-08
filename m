Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754979AbeEHMQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 08:16:53 -0400
Date: Tue, 8 May 2018 15:16:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wenwen Wang <wang6495@umn.edu>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        "open list:STAGING - ATOMISP DRIVER" <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] media: staging: atomisp: fix a potential missing-check
 bug
Message-ID: <20180508121635.mdw4jikv66iyprie@mwanda>
References: <1525300731-27324-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525300731-27324-1-git-send-email-wang6495@umn.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 02, 2018 at 05:38:49PM -0500, Wenwen Wang wrote:
> At the end of atomisp_subdev_set_selection(), the function
> atomisp_subdev_get_rect() is invoked to get the pointer to v4l2_rect. Since
> this function may return a NULL pointer, it is firstly invoked to check
> the returned pointer. If the returned pointer is not NULL, then the
> function is invoked again to obtain the pointer and the memory content
> at the location of the returned pointer is copied to the memory location of
> r. In most cases, the pointers returned by the two invocations are same.
> However, given that the pointer returned by the function
> atomisp_subdev_get_rect() is not a constant, it is possible that the two
> invocations return two different pointers. For example, another thread may
> race to modify the related pointers during the two invocations.

You're assuming a very serious race condition exists.


> In that
> case, even if the first returned pointer is not null, the second returned
> pointer might be null, which will cause issues such as null pointer
> dereference.

And then complaining that if a really serious bug exists then this very
minor bug would exist too...  If there were really a race condition like
that then we'd want to fix it instead.  In other words, this is not a
real life bug fix.

But it would be fine as a readability or static checker fix so that's
fine.

regards,
dan carpenter
