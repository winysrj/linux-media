Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55504 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbeDZKDC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 06:03:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] media: ispstat: don't dereference user_cfg before a null check
Date: Thu, 26 Apr 2018 13:03:15 +0300
Message-ID: <2302951.d1m0yxIoYN@avalon>
In-Reply-To: <20180426083731.72bmygsp2waf3eeu@valkosipuli.retiisi.org.uk>
References: <20180424130618.18211-1-colin.king@canonical.com> <20180426083731.72bmygsp2waf3eeu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday, 26 April 2018 11:37:31 EEST Sakari Ailus wrote:
> On Tue, Apr 24, 2018 at 02:06:18PM +0100, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The pointer user_cfg (a copy of new_conf) is dereference before
> > new_conf is null checked, hence we may have a null pointer dereference
> > on user_cfg when assigning buf_size from user_cfg->buf_size. Ensure
> > this does not occur by moving the assignment of buf_size after the
> > null check.
> > 
> > Detected by CoverityScan, CID#1468386 ("Dereference before null check")
> > 
> > Fixes: 68e342b3068c ("[media] omap3isp: Statistics")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Thanks for the patch.
> 
> Gustavo sent effectively the same patch a moment earlier, and that patch
> got applied instead.

Isn't there a guarantee that new_buf won't be NULL ? The new_buf pointer comes 
from the parg variable in video_usercopy(), which should always point to a 
valid buffer given that the ioctl number specifies a non-zero size.

-- 
Regards,

Laurent Pinchart
