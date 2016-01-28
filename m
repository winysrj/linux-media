Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57808 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbcA1P6M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 10:58:12 -0500
Date: Thu, 28 Jan 2016 13:57:52 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH 17/31] media: au0828 video change to use
 v4l_enable_media_tuner()
Message-ID: <20160128135752.536e909e@recife.lan>
In-Reply-To: <2d2392f96a7f10a8d94a4d7fa6d5657b56b75593.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<2d2392f96a7f10a8d94a4d7fa6d5657b56b75593.1452105878.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  6 Jan 2016 13:27:06 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> au0828 is changed to use v4l_enable_media_tuner() to check for
> tuner availability from vidioc_g_tuner(), and au0828_v4l2_close(),
> before changing tuner settings. If tuner isn't free, return busy
> condition from vidioc_g_tuner() and in au0828_v4l2_close() tuner
> is left untouched without powering down to save energy.

Did you test the code when the input is not a tuner, but, instead,
Composite or S-Video connector, as shown at:
	https://mchehab.fedorapeople.org/mc-next-gen/au0828.png

I guess calling it v4l-enable_media_tuner() is not right, specially
since there are hybrid devices that have DTV (via DVB API) and
S-Video and/or Composite/RCA capture via V4L2 API.

> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 32bcc56..ed3ba05 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1010,8 +1010,12 @@ static int au0828_v4l2_close(struct file *filp)
>  		goto end;
>  
>  	if (dev->users == 1) {
> -		/* Save some power by putting tuner to sleep */
> -		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> +		/* Save some power by putting tuner to sleep, if it is free */
> +		/* What happens when radio is using tuner?? */
> +		ret = v4l_enable_media_tuner(vdev);
> +		if (ret == 0)
> +			v4l2_device_call_all(&dev->v4l2_dev, 0, core,
> +					     s_power, 0);
>  		dev->std_set_in_tuner_core = 0;
>  
>  		/* When close the device, set the usb intf0 into alt0 to free
> @@ -1412,10 +1416,16 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
>  static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
> +	struct video_device *vfd = video_devdata(file);
> +	int ret;
>  
>  	if (t->index != 0)
>  		return -EINVAL;
>  
> +	ret = v4l_enable_media_tuner(vfd);
> +	if (ret)
> +		return ret;
> +
>  	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
