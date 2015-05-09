Return-path: <linux-media-owner@vger.kernel.org>
Received: from dcvr.yhbt.net ([64.71.152.64]:53172 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbbEIEvK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 May 2015 00:51:10 -0400
Date: Sat, 9 May 2015 04:51:09 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, vladcatoi@gmail.com,
	damien@zamaudio.com, chris.j.arges@canonical.com,
	takamichiho@gmail.com, misterpib@gmail.com, daniel@zonque.org,
	pmatilai@laiskiainen.org, jussi@sonarnerd.net, fisch602@gmail.com,
	joe@oampo.co.uk, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] sound/usb: Update ALSA driver to use media
 controller API
Message-ID: <20150509045109.GA6528@dcvr.yhbt.net>
References: <cover.1431110739.git.shuahkh@osg.samsung.com>
 <dd21d1282a85d620be1aae497b66ccb355e458ba.1431110739.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd21d1282a85d620be1aae497b66ccb355e458ba.1431110739.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shuah Khan <shuahkh@osg.samsung.com> wrote:
> @@ -541,13 +591,19 @@ int snd_usb_create_quirk(struct snd_usb_audio *chip,
>  		[QUIRK_AUDIO_ALIGN_TRANSFER] = create_align_transfer_quirk,
>  		[QUIRK_AUDIO_STANDARD_MIXER] = create_standard_mixer_quirk,
>  	};
> +	int ret;
>  
> +	if (quirk->media_device) {
> +		/* don't want to fail when media_device_init() doesn't work */
> +		ret = media_device_init(iface);
> +	}
>  	if (quirk->type < QUIRK_TYPE_COUNT) {
> -		return quirk_funcs[quirk->type](chip, iface, driver, quirk);
> +		ret = quirk_funcs[quirk->type](chip, iface, driver, quirk);
>  	} else {
>  		usb_audio_err(chip, "invalid quirk type %d\n", quirk->type);
>  		return -ENXIO;
>  	}
> +	return ret;
>  }

What is the point of saving 'ret' of media_device_init if it'll
only be clobbered or ignored for ENXIO?
