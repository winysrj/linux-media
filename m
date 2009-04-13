Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32101.mail.mud.yahoo.com ([68.142.207.115]:20047 "HELO
	web32101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750822AbZDMRfS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 13:35:18 -0400
Message-ID: <486508.99603.qm@web32101.mail.mud.yahoo.com>
Date: Mon, 13 Apr 2009 10:28:37 -0700 (PDT)
From: Agustin <gatoguan-os@yahoo.com>
Subject: Testing latest mx3_camera.c
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Guennadi & lists,

Which patchset should one use today to have latest and most stable "mx3_camera" driver in 2.6.29?

Until now, I have been using mx3_camera (/soc_camera) to interface a custom 7.5MPix 12bpp camera on a PCM037 based system running linux 2.6.28-next plus your November 2009 soc_camera patchset. I have also added support for 16 bit data in IDMAC driver though I have tested just 12.

I currently use OSELAS i.MX31 BSP Release 10, that is 2.6.29 plus a patch stack prepared by Sascha Hauer / Pengutronix. On top of that I am applying the "v4l-20090408" series from http://gross-embedded.homelinux.org/~lyakh/v4l-20090408/, with little merging effort.

--
Agustin Ferrin Pozuelo
Embedded Systems Consultant
http://embedded.ferrin.org
Tel. +34 610502587

