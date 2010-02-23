Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58433 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0BWXoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 18:44:44 -0500
MIME-Version: 1.0
In-Reply-To: <1262613782-20463-4-git-send-email-hvaibhav@ti.com>
References: <hvaibhav@ti.com>
	 <1262613782-20463-4-git-send-email-hvaibhav@ti.com>
Date: Tue, 23 Feb 2010 18:44:42 -0500
Message-ID: <55a3e0ce1002231544o36a63a07if76501bff7967b45@mail.gmail.com>
Subject: Re: [PATCH 3/9] tvp514x: add YUYV format support
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com,
	m-karicheri2@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vaibhav,


On Mon, Jan 4, 2010 at 9:02 AM,  <hvaibhav@ti.com> wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/tvp514x.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> index 4cf3593..b344b58 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -212,6 +212,13 @@ static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
>         .description = "8-bit UYVY 4:2:2 Format",
>         .pixelformat = V4L2_PIX_FMT_UYVY,
>        },
> +       {
> +        .index = 1,
> +        .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +        .flags = 0,
> +        .description = "8-bit YUYV 4:2:2 Format",
> +        .pixelformat = V4L2_PIX_FMT_YUYV,
> +       },
>  };

As per data sheet I can see only CbYCrY format output from the tvp5146
which translate to UYVY. How are you configuring tvp to output YUYV? I
don;t see any change to the code to configure this format.

CCDC can switch the CbCr order and also can swap Y/C order. So if you
are achieving
this via ccdc configuration, there is no need to add this format to tvp5146 IMO.

-Murali

>
>  /**
> --
> 1.6.2.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Murali Karicheri
mkaricheri@gmail.com
