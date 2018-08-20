Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:44513 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbeHTWJK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 18:09:10 -0400
Received: by mail-qt0-f180.google.com with SMTP id b15-v6so17365100qtp.11
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2018 11:52:23 -0700 (PDT)
Message-ID: <3fe3186f007c24fb8e45784965c04f46e4e16a7d.camel@redhat.com>
Subject: Re: [Nouveau] [PATCH (repost) 2/5] drm_dp_cec: add note about good
 MegaChips 2900 CEC support
From: Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: nouveau@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Date: Mon, 20 Aug 2018 14:52:21 -0400
In-Reply-To: <20180817141122.9541-3-hverkuil@xs4all.nl>
References: <20180817141122.9541-1-hverkuil@xs4all.nl>
         <20180817141122.9541-3-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Lyude Paul <lyude@redhat.com>

On Fri, 2018-08-17 at 16:11 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> A big problem with DP CEC-Tunneling-over-AUX is that it is tricky
> to find adapters with a chipset that supports this AND where the
> manufacturer actually connected the HDMI CEC line to the chipset.
> 
> Add a mention of the MegaChips 2900 chipset which seems to support
> this feature well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/drm_dp_cec.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_cec.c b/drivers/gpu/drm/drm_dp_cec.c
> index 1407b13a8d5d..8a718f85079a 100644
> --- a/drivers/gpu/drm/drm_dp_cec.c
> +++ b/drivers/gpu/drm/drm_dp_cec.c
> @@ -16,7 +16,9 @@
>   * here. Quite a few active (mini-)DP-to-HDMI or USB-C-to-HDMI adapters
>   * have a converter chip that supports CEC-Tunneling-over-AUX (usually the
>   * Parade PS176), but they do not wire up the CEC pin, thus making CEC
> - * useless.
> + * useless. Note that MegaChips 2900-based adapters appear to have good
> + * support for CEC tunneling. Those adapters that I have tested using
> + * this chipset all have the CEC line connected.
>   *
>   * Sadly there is no way for this driver to know this. What happens is
>   * that a /dev/cecX device is created that is isolated and unable to see
