Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:56191 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933818AbcIFJVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:21:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: p.zabel@pengutronix.de, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        xie.baoyou@zte.com.cn
Subject: Re: [PATCH] [media] coda: add missing header dependencies
Date: Tue, 06 Sep 2016 11:21:38 +0200
Message-ID: <17845866.BEgCsGq73Z@wuerfel>
In-Reply-To: <1473148256-25347-1-git-send-email-baoyou.xie@linaro.org>
References: <1473148256-25347-1-git-send-email-baoyou.xie@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 6, 2016 3:50:56 PM CEST Baoyou Xie wrote:
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> +#include <coda.h>
> 

by convention, we tend to write this as

#include "coda.h"

otherwise the patch looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
