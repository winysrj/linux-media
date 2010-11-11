Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab0KKNd0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 08:33:26 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oABDXQt4003176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 08:33:26 -0500
Received: from pedra (vpn-228-194.phx2.redhat.com [10.3.228.194])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oABDXNjW027735
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 08:33:25 -0500
Date: Thu, 11 Nov 2010 11:33:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] Fix some troubles with cx231xx-input
Message-ID: <20101111113316.5115f96b@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those patches fix a few troubles with cx231xx-input.

Mauro Carvalho Chehab (2):
  [media] rc: Allow specifying properties for i2c IR's
  [media] cx231xx: Don't register remote controls twice

 drivers/media/video/cx231xx/Kconfig         |    2 +-
 drivers/media/video/cx231xx/cx231xx-input.c |   47 +++++++--------------------
 drivers/media/video/cx231xx/cx231xx.h       |   13 +-------
 drivers/media/video/ir-kbd-i2c.c            |    4 ++-
 include/media/ir-kbd-i2c.h                  |    2 +
 5 files changed, 19 insertions(+), 49 deletions(-)

