Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1KGIVg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Nov 2011 03:21:36 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA78LZmO030273
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Nov 2011 03:21:35 -0500
Message-ID: <4EB79528.60106@redhat.com>
Date: Mon, 07 Nov 2011 09:22:00 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR 3.2 <resend>] Fixes for event framework
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro et all,

Please pull from me tree for the following event framework fixes:

The following changes since commit b82b12633773804713fc10ae5d0006be2b5bf943:

   staging: Move media drivers to staging/media (2011-11-01 23:55:06 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git eventfixes

Hans de Goede (3):
       v4l2-event: Deny subscribing with a type of V4L2_EVENT_ALL
       v4l2-event: Remove pending events from fh event queue when unsubscribing
       v4l2-event: Don't set sev->fh to NULL on unsubscribe

  drivers/media/video/v4l2-ctrls.c |    4 ++--
  drivers/media/video/v4l2-event.c |   10 +++++++++-
  2 files changed, 11 insertions(+), 3 deletions(-)

Thanks & Regards,

Hans
