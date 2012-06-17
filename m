Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4254 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab2FQMIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jun 2012 08:08:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Daniel =?utf-8?q?Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: Re: [PATCH] tvaudio: rename getmode and setmode
Date: Sun, 17 Jun 2012 14:08:10 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <201206100828.00951.hverkuil@xs4all.nl> <1339934022-32651-1-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <1339934022-32651-1-git-send-email-daniel-gl@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206171408.10350.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun June 17 2012 13:53:42 Daniel Glöckner wrote:
> This is basically s/getmode/getrxsubchans/ and s/setmode/setaudmode/
> with some whitespace adjustment in affected lines to please the eye.
> The rename is done to point out their relation to the rxsubchans and
> audmode fields of struct v4l2_tuner.
> 
> I also corrected a commented out call to v4l_dbg in one of the lines.

Looks much better!

For the whole patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

You could even make it a little bit better by removing all typedefs
(they are totally bogus) and lower case those ugly uppercase struct
names (CHIPSTATE, AUDIOCMD and CHIPDESC).

Regards,

	Hans

> 
> Signed-off-by: Daniel Glöckner <daniel-gl@gmx.net>
> ---
>  drivers/media/video/tvaudio.c |  108 +++++++++++++++++++++++------------------
>  1 files changed, 60 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
> index 1e61cbf..321b315 100644
> --- a/drivers/media/video/tvaudio.c
> +++ b/drivers/media/video/tvaudio.c
> @@ -59,8 +59,8 @@ struct CHIPSTATE;
>  typedef int  (*getvalue)(int);
>  typedef int  (*checkit)(struct CHIPSTATE*);
>  typedef int  (*initialize)(struct CHIPSTATE*);
> -typedef int  (*getmode)(struct CHIPSTATE*);
> -typedef void (*setmode)(struct CHIPSTATE*, int mode);
> +typedef int  (*getrxsubchans)(struct CHIPSTATE *);
> +typedef void (*setaudmode)(struct CHIPSTATE*, int mode);
>  
>  /* i2c command */
>  typedef struct AUDIOCMD {
> @@ -96,8 +96,8 @@ struct CHIPDESC {
>  	getvalue volfunc,treblefunc,bassfunc;
>  
>  	/* get/set mode */
> -	getmode  getmode;
> -	setmode  setmode;
> +	getrxsubchans	getrxsubchans;
> +	setaudmode	setaudmode;
>  
>  	/* input switch register + values for v4l inputs */
>  	int  inputreg;
> @@ -306,7 +306,7 @@ static int chip_thread(void *data)
>  			continue;
>  
>  		/* have a look what's going on */
> -		mode = desc->getmode(chip);
> +		mode = desc->getrxsubchans(chip);
>  		if (mode == chip->prevmode)
>  			continue;
>  
> @@ -340,7 +340,7 @@ static int chip_thread(void *data)
>  			else if (mode & V4L2_TUNER_SUB_STEREO)
>  				selected = V4L2_TUNER_MODE_STEREO;
>  		}
> -		desc->setmode(chip, selected);
> +		desc->setaudmode(chip, selected);
>  
>  		/* schedule next check */
>  		mod_timer(&chip->wt, jiffies+msecs_to_jiffies(2000));
> @@ -373,7 +373,7 @@ static int chip_thread(void *data)
>  #define TDA9840_TEST_INT1SN 0x1 /* Integration time 0.5s when set */
>  #define TDA9840_TEST_INTFU 0x02 /* Disables integrator function */
>  
> -static int tda9840_getmode(struct CHIPSTATE *chip)
> +static int tda9840_getrxsubchans(struct CHIPSTATE *chip)
>  {
>  	struct v4l2_subdev *sd = &chip->sd;
>  	int val, mode;
> @@ -385,12 +385,13 @@ static int tda9840_getmode(struct CHIPSTATE *chip)
>  	if (val & TDA9840_ST_STEREO)
>  		mode = V4L2_TUNER_SUB_STEREO;
>  
> -	v4l2_dbg(1, debug, sd, "tda9840_getmode(): raw chip read: %d, return: %d\n",
> +	v4l2_dbg(1, debug, sd,
> +		"tda9840_getrxsubchans(): raw chip read: %d, return: %d\n",
>  		val, mode);
>  	return mode;
>  }
>  
> -static void tda9840_setmode(struct CHIPSTATE *chip, int mode)
> +static void tda9840_setaudmode(struct CHIPSTATE *chip, int mode)
>  {
>  	int update = 1;
>  	int t = chip->shadow.bytes[TDA9840_SW + 1] & ~0x7e;
> @@ -532,7 +533,7 @@ static int tda9855_volume(int val) { return val/0x2e8+0x27; }
>  static int tda9855_bass(int val)   { return val/0xccc+0x06; }
>  static int tda9855_treble(int val) { return (val/0x1c71+0x3)<<1; }
>  
> -static int  tda985x_getmode(struct CHIPSTATE *chip)
> +static int  tda985x_getrxsubchans(struct CHIPSTATE *chip)
>  {
>  	int mode, val;
>  
> @@ -547,7 +548,7 @@ static int  tda985x_getmode(struct CHIPSTATE *chip)
>  	return mode;
>  }
>  
> -static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
> +static void tda985x_setaudmode(struct CHIPSTATE *chip, int mode)
>  {
>  	int update = 1;
>  	int c6 = chip->shadow.bytes[TDA985x_C6+1] & 0x3f;
> @@ -692,7 +693,7 @@ static void tda985x_setmode(struct CHIPSTATE *chip, int mode)
>  #define TDA9873_STEREO      2 /* Stereo sound is identified     */
>  #define TDA9873_DUAL        4 /* Dual sound is identified       */
>  
> -static int tda9873_getmode(struct CHIPSTATE *chip)
> +static int tda9873_getrxsubchans(struct CHIPSTATE *chip)
>  {
>  	struct v4l2_subdev *sd = &chip->sd;
>  	int val,mode;
> @@ -703,24 +704,29 @@ static int tda9873_getmode(struct CHIPSTATE *chip)
>  		mode = V4L2_TUNER_SUB_STEREO;
>  	if (val & TDA9873_DUAL)
>  		mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
> -	v4l2_dbg(1, debug, sd, "tda9873_getmode(): raw chip read: %d, return: %d\n",
> +	v4l2_dbg(1, debug, sd,
> +		"tda9873_getrxsubchans(): raw chip read: %d, return: %d\n",
>  		val, mode);
>  	return mode;
>  }
>  
> -static void tda9873_setmode(struct CHIPSTATE *chip, int mode)
> +static void tda9873_setaudmode(struct CHIPSTATE *chip, int mode)
>  {
>  	struct v4l2_subdev *sd = &chip->sd;
>  	int sw_data  = chip->shadow.bytes[TDA9873_SW+1] & ~ TDA9873_TR_MASK;
>  	/*	int adj_data = chip->shadow.bytes[TDA9873_AD+1] ; */
>  
>  	if ((sw_data & TDA9873_INP_MASK) != TDA9873_INTERNAL) {
> -		v4l2_dbg(1, debug, sd, "tda9873_setmode(): external input\n");
> +		v4l2_dbg(1, debug, sd,
> +			 "tda9873_setaudmode(): external input\n");
>  		return;
>  	}
>  
> -	v4l2_dbg(1, debug, sd, "tda9873_setmode(): chip->shadow.bytes[%d] = %d\n", TDA9873_SW+1, chip->shadow.bytes[TDA9873_SW+1]);
> -	v4l2_dbg(1, debug, sd, "tda9873_setmode(): sw_data  = %d\n", sw_data);
> +	v4l2_dbg(1, debug, sd,
> +		 "tda9873_setaudmode(): chip->shadow.bytes[%d] = %d\n",
> +		 TDA9873_SW+1, chip->shadow.bytes[TDA9873_SW+1]);
> +	v4l2_dbg(1, debug, sd, "tda9873_setaudmode(): sw_data  = %d\n",
> +		 sw_data);
>  
>  	switch (mode) {
>  	case V4L2_TUNER_MODE_MONO:
> @@ -743,7 +749,8 @@ static void tda9873_setmode(struct CHIPSTATE *chip, int mode)
>  	}
>  
>  	chip_write(chip, TDA9873_SW, sw_data);
> -	v4l2_dbg(1, debug, sd, "tda9873_setmode(): req. mode %d; chip_write: %d\n",
> +	v4l2_dbg(1, debug, sd,
> +		"tda9873_setaudmode(): req. mode %d; chip_write: %d\n",
>  		mode, sw_data);
>  }
>  
> @@ -889,7 +896,7 @@ static int tda9874a_setup(struct CHIPSTATE *chip)
>  	return 1;
>  }
>  
> -static int tda9874a_getmode(struct CHIPSTATE *chip)
> +static int tda9874a_getrxsubchans(struct CHIPSTATE *chip)
>  {
>  	struct v4l2_subdev *sd = &chip->sd;
>  	int dsr,nsr,mode;
> @@ -928,12 +935,13 @@ static int tda9874a_getmode(struct CHIPSTATE *chip)
>  			mode |= V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
>  	}
>  
> -	v4l2_dbg(1, debug, sd, "tda9874a_getmode(): DSR=0x%X, NSR=0x%X, NECR=0x%X, return: %d.\n",
> +	v4l2_dbg(1, debug, sd,
> +		 "tda9874a_getrxsubchans(): DSR=0x%X, NSR=0x%X, NECR=0x%X, return: %d.\n",
>  		 dsr, nsr, necr, mode);
>  	return mode;
>  }
>  
> -static void tda9874a_setmode(struct CHIPSTATE *chip, int mode)
> +static void tda9874a_setaudmode(struct CHIPSTATE *chip, int mode)
>  {
>  	struct v4l2_subdev *sd = &chip->sd;
>  
> @@ -979,7 +987,8 @@ static void tda9874a_setmode(struct CHIPSTATE *chip, int mode)
>  		chip_write(chip, TDA9874A_AOSR, aosr);
>  		chip_write(chip, TDA9874A_MDACOSR, mdacosr);
>  
> -		v4l2_dbg(1, debug, sd, "tda9874a_setmode(): req. mode %d; AOSR=0x%X, MDACOSR=0x%X.\n",
> +		v4l2_dbg(1, debug, sd,
> +			"tda9874a_setaudmode(): req. mode %d; AOSR=0x%X, MDACOSR=0x%X.\n",
>  			mode, aosr, mdacosr);
>  
>  	} else { /* dic == 0x07 */
> @@ -1017,7 +1026,8 @@ static void tda9874a_setmode(struct CHIPSTATE *chip, int mode)
>  		chip_write(chip, TDA9874A_FMMR, fmmr);
>  		chip_write(chip, TDA9874A_AOSR, aosr);
>  
> -		v4l2_dbg(1, debug, sd, "tda9874a_setmode(): req. mode %d; FMMR=0x%X, AOSR=0x%X.\n",
> +		v4l2_dbg(1, debug, sd,
> +			"tda9874a_setaudmode(): req. mode %d; FMMR=0x%X, AOSR=0x%X.\n",
>  			mode, fmmr, aosr);
>  	}
>  }
> @@ -1262,7 +1272,7 @@ static int tea6320_initialize(struct CHIPSTATE * chip)
>  static int tda8425_shift10(int val) { return (val >> 10) | 0xc0; }
>  static int tda8425_shift12(int val) { return (val >> 12) | 0xf0; }
>  
> -static void tda8425_setmode(struct CHIPSTATE *chip, int mode)
> +static void tda8425_setaudmode(struct CHIPSTATE *chip, int mode)
>  {
>  	int s1 = chip->shadow.bytes[TDA8425_S1+1] & 0xe1;
>  
> @@ -1341,7 +1351,7 @@ static void tda8425_setmode(struct CHIPSTATE *chip, int mode)
>   * stereo  L  L
>   * BIL     H  L
>   */
> -static int ta8874z_getmode(struct CHIPSTATE *chip)
> +static int ta8874z_getrxsubchans(struct CHIPSTATE *chip)
>  {
>  	int val, mode;
>  
> @@ -1352,7 +1362,9 @@ static int ta8874z_getmode(struct CHIPSTATE *chip)
>  	}else if (!(val & TA8874Z_B0)){
>  		mode = V4L2_TUNER_SUB_STEREO;
>  	}
> -	/* v4l_dbg(1, debug, chip->c, "ta8874z_getmode(): raw chip read: 0x%02x, return: 0x%02x\n", val, mode); */
> +	/* v4l2_dbg(1, debug, &chip->sd,
> +		 "ta8874z_getrxsubchans(): raw chip read: 0x%02x, return: 0x%02x\n",
> +		 val, mode); */
>  	return mode;
>  }
>  
> @@ -1362,13 +1374,13 @@ static audiocmd ta8874z_main = {2, { 0, TA8874Z_SEPARATION_DEFAULT}};
>  static audiocmd ta8874z_sub = {2, { TA8874Z_MODE_SUB, TA8874Z_SEPARATION_DEFAULT}};
>  static audiocmd ta8874z_both = {2, { TA8874Z_MODE_MAIN | TA8874Z_MODE_SUB, TA8874Z_SEPARATION_DEFAULT}};
>  
> -static void ta8874z_setmode(struct CHIPSTATE *chip, int mode)
> +static void ta8874z_setaudmode(struct CHIPSTATE *chip, int mode)
>  {
>  	struct v4l2_subdev *sd = &chip->sd;
>  	int update = 1;
>  	audiocmd *t = NULL;
>  
> -	v4l2_dbg(1, debug, sd, "ta8874z_setmode(): mode: 0x%02x\n", mode);
> +	v4l2_dbg(1, debug, sd, "ta8874z_setaudmode(): mode: 0x%02x\n", mode);
>  
>  	switch(mode){
>  	case V4L2_TUNER_MODE_MONO:
> @@ -1442,8 +1454,8 @@ static struct CHIPDESC chiplist[] = {
>  
>  		/* callbacks */
>  		.checkit    = tda9840_checkit,
> -		.getmode    = tda9840_getmode,
> -		.setmode    = tda9840_setmode,
> +		.getrxsubchans = tda9840_getrxsubchans,
> +		.setaudmode = tda9840_setaudmode,
>  
>  		.init       = { 2, { TDA9840_TEST, TDA9840_TEST_INT1SN
>  				/* ,TDA9840_SW, TDA9840_MONO */} }
> @@ -1458,8 +1470,8 @@ static struct CHIPDESC chiplist[] = {
>  
>  		/* callbacks */
>  		.checkit    = tda9873_checkit,
> -		.getmode    = tda9873_getmode,
> -		.setmode    = tda9873_setmode,
> +		.getrxsubchans = tda9873_getrxsubchans,
> +		.setaudmode = tda9873_setaudmode,
>  
>  		.init       = { 4, { TDA9873_SW, 0xa4, 0x06, 0x03 } },
>  		.inputreg   = TDA9873_SW,
> @@ -1478,8 +1490,8 @@ static struct CHIPDESC chiplist[] = {
>  		/* callbacks */
>  		.initialize = tda9874a_initialize,
>  		.checkit    = tda9874a_checkit,
> -		.getmode    = tda9874a_getmode,
> -		.setmode    = tda9874a_setmode,
> +		.getrxsubchans = tda9874a_getrxsubchans,
> +		.setaudmode = tda9874a_setaudmode,
>  	},
>  	{
>  		.name       = "tda9875",
> @@ -1508,8 +1520,8 @@ static struct CHIPDESC chiplist[] = {
>  		.addr_hi    = I2C_ADDR_TDA985x_H >> 1,
>  		.registers  = 11,
>  
> -		.getmode    = tda985x_getmode,
> -		.setmode    = tda985x_setmode,
> +		.getrxsubchans = tda985x_getrxsubchans,
> +		.setaudmode = tda985x_setaudmode,
>  
>  		.init       = { 8, { TDA9850_C4, 0x08, 0x08, TDA985x_STEREO, 0x07, 0x10, 0x10, 0x03 } }
>  	},
> @@ -1530,8 +1542,8 @@ static struct CHIPDESC chiplist[] = {
>  		.volfunc    = tda9855_volume,
>  		.bassfunc   = tda9855_bass,
>  		.treblefunc = tda9855_treble,
> -		.getmode    = tda985x_getmode,
> -		.setmode    = tda985x_setmode,
> +		.getrxsubchans = tda985x_getrxsubchans,
> +		.setaudmode = tda985x_setaudmode,
>  
>  		.init       = { 12, { 0, 0x6f, 0x6f, 0x0e, 0x07<<1, 0x8<<2,
>  				    TDA9855_MUTE | TDA9855_AVL | TDA9855_LOUD | TDA9855_INT,
> @@ -1612,7 +1624,7 @@ static struct CHIPDESC chiplist[] = {
>  		.volfunc    = tda8425_shift10,
>  		.bassfunc   = tda8425_shift12,
>  		.treblefunc = tda8425_shift12,
> -		.setmode    = tda8425_setmode,
> +		.setaudmode = tda8425_setaudmode,
>  
>  		.inputreg   = TDA8425_S1,
>  		.inputmap   = { TDA8425_S1_CH1, TDA8425_S1_CH1, TDA8425_S1_CH1 },
> @@ -1643,8 +1655,8 @@ static struct CHIPDESC chiplist[] = {
>  		.registers  = 2,
>  
>  		/* callbacks */
> -		.getmode    = ta8874z_getmode,
> -		.setmode    = ta8874z_setmode,
> +		.getrxsubchans = ta8874z_getrxsubchans,
> +		.setaudmode = ta8874z_setaudmode,
>  
>  		.init       = {2, { TA8874Z_MONO_SET, TA8874Z_SEPARATION_DEFAULT}},
>  	},
> @@ -1840,7 +1852,7 @@ static int tvaudio_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	struct CHIPSTATE *chip = to_state(sd);
>  	struct CHIPDESC *desc = chip->desc;
>  
> -	if (!desc->setmode)
> +	if (!desc->setaudmode)
>  		return 0;
>  	if (chip->radio)
>  		return 0;
> @@ -1860,7 +1872,7 @@ static int tvaudio_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	if (chip->thread)
>  		wake_up_process(chip->thread);
>  	else
> -		desc->setmode(chip, vt->audmode);
> +		desc->setaudmode(chip, vt->audmode);
>  
>  	return 0;
>  }
> @@ -1870,13 +1882,13 @@ static int tvaudio_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	struct CHIPSTATE *chip = to_state(sd);
>  	struct CHIPDESC *desc = chip->desc;
>  
> -	if (!desc->getmode)
> +	if (!desc->getrxsubchans)
>  		return 0;
>  	if (chip->radio)
>  		return 0;
>  
>  	vt->audmode = chip->audmode;
> -	vt->rxsubchans = desc->getmode(chip);
> +	vt->rxsubchans = desc->getrxsubchans(chip);
>  	vt->capability = V4L2_TUNER_CAP_STEREO |
>  		V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2;
>  
> @@ -1896,7 +1908,7 @@ static int tvaudio_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *fr
>  	struct CHIPSTATE *chip = to_state(sd);
>  	struct CHIPDESC *desc = chip->desc;
>  
> -	/* For chips that provide getmode and setmode, and doesn't
> +	/* For chips that provide getrxsubchans and setaudmode, and doesn't
>  	   automatically follows the stereo carrier, a kthread is
>  	   created to set the audio standard. In this case, when then
>  	   the video channel is changed, tvaudio starts on MONO mode.
> @@ -1905,7 +1917,7 @@ static int tvaudio_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *fr
>  	   audio carrier.
>  	 */
>  	if (chip->thread) {
> -		desc->setmode(chip, V4L2_TUNER_MODE_MONO);
> +		desc->setaudmode(chip, V4L2_TUNER_MODE_MONO);
>  		chip->prevmode = -1; /* reset previous mode */
>  		mod_timer(&chip->wt, jiffies+msecs_to_jiffies(2000));
>  	}
> @@ -2048,7 +2060,7 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
>  	chip->thread = NULL;
>  	init_timer(&chip->wt);
>  	if (desc->flags & CHIP_NEED_CHECKMODE) {
> -		if (!desc->getmode || !desc->setmode) {
> +		if (!desc->getrxsubchans || !desc->setaudmode) {
>  			/* This shouldn't be happen. Warn user, but keep working
>  			   without kthread
>  			 */
> 
