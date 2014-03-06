Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40754 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaCFE7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 23:59:03 -0500
Received: by mail-oa0-f54.google.com with SMTP id n16so2101529oag.13
        for <linux-media@vger.kernel.org>; Wed, 05 Mar 2014 20:59:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1394081739-23017-1-git-send-email-sw0312.kim@samsung.com>
References: <CAK9yfHx0o2n7fPvPeMHmMoLrP+ZifkP2uCitpatY8pFG-hDxCA@mail.gmail.com>
	<1394081739-23017-1-git-send-email-sw0312.kim@samsung.com>
Date: Thu, 6 Mar 2014 10:29:02 +0530
Message-ID: <CAK9yfHxVDT5qd05D7hY0ZZbGL3ifTVS+=bqmg7iSHswsMPUw6Q@mail.gmail.com>
Subject: Re: [PATCH v3] [media] s5p-mfc: remove meaningless memory bank assignment
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Seung-Woo,

On 6 March 2014 10:25, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:
> This patch removes meaningless assignment of memory bank to itself.
>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> ---

Thanks for re-doing this.

Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
