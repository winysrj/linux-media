Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45622 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752255AbeD3PPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 11:15:06 -0400
Date: Mon, 30 Apr 2018 18:15:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] media: ispstat: don't dereference user_cfg before
 a null check
Message-ID: <20180430151503.d3kq2zomil6uh2xf@valkosipuli.retiisi.org.uk>
References: <20180424130618.18211-1-colin.king@canonical.com>
 <20180426083731.72bmygsp2waf3eeu@valkosipuli.retiisi.org.uk>
 <2302951.d1m0yxIoYN@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2302951.d1m0yxIoYN@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 01:03:15PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday, 26 April 2018 11:37:31 EEST Sakari Ailus wrote:
> > On Tue, Apr 24, 2018 at 02:06:18PM +0100, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > The pointer user_cfg (a copy of new_conf) is dereference before
> > > new_conf is null checked, hence we may have a null pointer dereference
> > > on user_cfg when assigning buf_size from user_cfg->buf_size. Ensure
> > > this does not occur by moving the assignment of buf_size after the
> > > null check.
> > > 
> > > Detected by CoverityScan, CID#1468386 ("Dereference before null check")
> > > 
> > > Fixes: 68e342b3068c ("[media] omap3isp: Statistics")
> > > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > 
> > Thanks for the patch.
> > 
> > Gustavo sent effectively the same patch a moment earlier, and that patch
> > got applied instead.
> 
> Isn't there a guarantee that new_buf won't be NULL ? The new_buf pointer comes 
> from the parg variable in video_usercopy(), which should always point to a 
> valid buffer given that the ioctl number specifies a non-zero size.

Fair question. After looking at the code, I agree with you; there should be
no reason to perform the check in the first place. It may have been that
the function has been used differently in the past but the check should be
rather removed now.

I'll drop the patch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
