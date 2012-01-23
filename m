Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2AWJb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 04:31:29 -0500
Date: Mon, 23 Jan 2012 10:31:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] a fix for 3.3
Message-ID: <Pine.LNX.4.64.1201231030050.11184@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

The following change since commit 9e5e3097a3febbf317abc6d1b07bc6c33b20c279:

  [media] az6007: CodingStyle fixes (2012-01-21 13:52:39 -0200)

is available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.3-rc1-fixes

Josh Wu (1):
      V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions

 drivers/media/video/atmel-isi.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
