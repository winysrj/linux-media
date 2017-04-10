Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59284 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751935AbdDJQ55 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 12:57:57 -0400
To: LMML <linux-media@vger.kernel.org>
Cc: Evgeny Plehov <EvgenyPlehov@ukr.net>,
        =?UTF-8?Q?Stefan_Br=c3=bcns?= <stefan.bruens@rwth-aachen.de>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.12] si2157: Si2141 tuner support
Message-ID: <3ad43f2f-33d5-1459-e600-7d5a935aaf19@iki.fi>
Date: Mon, 10 Apr 2017 19:57:48 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patch set replaces existing si2146 support with new one, that looks 
more correct for my eyes.

Antti

The following changes since commit 7ca0ef3da09888b303991edb80cd0283ee641c9e:

   Merge tag 'v4.11-rc5' into patchwork (2017-04-04 11:11:43 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git si2168

for you to fetch changes up to c9110a61811b9349ac64c3e50fd927c580e2eacd:

   si2157: Add support for Si2141-A10 (2017-04-06 16:48:52 +0300)

----------------------------------------------------------------
Antti Palosaari (1):
       si2157: revert si2157: Si2141/2151 tuner support

Stefan Brüns (1):
       si2157: Add support for Si2141-A10

  drivers/media/tuners/si2157.c | 85 
+++++++++++++++++++++++--------------------------------------------------------------
  1 file changed, 23 insertions(+), 62 deletions(-)

-- 
http://palosaari.fi/
