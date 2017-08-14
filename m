Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37515 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdHNUcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 16:32:41 -0400
Subject: Re: [PATCH 0/2] More s5p-jpeg fixes
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1502191352-11595-1-git-send-email-andrzej.p@samsung.com>
 <CGME20170811115011eucas1p2d31daaa9e6f8d142291d9352ad5b732c@eucas1p2.samsung.com>
 <1502452201-17171-1-git-send-email-andrzej.p@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <df06d840-d0d2-4aa4-4490-152d020f6ef5@gmail.com>
Date: Mon, 14 Aug 2017 22:31:56 +0200
MIME-Version: 1.0
In-Reply-To: <1502452201-17171-1-git-send-email-andrzej.p@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thanks for the patches.

On 08/11/2017 01:49 PM, Andrzej Pietrasiewicz wrote:
> Hi All,
> 
> The first patch in the series fixes decoding path,
> the second patch fixes encoding path. Please see
> appropriate commit messages.
> 
> Andrzej Pietrasiewicz (2):
>   media: s5p-jpeg: don't overwrite result's "size" member
>   media: s5p-jpeg: set w/h when encoding
> 
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 

Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
