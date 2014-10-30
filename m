Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57382 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbaJ3N3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 09:29:48 -0400
Date: Thu, 30 Oct 2014 14:15:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] [media] fix a warning on avr32 arch
Message-ID: <20141030141529.23db53f3@kant>
In-Reply-To: <3948e2c09f98e556afe11f0e3d348bbe610af31e.1414664215.git.mchehab@osg.samsung.com>
References: <3948e2c09f98e556afe11f0e3d348bbe610af31e.1414664215.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 30 Mauro Carvalho Chehab wrote:
> on avr32 arch, those warnings happen:
> 	drivers/media/firewire/firedtv-fw.c: In function 'node_update':
> 	drivers/media/firewire/firedtv-fw.c:329: warning: comparison is always true due to limited range of data type
> 
> In this particular case, the signal is desired, as the isochannel
> var can be initalized with -1 inside the driver.
> 
> So, change the type to s8, to avoid issues on archs where char
> is unsigned.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> 
> diff --git a/drivers/media/firewire/firedtv.h b/drivers/media/firewire/firedtv.h
> index c2ba085e0d20..346a85be6de2 100644
> --- a/drivers/media/firewire/firedtv.h
> +++ b/drivers/media/firewire/firedtv.h
> @@ -96,7 +96,7 @@ struct firedtv {
>  
>  	enum model_type		type;
>  	char			subunit;
> -	char			isochannel;
> +	s8			isochannel;
>  	struct fdtv_ir_context	*ir_context;
>  
>  	fe_sec_voltage_t	voltage;

-- 
Stefan Richter
-=====-====- =-=- ====-
http://arcgraph.de/sr/
