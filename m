Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33910 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbcC1TiO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 15:38:14 -0400
Received: by mail-io0-f193.google.com with SMTP id p21so19266365ioe.1
        for <linux-media@vger.kernel.org>; Mon, 28 Mar 2016 12:38:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3cabc4b828abac3c6dea240ae22d4754a438ad1b.1459188623.git.mchehab@osg.samsung.com>
References: <20160328150948.3efa93ee@recife.lan>
	<91b3d9b66d52707ca95d996edd423c0f5e36b6ca.1459188623.git.mchehab@osg.samsung.com>
	<3cabc4b828abac3c6dea240ae22d4754a438ad1b.1459188623.git.mchehab@osg.samsung.com>
Date: Mon, 28 Mar 2016 15:38:13 -0400
Message-ID: <CABxcv==hBbnzkX9N_6cSMwVqTZ18jps8_u_nRMgKGXSK8vXjMg@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] avoid double locks with graph_mutex
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Mon, Mar 28, 2016 at 2:11 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Add a note at the headers telling that the link setup
> callbacks are called with the mutex hold. Also, removes a
> double lock at the PM suspend callbacks.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/media-device.c      | 1 -
>  drivers/media/v4l2-core/v4l2-mc.c | 4 ----
>  include/media/media-device.h      | 3 ++-
>  include/media/media-entity.h      | 3 +++
>  4 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 6cfa890af7b4..6af5e6932271 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -93,7 +93,6 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
>         media_device_for_each_entity(entity, mdev) {
>                 if (((media_entity_id(entity) == id) && !next) ||
>                     ((media_entity_id(entity) > id) && next)) {
> -                       mutex_unlock(&mdev->graph_mutex);

This change belongs to patch 1/2.

After this change, feel free to add to both patches:

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
