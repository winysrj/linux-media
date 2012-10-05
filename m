Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49364 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab2JEXPm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 19:15:42 -0400
Message-ID: <506F6A05.1080004@iki.fi>
Date: Sat, 06 Oct 2012 02:15:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>
Subject: [GIT PULL FOR v3.7] small cxd2820r correction
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit e32087bcc4daa29fd30cf7742ef9b522625a1690:

   [media] davinci: vpbe: replace V4L2_OUT_CAP_CUSTOM_TIMINGS with 
V4L2_OUT_CAP_DV_TIMINGS (2012-10-05 14:29:20 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.7_mauro-6

for you to fetch changes up to 345169a767696a1e54168d9f8a8581faeca23327:

   cxd2820r: silence compiler warning (2012-10-06 02:11:14 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       cxd2820r: silence compiler warning

  drivers/media/dvb-frontends/cxd2820r_core.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)


-- 
http://palosaari.fi/

