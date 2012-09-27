Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39820 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab2I0WPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 18:15:34 -0400
Message-ID: <5064CFEF.7040301@iki.fi>
Date: Fri, 28 Sep 2012 01:15:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] all the rest patches!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
New attempt. I really want that "PCTV 520e workaround for DRX-K fw 
loading" in too or find out other fix quickly. I have answered too many 
bug reports according to it currently. Will take debugs now...

regards
Antti


The following changes since commit 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:

   [media] media: mx2_camera: use managed functions to clean up code 
(2012-09-27 15:56:47 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.7_mauro-2

for you to fetch changes up to 2baf1e9dd547402b8a5748e66f894af9c6a2789a:

   em28xx: PCTV 520e workaround for DRX-K fw loading (2012-09-28 
01:06:38 +0300)

----------------------------------------------------------------
Antti Palosaari (4):
       em28xx: implement FE set_lna() callback
       cxd2820r: use static GPIO config when GPIOLIB is undefined
       em28xx: do not set PCTV 290e LNA handler if fe attach fail
       em28xx: PCTV 520e workaround for DRX-K fw loading

  drivers/media/dvb-frontends/cxd2820r_core.c | 29 
++++++++++++++++++++---------
  drivers/media/usb/em28xx/em28xx-dvb.c       | 61 
++++++++++++++++++++++++++++++++++++++++++++++++++-----------
  2 files changed, 70 insertions(+), 20 deletions(-)


-- 
http://palosaari.fi/

