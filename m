Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46138 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbaCNToL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 15:44:11 -0400
Received: from dyn3-82-128-190-236.psoas.suomi.net ([82.128.190.236] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1WOY1a-0004MU-Pv
	for linux-media@vger.kernel.org; Fri, 14 Mar 2014 21:44:10 +0200
Message-ID: <53235C0A.5010402@iki.fi>
Date: Fri, 14 Mar 2014 21:44:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] AF9035/AF9033 PID filter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ba35ca07080268af1badeb47de0f9eff28126339:

   [media] em28xx-audio: make sure audio is unmuted on open() 
(2014-03-14 10:17:18 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9033_pid_filter

for you to fetch changes up to 370264fd6a8391ba5a51986ccf8bc9a2267efeb8:

   af9033: Don't export functions for the hardware filter (2014-03-14 
21:33:13 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
       af9033: implement PID filter
       af9035: use af9033 PID filters

Mauro Carvalho Chehab (1):
       af9033: Don't export functions for the hardware filter

  drivers/media/dvb-frontends/af9033.c  | 59 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
  drivers/media/dvb-frontends/af9033.h  | 34 
++++++++++++++++++++++++++++++----
  drivers/media/usb/dvb-usb-v2/af9035.c | 63 
+++++++++++++--------------------------------------------------
  drivers/media/usb/dvb-usb-v2/af9035.h |  2 ++
  4 files changed, 103 insertions(+), 55 deletions(-)

-- 
http://palosaari.fi/
