Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:42795 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3HaLt4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 07:49:56 -0400
Received: by mail-vb0-f54.google.com with SMTP id q14so1991239vbe.13
        for <linux-media@vger.kernel.org>; Sat, 31 Aug 2013 04:49:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <637d28441ff1e63ae72385afcba990fda11e0210.1377861337.git.dinram@cisco.com>
References: <a661e3d7ccefe3baa8134888a0471ce1e5463f47.1377861337.git.dinram@cisco.com>
	<1377862104-15429-1-git-send-email-dinram@cisco.com>
	<637d28441ff1e63ae72385afcba990fda11e0210.1377861337.git.dinram@cisco.com>
Date: Sat, 31 Aug 2013 07:49:53 -0400
Message-ID: <CAC-25o_Fk3fva7xdna=-fUv53vp2DjRt99+sEGwTwvgQn=cgkg@mail.gmail.com>
Subject: Re: [PATCH 3/6] si4713 : Bug fix for si4713_tx_tune_power() method in
 the i2c driver
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Dinesh Ram <dinram@cisco.com>
Cc: Linux-Media <linux-media@vger.kernel.org>, dinesh.ram@cern.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dinesh,

On Fri, Aug 30, 2013 at 7:28 AM, Dinesh Ram <dinram@cisco.com> wrote:
> In the si4713_tx_tune_power() method, the args array element 'power' can take values between
> SI4713_MIN_POWER and SI4713_MAX_POWER. power = 0 is also valid.
> All the values (0 > power < SI4713_MIN_POWER) are illegal and hence
> are all mapped to SI4713_MIN_POWER.

While do we need to assume min power in these cases?

>
> Signed-off-by: Dinesh Ram <dinram@cisco.com>
> ---
>  drivers/media/radio/si4713/si4713.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
> index 55c4d27..5d0be87 100644
> --- a/drivers/media/radio/si4713/si4713.c
> +++ b/drivers/media/radio/si4713/si4713.c
> @@ -550,14 +550,14 @@ static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
>  }
>
>  /*
> - * si4713_tx_tune_power - Sets the RF voltage level between 88 and 115 dBuV in
> + * si4713_tx_tune_power - Sets the RF voltage level between 88 and 120 dBuV in
>   *                     1 dB units. A value of 0x00 indicates off. The command
>   *                     also sets the antenna tuning capacitance. A value of 0
>   *                     indicates autotuning, and a value of 1 - 191 indicates
>   *                     a manual override, which results in a tuning
>   *                     capacitance of 0.25 pF x @antcap.
>   * @sdev: si4713_device structure for the device we are communicating
> - * @power: tuning power (88 - 115 dBuV, unit/step 1 dB)
> + * @power: tuning power (88 - 120 dBuV, unit/step 1 dB)
>   * @antcap: value of antenna tuning capacitor (0 - 191)
>   */
>  static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
> @@ -571,16 +571,16 @@ static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
>          *      .Third byte = power
>          *      .Fourth byte = antcap
>          */
> -       const u8 args[SI4713_TXPWR_NARGS] = {
> +       u8 args[SI4713_TXPWR_NARGS] = {
>                 0x00,
>                 0x00,
>                 power,
>                 antcap,
>         };
>
> -       if (((power > 0) && (power < SI4713_MIN_POWER)) ||
> -               power > SI4713_MAX_POWER || antcap > SI4713_MAX_ANTCAP)
> -               return -EDOM;
> +       /* Map power values 1-87 to MIN_POWER (88) */
> +       if (power > 0 && power < SI4713_MIN_POWER)
> +               args[2] = power = SI4713_MIN_POWER;

Why are you allowing antcap > SI4713_MAX_ANTCAP? and power >
SI4713_MAX_POWER too?

>
>         err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_POWER,
>                                   args, ARRAY_SIZE(args), val,
> @@ -1457,9 +1457,9 @@ static int si4713_probe(struct i2c_client *client,
>                         V4L2_CID_TUNE_PREEMPHASIS,
>                         V4L2_PREEMPHASIS_75_uS, 0, V4L2_PREEMPHASIS_50_uS);
>         sdev->tune_pwr_level = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> -                       V4L2_CID_TUNE_POWER_LEVEL, 0, 120, 1, DEFAULT_POWER_LEVEL);
> +                       V4L2_CID_TUNE_POWER_LEVEL, 0, SI4713_MAX_POWER, 1, DEFAULT_POWER_LEVEL);
>         sdev->tune_ant_cap = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> -                       V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, 191, 1, 0);
> +                       V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, SI4713_MAX_ANTCAP, 1, 0);
>
>         if (hdl->error) {
>                 rval = hdl->error;
> --
> 1.8.4.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Eduardo Bezerra Valentin
