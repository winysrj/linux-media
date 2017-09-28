Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:18247 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdI1NCw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 09:02:52 -0400
Subject: Re: [RESEND PATCH v2 13/17] media: v4l2-async: simplify
 v4l2_async_subdev structure
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <90cfb08b-b363-a317-8781-dcb191805c80@samsung.com>
Date: Thu, 28 Sep 2017 15:02:37 +0200
MIME-version: 1.0
In-reply-to: <20170928125316.texy2qrzpvzekp7a@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <cover.1506548682.git.mchehab@s-opensource.com>
        <20170928125316.texy2qrzpvzekp7a@valkosipuli.retiisi.org.uk>
        <CGME20170928130249epcas2p2c1f6e52226c3a5c72829b1bf3cbaa0cd@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2017 02:53 PM, Mauro Carvalho Chehab wrote:
> (Resending for Mauro, while dropping the non-list recipients. The original
> likely had too many recipients.)
> 
> The V4L2_ASYNC_MATCH_FWNODE match criteria requires just one
> struct to be filled (struct fwnode_handle). The V4L2_ASYNC_MATCH_DEVNAME
> match criteria requires just a device name.
> 
> So, it doesn't make sense to enclose those into structs,
> as the criteria can go directly into the union.
> 
> That makes easier to document it, as we don't need to document
> weird senseless structs.
> 
> At drivers, this makes even clearer about the match criteria.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
