Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41413 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0DZQRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 12:17:22 -0400
Received: by bwz19 with SMTP id 19so304343bwz.21
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 09:17:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4a55b56f7166edd18f511c2674ce071fee5f79cc.1272267137.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
	 <4a55b56f7166edd18f511c2674ce071fee5f79cc.1272267137.git.hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 12:17:17 -0400
Message-ID: <h2l30353c3d1004260917o61e7be41lc4ae0b7e1b2f6137@mail.gmail.com>
Subject: Re: [PATCH 06/15] [RFC] msp3400: convert to the new control framework
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 26, 2010 at 3:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/msp3400-driver.c   |  248 +++++++++++--------------------
>  drivers/media/video/msp3400-driver.h   |   16 ++-
>  drivers/media/video/msp3400-kthreads.c |   16 +-
>  3 files changed, 108 insertions(+), 172 deletions(-)
>
> diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
> index e9df3cb..de0da40 100644
> --- a/drivers/media/video/msp3400-driver.c
> +++ b/drivers/media/video/msp3400-driver.c
> @@ -283,51 +283,6 @@ void msp_set_scart(struct i2c_client *client, int in, int out)
>                msp_write_dem(client, 0x40, state->i2s_mode);
>  }
>
> -void msp_set_audio(struct i2c_client *client)
> -{
> -       struct msp_state *state = to_state(i2c_get_clientdata(client));
> -       int bal = 0, bass, treble, loudness;
> -       int val = 0;
> -       int reallymuted = state->muted | state->scan_in_progress;
> -
> -       if (!reallymuted)
> -               val = (state->volume * 0x7f / 65535) << 8;
> -
> -       v4l_dbg(1, msp_debug, client, "mute=%s scanning=%s volume=%d\n",
> -               state->muted ? "on" : "off",
> -               state->scan_in_progress ? "yes" : "no",
> -               state->volume);
> -
> -       msp_write_dsp(client, 0x0000, val);
> -       msp_write_dsp(client, 0x0007, reallymuted ? 0x1 : (val | 0x1));
> -       if (state->has_scart2_out_volume)
> -               msp_write_dsp(client, 0x0040, reallymuted ? 0x1 : (val | 0x1));
> -       if (state->has_headphones)
> -               msp_write_dsp(client, 0x0006, val);
> -       if (!state->has_sound_processing)
> -               return;
> -
> -       if (val)
> -               bal = (u8)((state->balance / 256) - 128);
> -       bass = ((state->bass - 32768) * 0x60 / 65535) << 8;
> -       treble = ((state->treble - 32768) * 0x60 / 65535) << 8;
> -       loudness = state->loudness ? ((5 * 4) << 8) : 0;
> -
> -       v4l_dbg(1, msp_debug, client, "balance=%d bass=%d treble=%d loudness=%d\n",
> -               state->balance, state->bass, state->treble, state->loudness);
> -
> -       msp_write_dsp(client, 0x0001, bal << 8);
> -       msp_write_dsp(client, 0x0002, bass);
> -       msp_write_dsp(client, 0x0003, treble);
> -       msp_write_dsp(client, 0x0004, loudness);
> -       if (!state->has_headphones)
> -               return;
> -       msp_write_dsp(client, 0x0030, bal << 8);
> -       msp_write_dsp(client, 0x0031, bass);
> -       msp_write_dsp(client, 0x0032, treble);
> -       msp_write_dsp(client, 0x0033, loudness);
> -}
> -
>  /* ------------------------------------------------------------------------ */
>
>  static void msp_wake_thread(struct i2c_client *client)
> @@ -363,98 +318,73 @@ int msp_sleep(struct msp_state *state, int timeout)
>
>  /* ------------------------------------------------------------------------ */
>
> -static int msp_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int msp_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> -       struct msp_state *state = to_state(sd);
> +       struct msp_state *state = ctrl_to_state(ctrl);
> +       struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
> +       int val = ctrl->val;
>
>        switch (ctrl->id) {
> -       case V4L2_CID_AUDIO_VOLUME:
> -               ctrl->value = state->volume;
> -               break;
> -
> -       case V4L2_CID_AUDIO_MUTE:
> -               ctrl->value = state->muted;
> -               break;
> -
> -       case V4L2_CID_AUDIO_BALANCE:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               ctrl->value = state->balance;
> -               break;
> -
> -       case V4L2_CID_AUDIO_BASS:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               ctrl->value = state->bass;
> +       case V4L2_CID_AUDIO_VOLUME: {
> +               /* audio volume cluster */
> +               int reallymuted = state->muted->val | state->scan_in_progress;
> +
> +               if (!reallymuted)
> +                       val = (val * 0x7f / 65535) << 8;
> +
> +               v4l_dbg(1, msp_debug, client, "mute=%s scanning=%s volume=%d\n",
> +                               state->muted->val ? "on" : "off",
> +                               state->scan_in_progress ? "yes" : "no",
> +                               state->volume->val);
> +
> +               msp_write_dsp(client, 0x0000, val);
> +               msp_write_dsp(client, 0x0007, reallymuted ? 0x1 : (val | 0x1));
> +               if (state->has_scart2_out_volume)
> +                       msp_write_dsp(client, 0x0040, reallymuted ? 0x1 : (val | 0x1));
> +               if (state->has_headphones)
> +                       msp_write_dsp(client, 0x0006, val);
>                break;
> -
> -       case V4L2_CID_AUDIO_TREBLE:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               ctrl->value = state->treble;
> -               break;
> -
> -       case V4L2_CID_AUDIO_LOUDNESS:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               ctrl->value = state->loudness;
> -               break;
> -
> -       default:
> -               return -EINVAL;
>        }
> -       return 0;
> -}
> -
> -static int msp_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> -{
> -       struct msp_state *state = to_state(sd);
> -       struct i2c_client *client = v4l2_get_subdevdata(sd);
> -
> -       switch (ctrl->id) {
> -       case V4L2_CID_AUDIO_VOLUME:
> -               state->volume = ctrl->value;
> -               if (state->volume == 0)
> -                       state->balance = 32768;
> -               break;
> -
> -       case V4L2_CID_AUDIO_MUTE:
> -               if (ctrl->value < 0 || ctrl->value >= 2)
> -                       return -ERANGE;
> -               state->muted = ctrl->value;
> -               break;
>
>        case V4L2_CID_AUDIO_BASS:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               state->bass = ctrl->value;
> +               val = ((val - 32768) * 0x60 / 65535) << 8;
> +               msp_write_dsp(client, 0x0002, val);
> +               if (state->has_headphones)
> +                       msp_write_dsp(client, 0x0031, val);
>                break;
>
>        case V4L2_CID_AUDIO_TREBLE:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               state->treble = ctrl->value;
> +               val = ((val - 32768) * 0x60 / 65535) << 8;
> +               msp_write_dsp(client, 0x0003, val);
> +               if (state->has_headphones)
> +                       msp_write_dsp(client, 0x0032, val);
>                break;
>
>        case V4L2_CID_AUDIO_LOUDNESS:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               state->loudness = ctrl->value;
> +               val = val ? ((5 * 4) << 8) : 0;
> +               msp_write_dsp(client, 0x0004, val);
> +               if (state->has_headphones)
> +                       msp_write_dsp(client, 0x0033, val);
>                break;
>
>        case V4L2_CID_AUDIO_BALANCE:
> -               if (!state->has_sound_processing)
> -                       return -EINVAL;
> -               state->balance = ctrl->value;
> +               val = (u8)((val / 256) - 128);
> +               msp_write_dsp(client, 0x0001, val << 8);
> +               if (state->has_headphones)
> +                       msp_write_dsp(client, 0x0030, val << 8);
>                break;
>
>        default:
>                return -EINVAL;
>        }
> -       msp_set_audio(client);
>        return 0;

The return value here should reflect if the update was successful or
not. msp_write_dsp can fail and if does the error should be propagated
to the caller and the value of the control should not be updated.
Also, msp_write_dsp and msp_read_dsp should probably return -EIO in
case of failures rather than -1.

Regards,

David Ellingsworth

<snip to end>
