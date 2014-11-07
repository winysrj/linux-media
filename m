Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:42630 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaKGJyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 04:54:36 -0500
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] rc-main: Fix =?UTF-8?Q?rc=5Ftype=20handling?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Nov 2014 10:54:29 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
In-Reply-To: <fb9b1641ba30385e1c142ecef2b631d31a881fd1.1415190468.git.mchehab@osg.samsung.com>
References: <fb9b1641ba30385e1c142ecef2b631d31a881fd1.1415190468.git.mchehab@osg.samsung.com>
Message-ID: <7b470908627a92aca71494999af3cd63@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-11-05 13:27, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> 	drivers/media/rc/rc-main.c:1426 rc_register_device() warn: should '1
> << rc_map->rc_type' be a 64 bit type?
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 296de853a25d..66eabc5dd000 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1423,7 +1423,7 @@ int rc_register_device(struct rc_dev *dev)
>  	}
> 
>  	if (dev->change_protocol) {
> -		u64 rc_type = (1 << rc_map->rc_type);
> +		u64 rc_type = (1ll << rc_map->rc_type);

Just a minor nitpick, but I think "ull" is more consistent with "u64"

>  		rc = dev->change_protocol(dev, &rc_type);
>  		if (rc < 0)
>  			goto out_raw;
