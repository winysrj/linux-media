Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47304 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753717AbeDZIhd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 04:37:33 -0400
Date: Thu, 26 Apr 2018 11:37:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Colin King <colin.king@canonical.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] media: ispstat: don't dereference user_cfg before
 a null check
Message-ID: <20180426083731.72bmygsp2waf3eeu@valkosipuli.retiisi.org.uk>
References: <20180424130618.18211-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424130618.18211-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 02:06:18PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer user_cfg (a copy of new_conf) is dereference before
> new_conf is null checked, hence we may have a null pointer dereference
> on user_cfg when assigning buf_size from user_cfg->buf_size. Ensure
> this does not occur by moving the assignment of buf_size after the
> null check.
> 
> Detected by CoverityScan, CID#1468386 ("Dereference before null check")
> 
> Fixes: 68e342b3068c ("[media] omap3isp: Statistics")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks for the patch.

Gustavo sent effectively the same patch a moment earlier, and that patch
got applied instead.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
