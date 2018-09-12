Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50908 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbeILMHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 08:07:55 -0400
Subject: Re: [PATCH 3/3] media: replace strncpy() by strscpy()
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
 <7da460f4d77659c3fc19743c287f0b24f6cd596a.1536581758.git.mchehab+samsung@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <745c8790-564c-4365-8a80-d7dd38fd4559@xs4all.nl>
Date: Wed, 12 Sep 2018 09:04:40 +0200
MIME-Version: 1.0
In-Reply-To: <7da460f4d77659c3fc19743c287f0b24f6cd596a.1536581758.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 02:19 PM, Mauro Carvalho Chehab wrote:
> The strncpy() function is being deprecated upstream. Replace
> it by the safer strscpy().
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/dvb-frontends/as102_fe.c           |  2 +-
>  drivers/media/dvb-frontends/dib7000p.c           |  3 ++-
>  drivers/media/dvb-frontends/dib8000.c            |  4 ++--
>  drivers/media/dvb-frontends/dib9000.c            |  6 ++++--
>  drivers/media/dvb-frontends/dvb-pll.c            |  2 +-
>  drivers/media/dvb-frontends/m88ds3103.c          |  2 +-
>  drivers/media/pci/bt8xx/dst.c                    |  3 ++-
>  drivers/media/pci/mantis/mantis_i2c.c            |  2 +-
>  drivers/media/pci/saa7134/saa7134-go7007.c       |  2 +-
>  drivers/media/platform/am437x/am437x-vpfe.c      |  2 +-
>  drivers/media/platform/davinci/vpfe_capture.c    |  2 +-
>  drivers/media/platform/davinci/vpif_capture.c    |  2 +-
>  drivers/media/platform/davinci/vpif_display.c    |  3 +--
>  drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
>  drivers/media/platform/exynos4-is/fimc-m2m.c     |  2 +-
>  drivers/media/platform/mtk-vpu/mtk_vpu.c         |  2 +-
>  drivers/media/platform/mx2_emmaprp.c             |  4 ++--
>  drivers/media/platform/s5p-g2d/g2d.c             |  6 +++---
>  drivers/media/platform/ti-vpe/vpe.c              |  6 +++---
>  drivers/media/platform/vicodec/vicodec-core.c    |  4 ++--
>  drivers/media/platform/vim2m.c                   |  4 ++--
>  drivers/media/radio/si4713/si4713.c              |  2 +-
>  drivers/media/usb/go7007/go7007-usb.c            | 16 ++++++++--------
>  drivers/media/usb/go7007/go7007-v4l2.c           |  2 +-
>  drivers/media/usb/hdpvr/hdpvr-video.c            |  9 +++------
>  drivers/media/usb/pulse8-cec/pulse8-cec.c        |  4 ++--
>  drivers/media/usb/pvrusb2/pvrusb2-hdw.c          |  2 +-
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c         |  4 ++--
>  drivers/staging/media/bcm2048/radio-bcm2048.c    |  4 ++--
>  drivers/staging/media/imx/imx-ic-common.c        |  2 +-
>  drivers/staging/media/imx/imx-media-vdic.c       |  2 +-
>  drivers/staging/media/zoran/zoran_driver.c       | 10 +++++-----
>  32 files changed, 61 insertions(+), 61 deletions(-)
> 

<snip>

> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index ea3ddd5a42bd..6f094dea6bc2 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1759,7 +1759,7 @@ static int vpfe_probe(struct platform_device *pdev)
>  
>  	mutex_lock(&ccdc_lock);
>  
> -	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
> +	strscpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);

32 -> sizeof(ccdc_cfg->name)

>  	/* Get VINT0 irq resource */
>  	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>  	if (!res1) {
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 62bced38db10..b246af6cc21f 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1254,7 +1254,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
>  	} else {
>  		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
>  	}
> -	strncpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);
> +	strscpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);

VPIF_MAX_NAME -> sizeof(std_info->name)

>  	std_info->width = bt->width;
>  	std_info->height = bt->height;
>  	std_info->frm_fmt = bt->interlaced ? 0 : 1;
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 78eba66f4b2b..65f51ebef6b4 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -987,8 +987,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
>  	} else {
>  		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
>  	}
> -	strncpy(std_info->name, "Custom timings BT656/1120",
> -			VPIF_MAX_NAME);
> +	strscpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);

