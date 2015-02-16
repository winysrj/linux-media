Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36959 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbbBPJES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 04:04:18 -0500
Message-ID: <54E1B277.9030802@xs4all.nl>
Date: Mon, 16 Feb 2015 10:03:51 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Herrmann <dh.herrmann@gmail.com>,
	Tom Gundersen <teg@jklm.no>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv4 13/25] [media] dvb_net: add support for DVB net node
 at the media controller
References: <cover.1423867976.git.mchehab@osg.samsung.com> <9c7ff55979e714f5ffb23a8a85bc2593d5b9350b.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <9c7ff55979e714f5ffb23a8a85bc2593d5b9350b.1423867976.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> Make the dvb core network support aware of the media controller and
> register the corresponding devices.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> index 686d3277dad1..40990058b4bc 100644
> --- a/drivers/media/dvb-core/dvb_net.c
> +++ b/drivers/media/dvb-core/dvb_net.c
> @@ -1462,14 +1462,16 @@ static const struct file_operations dvb_net_fops = {
>  	.llseek = noop_llseek,
>  };
>  
> -static struct dvb_device dvbdev_net = {
> +static const struct dvb_device dvbdev_net = {
>  	.priv = NULL,
>  	.users = 1,
>  	.writers = 1,
> +#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> +	.name = "dvb net",

I would suggest 'dvb-net' rather than 'dvb net' with a space. That's a personal
preference, though.

Regards,

	Hans

> +#endif
>  	.fops = &dvb_net_fops,
>  };
>  
> -
>  void dvb_net_release (struct dvb_net *dvbnet)
>  {
>  	int i;
> 

