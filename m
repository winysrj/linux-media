Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:47038 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936440Ab3DHPox (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:44:53 -0400
Received: by mail-vb0-f51.google.com with SMTP id x19so3972982vbf.10
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 08:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365418061-23694-7-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
	<1365418061-23694-7-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 8 Apr 2013 11:44:51 -0400
Message-ID: <CAC-25o8YTJTkoQ57thjRVhCz6WgnQLmzU_JdKZjLE4vBHxNsrA@mail.gmail.com>
Subject: Re: [REVIEW PATCH 6/7] radio-si4713: convert to the control framework
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
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>

Output of v4l2-compliant:
is radio
Driver Info:
	Driver name   : radio-si4713
	Card type     : Silicon Labs Si4713 Modulator
	Bus info      : platform:radio-si4713
	Driver version: 3.9.0
	Capabilities  : 0x80080800
		RDS Output
		Modulator
		Device Capabilities
	Device Caps   : 0x00080800
		RDS Output
		Modulator

Compliance test for device /dev/radio0 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(321): !(dcaps & io_caps)
	test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
	test second radio open: OK
		fail: v4l2-compliance.cpp(321): !(dcaps & io_caps)
	test VIDIOC_QUERYCAP: FAIL
		fail: v4l2-compliance.cpp(335): doioctl(node, VIDIOC_G_PRIORITY, &prio)
	test VIDIOC_G/S_PRIORITY: FAIL

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 1

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
		fail: v4l2-test-controls.cpp(428): could not set minimum value
	test VIDIOC_G/S_CTRL: FAIL
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		fail: v4l2-test-controls.cpp(713): subscribe event for control 'User
Controls' failed
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 22 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)