Ditto.

>  	std_info->width = bt->width;
>  	std_info->height = bt->height;
>  	std_info->frm_fmt = bt->interlaced ? 0 : 1;

<snip>

> diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> index f8d35e3ac1dc..9f4bca037b59 100644
> --- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
> +++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> @@ -615,7 +615,7 @@ static void vpu_init_ipi_handler(void *data, unsigned int len, void *priv)
>  	struct vpu_run *run = (struct vpu_run *)data;
>  
>  	vpu->run.signaled = run->signaled;
> -	strncpy(vpu->run.fw_ver, run->fw_ver, VPU_FW_VER_LEN);
> +	strscpy(vpu->run.fw_ver, run->fw_ver, VPU_FW_VER_LEN);

VPU_FW_VER_LEN -> sizeof(vpu->run.fw_ver)

>  	vpu->run.dec_capability = run->dec_capability;
>  	vpu->run.enc_capability = run->enc_capability;
>  	wake_up_interruptible(&vpu->run.wq);

<snip>

> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
> index f4a53f1e856e..289bbed255cb 100644
> --- a/drivers/media/radio/si4713/si4713.c
> +++ b/drivers/media/radio/si4713/si4713.c
> @@ -1272,7 +1272,7 @@ static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
>  	if (vm->index > 0)
>  		return -EINVAL;
>  
> -	strncpy(vm->name, "FM Modulator", 32);
> +	strscpy(vm->name, "FM Modulator", 32);

32 -> sizeof(vm->name)

>  	vm->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW |
>  		V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_CONTROLS;
>  

<snip>

> diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
> index e082086428a4..034983c11532 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-video.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-video.c
> @@ -769,8 +769,7 @@ static int vidioc_enum_input(struct file *file, void *_fh, struct v4l2_input *i)
>  
>  	i->type = V4L2_INPUT_TYPE_CAMERA;
>  
> -	strncpy(i->name, iname[n], sizeof(i->name) - 1);
> -	i->name[sizeof(i->name) - 1] = '\0';
> +	strscpy(i->name, iname[n], sizeof(i->name));
>  
>  	i->audioset = 1<<HDPVR_RCA_FRONT | 1<<HDPVR_RCA_BACK | 1<<HDPVR_SPDIF;
>  
> @@ -841,8 +840,7 @@ static int vidioc_enumaudio(struct file *file, void *priv,
>  
>  	audio->capability = V4L2_AUDCAP_STEREO;
>  
> -	strncpy(audio->name, audio_iname[n], sizeof(audio->name) - 1);
> -	audio->name[sizeof(audio->name) - 1] = '\0';
> +	strscpy(audio->name, audio_iname[n], sizeof(audio->name));
>  
>  	return 0;
>  }
> @@ -874,7 +872,6 @@ static int vidioc_g_audio(struct file *file, void *private_data,
>  	audio->index = dev->options.audio_input;
>  	audio->capability = V4L2_AUDCAP_STEREO;
>  	strscpy(audio->name, audio_iname[audio->index], sizeof(audio->name));
> -	audio->name[sizeof(audio->name) - 1] = '\0';
>  	return 0;
>  }
>  
> @@ -991,7 +988,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
>  		return -EINVAL;
>  
>  	f->flags = V4L2_FMT_FLAG_COMPRESSED;
> -	strncpy(f->description, "MPEG2-TS with AVC/AAC streams", 32);
> +	strscpy(f->description, "MPEG2-TS with AVC/AAC streams", 32);

32 -> sizeof(f->description)

>  	f->pixelformat = V4L2_PIX_FMT_MPEG;
>  
>  	return 0;
> diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
> index 365c78b748dd..7f961fb23dc6 100644
> --- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
> +++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
> @@ -435,7 +435,7 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
>  	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 0);
>  	if (err)
>  		return err;
> -	strncpy(log_addrs->osd_name, data, 13);
> +	strscpy(log_addrs->osd_name, data, 13);

