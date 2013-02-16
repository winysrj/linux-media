Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:35896 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3BPMuh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 07:50:37 -0500
Received: by mail-qa0-f54.google.com with SMTP id hg5so682028qab.13
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 04:50:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0339a6e257048b047bde48da5a87cb5ed4932c5f.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
 <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl> <0339a6e257048b047bde48da5a87cb5ed4932c5f.1361006882.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 16 Feb 2013 18:20:16 +0530
Message-ID: <CA+V-a8tSJ0SR4sc8EHLV0GaHaRTNHaQG6yt064uhMDhigK4XMA@mail.gmail.com>
Subject: Re: [RFC PATCH 05/18] davinci: remove VPBE_ENC_DV_PRESET and rename VPBE_ENC_CUSTOM_TIMINGS
To: Hans Verkuil <hverkuil@xs4all.nl>, Sekhar Nori <nsekhar@ti.com>
Cc: linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc'ed  Sekhar, DLOS, LAK.

Sekhar Can you Ack this patch for platform changes ?

On Sat, Feb 16, 2013 at 2:58 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Remove VPBE_ENC_DV_PRESET (the DV_PRESET API is no longer supported) and
> VPBE_ENC_CUSTOM_TIMINGS is renamed to VPBE_ENC_DV_TIMINGS since the old
> "CUSTOM_TIMINGS" name is deprecated in favor of "DV_TIMINGS".
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar

