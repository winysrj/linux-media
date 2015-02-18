Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57041 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbbBRPiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 10:38:07 -0500
Message-ID: <54E4B1C2.20403@xs4all.nl>
Date: Wed, 18 Feb 2015 16:37:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Herrmann <dh.herrmann@gmail.com>,
	Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 4/7] [media] dvb core: rename the media controller entities
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com> <56874b07885afd9d58dd3d3985d6167eb9a3deea.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <56874b07885afd9d58dd3d3985d6167eb9a3deea.1424273378.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 02/18/2015 04:29 PM, Mauro Carvalho Chehab wrote:
> Prefix all DVB media controller entities with "dvb-" and use dash
> instead of underline at the names.
> 
> Requested-by: Hans Verkuil <hverkuil@xs4all.nl>
			      ^^^^^^^^^^^^^^^^^^

For these foo-by lines please keep my hans.verkuil@cisco.com email.
It's my way of thanking Cisco for allowing me to do this work. Not a
big deal, but if you can change that before committing?

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
> index 2835924955a4..d0e3f9d85f34 100644
> --- a/drivers/media/dvb-core/dmxdev.c
> +++ b/drivers/media/dvb-core/dmxdev.c
> @@ -1141,7 +1141,7 @@ static const struct dvb_device dvbdev_demux = {
>  	.users = 1,
>  	.writers = 1,
>  #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> -	.name = "demux",
> +	.name = "dvb-demux",
>  #endif
>  	.fops = &dvb_demux_fops
>  };
> @@ -1217,7 +1217,7 @@ static const struct dvb_device dvbdev_dvr = {
>  	.readers = 1,
>  	.users = 1,
>  #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> -	.name = "dvr",
> +	.name = "dvb-dvr",
>  #endif
>  	.fops = &dvb_dvr_fops
>  };
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
> index 2bf28eb97a64..55a217f0ad0e 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> @@ -1644,7 +1644,7 @@ static const struct dvb_device dvbdev_ca = {
>  	.readers = 1,
>  	.writers = 1,
>  #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> -	.name = "ca_en50221",
> +	.name = "dvb-ca-en50221",
>  #endif
>  	.fops = &dvb_ca_fops,
>  };
> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index 40990058b4bc..1508d918205d 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -1467,7 +1467,7 @@ static const struct dvb_device dvbdev_net = {
>  	.users = 1,
>  	.writers = 1,
>  #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> -	.name = "dvb net",
> +	.name = "dvb-net",
>  #endif
>  	.fops = &dvb_net_fops,
>  };
> 

