Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10597 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3LIPvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 10:51:51 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXJ00CCZQQEDD90@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Dec 2013 10:51:51 -0500 (EST)
Date: Mon, 09 Dec 2013 13:51:44 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Dinesh.Ram@cern.ch,
	edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 11/11] si4713: coding style cleanups
Message-id: <20131209135144.17aa47f6@samsung.com>
In-reply-to: <1386325034-19344-12-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
 <1386325034-19344-12-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  6 Dec 2013 11:17:14 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Fix most checkpatch errors/warnings.
> 
> It's mostly whitespace changes, except for replacing msleep with
> usleep_range and the jiffies comparison with time_is_after_jiffies().
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/radio/si4713/radio-usb-si4713.c |   4 +-
>  drivers/media/radio/si4713/si4713.c           | 104 +++++++++++++-------------
>  2 files changed, 55 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
> index d978844..691e487 100644
> --- a/drivers/media/radio/si4713/radio-usb-si4713.c
> +++ b/drivers/media/radio/si4713/radio-usb-si4713.c
> @@ -207,7 +207,7 @@ static int si4713_send_startup_command(struct si4713_usb_device *radio)
>  		}
>  		if (time_is_before_jiffies(until_jiffies))
>  			return -EIO;
> -		msleep(3);
> +		usleep_range(3000, 5000);
>  	}
>  
>  	return retval;
> @@ -354,7 +354,7 @@ static int si4713_i2c_read(struct si4713_usb_device *radio, char *data, int len)
>  			data[0] = 0;
>  			return 0;
>  		}
> -		msleep(3);
> +		usleep_range(3000, 5000);
>  	}
>  }
>  
> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
> index 6f28a2b..451b9c0 100644
> --- a/drivers/media/radio/si4713/si4713.c
> +++ b/drivers/media/radio/si4713/si4713.c
> @@ -50,12 +50,12 @@ MODULE_VERSION("0.0.1");
>  #define DEFAULT_RDS_PS_REPEAT_COUNT	0x0003
>  #define DEFAULT_LIMITER_RTIME		0x1392
>  #define DEFAULT_LIMITER_DEV		0x102CA
> -#define DEFAULT_PILOT_FREQUENCY 	0x4A38
> +#define DEFAULT_PILOT_FREQUENCY		0x4A38
>  #define DEFAULT_PILOT_DEVIATION		0x1A5E
>  #define DEFAULT_ACOMP_ATIME		0x0000
>  #define DEFAULT_ACOMP_RTIME		0xF4240L
>  #define DEFAULT_ACOMP_GAIN		0x0F
> -#define DEFAULT_ACOMP_THRESHOLD 	(-0x28)
> +#define DEFAULT_ACOMP_THRESHOLD		(-0x28)
>  #define DEFAULT_MUTE			0x01
>  #define DEFAULT_POWER_LEVEL		88
>  #define DEFAULT_FREQUENCY		8800
> @@ -252,8 +252,8 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>  
>  		if (client->irq)
>  			return -EBUSY;
> -		msleep(1);
> -	} while (jiffies <= until_jiffies);
> +		usleep_range(1000, 2000);
> +	} while (time_is_after_jiffies(until_jiffies));

Condition seems to be wrong here: it should be time_is_before_jiffies().

Also, the better is to put this on a separate patch.

