Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:40552 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZDADUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 23:20:21 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2761649yxl.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 20:20:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15ed362e0903312012w733db706g6d617336f98c642f@mail.gmail.com>
References: <15ed362e0903312012w733db706g6d617336f98c642f@mail.gmail.com>
Date: Tue, 31 Mar 2009 23:20:19 -0400
Message-ID: <412bdbff0903312020o6c495845pab3ac4e7f23c5edd@mail.gmail.com>
Subject: Re: [PATCH] XC5000 support for DVB-T 6MHz and 8MHz
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/3/31 David Wong <davidtlwong@gmail.com>:
> This patch add XC5000 supports for DVB-T 6MHz and 8MHz bandwidth.
>
> Signed-off-by: David T.L. Wong <davidtlwong@gmail.com>

At first glance the patch looks sane.

Mauro, please do not merge this directly.  I am preparing a series of
xc5000 patches this week, and I will include this patch in the series
(which will get reviewed by stoth).  Also, I don't want this to go in
without having done at least some sanity testing under ATSC to ensure
it doesn't introduce any regressions (not that I think it will).

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
