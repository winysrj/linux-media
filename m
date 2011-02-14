Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39946 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1BNLL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 06:11:27 -0500
Received: by iyj8 with SMTP id 8so4686823iyj.19
        for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 03:11:27 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 14 Feb 2011 12:11:26 +0100
Message-ID: <AANLkTi=1CFkBG=Ux+fY5ZP+WikRQ-rTqk75PVeSge-DG@mail.gmail.com>
Subject: media-ctl and omap-isp kernel compatibility issue
From: Bastian Hecht <hechtb@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello omap video stack hackers,

some months ago I worked with the mt9p031 sensor from aptina.
Unfortunately had to switch to another video chip and I try to achieve
the same stage as with my old device.
That means the new chip (OV5642) already is up, configured and sends
data over the parallel bus.

I pulled the new media-ctl tool from
git://git.ideasonboard.org/media-ctl.git and compiled it giving the
headers from my kernel pull from
git://gitorious.org/maemo-multimedia/omap3isp-rx51.git (devel)

Some enums are undefined:
media.c:47: error: ‘MEDIA_LINK_FLAG_ACTIVE’ undeclared
media.c:289: error: ‘MEDIA_ENTITY_TYPE_NODE’ undeclared
media.c:290: error: ‘MEDIA_ENTITY_TYPE_SUBDEV’ undeclared


So what repos should I go for these days? Is
git://gitorious.org/maemo-multimedia/omap3isp-rx51.git ok or should I
switch to some other repo? Or is media-ctl just outdated?

Thanks for help,


 Bastian Hecht
