Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27049 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbcK1NvH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 08:51:07 -0500
Date: Mon, 28 Nov 2016 16:49:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sakari Alius <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        wharms@bfs.de, linux-media@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] uvcvideo: freeing an error pointer
Message-ID: <20161128134358.GS6266@mwanda>
References: <20161125102835.GA5856@mwanda>
 <2064794.XNX8XhaLMu@avalon>
 <58384F15.4040207@bfs.de>
 <11316049.HORSOXRmDr@avalon>
 <20161125192024.GI6266@mwanda>
 <20161127162145.GF16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161127162145.GF16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I understand the comparison, but I just think it's better if people
always keep track of what has been allocated and what has not.  I tried
so hard to get Markus to stop sending those hundreds of patches where
he's like "this function has a sanity check so we can pass pointers
that weren't allocated"...  It's garbage code.

But I understand that other people don't agree.

regards,
dan carpenter

