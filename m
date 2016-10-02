Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59629 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbcJBOzF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2016 10:55:05 -0400
Date: Sun, 2 Oct 2016 16:55:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>, kernel@stlinux.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] staging: media: stih-cec: remove unused including
 <linux/version.h>
Message-ID: <20161002145505.GA21312@kroah.com>
References: <1475075593-22123-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475075593-22123-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 28, 2016 at 03:13:13PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/staging/media/st-cec/stih-cec.c | 1 -

This file isn't in my tree, maybe it needs to go through Mauro's...
