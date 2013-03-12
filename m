Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:59952 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3CLPKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 11:10:11 -0400
Received: by mail-oa0-f53.google.com with SMTP id m1so5830024oag.26
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 08:10:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1361275236-16071-1-git-send-email-sachin.kamat@linaro.org>
References: <1361275236-16071-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 12 Mar 2013 20:40:10 +0530
Message-ID: <CAK9yfHxKYVUdKik5Q04HhpFccS7KwM6T6HqXMBzB=v7h_o58SQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] timblogiw: Fix sparse warning
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, sachin.kamat@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 February 2013 17:30, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Fixes the below warning:
> drivers/media/platform/timblogiw.c:81:31: warning:
> symbol 'timblogiw_tvnorms' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

ping..


> ---
>  drivers/media/platform/timblogiw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
> index c3a2a44..2d91eeb 100644
> --- a/drivers/media/platform/timblogiw.c
> +++ b/drivers/media/platform/timblogiw.c
> @@ -78,7 +78,7 @@ struct timblogiw_buffer {
>         struct timblogiw_fh     *fh;
>  };
>
> -const struct timblogiw_tvnorm timblogiw_tvnorms[] = {
> +static const struct timblogiw_tvnorm timblogiw_tvnorms[] = {
>         {
>                 .std                    = V4L2_STD_PAL,
>                 .width                  = 720,
> --
> 1.7.4.1
>



-- 
With warm regards,
Sachin