Total: 36, Succeeded: 31, Failed: 5, Warnings: 0
> ---
>  drivers/media/radio/radio-si4713.c |   89 +---
>  drivers/media/radio/si4713-i2c.c   |  908 ++++++++----------------------------
>  drivers/media/radio/si4713-i2c.h   |   65 ++-
>  3 files changed, 239 insertions(+), 823 deletions(-)
>
> diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
> index 633c545..f8c6137 100644
> --- a/drivers/media/radio/radio-si4713.c
> +++ b/drivers/media/radio/radio-si4713.c
> @@ -76,61 +76,6 @@ static int radio_si4713_querycap(struct file *file, void *priv,
>         return 0;
>  }
>
> -/* radio_si4713_queryctrl - enumerate control items */
> -static int radio_si4713_queryctrl(struct file *file, void *priv,
> -                                 struct v4l2_queryctrl *qc)
> -{
> -       /* Must be sorted from low to high control ID! */
> -       static const u32 user_ctrls[] = {
> -               V4L2_CID_USER_CLASS,
> -               V4L2_CID_AUDIO_MUTE,
> -               0
> -       };
> -
> -       /* Must be sorted from low to high control ID! */
> -       static const u32 fmtx_ctrls[] = {
> -               V4L2_CID_FM_TX_CLASS,
> -               V4L2_CID_RDS_TX_DEVIATION,
> -               V4L2_CID_RDS_TX_PI,
> -               V4L2_CID_RDS_TX_PTY,
> -               V4L2_CID_RDS_TX_PS_NAME,
> -               V4L2_CID_RDS_TX_RADIO_TEXT,
> -               V4L2_CID_AUDIO_LIMITER_ENABLED,
> -               V4L2_CID_AUDIO_LIMITER_RELEASE_TIME,
> -               V4L2_CID_AUDIO_LIMITER_DEVIATION,
> -               V4L2_CID_AUDIO_COMPRESSION_ENABLED,
> -               V4L2_CID_AUDIO_COMPRESSION_GAIN,
> -               V4L2_CID_AUDIO_COMPRESSION_THRESHOLD,
> -               V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME,
> -               V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME,
> -               V4L2_CID_PILOT_TONE_ENABLED,
> -               V4L2_CID_PILOT_TONE_DEVIATION,
> -               V4L2_CID_PILOT_TONE_FREQUENCY,
> -               V4L2_CID_TUNE_PREEMPHASIS,
> -               V4L2_CID_TUNE_POWER_LEVEL,
> -               V4L2_CID_TUNE_ANTENNA_CAPACITOR,
> -               0
> -       };
> -       static const u32 *ctrl_classes[] = {
> -               user_ctrls,
> -               fmtx_ctrls,
> -               NULL
> -       };
> -       struct radio_si4713_device *rsdev;
> -
> -       rsdev = video_get_drvdata(video_devdata(file));
> -
> -       qc->id = v4l2_ctrl_next(ctrl_classes, qc->id);
> -       if (qc->id == 0)
> -               return -EINVAL;
> -
> -       if (qc->id == V4L2_CID_USER_CLASS || qc->id == V4L2_CID_FM_TX_CLASS)
> -               return v4l2_ctrl_query_fill(qc, 0, 0, 0, 0);
> -
> -       return v4l2_device_call_until_err(&rsdev->v4l2_dev, 0, core,
> -                                         queryctrl, qc);
> -}
> -
>  /*
>   * v4l2 ioctl call backs.
>   * we are just a wrapper for v4l2_sub_devs.
> @@ -140,34 +85,6 @@ static inline struct v4l2_device *get_v4l2_dev(struct file *file)
>         return &((struct radio_si4713_device *)video_drvdata(file))->v4l2_dev;
>  }
>
> -static int radio_si4713_g_ext_ctrls(struct file *file, void *p,
> -                                   struct v4l2_ext_controls *vecs)
> -{
> -       return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
> -                                         g_ext_ctrls, vecs);
> -}
> -
> -static int radio_si4713_s_ext_ctrls(struct file *file, void *p,
> -                                   struct v4l2_ext_controls *vecs)
> -{
> -       return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
> -                                         s_ext_ctrls, vecs);
> -}
> -
> -static int radio_si4713_g_ctrl(struct file *file, void *p,
> -                              struct v4l2_control *vc)
> -{
> -       return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
> -                                         g_ctrl, vc);
> -}
> -
> -static int radio_si4713_s_ctrl(struct file *file, void *p,
> -                              struct v4l2_control *vc)
> -{
> -       return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
> -                                         s_ctrl, vc);
> -}
> -
>  static int radio_si4713_g_modulator(struct file *file, void *p,
>                                     struct v4l2_modulator *vm)
>  {
> @@ -205,11 +122,6 @@ static long radio_si4713_default(struct file *file, void *p,
>
>  static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
>         .vidioc_querycap        = radio_si4713_querycap,
> -       .vidioc_queryctrl       = radio_si4713_queryctrl,
> -       .vidioc_g_ext_ctrls     = radio_si4713_g_ext_ctrls,
> -       .vidioc_s_ext_ctrls     = radio_si4713_s_ext_ctrls,
> -       .vidioc_g_ctrl          = radio_si4713_g_ctrl,
> -       .vidioc_s_ctrl          = radio_si4713_s_ctrl,
>         .vidioc_g_modulator     = radio_si4713_g_modulator,
>         .vidioc_s_modulator     = radio_si4713_s_modulator,
>         .vidioc_g_frequency     = radio_si4713_g_frequency,
> @@ -274,6 +186,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>
>         rsdev->radio_dev = radio_si4713_vdev_template;
>         rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
> +       rsdev->radio_dev.ctrl_handler = sd->ctrl_handler;
>         /* Serialize all access to the si4713 */
>         rsdev->radio_dev.lock = &rsdev->lock;
>         video_set_drvdata(&rsdev->radio_dev, rsdev);
> diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
> index facd669..0faac952 100644
> --- a/drivers/media/radio/si4713-i2c.c
> +++ b/drivers/media/radio/si4713-i2c.c
> @@ -52,8 +52,6 @@ static const char *si4713_supply_names[SI4713_NUM_SUPPLIES] = {
>
>  #define DEFAULT_RDS_PI                 0x00
>  #define DEFAULT_RDS_PTY                        0x00
> -#define DEFAULT_RDS_PS_NAME            ""
> -#define DEFAULT_RDS_RADIO_TEXT         DEFAULT_RDS_PS_NAME
>  #define DEFAULT_RDS_DEVIATION          0x00C8
>  #define DEFAULT_RDS_PS_REPEAT_COUNT    0x0003
>  #define DEFAULT_LIMITER_RTIME          0x1392
> @@ -107,7 +105,6 @@ static const char *si4713_supply_names[SI4713_NUM_SUPPLIES] = {
>                                         (status & SI4713_ERR))
>  /* mute definition */
>  #define set_mute(p)    ((p & 1) | ((p & 1) << 1));
> -#define get_mute(p)    (p & 0x01)
>
>  #ifdef DEBUG
>  #define DBG_BUFFER(device, message, buffer, size)                      \
> @@ -189,21 +186,6 @@ static int usecs_to_dev(unsigned long usecs, unsigned long const array[],
>         return rval;
>  }
>
> -static unsigned long dev_to_usecs(int value, unsigned long const array[],
> -                       int size)
> -{
> -       int i;
> -       int rval = -EINVAL;
> -
> -       for (i = 0; i < size / 2; i++)
> -               if (array[i * 2] == value) {
> -                       rval = array[(i * 2) + 1];
> -                       break;
> -               }
> -
> -       return rval;
> -}
> -
>  /* si4713_handler: IRQ handler, just complete work */
>  static irqreturn_t si4713_handler(int irq, void *dev)
>  {
> @@ -787,9 +769,6 @@ static int si4713_set_mute(struct si4713_device *sdev, u16 mute)
>                 rval = si4713_write_property(sdev,
>                                 SI4713_TX_LINE_INPUT_MUTE, mute);
>
> -       if (rval >= 0)
> -               sdev->mute = get_mute(mute);
> -
>         return rval;
>  }
>
> @@ -830,7 +809,6 @@ static int si4713_set_rds_ps_name(struct si4713_device *sdev, char *ps_name)
>                         return rval;
>         }
>
> -       strncpy(sdev->rds_info.ps_name, ps_name, MAX_RDS_PS_NAME);
>         return rval;
>  }
>
> @@ -842,24 +820,23 @@ static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
>         s8 left;
>
>         if (!sdev->power_state)
> -               goto copy;
> +               return rval;
>
>         rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_CLEAR, 0, 0, 0, &left);
>         if (rval < 0)
>                 return rval;
>
>         if (!strlen(rt))
> -               goto copy;
> +               return rval;
>
>         do {
>                 /* RDS spec says that if the last block isn't used,
>                  * then apply a carriage return
>                  */
> -               if (t_index < (RDS_RADIOTEXT_INDEX_MAX *
> -                       RDS_RADIOTEXT_BLK_SIZE)) {
> +               if (t_index < (RDS_RADIOTEXT_INDEX_MAX * RDS_RADIOTEXT_BLK_SIZE)) {
>                         for (i = 0; i < RDS_RADIOTEXT_BLK_SIZE; i++) {
> -                               if (!rt[t_index + i] || rt[t_index + i] ==
> -                                       RDS_CARRIAGE_RETURN) {
> +                               if (!rt[t_index + i] ||
> +                                   rt[t_index + i] == RDS_CARRIAGE_RETURN) {
>                                         rt[t_index + i] = RDS_CARRIAGE_RETURN;
>                                         cr_inserted = 1;
>                                         break;
> @@ -881,13 +858,38 @@ static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
>                         break;
>         } while (left > 0);
>
> -copy:
> -       strncpy(sdev->rds_info.radio_text, rt, MAX_RDS_RADIO_TEXT);
> +       return rval;
> +}
> +
> +/*
> + * si4713_update_tune_status - update properties from tx_tune_status
> + * command. Must be called with sdev->mutex held.
> + * @sdev: si4713_device structure for the device we are communicating
> + */
> +static int si4713_update_tune_status(struct si4713_device *sdev)
> +{
> +       int rval;
> +       u16 f = 0;
> +       u8 p = 0, a = 0, n = 0;
> +
> +       rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
> +
> +       if (rval < 0)
> +               goto exit;
> +
> +/*     TODO: check that power_level and antenna_capacitor really are not
> +       changed by the hardware. If they are, then these controls should become
> +       volatiles.
> +       sdev->power_level = p;
> +       sdev->antenna_capacitor = a;*/
> +       sdev->tune_rnl = n;
> +
> +exit:
>         return rval;
>  }
>
>  static int si4713_choose_econtrol_action(struct si4713_device *sdev, u32 id,
> -               u32 **shadow, s32 *bit, s32 *mask, u16 *property, int *mul,
> +               s32 *bit, s32 *mask, u16 *property, int *mul,
>                 unsigned long **table, int *size)
>  {
>         s32 rval = 0;
> @@ -897,277 +899,76 @@ static int si4713_choose_econtrol_action(struct si4713_device *sdev, u32 id,
>         case V4L2_CID_RDS_TX_PI:
>                 *property = SI4713_TX_RDS_PI;
>                 *mul = 1;
> -               *shadow = &sdev->rds_info.pi;
>                 break;
>         case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
>                 *property = SI4713_TX_ACOMP_THRESHOLD;
>                 *mul = 1;
> -               *shadow = &sdev->acomp_info.threshold;
>                 break;
>         case V4L2_CID_AUDIO_COMPRESSION_GAIN:
>                 *property = SI4713_TX_ACOMP_GAIN;
>                 *mul = 1;
> -               *shadow = &sdev->acomp_info.gain;
>                 break;
>         case V4L2_CID_PILOT_TONE_FREQUENCY:
>                 *property = SI4713_TX_PILOT_FREQUENCY;
>                 *mul = 1;
> -               *shadow = &sdev->pilot_info.frequency;
>                 break;
>         case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
>                 *property = SI4713_TX_ACOMP_ATTACK_TIME;
>                 *mul = ATTACK_TIME_UNIT;
> -               *shadow = &sdev->acomp_info.attack_time;
>                 break;
>         case V4L2_CID_PILOT_TONE_DEVIATION:
>                 *property = SI4713_TX_PILOT_DEVIATION;
>                 *mul = 10;
> -               *shadow = &sdev->pilot_info.deviation;
>                 break;
>         case V4L2_CID_AUDIO_LIMITER_DEVIATION:
>                 *property = SI4713_TX_AUDIO_DEVIATION;
>                 *mul = 10;
> -               *shadow = &sdev->limiter_info.deviation;
>                 break;
>         case V4L2_CID_RDS_TX_DEVIATION:
>                 *property = SI4713_TX_RDS_DEVIATION;
>                 *mul = 1;
> -               *shadow = &sdev->rds_info.deviation;
>                 break;
>
>         case V4L2_CID_RDS_TX_PTY:
>                 *property = SI4713_TX_RDS_PS_MISC;
>                 *bit = 5;
>                 *mask = 0x1F << 5;
> -               *shadow = &sdev->rds_info.pty;
>                 break;
>         case V4L2_CID_AUDIO_LIMITER_ENABLED:
>                 *property = SI4713_TX_ACOMP_ENABLE;
>                 *bit = 1;
>                 *mask = 1 << 1;
> -               *shadow = &sdev->limiter_info.enabled;
>                 break;
>         case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
>                 *property = SI4713_TX_ACOMP_ENABLE;
>                 *bit = 0;
>                 *mask = 1 << 0;
> -               *shadow = &sdev->acomp_info.enabled;
>                 break;
>         case V4L2_CID_PILOT_TONE_ENABLED:
>                 *property = SI4713_TX_COMPONENT_ENABLE;
>                 *bit = 0;
>                 *mask = 1 << 0;
> -               *shadow = &sdev->pilot_info.enabled;
>                 break;
>
>         case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
>                 *property = SI4713_TX_LIMITER_RELEASE_TIME;
>                 *table = limiter_times;
>                 *size = ARRAY_SIZE(limiter_times);
> -               *shadow = &sdev->limiter_info.release_time;
>                 break;
>         case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
>                 *property = SI4713_TX_ACOMP_RELEASE_TIME;
>                 *table = acomp_rtimes;
>                 *size = ARRAY_SIZE(acomp_rtimes);
> -               *shadow = &sdev->acomp_info.release_time;
>                 break;
>         case V4L2_CID_TUNE_PREEMPHASIS:
>                 *property = SI4713_TX_PREEMPHASIS;
>                 *table = preemphasis_values;
>                 *size = ARRAY_SIZE(preemphasis_values);
> -               *shadow = &sdev->preemphasis;
>                 break;
>
>         default:
>                 rval = -EINVAL;
> -       }
> -
> -       return rval;
> -}
> -
> -static int si4713_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc);
> -
> -/* write string property */
> -static int si4713_write_econtrol_string(struct si4713_device *sdev,
> -                               struct v4l2_ext_control *control)
> -{
> -       struct v4l2_queryctrl vqc;
> -       int len;
> -       s32 rval = 0;
> -
> -       vqc.id = control->id;
> -       rval = si4713_queryctrl(&sdev->sd, &vqc);
> -       if (rval < 0)
> -               goto exit;
> -
> -       switch (control->id) {
> -       case V4L2_CID_RDS_TX_PS_NAME: {
> -               char ps_name[MAX_RDS_PS_NAME + 1];
> -
> -               len = control->size - 1;
> -               if (len < 0 || len > MAX_RDS_PS_NAME) {
> -                       rval = -ERANGE;
> -                       goto exit;
> -               }
> -               rval = copy_from_user(ps_name, control->string, len);
> -               if (rval) {
> -                       rval = -EFAULT;
> -                       goto exit;
> -               }
> -               ps_name[len] = '\0';
> -
> -               if (strlen(ps_name) % vqc.step) {
> -                       rval = -ERANGE;
> -                       goto exit;
> -               }
> -
> -               rval = si4713_set_rds_ps_name(sdev, ps_name);
> -       }
> -               break;
> -
> -       case V4L2_CID_RDS_TX_RADIO_TEXT: {
> -               char radio_text[MAX_RDS_RADIO_TEXT + 1];
> -
> -               len = control->size - 1;
> -               if (len < 0 || len > MAX_RDS_RADIO_TEXT) {
> -                       rval = -ERANGE;
> -                       goto exit;
> -               }
> -               rval = copy_from_user(radio_text, control->string, len);
> -               if (rval) {
> -                       rval = -EFAULT;
> -                       goto exit;
> -               }
> -               radio_text[len] = '\0';
> -
> -               if (strlen(radio_text) % vqc.step) {
> -                       rval = -ERANGE;
> -                       goto exit;
> -               }
> -
> -               rval = si4713_set_rds_radio_text(sdev, radio_text);
> -       }
> -               break;
> -
> -       default:
> -               rval = -EINVAL;
> -               break;
> -       }
> -
> -exit:
> -       return rval;
> -}
> -
> -static int validate_range(struct v4l2_subdev *sd,
> -                                       struct v4l2_ext_control *control)
> -{
> -       struct v4l2_queryctrl vqc;
> -       int rval;
> -
> -       vqc.id = control->id;
> -       rval = si4713_queryctrl(sd, &vqc);
> -       if (rval < 0)
> -               goto exit;
> -
> -       if (control->value < vqc.minimum || control->value > vqc.maximum)
> -               rval = -ERANGE;
> -
> -exit:
> -       return rval;
> -}
> -
> -/* properties which use tx_tune_power*/
> -static int si4713_write_econtrol_tune(struct si4713_device *sdev,
> -                               struct v4l2_ext_control *control)
> -{
> -       s32 rval = 0;
> -       u8 power, antcap;
> -
> -       rval = validate_range(&sdev->sd, control);
> -       if (rval < 0)
> -               return rval;
> -
> -       switch (control->id) {
> -       case V4L2_CID_TUNE_POWER_LEVEL:
> -               power = control->value;
> -               antcap = sdev->antenna_capacitor;
> -               break;
> -       case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> -               power = sdev->power_level;
> -               antcap = control->value;
>                 break;
> -       default:
> -               return -EINVAL;
> -       }
> -
> -       if (sdev->power_state)
> -               rval = si4713_tx_tune_power(sdev, power, antcap);
> -
> -       if (rval == 0) {
> -               sdev->power_level = power;
> -               sdev->antenna_capacitor = antcap;
> -       }
> -
> -       return rval;
> -}
> -
> -static int si4713_write_econtrol_integers(struct si4713_device *sdev,
> -                                       struct v4l2_ext_control *control)
> -{
> -       s32 rval;
> -       u32 *shadow = NULL, val = 0;
> -       s32 bit = 0, mask = 0;
> -       u16 property = 0;
> -       int mul = 0;
> -       unsigned long *table = NULL;
> -       int size = 0;
> -
> -       rval = validate_range(&sdev->sd, control);
> -       if (rval < 0)
> -               return rval;
> -
> -       rval = si4713_choose_econtrol_action(sdev, control->id, &shadow, &bit,
> -                       &mask, &property, &mul, &table, &size);
> -       if (rval < 0)
> -               return rval;
> -
> -       val = control->value;
> -       if (mul) {
> -               val = control->value / mul;
> -       } else if (table) {
> -               rval = usecs_to_dev(control->value, table, size);
> -               if (rval < 0)
> -                       return rval;
> -               val = rval;
> -               rval = 0;
> -       }
> -
> -       if (sdev->power_state) {
> -               if (mask) {
> -                       rval = si4713_read_property(sdev, property, &val);
> -                       if (rval < 0)
> -                               return rval;
> -                       val = set_bits(val, control->value, bit, mask);
> -               }
> -
> -               rval = si4713_write_property(sdev, property, val);
> -               if (rval < 0)
> -                       return rval;
> -               if (mask)
> -                       val = control->value;
> -       }
> -
> -       if (mul) {
> -               *shadow = val * mul;
> -       } else if (table) {
> -               rval = dev_to_usecs(val, table, size);
> -               if (rval < 0)
> -                       return rval;
> -               *shadow = rval;
> -               rval = 0;
> -       } else {
> -               *shadow = val;
>         }
>
>         return rval;
> @@ -1181,109 +982,24 @@ static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulato
>   */
>  static int si4713_setup(struct si4713_device *sdev)
>  {
> -       struct v4l2_ext_control ctrl;
>         struct v4l2_frequency f;
>         struct v4l2_modulator vm;
> -       struct si4713_device *tmp;
> -       int rval = 0;
> -
> -       tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> -       if (!tmp)
> -               return -ENOMEM;
> -
> -       /* Get a local copy to avoid race */
> -       memcpy(tmp, sdev, sizeof(*sdev));
> -
> -       ctrl.id = V4L2_CID_RDS_TX_PI;
> -       ctrl.value = tmp->rds_info.pi;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_COMPRESSION_THRESHOLD;
> -       ctrl.value = tmp->acomp_info.threshold;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_COMPRESSION_GAIN;
> -       ctrl.value = tmp->acomp_info.gain;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_PILOT_TONE_FREQUENCY;
> -       ctrl.value = tmp->pilot_info.frequency;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME;
> -       ctrl.value = tmp->acomp_info.attack_time;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_PILOT_TONE_DEVIATION;
> -       ctrl.value = tmp->pilot_info.deviation;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_LIMITER_DEVIATION;
> -       ctrl.value = tmp->limiter_info.deviation;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_RDS_TX_DEVIATION;
> -       ctrl.value = tmp->rds_info.deviation;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_RDS_TX_PTY;
> -       ctrl.value = tmp->rds_info.pty;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_LIMITER_ENABLED;
> -       ctrl.value = tmp->limiter_info.enabled;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_COMPRESSION_ENABLED;
> -       ctrl.value = tmp->acomp_info.enabled;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_PILOT_TONE_ENABLED;
> -       ctrl.value = tmp->pilot_info.enabled;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_LIMITER_RELEASE_TIME;
> -       ctrl.value = tmp->limiter_info.release_time;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME;
> -       ctrl.value = tmp->acomp_info.release_time;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_TUNE_PREEMPHASIS;
> -       ctrl.value = tmp->preemphasis;
> -       rval |= si4713_write_econtrol_integers(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_RDS_TX_PS_NAME;
> -       rval |= si4713_set_rds_ps_name(sdev, tmp->rds_info.ps_name);
> -
> -       ctrl.id = V4L2_CID_RDS_TX_RADIO_TEXT;
> -       rval |= si4713_set_rds_radio_text(sdev, tmp->rds_info.radio_text);
> +       int rval;
>
>         /* Device procedure needs to set frequency first */
> -       f.frequency = tmp->frequency ? tmp->frequency : DEFAULT_FREQUENCY;
> +       f.frequency = sdev->frequency ? sdev->frequency : DEFAULT_FREQUENCY;
>         f.frequency = si4713_to_v4l2(f.frequency);
> -       rval |= si4713_s_frequency(&sdev->sd, &f);
> -
> -       ctrl.id = V4L2_CID_TUNE_POWER_LEVEL;
> -       ctrl.value = tmp->power_level;
> -       rval |= si4713_write_econtrol_tune(sdev, &ctrl);
> -
> -       ctrl.id = V4L2_CID_TUNE_ANTENNA_CAPACITOR;
> -       ctrl.value = tmp->antenna_capacitor;
> -       rval |= si4713_write_econtrol_tune(sdev, &ctrl);
> +       rval = si4713_s_frequency(&sdev->sd, &f);
>
>         vm.index = 0;
> -       if (tmp->stereo)
> +       if (sdev->stereo)
>                 vm.txsubchans = V4L2_TUNER_SUB_STEREO;
>         else
>                 vm.txsubchans = V4L2_TUNER_SUB_MONO;
> -       if (tmp->rds_info.enabled)
> +       if (sdev->rds_enabled)
>                 vm.txsubchans |= V4L2_TUNER_SUB_RDS;
>         si4713_s_modulator(&sdev->sd, &vm);
>
> -       kfree(tmp);
> -
>         return rval;
>  }
>
> @@ -1307,406 +1023,116 @@ static int si4713_initialize(struct si4713_device *sdev)
>         if (rval < 0)
>                 return rval;
>
> -       sdev->rds_info.pi = DEFAULT_RDS_PI;
> -       sdev->rds_info.pty = DEFAULT_RDS_PTY;
> -       sdev->rds_info.deviation = DEFAULT_RDS_DEVIATION;
> -       strlcpy(sdev->rds_info.ps_name, DEFAULT_RDS_PS_NAME, MAX_RDS_PS_NAME);
> -       strlcpy(sdev->rds_info.radio_text, DEFAULT_RDS_RADIO_TEXT,
> -                                                       MAX_RDS_RADIO_TEXT);
> -       sdev->rds_info.enabled = 1;
> -
> -       sdev->limiter_info.release_time = DEFAULT_LIMITER_RTIME;
> -       sdev->limiter_info.deviation = DEFAULT_LIMITER_DEV;
> -       sdev->limiter_info.enabled = 1;
> -
> -       sdev->pilot_info.deviation = DEFAULT_PILOT_DEVIATION;
> -       sdev->pilot_info.frequency = DEFAULT_PILOT_FREQUENCY;
> -       sdev->pilot_info.enabled = 1;
> -
> -       sdev->acomp_info.release_time = DEFAULT_ACOMP_RTIME;
> -       sdev->acomp_info.attack_time = DEFAULT_ACOMP_ATIME;
> -       sdev->acomp_info.threshold = DEFAULT_ACOMP_THRESHOLD;
> -       sdev->acomp_info.gain = DEFAULT_ACOMP_GAIN;
> -       sdev->acomp_info.enabled = 1;
>
>         sdev->frequency = DEFAULT_FREQUENCY;
> -       sdev->preemphasis = DEFAULT_PREEMPHASIS;
> -       sdev->mute = DEFAULT_MUTE;
> -       sdev->power_level = DEFAULT_POWER_LEVEL;
> -       sdev->antenna_capacitor = 0;
>         sdev->stereo = 1;
>         sdev->tune_rnl = DEFAULT_TUNE_RNL;
> -
> -       return rval;
> -}
> -
> -/* read string property */
> -static int si4713_read_econtrol_string(struct si4713_device *sdev,
> -                               struct v4l2_ext_control *control)
> -{
> -       s32 rval = 0;
> -
> -       switch (control->id) {
> -       case V4L2_CID_RDS_TX_PS_NAME:
> -               if (strlen(sdev->rds_info.ps_name) + 1 > control->size) {
> -                       control->size = MAX_RDS_PS_NAME + 1;
> -                       rval = -ENOSPC;
> -                       goto exit;
> -               }
> -               rval = copy_to_user(control->string, sdev->rds_info.ps_name,
> -                                       strlen(sdev->rds_info.ps_name) + 1);
> -               if (rval)
> -                       rval = -EFAULT;
> -               break;
> -
> -       case V4L2_CID_RDS_TX_RADIO_TEXT:
> -               if (strlen(sdev->rds_info.radio_text) + 1 > control->size) {
> -                       control->size = MAX_RDS_RADIO_TEXT + 1;
> -                       rval = -ENOSPC;
> -                       goto exit;
> -               }
> -               rval = copy_to_user(control->string, sdev->rds_info.radio_text,
> -                                       strlen(sdev->rds_info.radio_text) + 1);
> -               if (rval)
> -                       rval = -EFAULT;
> -               break;
> -
> -       default:
> -               rval = -EINVAL;
> -               break;
> -       }
> -
> -exit:
> -       return rval;
> -}
> -
> -/*
> - * si4713_update_tune_status - update properties from tx_tune_status
> - * command.
> - * @sdev: si4713_device structure for the device we are communicating
> - */
> -static int si4713_update_tune_status(struct si4713_device *sdev)
> -{
> -       int rval;
> -       u16 f = 0;
> -       u8 p = 0, a = 0, n = 0;
> -
> -       rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
> -
> -       if (rval < 0)
> -               goto exit;
> -
> -       sdev->power_level = p;
> -       sdev->antenna_capacitor = a;
> -       sdev->tune_rnl = n;
> -
> -exit:
> -       return rval;
> -}
> -
> -/* properties which use tx_tune_status */
> -static int si4713_read_econtrol_tune(struct si4713_device *sdev,
> -                               struct v4l2_ext_control *control)
> -{
> -       s32 rval = 0;
> -
> -       if (sdev->power_state) {
> -               rval = si4713_update_tune_status(sdev);
> -               if (rval < 0)
> -                       return rval;
> -       }
> -
> -       switch (control->id) {
> -       case V4L2_CID_TUNE_POWER_LEVEL:
> -               control->value = sdev->power_level;
> -               break;
> -       case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> -               control->value = sdev->antenna_capacitor;
> -               break;
> -       default:
> -               return -EINVAL;
> -       }
> -
> -       return rval;
> +       return 0;
>  }
>
> -static int si4713_read_econtrol_integers(struct si4713_device *sdev,
> -                               struct v4l2_ext_control *control)
> +/* si4713_s_ctrl - set the value of a control */
> +static int si4713_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> -       s32 rval;
> -       u32 *shadow = NULL, val = 0;
> +       struct si4713_device *sdev =
> +               container_of(ctrl->handler, struct si4713_device, ctrl_handler);
> +       u32 val = 0;
>         s32 bit = 0, mask = 0;
>         u16 property = 0;
>         int mul = 0;
>         unsigned long *table = NULL;
>         int size = 0;
> +       bool force = false;
> +       int c;
> +       int ret = 0;
>
> -       rval = si4713_choose_econtrol_action(sdev, control->id, &shadow, &bit,
> -                       &mask, &property, &mul, &table, &size);
> -       if (rval < 0)
> -               return rval;
> -
> -       if (sdev->power_state) {
> -               rval = si4713_read_property(sdev, property, &val);
> -               if (rval < 0)
> -                       return rval;
> -
> -               /* Keep negative values for threshold */
> -               if (control->id == V4L2_CID_AUDIO_COMPRESSION_THRESHOLD)
> -                       *shadow = (s16)val;
> -               else if (mask)
> -                       *shadow = get_status_bit(val, bit, mask);
> -               else if (mul)
> -                       *shadow = val * mul;
> -               else
> -                       *shadow = dev_to_usecs(val, table, size);
> -       }
> -
> -       control->value = *shadow;
> -
> -       return rval;
> -}
> -
> -/*
> - * Video4Linux Subdev Interface
> - */
> -/* si4713_s_ext_ctrls - set extended controls value */
> -static int si4713_s_ext_ctrls(struct v4l2_subdev *sd,
> -                               struct v4l2_ext_controls *ctrls)
> -{
> -       struct si4713_device *sdev = to_si4713_device(sd);
> -       int i;
> -
> -       if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
> +       if (ctrl->id != V4L2_CID_AUDIO_MUTE)
>                 return -EINVAL;
> -
> -       for (i = 0; i < ctrls->count; i++) {
> -               int err;
> -
> -               switch ((ctrls->controls + i)->id) {
> -               case V4L2_CID_RDS_TX_PS_NAME:
> -               case V4L2_CID_RDS_TX_RADIO_TEXT:
> -                       err = si4713_write_econtrol_string(sdev,
> -                                                       ctrls->controls + i);
> -                       break;
> -               case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> -               case V4L2_CID_TUNE_POWER_LEVEL:
> -                       err = si4713_write_econtrol_tune(sdev,
> -                                                       ctrls->controls + i);
> -                       break;
> -               default:
> -                       err = si4713_write_econtrol_integers(sdev,
> -                                                       ctrls->controls + i);
> -               }
> -
> -               if (err < 0) {
> -                       ctrls->error_idx = i;
> -                       return err;
> +       if (ctrl->is_new) {
> +               if (ctrl->val) {
> +                       ret = si4713_set_mute(sdev, ctrl->val);
> +                       if (!ret)
> +                               ret = si4713_set_power_state(sdev, POWER_DOWN);
> +                       return ret;
>                 }
> +               ret = si4713_set_power_state(sdev, POWER_UP);
> +               if (!ret)
> +                       ret = si4713_set_mute(sdev, ctrl->val);
> +               if (!ret)
> +                       ret = si4713_setup(sdev);
> +               if (ret)
> +                       return ret;
> +               force = true;
>         }
>
> -       return 0;
> -}
> -
> -/* si4713_g_ext_ctrls - get extended controls value */
> -static int si4713_g_ext_ctrls(struct v4l2_subdev *sd,
> -                               struct v4l2_ext_controls *ctrls)
> -{
> -       struct si4713_device *sdev = to_si4713_device(sd);
> -       int i;
> +       if (!sdev->power_state)
> +               return 0;
>
> -       if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
> -               return -EINVAL;
> +       for (c = 1; !ret && c < ctrl->ncontrols; c++) {
> +               ctrl = ctrl->cluster[c];
>
> -       for (i = 0; i < ctrls->count; i++) {
> -               int err;
> +               if (!force && !ctrl->is_new)
> +                       continue;
>
> -               switch ((ctrls->controls + i)->id) {
> +               switch (ctrl->id) {
>                 case V4L2_CID_RDS_TX_PS_NAME:
> +                       ret = si4713_set_rds_ps_name(sdev, ctrl->string);
> +                       break;
> +
>                 case V4L2_CID_RDS_TX_RADIO_TEXT:
> -                       err = si4713_read_econtrol_string(sdev,
> -                                                       ctrls->controls + i);
> +                       ret = si4713_set_rds_radio_text(sdev, ctrl->string);
>                         break;
> +
>                 case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> +                       /* don't handle this control if we force setting all
> +                        * controls since in that case it will be handled by
> +                        * V4L2_CID_TUNE_POWER_LEVEL. */
> +                       if (force)
> +                               break;
> +                       /* fall through */
>                 case V4L2_CID_TUNE_POWER_LEVEL:
> -                       err = si4713_read_econtrol_tune(sdev,
> -                                                       ctrls->controls + i);
> +                       ret = si4713_tx_tune_power(sdev,
> +                               sdev->tune_pwr_level->val, sdev->tune_ant_cap->val);
> +                       if (!ret) {
> +                               /* Make sure we don't set this twice */
> +                               sdev->tune_ant_cap->is_new = false;
> +                               sdev->tune_pwr_level->is_new = false;
> +                       }
>                         break;
> -               default:
> -                       err = si4713_read_econtrol_integers(sdev,
> -                                                       ctrls->controls + i);
> -               }
> -
> -               if (err < 0) {
> -                       ctrls->error_idx = i;
> -                       return err;
> -               }
> -       }
> -
> -       return 0;
> -}
> -
> -/* si4713_queryctrl - enumerate control items */
> -static int si4713_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> -{
> -       int rval = 0;
> -
> -       switch (qc->id) {
> -       /* User class controls */
> -       case V4L2_CID_AUDIO_MUTE:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, DEFAULT_MUTE);
> -               break;
> -       /* FM_TX class controls */
> -       case V4L2_CID_RDS_TX_PI:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 0xFFFF, 1, DEFAULT_RDS_PI);
> -               break;
> -       case V4L2_CID_RDS_TX_PTY:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 31, 1, DEFAULT_RDS_PTY);
> -               break;
> -       case V4L2_CID_RDS_TX_DEVIATION:
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_RDS_DEVIATION,
> -                                               10, DEFAULT_RDS_DEVIATION);
> -               break;
> -       case V4L2_CID_RDS_TX_PS_NAME:
> -               /*
> -                * Report step as 8. From RDS spec, psname
> -                * should be 8. But there are receivers which scroll strings
> -                * sized as 8xN.
> -                */
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_RDS_PS_NAME, 8, 0);
> -               break;
> -       case V4L2_CID_RDS_TX_RADIO_TEXT:
> -               /*
> -                * Report step as 32 (2A block). From RDS spec,
> -                * radio text should be 32 for 2A block. But there are receivers
> -                * which scroll strings sized as 32xN. Setting default to 32.
> -                */
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_RDS_RADIO_TEXT, 32, 0);
> -               break;
>
> -       case V4L2_CID_AUDIO_LIMITER_ENABLED:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> -               break;
> -       case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
> -               rval = v4l2_ctrl_query_fill(qc, 250, MAX_LIMITER_RELEASE_TIME,
> -                                               50, DEFAULT_LIMITER_RTIME);
> -               break;
> -       case V4L2_CID_AUDIO_LIMITER_DEVIATION:
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_LIMITER_DEVIATION,
> -                                               10, DEFAULT_LIMITER_DEV);
> -               break;
> -
> -       case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> -               break;
> -       case V4L2_CID_AUDIO_COMPRESSION_GAIN:
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_ACOMP_GAIN, 1,
> -                                               DEFAULT_ACOMP_GAIN);
> -               break;
> -       case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
> -               rval = v4l2_ctrl_query_fill(qc, MIN_ACOMP_THRESHOLD,
> -                                               MAX_ACOMP_THRESHOLD, 1,
> -                                               DEFAULT_ACOMP_THRESHOLD);
> -               break;
> -       case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_ACOMP_ATTACK_TIME,
> -                                               500, DEFAULT_ACOMP_ATIME);
> -               break;
> -       case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
> -               rval = v4l2_ctrl_query_fill(qc, 100000, MAX_ACOMP_RELEASE_TIME,
> -                                               100000, DEFAULT_ACOMP_RTIME);
> -               break;
> -
> -       case V4L2_CID_PILOT_TONE_ENABLED:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> -               break;
> -       case V4L2_CID_PILOT_TONE_DEVIATION:
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_PILOT_DEVIATION,
> -                                               10, DEFAULT_PILOT_DEVIATION);
> -               break;
> -       case V4L2_CID_PILOT_TONE_FREQUENCY:
> -               rval = v4l2_ctrl_query_fill(qc, 0, MAX_PILOT_FREQUENCY,
> -                                               1, DEFAULT_PILOT_FREQUENCY);
> -               break;
> -
> -       case V4L2_CID_TUNE_PREEMPHASIS:
> -               rval = v4l2_ctrl_query_fill(qc, V4L2_PREEMPHASIS_DISABLED,
> -                                               V4L2_PREEMPHASIS_75_uS, 1,
> -                                               V4L2_PREEMPHASIS_50_uS);
> -               break;
> -       case V4L2_CID_TUNE_POWER_LEVEL:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 120, 1, DEFAULT_POWER_LEVEL);
> -               break;
> -       case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> -               rval = v4l2_ctrl_query_fill(qc, 0, 191, 1, 0);
> -               break;
> -       default:
> -               rval = -EINVAL;
> -               break;
> -       }
> -
> -       return rval;
> -}
> -
> -/* si4713_g_ctrl - get the value of a control */
> -static int si4713_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> -{
> -       struct si4713_device *sdev = to_si4713_device(sd);
> -       int rval = 0;
> -
> -       if (!sdev)
> -               return -ENODEV;
> -
> -       if (sdev->power_state) {
> -               rval = si4713_read_property(sdev, SI4713_TX_LINE_INPUT_MUTE,
> -                                               &sdev->mute);
> -
> -               if (rval < 0)
> -                       return rval;
> -       }
> -
> -       switch (ctrl->id) {
> -       case V4L2_CID_AUDIO_MUTE:
> -               ctrl->value = get_mute(sdev->mute);
> -               break;
> -       }
> -
> -       return rval;
> -}
> -
> -/* si4713_s_ctrl - set the value of a control */
> -static int si4713_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> -{
> -       struct si4713_device *sdev = to_si4713_device(sd);
> -       int rval = 0;
> -
> -       if (!sdev)
> -               return -ENODEV;
> -
> -       switch (ctrl->id) {
> -       case V4L2_CID_AUDIO_MUTE:
> -               if (ctrl->value) {
> -                       rval = si4713_set_mute(sdev, ctrl->value);
> -                       if (rval < 0)
> -                               goto exit;
> -
> -                       rval = si4713_set_power_state(sdev, POWER_DOWN);
> -               } else {
> -                       rval = si4713_set_power_state(sdev, POWER_UP);
> -                       if (rval < 0)
> -                               goto exit;
> +               default:
> +                       ret = si4713_choose_econtrol_action(sdev, ctrl->id, &bit,
> +                                       &mask, &property, &mul, &table, &size);
> +                       if (ret < 0)
> +                               break;
> +
> +                       val = ctrl->val;
> +                       if (mul) {
> +                               val = val / mul;
> +                       } else if (table) {
> +                               ret = usecs_to_dev(val, table, size);
> +                               if (ret < 0)
> +                                       break;
> +                               val = ret;
> +                               ret = 0;
> +                       }
>
> -                       rval = si4713_setup(sdev);
> -                       if (rval < 0)
> -                               goto exit;
> +                       if (mask) {
> +                               ret = si4713_read_property(sdev, property, &val);
> +                               if (ret < 0)
> +                                       break;
> +                               val = set_bits(val, ctrl->val, bit, mask);
> +                       }
>
> -                       rval = si4713_set_mute(sdev, ctrl->value);
> +                       ret = si4713_write_property(sdev, property, val);
> +                       if (ret < 0)
> +                               break;
> +                       if (mask)
> +                               val = ctrl->val;
> +                       break;
>                 }
> -               break;
>         }
>
> -exit:
> -       return rval;
> +       return ret;
>  }
>
>  /* si4713_ioctl - deal with private ioctls (only rnl for now) */
> @@ -1745,15 +1171,6 @@ static long si4713_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
>         return rval;
>  }
>
> -static const struct v4l2_subdev_core_ops si4713_subdev_core_ops = {
> -       .queryctrl      = si4713_queryctrl,
> -       .g_ext_ctrls    = si4713_g_ext_ctrls,
> -       .s_ext_ctrls    = si4713_s_ext_ctrls,
> -       .g_ctrl         = si4713_g_ctrl,
> -       .s_ctrl         = si4713_s_ctrl,
> -       .ioctl          = si4713_ioctl,
> -};
> -
>  /* si4713_g_modulator - get modulator attributes */
>  static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
>  {
> @@ -1783,7 +1200,6 @@ static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
>                         return rval;
>
>                 sdev->stereo = get_status_bit(comp_en, 1, 1 << 1);
> -               sdev->rds_info.enabled = get_status_bit(comp_en, 2, 1 << 2);
>         }
>
>         /* Report current audio mode: mono or stereo */
> @@ -1793,7 +1209,7 @@ static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
>                 vm->txsubchans = V4L2_TUNER_SUB_MONO;
>
>         /* Report rds feature status */
> -       if (sdev->rds_info.enabled)
> +       if (sdev->rds_enabled)
>                 vm->txsubchans |= V4L2_TUNER_SUB_RDS;
>         else
>                 vm->txsubchans &= ~V4L2_TUNER_SUB_RDS;
> @@ -1841,7 +1257,7 @@ static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulato
>         }
>
>         sdev->stereo = stereo;
> -       sdev->rds_info.enabled = rds;
> +       sdev->rds_enabled = rds;
>
>         return rval;
>  }
> @@ -1896,6 +1312,14 @@ static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequenc
>         return rval;
>  }
>
> +static const struct v4l2_ctrl_ops si4713_ctrl_ops = {
> +       .s_ctrl = si4713_s_ctrl,
> +};
> +
> +static const struct v4l2_subdev_core_ops si4713_subdev_core_ops = {
> +       .ioctl          = si4713_ioctl,
> +};
> +
>  static const struct v4l2_subdev_tuner_ops si4713_subdev_tuner_ops = {
>         .g_frequency    = si4713_g_frequency,
>         .s_frequency    = si4713_s_frequency,
> @@ -1917,6 +1341,7 @@ static int si4713_probe(struct i2c_client *client,
>  {
>         struct si4713_device *sdev;
>         struct si4713_platform_data *pdata = client->dev.platform_data;
> +       struct v4l2_ctrl_handler *hdl;
>         int rval, i;
>
>         sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
> @@ -1952,6 +1377,82 @@ static int si4713_probe(struct i2c_client *client,
>
>         init_completion(&sdev->work);
>
> +       hdl = &sdev->ctrl_handler;
> +       v4l2_ctrl_handler_init(hdl, 20);
> +       sdev->mute = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_MUTE, 0, 1, 1, DEFAULT_MUTE);
> +
> +       sdev->rds_pi = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_RDS_TX_PI, 0, 0xffff, 1, DEFAULT_RDS_PI);
> +       sdev->rds_pty = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_RDS_TX_PTY, 0, 31, 1, DEFAULT_RDS_PTY);
> +       sdev->rds_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_RDS_TX_DEVIATION, 0, MAX_RDS_DEVIATION,
> +                       10, DEFAULT_RDS_DEVIATION);
> +       /*
> +        * Report step as 8. From RDS spec, psname
> +        * should be 8. But there are receivers which scroll strings
> +        * sized as 8xN.
> +        */
> +       sdev->rds_ps_name = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_RDS_TX_PS_NAME, 0, MAX_RDS_PS_NAME, 8, 0);
> +       /*
> +        * Report step as 32 (2A block). From RDS spec,
> +        * radio text should be 32 for 2A block. But there are receivers
> +        * which scroll strings sized as 32xN. Setting default to 32.
> +        */
> +       sdev->rds_radio_text = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_RDS_TX_RADIO_TEXT, 0, MAX_RDS_RADIO_TEXT, 32, 0);
> +
> +       sdev->limiter_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_LIMITER_ENABLED, 0, 1, 1, 1);
> +       sdev->limiter_release_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_LIMITER_RELEASE_TIME, 250,
> +                       MAX_LIMITER_RELEASE_TIME, 10, DEFAULT_LIMITER_RTIME);
> +       sdev->limiter_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_LIMITER_DEVIATION, 0,
> +                       MAX_LIMITER_DEVIATION, 10, DEFAULT_LIMITER_DEV);
> +
> +       sdev->compression_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_COMPRESSION_ENABLED, 0, 1, 1, 1);
> +       sdev->compression_gain = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_COMPRESSION_GAIN, 0, MAX_ACOMP_GAIN, 1,
> +                       DEFAULT_ACOMP_GAIN);
> +       sdev->compression_threshold = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_COMPRESSION_THRESHOLD, MIN_ACOMP_THRESHOLD,
> +                       MAX_ACOMP_THRESHOLD, 1,
> +                       DEFAULT_ACOMP_THRESHOLD);
> +       sdev->compression_attack_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME, 0,
> +                       MAX_ACOMP_ATTACK_TIME, 500, DEFAULT_ACOMP_ATIME);
> +       sdev->compression_release_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME, 100000,
> +                       MAX_ACOMP_RELEASE_TIME, 100000, DEFAULT_ACOMP_RTIME);
> +
> +       sdev->pilot_tone_enabled = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_PILOT_TONE_ENABLED, 0, 1, 1, 1);
> +       sdev->pilot_tone_deviation = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_PILOT_TONE_DEVIATION, 0, MAX_PILOT_DEVIATION,
> +                       10, DEFAULT_PILOT_DEVIATION);
> +       sdev->pilot_tone_freq = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_PILOT_TONE_FREQUENCY, 0, MAX_PILOT_FREQUENCY,
> +                       1, DEFAULT_PILOT_FREQUENCY);
> +
> +       sdev->tune_preemphasis = v4l2_ctrl_new_std_menu(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_TUNE_PREEMPHASIS,
> +                       V4L2_PREEMPHASIS_75_uS, 0, V4L2_PREEMPHASIS_50_uS);
> +       sdev->tune_pwr_level = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_TUNE_POWER_LEVEL, 0, 120, 1, DEFAULT_POWER_LEVEL);
> +       sdev->tune_ant_cap = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> +                       V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, 191, 1, 0);
> +
> +       if (hdl->error) {
> +               rval = hdl->error;
> +               goto free_ctrls;
> +       }
> +       v4l2_ctrl_cluster(20, &sdev->mute);
> +       sdev->sd.ctrl_handler = hdl;
> +
>         if (client->irq) {
>                 rval = request_irq(client->irq,
>                         si4713_handler, IRQF_TRIGGER_FALLING | IRQF_DISABLED,
> @@ -1976,6 +1477,8 @@ static int si4713_probe(struct i2c_client *client,
>  free_irq:
>         if (client->irq)
>                 free_irq(client->irq, sdev);
> +free_ctrls:
> +       v4l2_ctrl_handler_free(hdl);
>  put_reg:
>         regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
>  free_gpio:
> @@ -2000,6 +1503,7 @@ static int si4713_remove(struct i2c_client *client)
>                 free_irq(client->irq, sdev);
>
>         v4l2_device_unregister_subdev(sd);
> +       v4l2_ctrl_handler_free(sd->ctrl_handler);
>         regulator_bulk_free(ARRAY_SIZE(sdev->supplies), sdev->supplies);
>         if (gpio_is_valid(sdev->gpio_reset))
>                 gpio_free(sdev->gpio_reset);
> diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
> index 979828d..25cdea2 100644
> --- a/drivers/media/radio/si4713-i2c.h
> +++ b/drivers/media/radio/si4713-i2c.h
> @@ -16,6 +16,7 @@
>  #define SI4713_I2C_H
>
>  #include <media/v4l2-subdev.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/si4713.h>
>
>  #define SI4713_PRODUCT_NUMBER          0x0D
> @@ -160,56 +161,33 @@
>  #define POWER_UP                       0x01
>  #define POWER_DOWN                     0x00
>
> -struct rds_info {
> -       u32 pi;
>  #define MAX_RDS_PTY                    31
> -       u32 pty;
>  #define MAX_RDS_DEVIATION              90000
> -       u32 deviation;
> +
>  /*
>   * PSNAME is known to be defined as 8 character sized (RDS Spec).
>   * However, there is receivers which scroll PSNAME 8xN sized.
>   */
>  #define MAX_RDS_PS_NAME                        96
> -       u8 ps_name[MAX_RDS_PS_NAME + 1];
> +
>  /*
>   * MAX_RDS_RADIO_TEXT is known to be defined as 32 (2A group) or 64 (2B group)
>   * character sized (RDS Spec).
>   * However, there is receivers which scroll them as well.
>   */
>  #define MAX_RDS_RADIO_TEXT             384
> -       u8 radio_text[MAX_RDS_RADIO_TEXT + 1];
> -       u32 enabled;
> -};
>
> -struct limiter_info {
>  #define MAX_LIMITER_RELEASE_TIME       102390
> -       u32 release_time;
>  #define MAX_LIMITER_DEVIATION          90000
> -       u32 deviation;
> -       u32 enabled;
> -};
>
> -struct pilot_info {
>  #define MAX_PILOT_DEVIATION            90000
> -       u32 deviation;
>  #define MAX_PILOT_FREQUENCY            19000
> -       u32 frequency;
> -       u32 enabled;
> -};
>
> -struct acomp_info {
>  #define MAX_ACOMP_RELEASE_TIME         1000000
> -       u32 release_time;
>  #define MAX_ACOMP_ATTACK_TIME          5000
> -       u32 attack_time;
>  #define MAX_ACOMP_THRESHOLD            0
>  #define MIN_ACOMP_THRESHOLD            (-40)
> -       s32 threshold;
>  #define MAX_ACOMP_GAIN                 20
> -       u32 gain;
> -       u32 enabled;
> -};
>
>  #define SI4713_NUM_SUPPLIES            2
>
> @@ -219,20 +197,41 @@ struct acomp_info {
>  struct si4713_device {
>         /* v4l2_subdev and i2c reference (v4l2_subdev priv data) */
>         struct v4l2_subdev sd;
> +       struct v4l2_ctrl_handler ctrl_handler;
>         /* private data structures */
> +       struct { /* si4713 control cluster */
> +               /* This is one big cluster since the mute control
> +                * powers off the device and after unmuting again all
> +                * controls need to be set at once. The only way of doing
> +                * that is by making it one big cluster. */
> +               struct v4l2_ctrl *mute;
> +               struct v4l2_ctrl *rds_ps_name;
> +               struct v4l2_ctrl *rds_radio_text;
> +               struct v4l2_ctrl *rds_pi;
> +               struct v4l2_ctrl *rds_deviation;
> +               struct v4l2_ctrl *rds_pty;
> +               struct v4l2_ctrl *compression_enabled;
> +               struct v4l2_ctrl *compression_threshold;
> +               struct v4l2_ctrl *compression_gain;
> +               struct v4l2_ctrl *compression_attack_time;
> +               struct v4l2_ctrl *compression_release_time;
> +               struct v4l2_ctrl *pilot_tone_enabled;
> +               struct v4l2_ctrl *pilot_tone_freq;
> +               struct v4l2_ctrl *pilot_tone_deviation;
> +               struct v4l2_ctrl *limiter_enabled;
> +               struct v4l2_ctrl *limiter_deviation;
> +               struct v4l2_ctrl *limiter_release_time;
> +               struct v4l2_ctrl *tune_preemphasis;
> +               struct v4l2_ctrl *tune_pwr_level;
> +               struct v4l2_ctrl *tune_ant_cap;
> +       };
>         struct completion work;
> -       struct rds_info rds_info;
> -       struct limiter_info limiter_info;
> -       struct pilot_info pilot_info;
> -       struct acomp_info acomp_info;
>         struct regulator_bulk_data supplies[SI4713_NUM_SUPPLIES];
>         int gpio_reset;
> +       u32 power_state;
> +       u32 rds_enabled;
>         u32 frequency;
>         u32 preemphasis;
> -       u32 mute;
> -       u32 power_level;
> -       u32 power_state;
> -       u32 antenna_capacitor;
>         u32 stereo;
>         u32 tune_rnl;
>  };
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
