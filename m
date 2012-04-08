Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:56380 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754527Ab2DHD4O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Apr 2012 23:56:14 -0400
Received: by qadb15 with SMTP id b15so1366996qad.2
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 20:56:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333857274-9435-1-git-send-email-saaguirre@ti.com>
References: <1333857274-9435-1-git-send-email-saaguirre@ti.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sat, 7 Apr 2012 22:55:52 -0500
Message-ID: <CAKnK67QWG2FhMzFHipu04wxWBzYfEd0A1wp=5LqR8kb-JQmffA@mail.gmail.com>
Subject: Re: [PATCH] Add support for YUV420 formats
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Sorry, forgot to mention that this is for your media-ctl app.

Regards,
Sergio

On Sat, Apr 7, 2012 at 10:54 PM,  <saaguirre@ti.com> wrote:
> From: Sergio Aguirre <saaguirre@ti.com>
>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  src/v4l2subdev.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> index b886b72..e28ed49 100644
> --- a/src/v4l2subdev.c
> +++ b/src/v4l2subdev.c
> @@ -498,8 +498,10 @@ static struct {
>        { "Y12", V4L2_MBUS_FMT_Y12_1X12 },
>        { "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
>        { "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
> +       { "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
>        { "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
>        { "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
> +       { "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
>        { "SBGGR8", V4L2_MBUS_FMT_SBGGR8_1X8 },
>        { "SGBRG8", V4L2_MBUS_FMT_SGBRG8_1X8 },
>        { "SGRBG8", V4L2_MBUS_FMT_SGRBG8_1X8 },
> --
> 1.7.5.4
>
