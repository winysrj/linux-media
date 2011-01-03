Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:8379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178Ab1ACQGy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 11:06:54 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p03G6sW4001801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 11:06:54 -0500
Received: from shalem.localdomain (vpn2-11-166.ams2.redhat.com [10.36.11.166])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p03G6qEj030812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 11:06:53 -0500
Message-ID: <4D21F5C2.5090309@redhat.com>
Date: Mon, 03 Jan 2011 17:13:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] gspca core fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Please pull from my tree for a number of gspca core fixes. While looking
into the issue you were seeing with qv4l2 I also found a bug in the
gspca core which made it impossible to switch from userptr to mmap
mode with qv4l2 and gspca. While fixing that I also ended up fixing
some locking issues. All the gspca core patches have been reviewed
by J.F. Moine.

This pull request also includes a patch for removing all the bogus
usb-ids from the et61x251 driver as discussed.

The following changes since commit 187134a5875df20356f4dca075db29f294115a47:

   [media] DVB: IR support for TechnoTrend CT-3650 (2010-12-31 09:10:24 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git for_v2.6.38

Hans de Goede (9):
       gspca_main: Locking fixes 1
       gspca_main: Locking fixes 2
       gspca_main: Update buffer flags even when user_copy fails
       gspca_main: Remove no longer used users variable
       gspca_main: Set memory type to GSPCA_MEMORY_NO on buffer release
       gspca_main: Simplify read mode memory type checks
       gspca_main: Allow switching from read to mmap / userptr mode
       gspca_main: wake wq on streamoff
       et61x251: remove wrongly claimed usb ids

  drivers/media/video/et61x251/et61x251.h |   24 ----
  drivers/media/video/gspca/gspca.c       |  208 ++++++++++++++-----------------
  drivers/media/video/gspca/gspca.h       |    2 -
  3 files changed, 94 insertions(+), 140 deletions(-)

Regards,

Hans
