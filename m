Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34912 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbdGSKtC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:49:02 -0400
Received: by mail-wm0-f67.google.com with SMTP id n64so2002430wmg.2
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 03:49:02 -0700 (PDT)
Subject: Re: [PATCH] [media] coda: disable BWB only while decoding on CODA 960
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
References: <20170719100612.16748-1-p.zabel@pengutronix.de>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <11dc2985-53b9-3ffe-9d55-1b9e4885f5a5@gmail.com>
Date: Wed, 19 Jul 2017 11:48:58 +0100
MIME-Version: 1.0
In-Reply-To: <20170719100612.16748-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/07/17 11:06, Philipp Zabel wrote:
> Disabling the BWB works around hangups observed while decoding. Since no
> issues have been observed while encoding, and disabling BWB also reduces
> encoding performance, reenable it for encoding.

Thanks for the speedy patch Philipp.

I can only test encode, but I can confirm that this patch restores the 
VPU encode performance. With that limitation...

Tested-by: Ian Arkver <ian.arkver.dev@gmail.com>

> Cc: Ian Arkver <ian.arkver.dev@gmail.com>
> Reported-by: Ian Arkver <ian.arkver.dev@gmail.com>
> Fixes: 89ed025d5c53 ("[media] coda: disable BWB for all codecs on CODA 960")
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
