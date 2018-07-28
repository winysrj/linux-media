Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:40578 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbeG1UVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jul 2018 16:21:08 -0400
Received: by mail-qt0-f194.google.com with SMTP id h4-v6so8369565qtj.7
        for <linux-media@vger.kernel.org>; Sat, 28 Jul 2018 11:53:43 -0700 (PDT)
Date: Sat, 28 Jul 2018 15:53:38 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?=
        <ville.syrjala@linux.intel.com>
Subject: Re: [PATCH for v4.19] drm_dp_cec.c: fix formatting typo: %pdH -> %phD
Message-ID: <20180728185338.GA14560@juma>
References: <f3720ddf-ec0f-cd22-46b6-720a5e2098f2@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3720ddf-ec0f-cd22-46b6-720a5e2098f2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 24, 2018 at 09:20:28PM +0200, Hans Verkuil wrote:
> This caused a kernel oops since %pdH interpreted the pointer
> as a struct file.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/drm_dp_cec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
> index 87b67cc1ea58..a6cac47f6248 100644
> --- a/drivers/gpu/drm/drm_dp_cec.c
> +++ b/drivers/gpu/drm/drm_dp_cec.c
> @@ -157,7 +157,7 @@ static void drm_dp_cec_adap_status(struct cec_adapter *adap,
> 
>  	if (drm_dp_read_desc(aux, &desc, true))
>  		return;
> -	seq_printf(file, "OUI: %*pdH\n",
> +	seq_printf(file, "OUI: %*phD\n",
>  		   (int)sizeof(id->oui), id->oui);
>  	seq_printf(file, "ID: %*pE\n",
>  		   (int)strnlen(id->device_id, sizeof(id->device_id)),

pushed to drm-misc-next-fixes for 4.19. Thanks.

Gustavo
