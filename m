Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:44537 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab1AHBRg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 20:17:36 -0500
Message-ID: <4D27BB29.9010302@iki.fi>
Date: Sat, 08 Jan 2011 03:17:29 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
CC: Romolo Manfredini <romoloman@hotmail.com>,
	Alireza Moini <alireza.moini@silverbrookresearch.com>
Subject: [GIT PULL FOR 2.6.38] af9013 IF config fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moi Mauro,

PULL that bug fix to the 2.6.38

t. Antti


The following changes since commit 0a97a683049d83deaf636d18316358065417d87b:

   [media] cpia2: convert .ioctl to .unlocked_ioctl (2011-01-06 11:34:41 
-0200)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9015

Antti Palosaari (1):
       af9013: fix AF9013 TDA18271 IF config

  drivers/media/dvb/frontends/af9013.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

-- 
http://palosaari.fi/
