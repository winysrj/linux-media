Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33212 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932781AbeCEJrY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 04:47:24 -0500
Date: Mon, 5 Mar 2018 12:47:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: jacopo+renesas@jmondi.org, linux-media@vger.kernel.org
Subject: Re: [bug report] media: i2c: Copy tw9910 soc_camera sensor driver
Message-ID: <20180305094714.a77u4xe5d6bgzdxc@mwanda>
References: <20180301095954.GA12656@mwanda>
 <20180302142016.GG4023@w540>
 <20180305072109.xl446yralwhapdap@mwanda>
 <20180305085148.GH4023@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305085148.GH4023@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 05, 2018 at 09:51:48AM +0100, jacopo mondi wrote:
> In your suggested fix:
> 
> > 	(((vdelay >> 8) & 0x3) << 6) |
> > 	(((vact >> 8) & 0x3) << 4) |
> > 	(((hedelay >> 8) & 0x3) << 2) |
> > 	((hact >> 8) & 0x03);
> >
> 
> Won't your analyzer in that case point out that
> "15 >> 8 is zero" again? I may have been underestimating it though
>

It will complain, yes, but it's a pretty common false positive and I
have it in the back of my head to teach the static checker to look for
that situation.  Eventually I will get around to it.

regards,
dan carpenter
