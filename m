Return-path: <mchehab@pedra>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46819 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1FGE4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 00:56:14 -0400
Received: by yie30 with SMTP id 30so733134yie.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 21:56:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1106061917080.11169@axis700.grange>
References: <Pine.LNX.4.64.1106061917080.11169@axis700.grange>
Date: Tue, 7 Jun 2011 12:56:13 +0800
Message-ID: <BANLkTikFAgYcWLw=Pn142sXLVoqv9GtW7g@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: MIPI flags are not sensor flags
From: Kassey Lee <kassey1216@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi, Guennadi:
        I'm a little confused.
        there is possible that a board will connect the sensor with
[1234] lanes.
        so this means it could be a board-specific flags too ?

thanks!

Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.

On Tue, Jun 7, 2011 at 1:17 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> SOCAM_MIPI_[1234]LANE flags are not board-specific sensor flags, they
> are bus configuration flags.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/media/soc_camera.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 238bd33..e34b5e6 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -109,12 +109,6 @@ struct soc_camera_host_ops {
>  #define SOCAM_SENSOR_INVERT_HSYNC      (1 << 2)
>  #define SOCAM_SENSOR_INVERT_VSYNC      (1 << 3)
>  #define SOCAM_SENSOR_INVERT_DATA       (1 << 4)
> -#define SOCAM_MIPI_1LANE               (1 << 5)
> -#define SOCAM_MIPI_2LANE               (1 << 6)
> -#define SOCAM_MIPI_3LANE               (1 << 7)
> -#define SOCAM_MIPI_4LANE               (1 << 8)
> -#define SOCAM_MIPI     (SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | \
> -                       SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)
>
>  struct i2c_board_info;
>  struct regulator_bulk_data;
> @@ -270,6 +264,12 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
>  #define SOCAM_PCLK_SAMPLE_FALLING      (1 << 13)
>  #define SOCAM_DATA_ACTIVE_HIGH         (1 << 14)
>  #define SOCAM_DATA_ACTIVE_LOW          (1 << 15)
> +#define SOCAM_MIPI_1LANE               (1 << 16)
> +#define SOCAM_MIPI_2LANE               (1 << 17)
> +#define SOCAM_MIPI_3LANE               (1 << 18)
> +#define SOCAM_MIPI_4LANE               (1 << 19)
> +#define SOCAM_MIPI     (SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | \
> +                       SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)
>
>  #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
>                              SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
