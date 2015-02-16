Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35505 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932069AbbBPJFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 04:05:09 -0500
Message-ID: <54E1B2B2.3010906@xs4all.nl>
Date: Mon, 16 Feb 2015 10:04:50 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv4 12/25] [media] dvb_ca_en50221: add support for CA node
 at the media controller
References: <cover.1423867976.git.mchehab@osg.samsung.com> <ff6b48d612b1130720761ec2f8ac28a05ac86d58.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <ff6b48d612b1130720761ec2f8ac28a05ac86d58.1423867976.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> Make the dvb core CA support aware of the media controller and
> register the corresponding devices.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
> index 0aac3096728e..2bf28eb97a64 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> @@ -1638,15 +1638,17 @@ static const struct file_operations dvb_ca_fops = {
>  	.llseek = noop_llseek,
>  };
>  
> -static struct dvb_device dvbdev_ca = {
> +static const struct dvb_device dvbdev_ca = {
>  	.priv = NULL,
>  	.users = 1,
>  	.readers = 1,
>  	.writers = 1,
> +#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> +	.name = "ca_en50221",

I'd use 'dvb-ca-en50221': the dvb prefix makes it clear that this is a 
dvb core device, and personally I prefer '-' over '_'.

Regards,

	Hans

> +#endif
>  	.fops = &dvb_ca_fops,
>  };
>  
> -
>  /* ******************************************************************************** */
>  /* Initialisation/shutdown functions */
>  
> 

