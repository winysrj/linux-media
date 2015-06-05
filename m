Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60938 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbbFELeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 07:34:13 -0400
Message-ID: <55718929.6080004@xs4all.nl>
Date: Fri, 05 Jun 2015 13:34:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxx <maxx@spaceboyz.net>
Subject: Re: [PATCH] radio-bcm2048: Enable access to automute and ctrl registers
References: <1431725511-7379-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1431725511-7379-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2015 11:31 PM, Pali Rohár wrote:
> From: maxx <maxx@spaceboyz.net>
> 
> This enables access to automute function of the chip via sysfs and
> gives direct access to FM_AUDIO_CTRL0/1 registers, also via sysfs. I
> don't think this is so important but helps in developing radio scanner
> apps.
> 
> Patch writen by maxx@spaceboyz.net
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Cc: maxx@spaceboyz.net

As Pavel mentioned, these patches need to be resend with correct Signed-off-by
lines.

Regarding this patch: I don't want to apply this since this really should be a
control. Or just enable it always. If someone wants to make this a control, then
let me know: there are two other drivers with an AUTOMUTE control: bttv and saa7134.

In both cases it is implemented as a private control, but it makes sense to
promote this to a standard user control. I can make a patch for that.

And for CTRL0/1: if you want direct register access, then implement
VIDIOC_DBG_G/S_REGISTER. This makes sure you have the right permissions etc.

More importantly: is anyone working on getting this driver out of staging? It's
been here for about a year and a half and I haven't seen any efforts to clean it up.

The whole sysfs part is out-of-spec and is another reason why I won't apply this
patch as is. Adding code to things that should go away isn't good...

So:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c |   96 +++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 1482d4b..8f9ba7b 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -826,6 +826,93 @@ static int bcm2048_get_mute(struct bcm2048_device *bdev)
>  	return err;
>  }
>  
> +static int bcm2048_set_automute(struct bcm2048_device *bdev, u8 automute)
> +{
> +	int err;
> +
> +	mutex_lock(&bdev->mutex);
> +
> +	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_AUDIO_PAUSE, automute);
> +
> +	mutex_unlock(&bdev->mutex);
> +	return err;
> +}
> +
> +static int bcm2048_get_automute(struct bcm2048_device *bdev)
> +{
> +	int err;
> +	u8 value;
> +
> +	mutex_lock(&bdev->mutex);
> +
> +	err = bcm2048_recv_command(bdev, BCM2048_I2C_FM_AUDIO_PAUSE, &value);
> +
> +	mutex_unlock(&bdev->mutex);
> +
> +	if (!err)
> +		err = value;
> +
> +	return err;
> +}
> +
> +static int bcm2048_set_ctrl0(struct bcm2048_device *bdev, u8 value)
> +{
> +	int err;
> +
> +	mutex_lock(&bdev->mutex);
> +
> +	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL0, value);
> +
> +	mutex_unlock(&bdev->mutex);
> +	return err;
> +}
> +
> +static int bcm2048_set_ctrl1(struct bcm2048_device *bdev, u8 value)
> +{
> +	int err;
> +
> +	mutex_lock(&bdev->mutex);
> +
> +	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL1, value);
> +
> +	mutex_unlock(&bdev->mutex);
> +	return err;
> +}
> +
> +static int bcm2048_get_ctrl0(struct bcm2048_device *bdev)
> +{
> +	int err;
> +	u8 value;
> +
> +	mutex_lock(&bdev->mutex);
> +
> +	err = bcm2048_recv_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL0, &value);
> +
> +	mutex_unlock(&bdev->mutex);
> +
> +	if (!err)
> +		err = value;
> +
> +	return err;
> +}
> +
> +static int bcm2048_get_ctrl1(struct bcm2048_device *bdev)
> +{
> +	int err;
> +	u8 value;
> +
> +	mutex_lock(&bdev->mutex);
> +
> +	err = bcm2048_recv_command(bdev, BCM2048_I2C_FM_AUDIO_CTRL1, &value);
> +
> +	mutex_unlock(&bdev->mutex);
> +
> +	if (!err)
> +		err = value;
> +
> +	return err;
> +}
> +
>  static int bcm2048_set_audio_route(struct bcm2048_device *bdev, u8 route)
>  {
>  	int err;
> @@ -2058,6 +2145,9 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
>  
>  DEFINE_SYSFS_PROPERTY(power_state, unsigned, int, "%u", 0)
>  DEFINE_SYSFS_PROPERTY(mute, unsigned, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(automute, unsigned, int, "%x", 0)
> +DEFINE_SYSFS_PROPERTY(ctrl0, unsigned, int, "%x", 0)
> +DEFINE_SYSFS_PROPERTY(ctrl1, unsigned, int, "%x", 0)
>  DEFINE_SYSFS_PROPERTY(audio_route, unsigned, int, "%u", 0)
>  DEFINE_SYSFS_PROPERTY(dac_output, unsigned, int, "%u", 0)
>  
> @@ -2095,6 +2185,12 @@ static struct device_attribute attrs[] = {
>  		bcm2048_power_state_write),
>  	__ATTR(mute, S_IRUGO | S_IWUSR, bcm2048_mute_read,
>  		bcm2048_mute_write),
> +	__ATTR(automute, S_IRUGO | S_IWUSR, bcm2048_automute_read,
> +		bcm2048_automute_write),
> +	__ATTR(ctrl0, S_IRUGO | S_IWUSR, bcm2048_ctrl0_read,
> +		bcm2048_ctrl0_write),
> +	__ATTR(ctrl1, S_IRUGO | S_IWUSR, bcm2048_ctrl1_read,
> +		bcm2048_ctrl1_write),
>  	__ATTR(audio_route, S_IRUGO | S_IWUSR, bcm2048_audio_route_read,
>  		bcm2048_audio_route_write),
>  	__ATTR(dac_output, S_IRUGO | S_IWUSR, bcm2048_dac_output_read,
> 

