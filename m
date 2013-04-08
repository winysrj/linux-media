Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:36475 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759673Ab3DHPly (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:41:54 -0400
Received: by mail-vb0-f44.google.com with SMTP id e12so3981044vbg.3
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 08:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365418061-23694-5-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
	<1365418061-23694-5-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 8 Apr 2013 11:41:52 -0400
Message-ID: <CAC-25o9nDSK4ob7mHcdP_MbmJtf+dZMyhUGpLvWTBhyL8aeqHA@mail.gmail.com>
Subject: Re: [REVIEW PATCH 4/7] radio-si4713: use V4L2 core lock.
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Apr 8, 2013 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Simplify locking by using the V4L2 core lock mechanism. This allows us to
> remove all locking from the i2c module. This will also simplify the upcoming
> conversion to the control framework.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>

Output of v4l2-compliant is same as in patch 03

Driver is still in one piece after this big change. No lockups have been seen.

> ---
>  drivers/media/radio/radio-si4713.c |    4 +
>  drivers/media/radio/si4713-i2c.c   |  156 +++++++++---------------------------
>  drivers/media/radio/si4713-i2c.h   |    1 -
>  3 files changed, 40 insertions(+), 121 deletions(-)
>
> diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
> index f0f0a90..633c545 100644
> --- a/drivers/media/radio/radio-si4713.c
> +++ b/drivers/media/radio/radio-si4713.c
> @@ -49,6 +49,7 @@ MODULE_ALIAS("platform:radio-si4713");
>  struct radio_si4713_device {
>         struct v4l2_device              v4l2_dev;
>         struct video_device             radio_dev;
> +       struct mutex lock;
>  };
>
>  /* radio_si4713_fops - file operations interface */
> @@ -247,6 +248,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>                 rval = -ENOMEM;
>                 goto exit;
>         }
> +       mutex_init(&rsdev->lock);
>
>         rval = v4l2_device_register(&pdev->dev, &rsdev->v4l2_dev);
>         if (rval) {
> @@ -272,6 +274,8 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>
>         rsdev->radio_dev = radio_si4713_vdev_template;
>         rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
> +       /* Serialize all access to the si4713 */
> +       rsdev->radio_dev.lock = &rsdev->lock;
>         video_set_drvdata(&rsdev->radio_dev, rsdev);
>         if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
>                 dev_err(&pdev->dev, "Could not register video device.\n");
> diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
> index e305c14..1cb9a2e 100644
> --- a/drivers/media/radio/si4713-i2c.c
> +++ b/drivers/media/radio/si4713-i2c.c
> @@ -21,7 +21,6 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>   */
>
> -#include <linux/mutex.h>
>  #include <linux/completion.h>
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> @@ -458,15 +457,13 @@ static int si4713_checkrev(struct si4713_device *sdev)
>         int rval;
>         u8 resp[SI4713_GETREV_NRESP];
>
> -       mutex_lock(&sdev->mutex);
> -
>         rval = si4713_send_command(sdev, SI4713_CMD_GET_REV,
>                                         NULL, 0,
>                                         resp, ARRAY_SIZE(resp),
>                                         DEFAULT_TIMEOUT);
>
>         if (rval < 0)
> -               goto unlock;
> +               return rval;
>
>         if (resp[1] == SI4713_PRODUCT_NUMBER) {
>                 v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
> @@ -475,9 +472,6 @@ static int si4713_checkrev(struct si4713_device *sdev)
>                 v4l2_err(&sdev->sd, "Invalid product number\n");
>                 rval = -EINVAL;
>         }
> -
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -778,17 +772,9 @@ static int si4713_tx_rds_ps(struct si4713_device *sdev, u8 psid,
>
>  static int si4713_set_power_state(struct si4713_device *sdev, u8 value)
>  {
> -       int rval;
> -
> -       mutex_lock(&sdev->mutex);
> -
>         if (value)
> -               rval = si4713_powerup(sdev);
> -       else
> -               rval = si4713_powerdown(sdev);
> -
> -       mutex_unlock(&sdev->mutex);
> -       return rval;
> +               return si4713_powerup(sdev);
> +       return si4713_powerdown(sdev);
>  }
>
>  static int si4713_set_mute(struct si4713_device *sdev, u16 mute)
> @@ -797,8 +783,6 @@ static int si4713_set_mute(struct si4713_device *sdev, u16 mute)
>
>         mute = set_mute(mute);
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state)
>                 rval = si4713_write_property(sdev,
>                                 SI4713_TX_LINE_INPUT_MUTE, mute);
> @@ -806,8 +790,6 @@ static int si4713_set_mute(struct si4713_device *sdev, u16 mute)
>         if (rval >= 0)
>                 sdev->mute = get_mute(mute);
>
> -       mutex_unlock(&sdev->mutex);
> -
>         return rval;
>  }
>
> @@ -820,15 +802,13 @@ static int si4713_set_rds_ps_name(struct si4713_device *sdev, char *ps_name)
>         if (!strlen(ps_name))
>                 memset(ps_name, 0, MAX_RDS_PS_NAME + 1);
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 /* Write the new ps name and clear the padding */
>                 for (i = 0; i < MAX_RDS_PS_NAME; i += (RDS_BLOCK / 2)) {
>                         rval = si4713_tx_rds_ps(sdev, (i / (RDS_BLOCK / 2)),
>                                                 ps_name + i);
>                         if (rval < 0)
> -                               goto unlock;
> +                               return rval;
>                 }
>
>                 /* Setup the size to be sent */
> @@ -841,19 +821,16 @@ static int si4713_set_rds_ps_name(struct si4713_device *sdev, char *ps_name)
>                                 SI4713_TX_RDS_PS_MESSAGE_COUNT,
>                                 rds_ps_nblocks(len));
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>
>                 rval = si4713_write_property(sdev,
>                                 SI4713_TX_RDS_PS_REPEAT_COUNT,
>                                 DEFAULT_RDS_PS_REPEAT_COUNT * 2);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>         }
>
>         strncpy(sdev->rds_info.ps_name, ps_name, MAX_RDS_PS_NAME);
> -
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -864,14 +841,12 @@ static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
>         u8 b_index = 0, cr_inserted = 0;
>         s8 left;
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (!sdev->power_state)
>                 goto copy;
>
>         rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_CLEAR, 0, 0, 0, &left);
>         if (rval < 0)
> -               goto unlock;
> +               return rval;
>
>         if (!strlen(rt))
>                 goto copy;
> @@ -898,7 +873,7 @@ static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
>                                 compose_u16(rt[t_index + 2], rt[t_index + 3]),
>                                 &left);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>
>                 t_index += RDS_RADIOTEXT_BLK_SIZE;
>
> @@ -908,9 +883,6 @@ static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
>
>  copy:
>         strncpy(sdev->rds_info.radio_text, rt, MAX_RDS_RADIO_TEXT);
> -
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -1114,9 +1086,7 @@ static int si4713_write_econtrol_tune(struct si4713_device *sdev,
>
>         rval = validate_range(&sdev->sd, control);
>         if (rval < 0)
> -               goto exit;
> -
> -       mutex_lock(&sdev->mutex);
> +               return rval;
>
>         switch (control->id) {
>         case V4L2_CID_TUNE_POWER_LEVEL:
> @@ -1128,8 +1098,7 @@ static int si4713_write_econtrol_tune(struct si4713_device *sdev,
>                 antcap = control->value;
>                 break;
>         default:
> -               rval = -EINVAL;
> -               goto unlock;
> +               return -EINVAL;
>         }
>
>         if (sdev->power_state)
> @@ -1140,9 +1109,6 @@ static int si4713_write_econtrol_tune(struct si4713_device *sdev,
>                 sdev->antenna_capacitor = antcap;
>         }
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
> -exit:
>         return rval;
>  }
>
> @@ -1159,12 +1125,12 @@ static int si4713_write_econtrol_integers(struct si4713_device *sdev,
>
>         rval = validate_range(&sdev->sd, control);
>         if (rval < 0)
> -               goto exit;
> +               return rval;
>
>         rval = si4713_choose_econtrol_action(sdev, control->id, &shadow, &bit,
>                         &mask, &property, &mul, &table, &size);
>         if (rval < 0)
> -               goto exit;
> +               return rval;
>
>         val = control->value;
>         if (mul) {
> @@ -1172,24 +1138,22 @@ static int si4713_write_econtrol_integers(struct si4713_device *sdev,
>         } else if (table) {
>                 rval = usecs_to_dev(control->value, table, size);
>                 if (rval < 0)
> -                       goto exit;
> +                       return rval;
>                 val = rval;
>                 rval = 0;
>         }
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 if (mask) {
>                         rval = si4713_read_property(sdev, property, &val);
>                         if (rval < 0)
> -                               goto unlock;
> +                               return rval;
>                         val = set_bits(val, control->value, bit, mask);
>                 }
>
>                 rval = si4713_write_property(sdev, property, val);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>                 if (mask)
>                         val = control->value;
>         }
> @@ -1199,16 +1163,13 @@ static int si4713_write_econtrol_integers(struct si4713_device *sdev,
>         } else if (table) {
>                 rval = dev_to_usecs(val, table, size);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>                 *shadow = rval;
>                 rval = 0;
>         } else {
>                 *shadow = val;
>         }
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
> -exit:
>         return rval;
>  }
>
> @@ -1231,9 +1192,7 @@ static int si4713_setup(struct si4713_device *sdev)
>                 return -ENOMEM;
>
>         /* Get a local copy to avoid race */
> -       mutex_lock(&sdev->mutex);
>         memcpy(tmp, sdev, sizeof(*sdev));
> -       mutex_unlock(&sdev->mutex);
>
>         ctrl.id = V4L2_CID_RDS_TX_PI;
>         ctrl.value = tmp->rds_info.pi;
> @@ -1338,17 +1297,15 @@ static int si4713_initialize(struct si4713_device *sdev)
>
>         rval = si4713_set_power_state(sdev, POWER_ON);
>         if (rval < 0)
> -               goto exit;
> +               return rval;
>
>         rval = si4713_checkrev(sdev);
>         if (rval < 0)
> -               goto exit;
> +               return rval;
>
>         rval = si4713_set_power_state(sdev, POWER_OFF);
>         if (rval < 0)
> -               goto exit;
> -
> -       mutex_lock(&sdev->mutex);
> +               return rval;
>
>         sdev->rds_info.pi = DEFAULT_RDS_PI;
>         sdev->rds_info.pty = DEFAULT_RDS_PTY;
> @@ -1380,9 +1337,6 @@ static int si4713_initialize(struct si4713_device *sdev)
>         sdev->stereo = 1;
>         sdev->tune_rnl = DEFAULT_TUNE_RNL;
>
> -       mutex_unlock(&sdev->mutex);
> -
> -exit:
>         return rval;
>  }
>
> @@ -1428,7 +1382,7 @@ exit:
>
>  /*
>   * si4713_update_tune_status - update properties from tx_tune_status
> - * command. Must be called with sdev->mutex held.
> + * command.
>   * @sdev: si4713_device structure for the device we are communicating
>   */
>  static int si4713_update_tune_status(struct si4713_device *sdev)
> @@ -1456,12 +1410,10 @@ static int si4713_read_econtrol_tune(struct si4713_device *sdev,
>  {
>         s32 rval = 0;
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 rval = si4713_update_tune_status(sdev);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>         }
>
>         switch (control->id) {
> @@ -1472,11 +1424,9 @@ static int si4713_read_econtrol_tune(struct si4713_device *sdev,
>                 control->value = sdev->antenna_capacitor;
>                 break;
>         default:
> -               rval = -EINVAL;
> +               return -EINVAL;
>         }
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -1494,14 +1444,12 @@ static int si4713_read_econtrol_integers(struct si4713_device *sdev,
>         rval = si4713_choose_econtrol_action(sdev, control->id, &shadow, &bit,
>                         &mask, &property, &mul, &table, &size);
>         if (rval < 0)
> -               goto exit;
> -
> -       mutex_lock(&sdev->mutex);
> +               return rval;
>
>         if (sdev->power_state) {
>                 rval = si4713_read_property(sdev, property, &val);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>
>                 /* Keep negative values for threshold */
>                 if (control->id == V4L2_CID_AUDIO_COMPRESSION_THRESHOLD)
> @@ -1516,9 +1464,6 @@ static int si4713_read_econtrol_integers(struct si4713_device *sdev,
>
>         control->value = *shadow;
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
> -exit:
>         return rval;
>  }
>
> @@ -1712,14 +1657,12 @@ static int si4713_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>         if (!sdev)
>                 return -ENODEV;
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 rval = si4713_read_property(sdev, SI4713_TX_LINE_INPUT_MUTE,
>                                                 &sdev->mute);
>
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>         }
>
>         switch (ctrl->id) {
> @@ -1728,8 +1671,6 @@ static int si4713_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>                 break;
>         }
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -1779,7 +1720,6 @@ static long si4713_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>         if (!arg)
>                 return -EINVAL;
>
> -       mutex_lock(&sdev->mutex);
>         switch (cmd) {
>         case SI4713_IOC_MEASURE_RNL:
>                 frequency = v4l2_to_si4713(rnl->frequency);
> @@ -1788,11 +1728,11 @@ static long si4713_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>                         /* Set desired measurement frequency */
>                         rval = si4713_tx_tune_measure(sdev, frequency, 0);
>                         if (rval < 0)
> -                               goto unlock;
> +                               return rval;
>                         /* get results from tune status */
>                         rval = si4713_update_tune_status(sdev);
>                         if (rval < 0)
> -                               goto unlock;
> +                               return rval;
>                 }
>                 rnl->rnl = sdev->tune_rnl;
>                 break;
> @@ -1802,8 +1742,6 @@ static long si4713_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>                 rval = -ENOIOCTLCMD;
>         }
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -1822,15 +1760,11 @@ static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
>         struct si4713_device *sdev = to_si4713_device(sd);
>         int rval = 0;
>
> -       if (!sdev) {
> -               rval = -ENODEV;
> -               goto exit;
> -       }
> +       if (!sdev)
> +               return -ENODEV;
>
> -       if (vm->index > 0) {
> -               rval = -EINVAL;
> -               goto exit;
> -       }
> +       if (vm->index > 0)
> +               return -EINVAL;
>
>         strncpy(vm->name, "FM Modulator", 32);
>         vm->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW |
> @@ -1840,15 +1774,13 @@ static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
>         vm->rangelow = si4713_to_v4l2(FREQ_RANGE_LOW);
>         vm->rangehigh = si4713_to_v4l2(FREQ_RANGE_HIGH);
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 u32 comp_en = 0;
>
>                 rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE,
>                                                 &comp_en);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>
>                 sdev->stereo = get_status_bit(comp_en, 1, 1 << 1);
>                 sdev->rds_info.enabled = get_status_bit(comp_en, 2, 1 << 2);
> @@ -1866,9 +1798,6 @@ static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
>         else
>                 vm->txsubchans &= ~V4L2_TUNER_SUB_RDS;
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
> -exit:
>         return rval;
>  }
>
> @@ -1896,13 +1825,11 @@ static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulato
>
>         rds = !!(vm->txsubchans & V4L2_TUNER_SUB_RDS);
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 rval = si4713_read_property(sdev,
>                                                 SI4713_TX_COMPONENT_ENABLE, &p);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>
>                 p = set_bits(p, stereo, 1, 1 << 1);
>                 p = set_bits(p, rds, 2, 1 << 2);
> @@ -1910,14 +1837,12 @@ static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulato
>                 rval = si4713_write_property(sdev,
>                                                 SI4713_TX_COMPONENT_ENABLE, p);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>         }
>
>         sdev->stereo = stereo;
>         sdev->rds_info.enabled = rds;
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -1929,23 +1854,19 @@ static int si4713_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
>
>         f->type = V4L2_TUNER_RADIO;
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 u16 freq;
>                 u8 p, a, n;
>
>                 rval = si4713_tx_tune_status(sdev, 0x00, &freq, &p, &a, &n);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>
>                 sdev->frequency = freq;
>         }
>
>         f->frequency = si4713_to_v4l2(sdev->frequency);
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -1960,19 +1881,15 @@ static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequenc
>         if (frequency < FREQ_RANGE_LOW || frequency > FREQ_RANGE_HIGH)
>                 return -EDOM;
>
> -       mutex_lock(&sdev->mutex);
> -
>         if (sdev->power_state) {
>                 rval = si4713_tx_tune_freq(sdev, frequency);
>                 if (rval < 0)
> -                       goto unlock;
> +                       return rval;
>                 frequency = rval;
>                 rval = 0;
>         }
>         sdev->frequency = frequency;
>
> -unlock:
> -       mutex_unlock(&sdev->mutex);
>         return rval;
>  }
>
> @@ -2030,7 +1947,6 @@ static int si4713_probe(struct i2c_client *client,
>
>         v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
>
> -       mutex_init(&sdev->mutex);
>         init_completion(&sdev->work);
>
>         if (client->irq) {
> diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
> index c6dfa7f..979828d 100644
> --- a/drivers/media/radio/si4713-i2c.h
> +++ b/drivers/media/radio/si4713-i2c.h
> @@ -220,7 +220,6 @@ struct si4713_device {
>         /* v4l2_subdev and i2c reference (v4l2_subdev priv data) */
>         struct v4l2_subdev sd;
>         /* private data structures */
> -       struct mutex mutex;
>         struct completion work;
>         struct rds_info rds_info;
>         struct limiter_info limiter_info;
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
