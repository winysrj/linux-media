Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45102 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915Ab2JXPCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 11:02:44 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so639399vcb.19
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2012 08:02:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351088137-11472-3-git-send-email-k.debski@samsung.com>
References: <1351088137-11472-1-git-send-email-k.debski@samsung.com>
	<1351088137-11472-3-git-send-email-k.debski@samsung.com>
Date: Wed, 24 Oct 2012 20:32:40 +0530
Message-ID: <CAK9yfHxccJgf9jxP-zGOvroTiDs=jKOjUkNQdoijCNeTL9VACw@mail.gmail.com>
Subject: Re: [PATCH 3/4] s5p-mfc: Fix vidioc_subscribe_event declaration
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

I have already submitted a similar patch [1] which Sylwester has
applied to his tree.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg53857.html

-- 
With warm regards,
Sachin

On 24 October 2012 19:45, Kamil Debski <k.debski@samsung.com> wrote:
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index 2af6d52..4b01b02 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1542,7 +1542,7 @@ int vidioc_encoder_cmd(struct file *file, void *priv,
>  }
>
>  static int vidioc_subscribe_event(struct v4l2_fh *fh,
> -                                       struct v4l2_event_subscription *sub)
> +                               const struct  v4l2_event_subscription *sub)
>  {
>         switch (sub->type) {
>         case V4L2_EVENT_EOS:
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
