Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45807 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbcCCKjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 05:39:12 -0500
Date: Thu, 3 Mar 2016 13:36:37 +0300
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
Message-ID: <20160303103637.GW5273@mwanda>
References: <1456937431-3794-1-git-send-email-shuahkh@osg.samsung.com>
 <20160302204131.GV5273@mwanda>
 <56D76FBF.9050209@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56D76FBF.9050209@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 02, 2016 at 03:57:03PM -0700, Shuah Khan wrote:
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

Yeah.  But it's the wrong idea.  If you remove a label then you have to
renumber everything.  Plus it doesn't say what the goto does.

> Names might help with code readability.
> 
> register_entity_fail probably makes more sense as a
> label than free_mctl.

A lot of people do that but the you wind up with code like:

	foo = whatever_register();
	if (!foo)
		goto whatever_failed;

	if (something_else)
		goto whatever_failed;

So it doesn't make sense.  Also it doesn't tell you what the goto does.
(You can already see that whatever_failed from looking at the if
statement on the line before.)  This function is larger than a page so
you have to flip down to the other page to see what the goto does, then
you have to flip back and find your place again.  But if the label says
what the goto does then you can just say, "Have we allocated anything
since mctl?  No, then freeing mctl is the right thing."  You don't need
to flip to the othe page.

regards,
dan carpenter

