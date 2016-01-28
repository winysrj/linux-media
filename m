Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58059 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967010AbcA1QqF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 11:46:05 -0500
Date: Thu, 28 Jan 2016 14:45:46 -0200
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
Subject: Re: [PATCH 25/31] media: au0828 fix to not call
 media_device_unregister_entity_notify()
Message-ID: <20160128144546.26eb3c4b@recife.lan>
In-Reply-To: <19782c8250ea1297271506e6558c089d4b25e026.1452105878.git.shuahkh@osg.samsung.com>
References: <cover.1452105878.git.shuahkh@osg.samsung.com>
	<19782c8250ea1297271506e6558c089d4b25e026.1452105878.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  6 Jan 2016 14:01:54 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> entity_notify handlers are removed from media_device_unregister().
> There is no need to call media_device_unregister_entity_notify()
> to do that right before calling media_device_unregister().

Please merge with the patch that added it.

> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/usb/au0828/au0828-core.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 9497ad1..722e073 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -137,8 +137,6 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	if (dev->media_dev &&
>  		media_devnode_is_registered(&dev->media_dev->devnode)) {
> -		media_device_unregister_entity_notify(dev->media_dev,
> -						      &dev->entity_notify);
>  		media_device_unregister(dev->media_dev);
>  		media_device_cleanup(dev->media_dev);
>  		dev->media_dev = NULL;
