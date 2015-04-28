Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35222 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991AbbD1MIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 08:08:01 -0400
Received: by widdi4 with SMTP id di4so137335984wid.0
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2015 05:08:00 -0700 (PDT)
Date: Tue, 28 Apr 2015 14:07:56 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Luke Hart <luke.hart@birchleys.eu>,
	Anil Belur <askb23@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Vaishali Thakkar <vthakkar1994@gmail.com>,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH] radio-bcm2048: remove unused var
Message-ID: <20150428120756.GE604@pali>
References: <5784d4a9f48f7661ab1814ef4e8d210fa065bafb.1430222617.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5784d4a9f48f7661ab1814ef4e8d210fa065bafb.1430222617.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 28 April 2015 09:03:41 Mauro Carvalho Chehab wrote:
> drivers/staging/media/bcm2048/radio-bcm2048.c: In function 'bcm2048_i2c_driver_probe':
> drivers/staging/media/bcm2048/radio-bcm2048.c:2596:11: warning: variable 'skip_release' set but not used [-Wunused-but-set-variable]
>   int err, skip_release = 0;
>            ^
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index e9d0691b21d3..5e11a78ceef3 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2593,7 +2593,7 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
>  					const struct i2c_device_id *id)
>  {
>  	struct bcm2048_device *bdev;
> -	int err, skip_release = 0;
> +	int err;
>  
>  	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
>  	if (!bdev) {
> @@ -2646,7 +2646,6 @@ free_sysfs:
>  	bcm2048_sysfs_unregister_properties(bdev, ARRAY_SIZE(attrs));
>  free_registration:
>  	video_unregister_device(&bdev->videodev);
> -	skip_release = 1;
>  free_irq:
>  	if (client->irq)
>  		free_irq(client->irq, bdev);

Looks good to me, so

Acked-by: Pali Rohár <pali.rohar@gmail.com>

-- 
Pali Rohár
pali.rohar@gmail.com