> ---
>  arch/arm/mach-davinci/board-dm644x-evm.c      |    4 ++--
>  arch/arm/mach-davinci/dm644x.c                |    2 +-
>  drivers/media/platform/davinci/vpbe.c         |    8 ++++----
>  drivers/media/platform/davinci/vpbe_display.c |    2 +-
>  drivers/media/platform/davinci/vpbe_venc.c    |    8 ++++----
>  include/media/davinci/vpbe_types.h            |    3 +--
>  6 files changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index 8e1b4ff..e8dc70b 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -649,7 +649,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
>  static struct vpbe_enc_mode_info dm644xevm_enc_preset_timing[] = {
>         {
>                 .name           = "480p59_94",
> -               .timings_type   = VPBE_ENC_CUSTOM_TIMINGS,
> +               .timings_type   = VPBE_ENC_DV_TIMINGS,
>                 .dv_timings     = V4L2_DV_BT_CEA_720X480P59_94,
>                 .interlaced     = 0,
>                 .xres           = 720,
> @@ -661,7 +661,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_preset_timing[] = {
>         },
>         {
>                 .name           = "576p50",
> -               .timings_type   = VPBE_ENC_CUSTOM_TIMINGS,
> +               .timings_type   = VPBE_ENC_DV_TIMINGS,
>                 .dv_timings     = V4L2_DV_BT_CEA_720X576P50,
>                 .interlaced     = 0,
>                 .xres           = 720,
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index db1dd92..ee0e994 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -706,7 +706,7 @@ static int dm644x_venc_setup_clock(enum vpbe_enc_timings_type type,
>                 v |= DM644X_VPSS_DACCLKEN;
>                 writel(v, DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL));
>                 break;
> -       case VPBE_ENC_CUSTOM_TIMINGS:
> +       case VPBE_ENC_DV_TIMINGS:
>                 if (pclock <= 27000000) {
>                         v |= DM644X_VPSS_DACCLKEN;
>                         writel(v, DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL));
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 4ca0f9a..2a49f00 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -344,7 +344,7 @@ static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
>                 return -EINVAL;
>
>         for (i = 0; i < output->num_modes; i++) {
> -               if (output->modes[i].timings_type == VPBE_ENC_CUSTOM_TIMINGS &&
> +               if (output->modes[i].timings_type == VPBE_ENC_DV_TIMINGS &&
>                     !memcmp(&output->modes[i].dv_timings,
>                                 dv_timings, sizeof(*dv_timings)))
>                         break;
> @@ -385,7 +385,7 @@ static int vpbe_g_dv_timings(struct vpbe_device *vpbe_dev,
>                      struct v4l2_dv_timings *dv_timings)
>  {
>         if (vpbe_dev->current_timings.timings_type &
> -         VPBE_ENC_CUSTOM_TIMINGS) {
> +         VPBE_ENC_DV_TIMINGS) {
>                 *dv_timings = vpbe_dev->current_timings.dv_timings;
>                 return 0;
>         }
> @@ -412,7 +412,7 @@ static int vpbe_enum_dv_timings(struct vpbe_device *vpbe_dev,
>                 return -EINVAL;
>
>         for (i = 0; i < output->num_modes; i++) {
> -               if (output->modes[i].timings_type == VPBE_ENC_CUSTOM_TIMINGS) {
> +               if (output->modes[i].timings_type == VPBE_ENC_DV_TIMINGS) {
>                         if (j == timings->index)
>                                 break;
>                         j++;
> @@ -515,7 +515,7 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
>                                 return vpbe_s_std(vpbe_dev,
>                                                  &preset_mode->std_id);
>                         if (preset_mode->timings_type &
> -                                               VPBE_ENC_CUSTOM_TIMINGS) {
> +                                               VPBE_ENC_DV_TIMINGS) {
>                                 dv_timings =
>                                         preset_mode->dv_timings;
>                                 return vpbe_s_dv_timings(vpbe_dev, &dv_timings);
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 5e6b0ca..1f59955 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -1202,7 +1202,7 @@ vpbe_display_g_dv_timings(struct file *file, void *priv,
>         /* Get the given standard in the encoder */
>
>         if (vpbe_dev->current_timings.timings_type &
> -                               VPBE_ENC_CUSTOM_TIMINGS) {
> +                               VPBE_ENC_DV_TIMINGS) {
>                 *dv_timings = vpbe_dev->current_timings.dv_timings;
>         } else {
>                 return -EINVAL;
> diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
> index bdbebd5..9546d26 100644
> --- a/drivers/media/platform/davinci/vpbe_venc.c
> +++ b/drivers/media/platform/davinci/vpbe_venc.c
> @@ -313,7 +313,7 @@ static int venc_set_480p59_94(struct v4l2_subdev *sd)
>                 return -EINVAL;
>
>         /* Setup clock at VPSS & VENC for SD */
> -       if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 27000000) < 0)
> +       if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 27000000) < 0)
>                 return -EINVAL;
>
>         venc_enabledigitaloutput(sd, 0);
> @@ -360,7 +360,7 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
>             venc->venc_type != VPBE_VERSION_2)
>                 return -EINVAL;
>         /* Setup clock at VPSS & VENC for SD */
> -       if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 27000000) < 0)
> +       if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 27000000) < 0)
>                 return -EINVAL;
>
>         venc_enabledigitaloutput(sd, 0);
> @@ -400,7 +400,7 @@ static int venc_set_720p60_internal(struct v4l2_subdev *sd)
>         struct venc_state *venc = to_state(sd);
>         struct venc_platform_data *pdata = venc->pdata;
>
> -       if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 74250000) < 0)
> +       if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 74250000) < 0)
>                 return -EINVAL;
>
>         venc_enabledigitaloutput(sd, 0);
> @@ -428,7 +428,7 @@ static int venc_set_1080i30_internal(struct v4l2_subdev *sd)
>         struct venc_state *venc = to_state(sd);
>         struct venc_platform_data *pdata = venc->pdata;
>
> -       if (pdata->setup_clock(VPBE_ENC_CUSTOM_TIMINGS, 74250000) < 0)
> +       if (pdata->setup_clock(VPBE_ENC_DV_TIMINGS, 74250000) < 0)
>                 return -EINVAL;
>
>         venc_enabledigitaloutput(sd, 0);
> diff --git a/include/media/davinci/vpbe_types.h b/include/media/davinci/vpbe_types.h
> index 9b85396..05dbe0b 100644
> --- a/include/media/davinci/vpbe_types.h
> +++ b/include/media/davinci/vpbe_types.h
> @@ -26,8 +26,7 @@ enum vpbe_version {
>  /* vpbe_timing_type - Timing types used in vpbe device */
>  enum vpbe_enc_timings_type {
>         VPBE_ENC_STD = 0x1,
> -       VPBE_ENC_DV_PRESET = 0x2,
> -       VPBE_ENC_CUSTOM_TIMINGS = 0x4,
> +       VPBE_ENC_DV_TIMINGS = 0x4,
>         /* Used when set timings through FB device interface */
>         VPBE_ENC_TIMINGS_INVALID = 0x8,
>  };
> --
> 1.7.10.4
>
