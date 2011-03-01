Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1CANVU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:21:20 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p21DLKtY015168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:21:20 -0500
Received: from pedra (vpn-225-140.phx2.redhat.com [10.3.225.140])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p21DIEb9025546
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:21:19 -0500
Date: Tue, 1 Mar 2011 10:18:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] Fix the remaining VIDIOC_*_OLD bits
Message-ID: <20110301101800.2775bfff@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The VIDIOC_*_OLD ioctls passed away, but there are still some places
that thinks that they're still alive. Tell them about the death of
those legacy stuff.

Mauro Carvalho Chehab (3):
  matrox: Remove legacy VIDIOC_*_OLD ioctls
  [media] videodev2.h.xml: Update to reflect videodev2.h changes
  [media] DocBook: Document the removal of the old VIDIOC_*_OLD ioctls

 Documentation/DocBook/v4l/compat.xml      |   20 +++--
 Documentation/DocBook/v4l/videodev2.h.xml |  141 ++++++++++++++++++++++++++---
 drivers/video/matrox/matroxfb_base.c      |    3 -
 3 files changed, 143 insertions(+), 21 deletions(-)

