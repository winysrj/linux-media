Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57706 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbaEDWNZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 May 2014 18:13:25 -0400
Message-ID: <5366BB83.7050807@iki.fi>
Date: Mon, 05 May 2014 01:13:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Brian Healy <healybrian@gmail.com>,
	Alessandro Miceli <angelofsky1980@gmail.com>
Subject: [GIT PULL 3.15] RTL2832U USB IDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is 3 new USB IDs for RTL28XXU driver and nothing more. These should 
be OK for 3.15 at that phase of RC cycle.

regards
Antti



The following changes since commit 8845cc6415ec28ef8d57b3fb81c75ef9bce69c5f:

   [media] fc2580: fix tuning failure on 32-bit arch (2014-04-16 
18:13:11 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl2832u_id

for you to fetch changes up to 5fc42f2a0cc20a558b31993f80d68e443388d307:

   rtl28xxu: add [1b80:d3af] Sveon STV27 (2014-05-05 01:03:56 +0300)

----------------------------------------------------------------
Alessandro Miceli (2):
       rtl28xxu: add [1b80:d39d] Sveon STV20
       rtl28xxu: add [1b80:d3af] Sveon STV27

Brian Healy (1):
       rtl28xxu: add 1b80:d395 Peak DVB-T USB

  drivers/media/dvb-core/dvb-usb-ids.h    | 2 ++
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 6 ++++++
  2 files changed, 8 insertions(+)

-- 
http://palosaari.fi/
