Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57533 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbcA1PCu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 10:02:50 -0500
Date: Thu, 28 Jan 2016 13:02:32 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: tiwai@suse.com, clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
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
	johan@oljud.se, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-api@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH 02/31] media: Add ALSA Media Controller function
 entities
Message-ID: <20160128130232.63c619d2@recife.lan>
In-Reply-To: <ad778fbd7f61105b273d2a49dc91662c4bb255d7.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<ad778fbd7f61105b273d2a49dc91662c4bb255d7.1452105878.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  6 Jan 2016 13:26:51 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Add ALSA Media Controller capture, playback, and mixer
> function entity defines.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  include/uapi/linux/media.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 75cbe92..53a96ae 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -89,6 +89,13 @@ struct media_device_info {
>  #define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 33)
>  
>  /*
> + * ALSA entities MEDIA_ENT_F_AUDIO_IO is for Capture and Playback
> +*/
> +#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 200)
> +#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 201)
> +#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 202)

Please document at KernelDoc.

> +
> +/*
>   * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
>   * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
>   * with the legacy v1 API.The number range is out of range by purpose:
> @@ -130,7 +137,7 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_F_OLD_BASE
>  #define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO_V4L
>  #define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
> -#define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> +#define MEDIA_ENT_T_DEVNODE_ALSA	MEDIA_ENT_F_AUDIO_IO

Please preserve the old number here, as we don't want to break kABI.

>  #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
>  
>  #define MEDIA_ENT_T_UNKNOWN		MEDIA_ENT_F_UNKNOWN
