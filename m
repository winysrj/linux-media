Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:36882 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab2D1PJz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:09:55 -0400
Received: by qabg1 with SMTP id g1so862132qab.20
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 08:09:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335362233-31022-1-git-send-email-saaguirre@ti.com>
References: <1335362233-31022-1-git-send-email-saaguirre@ti.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sat, 28 Apr 2012 10:04:01 -0500
Message-ID: <CAKnK67SP3JLHjR0w60wh6rh6zmXOB8gQFNfS08SS3ghddMoyLg@mail.gmail.com>
Subject: Re: [media-ctl PATCH] Compare entity name length aswell
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Wed, Apr 25, 2012 at 8:57 AM, Sergio Aguirre <saaguirre@ti.com> wrote:
> Otherwise, some false positives might arise when
> having 2 subdevices with similar names, like:
>
> "OMAP4 ISS ISP IPIPEIF"
> "OMAP4 ISS ISP IPIPE"
>
> Before this patch, trying to find "OMAP4 ISS ISP IPIPE", resulted
> in a false entity match, retrieving "OMAP4 ISS ISP IPIPEIF"
> information instead.
>
> Checking length should ensure such cases are handled well.

Any feedback about this?

Regards,
Sergio

>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  src/mediactl.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/src/mediactl.c b/src/mediactl.c
> index 5b8c587..451a386 100644
> --- a/src/mediactl.c
> +++ b/src/mediactl.c
> @@ -66,7 +66,8 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
>        for (i = 0; i < media->entities_count; ++i) {
>                struct media_entity *entity = &media->entities[i];
>
> -               if (strncmp(entity->info.name, name, length) == 0)
> +               if ((strncmp(entity->info.name, name, length) == 0) &&
> +                   (strlen(entity->info.name) == length))
>                        return entity;
>        }
>
> --
> 1.7.5.4
>
