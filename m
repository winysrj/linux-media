Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42790 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab2AEA1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 19:27:12 -0500
Received: by werm1 with SMTP id m1so8978484wer.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 16:27:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E1RiZsa-00045X-PR@www.linuxtv.org>
References: <E1RiZsa-00045X-PR@www.linuxtv.org>
Date: Wed, 4 Jan 2012 19:27:09 -0500
Message-ID: <CALzAhNUes=bpwjV2Q3b=1sfY_Pz9nsUxe_be6oNw_Lmt85KT3Q@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] cx25840 / cx23885: Fixing
 audio/volume regression
From: Steven Toth <stoth@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org, Mauro Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

My mistake, I've corrected the issue:

The following changes since commit 9c9c3d078b0dd81a74e5f531aa1efa30add5b419:

  [media] cx23885: Configure the MPEG encoder early to avoid jerky
video (2012-01-04 20:51:18 -0200)

are available in the git repository at:
  git://git.kernellabs.com/stoth/cx23885-hvr1850-fixups.git staging/for_v3.3

Steven Toth (6):
      [media] cx25840: Add a flag to enable the CX23888 DIF to be
enabled or not.
      [media] cx23885: Hauppauge HVR1850 Analog driver support
      [media] cx23885: Control cleanup on the MPEG Encoder
      [media] cx23885: Bugfix /sys/class/video4linux/videoX/name truncation
      [media] cx25840: Hauppauge HVR1850 Analog driver support (patch2)
      [media] cx25840: Added g_std support to the video decoder driver

 drivers/media/video/cx23885/cx23885-417.c   |  105 +-
 drivers/media/video/cx23885/cx23885-cards.c |   28 +-
 drivers/media/video/cx23885/cx23885-core.c  |   24 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |   14 +
 drivers/media/video/cx23885/cx23885-video.c |  157 ++-
 drivers/media/video/cx23885/cx23885.h       |   12 +
 drivers/media/video/cx25840/cx25840-core.c  | 3224 ++++++++++++++++++++++++++-
 include/media/cx25840.h                     |    1 +
 8 files changed, 3454 insertions(+), 111 deletions(-)

Thanks,

- Steve

On Wed, Jan 4, 2012 at 5:47 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] cx25840 / cx23885: Fixing audio/volume regression
> Author:  Steven Toth <stoth@kernellabs.com>
> Date:    Wed Jan 4 10:47:57 2012 -0300
>
> Since the conversion to subdev in Oct 2010 the audio controls have
> not functioned correctly in the cx23885 driver. Passing values of
> 0-3f did not translate into meaningfull register writes. I've
> converted the cx23885 driver to match the cx25840 volume control
> definition and now audio is working reliably again.
>
> Signed-off-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>  drivers/media/video/cx23885/cx23885-video.c |    6 +++---
>  drivers/media/video/cx25840/cx25840-audio.c |   10 +---------
>  2 files changed, 4 insertions(+), 12 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=4c3764d15050f91a76cede6f24402cd2701e73ef
>
> diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
> index 7415524..7f3b973 100644
> --- a/drivers/media/video/cx23885/cx23885-video.c
> +++ b/drivers/media/video/cx23885/cx23885-video.c
> @@ -253,9 +253,9 @@ static struct cx23885_ctrl cx23885_ctls[] = {
>                        .id            = V4L2_CID_AUDIO_VOLUME,
>                        .name          = "Volume",
>                        .minimum       = 0,
> -                       .maximum       = 0x3f,
> -                       .step          = 1,
> -                       .default_value = 0x3f,
> +                       .maximum       = 65535,
> +                       .step          = 65535 / 100,
> +                       .default_value = 65535,
>                        .type          = V4L2_CTRL_TYPE_INTEGER,
>                },
>                .reg                   = PATH1_VOL_CTL,
> diff --git a/drivers/media/video/cx25840/cx25840-audio.c b/drivers/media/video/cx25840/cx25840-audio.c
> index 005f110..34b96c7 100644
> --- a/drivers/media/video/cx25840/cx25840-audio.c
> +++ b/drivers/media/video/cx25840/cx25840-audio.c
> @@ -480,7 +480,6 @@ void cx25840_audio_set_path(struct i2c_client *client)
>
>  static void set_volume(struct i2c_client *client, int volume)
>  {
> -       struct cx25840_state *state = to_state(i2c_get_clientdata(client));
>        int vol;
>
>        /* Convert the volume to msp3400 values (0-127) */
> @@ -496,14 +495,7 @@ static void set_volume(struct i2c_client *client, int volume)
>        }
>
>        /* PATH1_VOLUME */
> -       if (is_cx2388x(state)) {
> -               /* for cx23885 volume doesn't work,
> -                * the calculation always results in
> -                * e4 regardless.
> -                */
> -               cx25840_write(client, 0x8d4, volume);
> -       } else
> -               cx25840_write(client, 0x8d4, 228 - (vol * 2));
> +       cx25840_write(client, 0x8d4, 228 - (vol * 2));
>  }
>
>  static void set_balance(struct i2c_client *client, int balance)



-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
