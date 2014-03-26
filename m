Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59032 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbaCZWdP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 18:33:15 -0400
Message-ID: <533355AA.3090305@iki.fi>
Date: Thu, 27 Mar 2014 00:33:14 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Jan Vcelak <jv@fcelda.cz>
Subject: [GIT PULL v3.15] rtl28xxu remove duplicate USB ID
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8432164ddf7bfe40748ac49995356ab4dfda43b7:

   [media] Sensoray 2255 uses videobuf2 (2014-03-24 17:23:43 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl28xxu_id

for you to fetch changes up to d412fb2a4c2effe3b3426330dfd1ee099b6b596f:

   rtl28xxu: remove duplicate ID 0458:707f Genius TVGo DVB-T03 
(2014-03-27 00:20:30 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
       rtl28xxu: remove duplicate ID 0458:707f Genius TVGo DVB-T03

  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 --
  1 file changed, 2 deletions(-)


-- 
http://palosaari.fi/
