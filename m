Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:60847 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbcBLMQM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 07:16:12 -0500
Subject: Re: [PATCH 1/2] [media] au0828: get rid of AU0828_VMUX_DEBUG
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	no To-header on input <""@pop.xs4all.nl>
References: <b39a8de587466a0052e696d8ebc3987066784384.1455276050.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56BDCD04.2030002@xs4all.nl>
Date: Fri, 12 Feb 2016 13:16:04 +0100
MIME-Version: 1.0
In-Reply-To: <b39a8de587466a0052e696d8ebc3987066784384.1455276050.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2016 12:21 PM, Mauro Carvalho Chehab wrote:
> This is not used on the driver. remove it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/usb/au0828/au0828-video.c | 12 +++---------
>  drivers/media/usb/au0828/au0828.h       |  1 -
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 4164302dd8ac..2fc2b29d2dd9 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -698,10 +698,9 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>  	for (i = 0; i < AU0828_MAX_INPUT; i++) {
>  		struct media_entity *ent = &dev->input_ent[i];
>  
> -		if (AUVI_INPUT(i).type == AU0828_VMUX_UNDEFINED)
> -			break;
> -
>  		switch (AUVI_INPUT(i).type) {
> +		case AU0828_VMUX_UNDEFINED:
> +			break;
>  		case AU0828_VMUX_CABLE:
>  		case AU0828_VMUX_TELEVISION:
>  		case AU0828_VMUX_DVB:
> @@ -716,7 +715,6 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>  			break;
>  		case AU0828_VMUX_COMPOSITE:
>  		case AU0828_VMUX_SVIDEO:
> -		default: /* AU0828_VMUX_DEBUG */
>  			/* FIXME: fix the decoder PAD */
>  			ret = media_create_pad_link(ent, 0, decoder, 0, 0);
>  			if (ret)
> @@ -1460,7 +1458,6 @@ static int vidioc_enum_input(struct file *file, void *priv,
>  		[AU0828_VMUX_CABLE] = "Cable TV",
>  		[AU0828_VMUX_TELEVISION] = "Television",
>  		[AU0828_VMUX_DVB] = "DVB",
> -		[AU0828_VMUX_DEBUG] = "tv debug"
>  	};
>  
>  	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> @@ -1952,7 +1949,6 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
>  		[AU0828_VMUX_CABLE] = "Cable TV",
>  		[AU0828_VMUX_TELEVISION] = "Television",
>  		[AU0828_VMUX_DVB] = "DVB",
> -		[AU0828_VMUX_DEBUG] = "tv debug"
>  	};
>  	int ret, i;
>  
> @@ -1988,11 +1984,9 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
>  		case AU0828_VMUX_CABLE:
>  		case AU0828_VMUX_TELEVISION:
>  		case AU0828_VMUX_DVB:
> +		default: /* Just to shut up a warning */
>  			ent->function = MEDIA_ENT_F_CONN_RF;
>  			break;
> -		default: /* AU0828_VMUX_DEBUG */
> -			ent->function = MEDIA_ENT_F_CONN_TEST;
> -			break;
>  		}
>  
>  		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index 19fd6a841988..23f869cf11da 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -76,7 +76,6 @@ enum au0828_itype {
>  	AU0828_VMUX_CABLE,
>  	AU0828_VMUX_TELEVISION,
>  	AU0828_VMUX_DVB,
> -	AU0828_VMUX_DEBUG
>  };
>  
>  struct au0828_input {
> 

