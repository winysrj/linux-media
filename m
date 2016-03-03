Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57738 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943AbcCCO7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 09:59:51 -0500
Subject: Re: [PATCH v3 02/22] uapi/media.h: Declare interface types for ALSA
To: Shuah Khan <shuahkh@osg.samsung.com>, mchehab@osg.samsung.com,
	tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
 <a1b468c2933dc2b4f2b6cc6d1ac30baee2a89f77.1455233152.git.shuahkh@osg.samsung.com>
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
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
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D85161.5070103@xs4all.nl>
Date: Thu, 3 Mar 2016 15:59:45 +0100
MIME-Version: 1.0
In-Reply-To: <a1b468c2933dc2b4f2b6cc6d1ac30baee2a89f77.1455233152.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/16 00:41, Shuah Khan wrote:
> Declare the interface types to be used on alsa for
> the new G_TOPOLOGY ioctl.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/media-entity.c | 16 ++++++++++++++++
>  include/uapi/linux/media.h   | 10 ++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index f2e4360..6179543 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -65,6 +65,22 @@ static inline const char *intf_type(struct media_interface *intf)
>  		return "v4l2-subdev";
>  	case MEDIA_INTF_T_V4L_SWRADIO:
>  		return "swradio";
> +	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
> +		return "pcm-capture";
> +	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
> +		return "pcm-playback";
> +	case MEDIA_INTF_T_ALSA_CONTROL:
> +		return "alsa-control";
> +	case MEDIA_INTF_T_ALSA_COMPRESS:
> +		return "compress";
> +	case MEDIA_INTF_T_ALSA_RAWMIDI:
> +		return "rawmidi";
> +	case MEDIA_INTF_T_ALSA_HWDEP:
> +		return "hwdep";
> +	case MEDIA_INTF_T_ALSA_SEQUENCER:
> +		return "sequencer";
> +	case MEDIA_INTF_T_ALSA_TIMER:
> +		return "timer";

Wouldn't it be better to add an 'alsa' prefix for all of these?

And 'dvb-' or 'v4l2-' (or v4l-) for the others as well.

Names like 'timer' are very generic. I think it would be a good idea to
make the naming more regular and have it include the subsystem name just
as the define does.

Regards,

	Hans

>  	default:
>  		return "unknown-intf";
>  	}
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index c9eb42a..3cc0366 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -265,6 +265,7 @@ struct media_links_enum {
>  
>  #define MEDIA_INTF_T_DVB_BASE	0x00000100
>  #define MEDIA_INTF_T_V4L_BASE	0x00000200
> +#define MEDIA_INTF_T_ALSA_BASE	0x00000300
>  
>  /* Interface types */
>  
> @@ -280,6 +281,15 @@ struct media_links_enum {
>  #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
>  #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
>  
> +#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
> +#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
> +#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
> +#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
> +#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
> +#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
> +#define MEDIA_INTF_T_ALSA_SEQUENCER     (MEDIA_INTF_T_ALSA_BASE + 6)
> +#define MEDIA_INTF_T_ALSA_TIMER         (MEDIA_INTF_T_ALSA_BASE + 7)
> +
>  /*
>   * MC next gen API definitions
>   *
> 
