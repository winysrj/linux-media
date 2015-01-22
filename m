Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39319 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbAVLEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 06:04:36 -0500
Received: by mail-ob0-f174.google.com with SMTP id gq1so789743obb.5
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2015 03:04:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421910017-14627-1-git-send-email-michel@daenzer.net>
References: <1421910017-14627-1-git-send-email-michel@daenzer.net>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 22 Jan 2015 16:34:15 +0530
Message-ID: <CAO_48GEeQ_DJBgxGSGNuSOitPkADaPqmQwvWWCJZRBmksZEjhQ@mail.gmail.com>
Subject: Re: [PATCH] reservation: Remove shadowing local variable 'ret'
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michel,

On 22 January 2015 at 12:30, Michel Dänzer <michel@daenzer.net> wrote:
> From: Michel Dänzer <michel.daenzer@amd.com>
>
> It was causing the return value of fence_is_signaled to be ignored, making
> reservation objects signal too early.
>
Thanks; pushed to my for-next.

> Cc: stable@vger.kernel.org
> Reviewed-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
> ---
>  drivers/dma-buf/reservation.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index 3c97c8f..8a37af9 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -402,8 +402,6 @@ reservation_object_test_signaled_single(struct fence *passed_fence)
>         int ret = 1;
>
>         if (!test_bit(FENCE_FLAG_SIGNALED_BIT, &lfence->flags)) {
> -               int ret;
> -
>                 fence = fence_get_rcu(lfence);
>                 if (!fence)
>                         return -1;
> --
> 2.1.4
>



-- 
Thanks and best regards,
Sumit.
