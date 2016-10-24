Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35737
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941115AbcJXUYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 16:24:47 -0400
Date: Mon, 24 Oct 2016 18:24:41 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>, kernel@stlinux.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] staging: media: stih-cec: remove unused including
 <linux/version.h>
Message-ID: <20161024182441.00fe2b48@vento.lan>
In-Reply-To: <20161002145505.GA21312@kroah.com>
References: <1475075593-22123-1-git-send-email-weiyj.lk@gmail.com>
        <20161002145505.GA21312@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 2 Oct 2016 16:55:05 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Wed, Sep 28, 2016 at 03:13:13PM +0000, Wei Yongjun wrote:
> > From: Wei Yongjun <weiyongjun1@huawei.com>
> > 
> > Remove including <linux/version.h> that don't need it.
> > 
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> > ---
> >  drivers/staging/media/st-cec/stih-cec.c | 1 -  
> 
> This file isn't in my tree, maybe it needs to go through Mauro's...

I'm applying it here on my tree.

Regards,

Thanks,
Mauro