>  
>  	return -EBUSY;
>  }
> @@ -269,9 +269,9 @@ static int si4713_read_property(struct si4713_device *sdev, u16 prop, u32 *pv)
>  	int err;
>  	u8 val[SI4713_GET_PROP_NRESP];
>  	/*
> -	 * 	.First byte = 0
> -	 * 	.Second byte = property's MSB
> -	 * 	.Third byte = property's LSB
> +	 *	.First byte = 0
> +	 *	.Second byte = property's MSB
> +	 *	.Third byte = property's LSB
>  	 */
>  	const u8 args[SI4713_GET_PROP_NARGS] = {
>  		0x00,
> @@ -306,11 +306,11 @@ static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
>  	int rval;
>  	u8 resp[SI4713_SET_PROP_NRESP];
>  	/*
> -	 * 	.First byte = 0
> -	 * 	.Second byte = property's MSB
> -	 * 	.Third byte = property's LSB
> -	 * 	.Fourth byte = value's MSB
> -	 * 	.Fifth byte = value's LSB
> +	 *	.First byte = 0
> +	 *	.Second byte = property's MSB
> +	 *	.Third byte = property's LSB
> +	 *	.Fourth byte = value's MSB
> +	 *	.Fifth byte = value's LSB
>  	 */
>  	const u8 args[SI4713_SET_PROP_NARGS] = {
>  		0x00,
> @@ -352,8 +352,8 @@ static int si4713_powerup(struct si4713_device *sdev)
>  	int err;
>  	u8 resp[SI4713_PWUP_NRESP];
>  	/*
> -	 * 	.First byte = Enabled interrupts and boot function
> -	 * 	.Second byte = Input operation mode
> +	 *	.First byte = Enabled interrupts and boot function
> +	 *	.Second byte = Input operation mode
>  	 */
>  	u8 args[SI4713_PWUP_NARGS] = {
>  		SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
> @@ -505,18 +505,18 @@ static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
>  		}
>  		if (jiffies_to_usecs(jiffies - start_jiffies) > usecs)
>  			return err < 0 ? err : -EIO;
> -		/* We sleep here for 3 ms in order to avoid flooding the device
> +		/* We sleep here for 3-4 ms in order to avoid flooding the device
>  		 * with USB requests. The si4713 USB driver was developed
>  		 * by reverse engineering the Windows USB driver. The windows
>  		 * driver also has a ~2.5 ms delay between responses. */
> -		msleep(3);
> +		usleep_range(3000, 4000);
>  	}
>  }
>  
>  /*
>   * si4713_tx_tune_freq - Sets the state of the RF carrier and sets the tuning
> - * 			frequency between 76 and 108 MHz in 10 kHz units and
> - * 			steps of 50 kHz.
> + *			frequency between 76 and 108 MHz in 10 kHz units and
> + *			steps of 50 kHz.
>   * @sdev: si4713_device structure for the device we are communicating
>   * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
>   */
> @@ -525,9 +525,9 @@ static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
>  	int err;
>  	u8 val[SI4713_TXFREQ_NRESP];
>  	/*
> -	 * 	.First byte = 0
> -	 * 	.Second byte = frequency's MSB
> -	 * 	.Third byte = frequency's LSB
> +	 *	.First byte = 0
> +	 *	.Second byte = frequency's MSB
> +	 *	.Third byte = frequency's LSB
>  	 */
>  	const u8 args[SI4713_TXFREQ_NARGS] = {
>  		0x00,
> @@ -555,11 +555,11 @@ static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
>  
>  /*
>   * si4713_tx_tune_power - Sets the RF voltage level between 88 and 120 dBuV in
> - * 			1 dB units. A value of 0x00 indicates off. The command
> - * 			also sets the antenna tuning capacitance. A value of 0
> - * 			indicates autotuning, and a value of 1 - 191 indicates
> - * 			a manual override, which results in a tuning
> - * 			capacitance of 0.25 pF x @antcap.
> + *			1 dB units. A value of 0x00 indicates off. The command
> + *			also sets the antenna tuning capacitance. A value of 0
> + *			indicates autotuning, and a value of 1 - 191 indicates
> + *			a manual override, which results in a tuning
> + *			capacitance of 0.25 pF x @antcap.
>   * @sdev: si4713_device structure for the device we are communicating
>   * @power: tuning power (88 - 120 dBuV, unit/step 1 dB)
>   * @antcap: value of antenna tuning capacitor (0 - 191)
> @@ -570,10 +570,10 @@ static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
>  	int err;
>  	u8 val[SI4713_TXPWR_NRESP];
>  	/*
> -	 * 	.First byte = 0
> -	 * 	.Second byte = 0
> -	 * 	.Third byte = power
> -	 * 	.Fourth byte = antcap
> +	 *	.First byte = 0
> +	 *	.Second byte = 0
> +	 *	.Third byte = power
> +	 *	.Fourth byte = antcap
>  	 */
>  	u8 args[SI4713_TXPWR_NARGS] = {
>  		0x00,
> @@ -602,12 +602,12 @@ static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
>  
>  /*
>   * si4713_tx_tune_measure - Enters receive mode and measures the received noise
> - * 			level in units of dBuV on the selected frequency.
> - * 			The Frequency must be between 76 and 108 MHz in 10 kHz
> - * 			units and steps of 50 kHz. The command also sets the
> - * 			antenna	tuning capacitance. A value of 0 means
> - * 			autotuning, and a value of 1 to 191 indicates manual
> - * 			override.
> + *			level in units of dBuV on the selected frequency.
> + *			The Frequency must be between 76 and 108 MHz in 10 kHz
> + *			units and steps of 50 kHz. The command also sets the
> + *			antenna	tuning capacitance. A value of 0 means
> + *			autotuning, and a value of 1 to 191 indicates manual
> + *			override.
>   * @sdev: si4713_device structure for the device we are communicating
>   * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
>   * @antcap: value of antenna tuning capacitor (0 - 191)
> @@ -618,10 +618,10 @@ static int si4713_tx_tune_measure(struct si4713_device *sdev, u16 frequency,
>  	int err;
>  	u8 val[SI4713_TXMEA_NRESP];
>  	/*
> -	 * 	.First byte = 0
> -	 * 	.Second byte = frequency's MSB
> -	 * 	.Third byte = frequency's LSB
> -	 * 	.Fourth byte = antcap
> +	 *	.First byte = 0
> +	 *	.Second byte = frequency's MSB
> +	 *	.Third byte = frequency's LSB
> +	 *	.Fourth byte = antcap
>  	 */
>  	const u8 args[SI4713_TXMEA_NARGS] = {
>  		0x00,
> @@ -651,11 +651,11 @@ static int si4713_tx_tune_measure(struct si4713_device *sdev, u16 frequency,
>  
>  /*
>   * si4713_tx_tune_status- Returns the status of the tx_tune_freq, tx_tune_mea or
> - * 			tx_tune_power commands. This command return the current
> - * 			frequency, output voltage in dBuV, the antenna tunning
> - * 			capacitance value and the received noise level. The
> - * 			command also clears the stcint interrupt bit when the
> - * 			first bit of its arguments is high.
> + *			tx_tune_power commands. This command return the current
> + *			frequency, output voltage in dBuV, the antenna tunning
> + *			capacitance value and the received noise level. The
> + *			command also clears the stcint interrupt bit when the
> + *			first bit of its arguments is high.
>   * @sdev: si4713_device structure for the device we are communicating
>   * @intack: 0x01 to clear the seek/tune complete interrupt status indicator.
>   * @frequency: returned frequency
> @@ -670,7 +670,7 @@ static int si4713_tx_tune_status(struct si4713_device *sdev, u8 intack,
>  	int err;
>  	u8 val[SI4713_TXSTATUS_NRESP];
>  	/*
> -	 * 	.First byte = intack bit
> +	 *	.First byte = intack bit
>  	 */
>  	const u8 args[SI4713_TXSTATUS_NARGS] = {
>  		intack & SI4713_INTACK_MASK,
> @@ -1364,7 +1364,7 @@ static int si4713_probe(struct i2c_client *client,
>  	struct v4l2_ctrl_handler *hdl;
>  	int rval, i;
>  
> -	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
> +	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
>  	if (!sdev) {
>  		dev_err(&client->dev, "Failed to alloc video device.\n");
>  		rval = -ENOMEM;
> @@ -1440,8 +1440,8 @@ static int si4713_probe(struct i2c_client *client,
>  			V4L2_CID_AUDIO_COMPRESSION_GAIN, 0, MAX_ACOMP_GAIN, 1,
>  			DEFAULT_ACOMP_GAIN);
>  	sdev->compression_threshold = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> -			V4L2_CID_AUDIO_COMPRESSION_THRESHOLD, MIN_ACOMP_THRESHOLD,
> -			MAX_ACOMP_THRESHOLD, 1,
> +			V4L2_CID_AUDIO_COMPRESSION_THRESHOLD,
> +			MIN_ACOMP_THRESHOLD, MAX_ACOMP_THRESHOLD, 1,
>  			DEFAULT_ACOMP_THRESHOLD);
>  	sdev->compression_attack_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
>  			V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME, 0,
> @@ -1463,9 +1463,11 @@ static int si4713_probe(struct i2c_client *client,
>  			V4L2_CID_TUNE_PREEMPHASIS,
>  			V4L2_PREEMPHASIS_75_uS, 0, V4L2_PREEMPHASIS_50_uS);
>  	sdev->tune_pwr_level = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> -			V4L2_CID_TUNE_POWER_LEVEL, 0, SI4713_MAX_POWER, 1, DEFAULT_POWER_LEVEL);
> +			V4L2_CID_TUNE_POWER_LEVEL, 0, SI4713_MAX_POWER,
> +			1, DEFAULT_POWER_LEVEL);
>  	sdev->tune_ant_cap = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,
> -			V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, SI4713_MAX_ANTCAP, 1, 0);
> +			V4L2_CID_TUNE_ANTENNA_CAPACITOR, 0, SI4713_MAX_ANTCAP,
> +			1, 0);
>  
>  	if (hdl->error) {
>  		rval = hdl->error;


-- 

Cheers,
Mauro
