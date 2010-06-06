Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab0FFOxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:44 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o56ErhAf025693
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 6 Jun 2010 10:53:43 -0400
Received: from pedra (vpn-11-208.rdu.redhat.com [10.11.11.208])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o56EraZD031853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 6 Jun 2010 10:53:42 -0400
Date: Sun, 6 Jun 2010 11:53:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] tm6000-alsa: Implement fillbuf
Message-ID: <20100606115313.475eba6c@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series fixes some bugs at alsa initialization that were leading into
passing a wrong pointer into alsa PCM substream private_data, causing oopses
at start/stop stream.

It also implements a routine to fill the alsa buffers when data is received
at the URB handler.

Note: I tested here with both tm6010 and tm5600 devices. The number of "audio"
packets is incredibly small, meaning that or the audio packets aren't properly
decoded, or there are still bugs at the copy_streams() routine. Maybe Stefan
or Dmitri can double check what's going wrong there.

Mauro Carvalho Chehab (2):
  tm6000-alsa: Fix several bugs at the driver initialization code
  tm6000-alsa: Implement a routine to store data received from URB

 drivers/staging/tm6000/tm6000-alsa.c |  105 +++++++++++++++++++++++-----------
 drivers/staging/tm6000/tm6000-core.c |    6 +-
 drivers/staging/tm6000/tm6000.h      |    5 +-
 3 files changed, 78 insertions(+), 38 deletions(-)

