Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47104 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750721AbdAWJDZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 04:03:25 -0500
To: LMML <linux-media@vger.kernel.org>
Cc: Chris Rankin <rankincj@gmail.com>,
        =?UTF-8?B?SMOla2FuIExlbm5lc3TDpWw=?= <hakan.lennestal@gmail.com>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.10] fix cxd2820r 4.9 regression
Message-ID: <019fdc86-10a5-037a-1683-26b949757c21@iki.fi>
Date: Mon, 23 Jan 2017 11:03:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d183e4efcae8d88a2f252e546978658ca6d273cc:

   [media] v4l: tvp5150: Add missing break in set control handler 
(2016-12-12 07:49:58 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git cxd2820r

for you to fetch changes up to 783d933cf02e970b49e0dcb586a76207aa6fa331:

   cxd2820r: fix gpio null pointer dereference (2017-01-23 10:40:17 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       cxd2820r: fix gpio null pointer dereference

  drivers/media/dvb-frontends/cxd2820r_core.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
http://palosaari.fi/
