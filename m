Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34217 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbcCCSWI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 13:22:08 -0500
Date: Thu, 3 Mar 2016 15:21:52 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, tiwai@suse.com,
	clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
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
Message-ID: <20160303152152.303c85ea@recife.lan>
In-Reply-To: <56D76FBF.9050209@osg.samsung.com>
References: <1456937431-3794-1-git-send-email-shuahkh@osg.samsung.com>
	<20160302204131.GV5273@mwanda>
	<56D76FBF.9050209@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 2 Mar 2016 15:57:03 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 03/02/2016 01:41 PM, Dan Carpenter wrote:
> > On Wed, Mar 02, 2016 at 09:50:31AM -0700, Shuah Khan wrote:
> >> +	mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
> >> +	if (!mctl)
> >> +		return -ENOMEM;
> >> +
> >> +	mctl->media_dev = mdev;
> >> +	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
> >> +		intf_type = MEDIA_INTF_T_ALSA_PCM_PLAYBACK;
> >> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_PLAYBACK;
> >> +		mctl->media_pad.flags = MEDIA_PAD_FL_SOURCE;
> >> +		mixer_pad = 1;
> >> +	} else {
> >> +		intf_type = MEDIA_INTF_T_ALSA_PCM_CAPTURE;
> >> +		mctl->media_entity.function = MEDIA_ENT_F_AUDIO_CAPTURE;
> >> +		mctl->media_pad.flags = MEDIA_PAD_FL_SINK;
> >> +		mixer_pad = 2;
> >> +	}
> >> +	mctl->media_entity.name = pcm->name;
> >> +	media_entity_pads_init(&mctl->media_entity, 1, &mctl->media_pad);
> >> +	ret =  media_device_register_entity(mctl->media_dev,
> >> +					    &mctl->media_entity);
> >> +	if (ret)
> >> +		goto err1;
> > 
> > Could we give this label a meaningful name instead of a number?
> > goto free_mctl;
> 
> I do see other places where numbered labels are used.
> Names might help with code readability.
> 
> register_entity_fail probably makes more sense as a
> label than free_mctl. In any case, I can address the
> labels in a follow-on patch.
> 
> > 
> >> +
> >> +	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
> >> +						  MAJOR(pcm_dev->devt),
> >> +						  MINOR(pcm_dev->devt));
> >> +	if (!mctl->intf_devnode) {
> >> +		ret = -ENOMEM;
> >> +		goto err2;
> > 
> > goto unregister_device;
> > 
> >> +	}
> >> +	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
> >> +						 &mctl->intf_devnode->intf,
> >> +						 MEDIA_LNK_FL_ENABLED);
> >> +	if (!mctl->intf_link) {
> >> +		ret = -ENOMEM;
> >> +		goto err3;
> > 
> > goto delete_devnode;
> > 
> >> +	}
> >> +
> >> +	/* create link between mixer and audio */
> >> +	media_device_for_each_entity(entity, mdev) {
> >> +		switch (entity->function) {
> >> +		case MEDIA_ENT_F_AUDIO_MIXER:
> >> +			ret = media_create_pad_link(entity, mixer_pad,
> >> +						    &mctl->media_entity, 0,
> >> +						    MEDIA_LNK_FL_ENABLED);
> >> +			if (ret)
> >> +				goto err4;
> > 
> > This is a bit weird because we're inside a loop.  Shouldn't we call
> > media_entity_remove_links() or something if this is the second time
> > through the loop?
> 
> Links are removed from media_device_unregister_entity()
> which is called in the error path.
> 
> > 
> > I don't understand this.  The kernel has the media_entity_cleanup() stub
> > function which is supposed to do this but it hasn't been implemented
> > yet?
> > 
> 
> Please see above. Links are removed when entity is
> unregistered. media_entity_cleanup() is a stub. It
> isn't intended for removing links.

Shuah,

Please address the issue that Dan is pointing on a separate
patch.

Thanks,
Mauro
