Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39871 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbcBINmn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2016 08:42:43 -0500
Date: Tue, 9 Feb 2016 11:42:28 -0200
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
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 20/22] media: au0828 add enable, disable source
 handlers
Message-ID: <20160209114228.70539d24@recife.lan>
In-Reply-To: <56B91E0A.90705@osg.samsung.com>
References: <cover.1454557589.git.shuahkh@osg.samsung.com>
	<1ebb3d41fa42581f8741e493f3109357ad1a0b3c.1454557589.git.shuahkh@osg.samsung.com>
	<20160204082649.0ad08a16@recife.lan>
	<56B919C7.80801@osg.samsung.com>
	<56B91E0A.90705@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 08 Feb 2016 16:00:26 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> >>> +	ret = __media_entity_pipeline_start(entity, pipe);
> >>> +	if (ret) {
> >>> +		pr_err("Start Pipeline: %s->%s Error %d\n",
> >>> +			source->name, entity->name, ret);
> >>> +		ret = __media_entity_setup_link(found_link, 0);
> >>> +		pr_err("Deactive link Error %d\n", ret);
> >>> +		goto end;
> >>> +	}  
> >>
> >> Hmm... isn't it to early to activate the pipeline here? My original
> >> guess is that, on the analog side, this should happen only at the stream
> >> on code. Wouldn't this break apps like mythTV?  
> 
> On analog side, there are a few ioctls that
> change the configuration on the tuner way
> before stream on step. Is there a reason to
> separate the setup_link() and pipeline_start()
> steps? I can separate these two steps, but I
> am not really seeing the reason for that.

I'm actually ok with that, provided that it won't break existing
apps. Did you test it with MythTV?

Regards,
Mauro
