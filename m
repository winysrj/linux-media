Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44426 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933837AbcCNKxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 06:53:31 -0400
Date: Mon, 14 Mar 2016 12:52:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	a.hajda@samsung.com, s.nawrocki@samsung.com, kgene@kernel.org,
	k.kozlowski@samsung.com, laurent.pinchart@ideasonboard.com,
	hyun.kwon@xilinx.com, soren.brinkmann@xilinx.com,
	gregkh@linuxfoundation.org, perex@perex.cz, tiwai@suse.com,
	hans.verkuil@cisco.com, lixiubo@cmss.chinamobile.com,
	javier@osg.samsung.com, g.liakhovetski@gmx.de,
	chehabrafael@gmail.com, crope@iki.fi, tommi.franttila@intel.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	hamohammed.sa@gmail.com, der.herr@hofr.at, navyasri.tech@gmail.com,
	Julia.Lawall@lip6.fr, amitoj1606@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH] media: add GFP flag to media_*() that could get called
 in atomic context
Message-ID: <20160314105253.GQ11084@valkosipuli.retiisi.org.uk>
References: <1457833689-4926-1-git-send-email-shuahkh@osg.samsung.com>
 <20160314072236.GO11084@valkosipuli.retiisi.org.uk>
 <20160314071358.27c87dab@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160314071358.27c87dab@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Mar 14, 2016 at 07:13:58AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 14 Mar 2016 09:22:37 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Shuah,
> > 
> > On Sat, Mar 12, 2016 at 06:48:09PM -0700, Shuah Khan wrote:
> > > Add GFP flags to media_create_pad_link(), media_create_intf_link(),
> > > media_devnode_create(), and media_add_link() that could get called
> > > in atomic context to allow callers to pass in the right flags for
> > > memory allocation.
> > > 
> > > tree-wide driver changes for media_*() GFP flags change:
> > > Change drivers to add gfpflags to interffaces, media_create_pad_link(),
> > > media_create_intf_link() and media_devnode_create().
> > > 
> > > Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> > > Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>  
> > 
> > What's the use case for calling the above functions in an atomic context?
> > 
> 
> ALSA code seems to do a lot of stuff at atomic context. That's what
> happens on my test machine when au0828 gets probed before
> snd-usb-audio:
> 	http://pastebin.com/LEX5LD5K
> 
> It seems that ALSA USB probe routine (usb_audio_probe) happens in
> atomic context.

usb_audio_probe() grabs a mutex (register_mutex) on its own. It certainly
cannot be called in atomic context.

In the above log, what I did notice, though, was that because *we* grab
mdev->lock spinlock in media_device_register_entity(), we may not sleep
which is what the notify() callback implementation in au0828 driver does
(for memory allocation).

Could we instead replace mdev->lock by a mutex?

If there is no pressing need to implement atomic memory allocation I simply
wouldn't do it, especially in device initialisation where an allocation
failure will lead to probe failure as well.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
