Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:62382 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932874AbcK1NzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 08:55:10 -0500
Date: Mon, 28 Nov 2016 14:54:58 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Sakari Alius <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        wharms@bfs.de, linux-media@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
In-Reply-To: <20161128134358.GS6266@mwanda>
Message-ID: <alpine.DEB.2.10.1611281453100.2967@hadrien>
References: <20161125102835.GA5856@mwanda> <2064794.XNX8XhaLMu@avalon> <58384F15.4040207@bfs.de> <11316049.HORSOXRmDr@avalon> <20161125192024.GI6266@mwanda> <20161127162145.GF16630@valkosipuli.retiisi.org.uk> <20161128134358.GS6266@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 28 Nov 2016, Dan Carpenter wrote:

> I understand the comparison, but I just think it's better if people
> always keep track of what has been allocated and what has not.  I tried
> so hard to get Markus to stop sending those hundreds of patches where
> he's like "this function has a sanity check so we can pass pointers
> that weren't allocated"...  It's garbage code.
>
> But I understand that other people don't agree.

In my opinion, it is good for code understanding to only do what is useful
to do.  It's not a hard and fast rule, but I think it is something to take
into account.

julia

>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
