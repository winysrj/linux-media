Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48804 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422785AbcBQMZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 07:25:20 -0500
Date: Wed, 17 Feb 2016 10:25:05 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>, tiwai@suse.com
Cc: clemens@ladisch.de, hans.verkuil@cisco.com,
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
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 04/22] media: Add ALSA Media Controller function
 entities
Message-ID: <20160217102505.200675ac@recife.lan>
In-Reply-To: <423baaaf7ae51eb9098b7d0adc5ad668a590449e.1455233153.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
	<423baaaf7ae51eb9098b7d0adc5ad668a590449e.1455233153.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Feb 2016 16:41:20 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Add ALSA Media Controller capture, playback, and mixer
> function entity defines.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  include/uapi/linux/media.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 3cc0366..449462e 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -98,6 +98,13 @@ struct media_device_info {
>  #define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 42)
>  
>  /*
> + * Audio Entity Functions
> + */
> +#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 200)
> +#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 201)
> +#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 202)
> +
> +/*
>   * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
>   * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
>   * with the legacy v1 API.The number range is out of range by purpose:

Looks OK to me. 

This won't apply anymore on master, because we changed the numberspace, 
but it is a trivial conflict. No need to rebase.

Takashi,

If OK for you, please ack.


-- 
Thanks,
Mauro
