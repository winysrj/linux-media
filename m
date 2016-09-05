Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36289 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754290AbcIESUR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 14:20:17 -0400
Subject: Re: [PATCH] [media] cx24120: do not allow an invalid delivery system
 types
To: Colin King <colin.king@canonical.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20160903170417.14061-1-colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <221de1f3-05be-3c91-a001-2093f4cb161b@gmail.com>
Date: Mon, 5 Sep 2016 19:20:12 +0100
MIME-Version: 1.0
In-Reply-To: <20160903170417.14061-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/16 18:04, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> cx24120_set_frontend currently allows invalid delivery system types
> other than SYS_DVBS2 and SYS_DVBS.  Fix this by returning -EINVAL
> for invalid values.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/media/dvb-frontends/cx24120.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Yes, that's needed, thanks!

Acked-by: Jemma Denson <jdenson@gmail.com>

