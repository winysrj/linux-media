Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48458 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270AbbERUYS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 16:24:18 -0400
Message-ID: <555A4A6F.6030305@iki.fi>
Date: Mon, 18 May 2015 23:24:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [GIT PULL 4.2] rtl2832_sdr: cleanup some set_bit() calls
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 9cae84b32dd52768cf2fd2fcb214c3f570676c4b:

   [media] DocBook/media: fix syntax error (2015-05-18 16:27:31 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl2832_sdr_pull

for you to fetch changes up to cc16cc8dbd7e34e7c3e01d5967da8de0f488be7f:

   rtl2832_sdr: cleanup some set_bit() calls (2015-05-18 23:19:43 +0300)

----------------------------------------------------------------
Dan Carpenter (1):
       rtl2832_sdr: cleanup some set_bit() calls

  drivers/media/dvb-frontends/rtl2832_sdr.c | 10 +++++-----
  1 file changed, 5 insertions(+), 5 deletions(-)

-- 
http://palosaari.fi/
