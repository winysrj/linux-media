Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59965 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbbBOVB0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 16:01:26 -0500
Received: from axis700.grange ([84.44.141.139]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0McEI3-1Y6x2i3SWl-00JcdG for
 <linux-media@vger.kernel.org>; Sun, 15 Feb 2015 22:01:23 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 04B5C40BD9
	for <linux-media@vger.kernel.org>; Sun, 15 Feb 2015 22:01:22 +0100 (CET)
Date: Sun, 15 Feb 2015 22:01:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: one delayed patch for 3.20 or 3.21
Message-ID: <Pine.LNX.4.64.1502152154160.3178@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is just a single patch for a single soc-camera host driver. No rush, 
I presume, you're not planning another 3.20 pull request, in which case it 
will wait until 3.21. But in case you are planning one and you find it 
acceptable to also take this one - here goes. I just missed this patch a 
while ago and wanted to put it up for whatever the next possibility would 
be. Otherwise I suddenly recalled to clean up patchwork (... :)), so, 
instead of 120+ patches for me it now only contains 15 :) I'll be looking 
at them as time permits and preparing more for 3.21 and sending some 
comments to those, that I won't yet find myself sufficiently comfortable 
about.

One more question to you - what about these my 2 patches:

[v4,2/2] V4L: add CCF support to the v4l2_clk API
https://patchwork.linuxtv.org/patch/28111/
[v3,1/2] V4L: remove clock name from v4l2_clk API
https://patchwork.linuxtv.org/patch/28108/

Are they good enough now? Shall I include them in my next pull request or 
would you prefer to take them yourself?

The following changes since commit 48b777c0833bc7392679405539bb5d3ed0900828:

  Merge branch 'patchwork' into to_next (2015-02-10 21:42:33 -0200)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.20-2

for you to fetch changes up to ed1a7b4be588c935cf31447366b005a07d73bb01:

  media: atmel-isi: increase the burst length to improve the performance (2015-02-15 17:28:37 +0100)

----------------------------------------------------------------
Josh Wu (1):
      media: atmel-isi: increase the burst length to improve the performance

 drivers/media/platform/soc_camera/atmel-isi.c | 2 ++
 include/media/atmel-isi.h                     | 4 ++++
 2 files changed, 6 insertions(+)

Thanks
Guennadi
