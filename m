Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41332 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbcCBUoV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 15:44:21 -0500
Date: Wed, 2 Mar 2016 23:41:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@osg.samsung.com, tiwai@suse.com, clemens@ladisch.de,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, javier@osg.samsung.com,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	tvboxspy@gmail.com, crope@iki.fi, ruchandani.tina@gmail.com,
	corbet@lwn.net, chehabrafael@gmail.com, k.kozlowski@samsung.com,
	stefanr@s5r6.in-berlin.de, inki.dae@samsung.com,
	jh1009.sung@samsung.com, elfring@users.sourceforge.net,
	prabhakar.csengg@gmail.com, sw0312.kim@samsung.com,
	p.zabel@pengutronix.de, ricardo.ribalda@gmail.com,
	labbott@fedoraproject.org, pierre-louis.bossart@linux.intel.com,
	ricard.wanderlof@axis.com, julian@jusst.de, takamichiho@gmail.com,
	dominic.sacre@gmx.de, misterpib@gmail.com, daniel@zonque.org,
	gtmkramer@xs4all.nl, normalperson@yhbt.net, joe@oampo.co.uk,
	linuxbugs@vittgam.net, johan@oljud.se, klock.android@gmail.com,
	nenggun.kim@samsung.com, j.anaszewski@samsung.com,
	geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH v5 22/22] sound/usb: Use Media Controller API to share
 media resources
Message-ID: <20160302204131.GV5273@mwanda>
References: <1456937431-3794-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1456937431-3794-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 02, 2016 at 09:50:31AM -0700, Shuah Khan wrote:
> +	mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
> +	if (!mctl)
> +		return -ENOMEM;
> +
> +	mctl->media_dev = mdev;
> +	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
> +		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_PLAYBACK;
> +		mctl->media_pad.flags = MEDIA_PAD_FL_SOURCE;
> +		mixer_pad = 1;
> +	} else {
> +		intf_type = MEDIA_INTF_T_ALSA_PCM_CAPTURE;
> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_CAPTURE;
> +		mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
> +		mixer_pad = 2;
> +	}
> +	mctl->media_entity.name = pcm->name;
> +	media_entity_pads_init(&mctl->media_entity, 1, &mctl->media_pad);
> +	ret =  media_device_register_entity(mctl->media_dev,
> +					    &mctl->media_entity);
> +	if (ret)
> +		goto err1;

Could we give this label a meaningful name instead of a number?
goto free_mctl;

> +
> +	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
> +						  MAJOR(pcm_dev->devt),
> +						  MINOR(pcm_dev->devt));
> +	if (!mctl->intf_devnode) {
> +		ret = -ENOMEM;
> +		goto err2;

goto unregister_device;

> +	}
> +	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
> +						 &mctl->intf_devnode->intf,
> +						 MEDIA_LNK_FL_ENABLED);
> +	if (!mctl->intf_link) {
> +		ret = -ENOMEM;
> +		goto err3;

goto delete_devnode;

> +	}
> +
> +	/* create link between mixer and audio */
> +	media_device_for_each_entity(entity, mdev) {
> +		switch (entity->function) {
> +		case MEDIA_ENT_F_AUDIO_MIXER:
> +			ret = media_create_pad_link(entity, mixer_pad,
> +						    &mctl->media_entity, 0,
> +						    MEDIA_LNK_FL_ENABLED);
> +			if (ret)
> +				goto err4;

This is a bit weird because we're inside a loop.  Shouldn't we call
media_entity_remove_links() or something if this is the second time
through the loop?

I don't understand this.  The kernel has the media_entity_cleanup() stub
function which is supposed to do this but it hasn't been implemented
yet?

regards,
dan carpenter

