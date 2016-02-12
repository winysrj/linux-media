Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56085 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbcBLMQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 07:16:26 -0500
Subject: Re: [PATCH 2/2] [media] cx231xx: get rid of CX231XX_VMUX_DEBUG
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	no To-header on input <""@pop.xs4all.nl>
References: <b39a8de587466a0052e696d8ebc3987066784384.1455276050.git.mchehab@osg.samsung.com>
 <74a125ed2542ac0306e8582bc86dd0fc9a2bdc02.1455276050.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56BDCD13.9070606@xs4all.nl>
Date: Fri, 12 Feb 2016 13:16:19 +0100
MIME-Version: 1.0
In-Reply-To: <74a125ed2542ac0306e8582bc86dd0fc9a2bdc02.1455276050.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2016 12:21 PM, Mauro Carvalho Chehab wrote:
> This macro is not used inside the driver. get rid of it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/usb/cx231xx/cx231xx-video.c | 3 +--
>  drivers/media/usb/cx231xx/cx231xx.h       | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index 7222b1c27d40..6414188ffdfa 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -1103,7 +1103,6 @@ static const char *iname[] = {
>  	[CX231XX_VMUX_TELEVISION] = "Television",
>  	[CX231XX_VMUX_CABLE]      = "Cable TV",
>  	[CX231XX_VMUX_DVB]        = "DVB",
> -	[CX231XX_VMUX_DEBUG]      = "for debug only",
>  };
>  
>  void cx231xx_v4l2_create_entities(struct cx231xx *dev)
> @@ -1136,7 +1135,7 @@ void cx231xx_v4l2_create_entities(struct cx231xx *dev)
>  			if (dev->tuner_type == TUNER_ABSENT)
>  				continue;
>  			/* fall though */
> -		default: /* CX231XX_VMUX_DEBUG */
> +		default: /* just to shut up a gcc warning */
>  			ent->function = MEDIA_ENT_F_CONN_RF;
>  			break;
>  		}
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index 60e14776a6cd..69f6d20870f5 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -281,7 +281,6 @@ enum cx231xx_itype {
>  	CX231XX_VMUX_CABLE,
>  	CX231XX_RADIO,
>  	CX231XX_VMUX_DVB,
> -	CX231XX_VMUX_DEBUG
>  };
>  
>  enum cx231xx_v_input {
> 

