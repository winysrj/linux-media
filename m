Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59266 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbbCBQ6H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 11:58:07 -0500
Date: Mon, 2 Mar 2015 13:58:03 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] soc-camera: one delayed patch for 3.20 or 3.21
Message-ID: <20150302135803.6ab73657@recife.lan>
In-Reply-To: <Pine.LNX.4.64.1502152154160.3178@axis700.grange>
References: <Pine.LNX.4.64.1502152154160.3178@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 15 Feb 2015 22:01:21 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi Mauro,
> 
> This is just a single patch for a single soc-camera host driver. No rush, 
> I presume, you're not planning another 3.20 pull request, in which case it 
> will wait until 3.21. But in case you are planning one and you find it 
> acceptable to also take this one - here goes. I just missed this patch a 
> while ago and wanted to put it up for whatever the next possibility would 
> be. Otherwise I suddenly recalled to clean up patchwork (... :)), so, 
> instead of 120+ patches for me it now only contains 15 :) I'll be looking 
> at them as time permits and preparing more for 3.21 and sending some 
> comments to those, that I won't yet find myself sufficiently comfortable 
> about.
> 
> One more question to you - what about these my 2 patches:
> 
> [v4,2/2] V4L: add CCF support to the v4l2_clk API
> https://patchwork.linuxtv.org/patch/28111/
> [v3,1/2] V4L: remove clock name from v4l2_clk API
> https://patchwork.linuxtv.org/patch/28108/
> 
> Are they good enough now? Shall I include them in my next pull request or 
> would you prefer to take them yourself?

Feel free to include on your next pull request, but please see my comments
for the first one:
	[v4,2/2] V4L: add CCF support to the v4l2_clk API
	https://patchwork.linuxtv.org/patch/28111/

Regards,
Mauro

> 
> The following changes since commit 48b777c0833bc7392679405539bb5d3ed0900828:
> 
>   Merge branch 'patchwork' into to_next (2015-02-10 21:42:33 -0200)
> 
> are available in the git repository at:
> 
> 
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.20-2
> 
> for you to fetch changes up to ed1a7b4be588c935cf31447366b005a07d73bb01:
> 
>   media: atmel-isi: increase the burst length to improve the performance (2015-02-15 17:28:37 +0100)
> 
> ----------------------------------------------------------------
> Josh Wu (1):
>       media: atmel-isi: increase the burst length to improve the performance
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 2 ++
>  include/media/atmel-isi.h                     | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> Thanks
> Guennadi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
