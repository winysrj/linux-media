Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:33970 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbaKAQqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Nov 2014 12:46:48 -0400
Message-ID: <54550E71.9010006@gentoo.org>
Date: Sat, 01 Nov 2014 17:46:41 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 6/7] [media] cx231xx-i2c: fix i2c_scan modprobe parameter
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com> <14a334de4f4b5786e55ce62872f7b033e9f0af3f.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <14a334de4f4b5786e55ce62872f7b033e9f0af3f.1414849031.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.11.2014 14:38, Mauro Carvalho Chehab wrote:
> This device doesn't properly implement read with a zero bytes
> len. So, use 1 byte for I2C scan.
> 
Yes, the idea sounds good, but we should fix this in the code in
cx231xx_i2c_check_for_device.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index 1a0d9efeb209..9b7e5a155e34 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -502,7 +502,7 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
>  		i2c_port);
>  	for (i = 0; i < 128; i++) {
>  		client.addr = i;
> -		rc = i2c_master_recv(&client, &buf, 0);
> +		rc = i2c_master_recv(&client, &buf, 1);
>  		if (rc < 0)
>  			continue;
>  		pr_info("i2c scan: found device @ 0x%x  [%s]\n",
> 