13 -> sizeof(log_addrs->osd_name)

>  	dev_dbg(pulse8->dev, "OSD name: %s\n", log_addrs->osd_name);
>  
>  	return 0;
> @@ -566,7 +566,7 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
>  		char *osd_str = cmd + 1;
>  
>  		cmd[0] = MSGCODE_SET_OSD_NAME;
> -		strncpy(cmd + 1, adap->log_addrs.osd_name, 13);
> +		strscpy(cmd + 1, adap->log_addrs.osd_name, 13);

13 -> sizeof(cmd) - 1

>  		if (osd_len < 4) {
>  			memset(osd_str + osd_len, ' ', 4 - osd_len);
>  			osd_len = 4;


> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> index a8519da0020b..2b5b8de5982b 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> @@ -2459,7 +2459,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
>  		if (!(qctrl.flags & V4L2_CTRL_FLAG_READ_ONLY)) {
>  			ciptr->set_value = ctrl_cx2341x_set;
>  		}
> -		strncpy(hdw->mpeg_ctrl_info[idx].desc,qctrl.name,
> +		strscpy(hdw->mpeg_ctrl_info[idx].desc, qctrl.name,
>  			PVR2_CTLD_INFO_DESC_SIZE);

PVR2_CTLD_INFO_DESC_SIZE -> sizeof(hdw->mpeg_ctrl_info[idx].desc)

>  		hdw->mpeg_ctrl_info[idx].desc[PVR2_CTLD_INFO_DESC_SIZE-1] = 0;
>  		ciptr->default_value = qctrl.default_value;
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> index cea232a3302d..666e7b89e182 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -284,7 +284,7 @@ static int pvr2_enumaudio(struct file *file, void *priv, struct v4l2_audio *vin)
>  
>  	if (vin->index > 0)
>  		return -EINVAL;
> -	strncpy(vin->name, "PVRUSB2 Audio", 14);
> +	strscpy(vin->name, "PVRUSB2 Audio", 14);

14 -> sizeof(vin->name)

>  	vin->capability = V4L2_AUDCAP_STEREO;
>  	return 0;
>  }
> @@ -293,7 +293,7 @@ static int pvr2_g_audio(struct file *file, void *priv, struct v4l2_audio *vin)
>  {
>  	/* pkt: FIXME: see above comment (VIDIOC_ENUMAUDIO) */
>  	vin->index = 0;
> -	strncpy(vin->name, "PVRUSB2 Audio", 14);
> +	strscpy(vin->name, "PVRUSB2 Audio", 14);

Ditto

>  	vin->capability = V4L2_AUDCAP_STEREO;
>  	return 0;
>  }
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 874d290f9622..1debfbad89ee 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2403,7 +2403,7 @@ static int bcm2048_vidioc_g_audio(struct file *file, void *priv,
>  	if (audio->index > 1)
>  		return -EINVAL;
>  
> -	strncpy(audio->name, "Radio", 32);
> +	strscpy(audio->name, "Radio", 32);

32 -> sizeof(audio->name)

>  	audio->capability = V4L2_AUDCAP_STEREO;
>  
>  	return 0;
> @@ -2431,7 +2431,7 @@ static int bcm2048_vidioc_g_tuner(struct file *file, void *priv,
>  	if (tuner->index > 0)
>  		return -EINVAL;
>  
> -	strncpy(tuner->name, "FM Receiver", 32);
> +	strscpy(tuner->name, "FM Receiver", 32);

32 -> sizeof(tuner->name)

>  	tuner->type = V4L2_TUNER_RADIO;
>  	tuner->rangelow =
>  		dev_to_v4l2(bcm2048_get_region_bottom_frequency(bdev));

<snip>

Basically using constants instead of sizeof() as the strscpy argument defeats the
purpose of strscpy, so that needs to be fixed.

The 'strcpy' patch uses sizeof everywhere, but I saw a few other occurrences of
this in the strlcpy patch. I think the strlcpy patch needs a follow-up that
replaces any hardcoded sizes with the safer sizeof().

BTW, I really like this strncpy patch: in many cases strncpy was unsafe. Good to
fix this.

Regards,

	Hans
