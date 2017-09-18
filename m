Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46422 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752967AbdIRLoa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 07:44:30 -0400
Date: Mon, 18 Sep 2017 14:44:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Srishti Sharma <srishtishar@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [PATCH] Staging: media: atomisp: Merge assignment with return
Message-ID: <20170918114423.ewtuei2dpr7wcmdx@valkosipuli.retiisi.org.uk>
References: <1505226307-5119-1-git-send-email-srishtishar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505226307-5119-1-git-send-email-srishtishar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 12, 2017 at 07:55:07PM +0530, Srishti Sharma wrote:
> Merge the assignment and the return statements to return the value
> directly. Done using the following semantic patch by coccinelle.
> 
> @@
> local idexpression ret;
> expression e;
> @@
> 
> -ret =
> +return
>      e;
> -return ret;
> 
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>

Hi Srishti,

I've merged the two patches as they're trivial and the commit message is
the same.

It's entirely reasonable to have a patch per driver but you should mention
that in the commit message (subject line) at least. This case is a bit
special because the other driver is also specific to the atomisp staging
driver.

Thanks.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
