Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbZDTTyS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 15:54:18 -0400
Date: Mon, 20 Apr 2009 16:54:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Dean A." <dean@sensoray.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: patch: s2255drv high quality mode and video status querying
Message-ID: <20090420165413.049552c5@pedra.chehab.org>
In-Reply-To: <tkrat.2351cf1cef386315@sensoray.com>
References: <tkrat.2351cf1cef386315@sensoray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Apr 2009 10:56:36 -0700 (PDT)
"Dean A." <dean@sensoray.com> wrote:

> From: Dean Anderson <dean@sensoray.com>
> 
> This patch adds V4L2 video status capability and V4L2_MODE_HIGHQUALITY
> operation.

Hi Dean,

I have a few comments to add over Trent's one.

> 
> Signed-off-by: Dean Anderson <dean@sensoray.com>
> 
> --- v4l-dvb-1e670024659d/linux/drivers/media/video/s2255drv.c.orig	2009-04-07 10:38:42.000000000 -0700
> +++ v4l-dvb-1e670024659d/linux/drivers/media/video/s2255drv.c	2009-04-07 10:42:51.000000000 -0700
> @@ -57,7 +57,8 @@
>  
>  #define FIRMWARE_FILE_NAME "f2255usb.bin"
>  
> -
> +#define S2255_REV_MAJOR 1
> +#define S2255_REV_MINOR 20
>  
> +
>  #define S2255_MAJOR_VERSION	1
>  #define S2255_MINOR_VERSION	13

Hmm... Why you need two different major/minor versions on your driver?


> @@ -1207,8 +1236,8 @@ static int s2255_set_mode(struct s2255_d
>  			  struct s2255_mode *mode)
>  {
>  	int res;
> -	u32 *buffer;
> -	unsigned long chn_rev;
> +	__le32 *buffer;
> +	u32 chn_rev;

Also, please don't mix more than one thing at the same patch. Clearly, you did
some endiannes fix at the same patch. Please split it into different patches.

> +static int s2255_cmd_status(struct s2255_dev *dev, unsigned long chn,
> +			    u32 *pstatus)
> +{
> +	int res;
> +	__le32 *buffer;
> +	u32 chn_rev;
> +
> +	mutex_lock(&dev->lock);
> +	chn_rev = G_chnmap[chn];
> +	dprintk(4, "s2255_get_status: chan %d\n", chn_rev);
> +	buffer = kzalloc(512, GFP_KERNEL);
> +	if (buffer == NULL) {
> +		dev_err(&dev->udev->dev, "out of mem\n");
> +		mutex_unlock(&dev->lock);
> +		return -ENOMEM;
> +	}
> +	/* form the get vid status command */
> +	buffer[0] = IN_DATA_TOKEN;
> +	buffer[1] = cpu_to_le32(chn_rev);
> +	buffer[2] = CMD_STATUS;
> +	*pstatus = 0;
> +	dev->vidstatus_ready[chn] = 0;
> +	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
> +	kfree(buffer);
> +	wait_event_timeout(dev->wait_vidstatus[chn],
> +			   (dev->vidstatus_ready[chn] != 0),
> +			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
> +	if (dev->vidstatus_ready[chn] != 1) {
> +		printk(KERN_DEBUG "s2255: no vidstatus response\n");
> +		res = -EFAULT;
> +	}
> +	*pstatus = dev->vidstatus[chn];
> +	dprintk(4, "s2255: vid status %d\n", *pstatus);
> +	mutex_unlock(&dev->lock);
> +	return res;
> +}
> +

Also, please split "high quality mode" from "video status querying". You should
provide one patch per different feature you're adding.


Cheers,
Mauro
