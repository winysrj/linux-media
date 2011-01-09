Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1AILvU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 06:51:20 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p09BpK7V018284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 9 Jan 2011 06:51:20 -0500
Received: from shalem.localdomain (vpn2-8-32.ams2.redhat.com [10.36.8.32])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p09BpImw025388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 Jan 2011 06:51:19 -0500
Message-ID: <4D29A300.5070404@redhat.com>
Date: Sun, 09 Jan 2011 12:58:56 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38-rc1] gspca locking fixes and moving over
 usb-ids to sonix? drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Here is a new pull request including all the patches from my previous request:

"Please pull from my tree for a number of gspca core fixes. While looking
into the issue you were seeing with qv4l2 I also found a bug in the
gspca core which made it impossible to switch from userptr to mmap
mode with qv4l2 and gspca. While fixing that I also ended up fixing
some locking issues."

On top of that there are patches removing non supported bogus /
non supported usb-ids from Luca's et61x251 and sn9xc102 drivers.
Combined with some fixes / bridge variant unification patches
to the gspca sonixb and sonixj drivers allowing moving most
usb-ids to use gspca sonix? by default.

I've asked J.F. Moine to review all these patches and he has
and responded to me with an Acked-By email hence the Acked-By
tag on all of them. Except for the last one which I did after
he reviewed the 2 patch sets.

The following changes since commit 0a97a683049d83deaf636d18316358065417d87b:

   [media] cpia2: convert .ioctl to .unlocked_ioctl (2011-01-06 11:34:41 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git for_2.6.38-rc1

Hans de Goede (19):
       gspca_main: Locking fixes 1
       gspca_main: Locking fixes 2
       gspca_main: Update buffer flags even when user_copy fails
       gspca_main: Remove no longer used users variable
       gspca_main: Set memory type to GSPCA_MEMORY_NO on buffer release
       gspca_main: Simplify read mode memory type checks
       gspca_main: Allow switching from read to mmap / userptr mode
       gspca_main: wake wq on streamoff
       et61x251: remove wrongly claimed usb ids
       sn9c102: Remove not supported and non existing usb ids
       gspca_sonixb: Refactor to unify bridge handling
       gspca_sonixb: Adjust autoexposure window for vga cams so that it is centered
       gspca_sonixb: Fix TAS5110D sensor gain control
       gspca_sonixb: TAS5130C brightness control really is a gain control
       gspca_sonixb: Add usb ids for known sn9c103 cameras
       gspca_sonixj: Enable more usb ids when sn9c102 gets compiled too
       gspca_sonixj: Probe sensor type independent of bridge type
       gspca_sonixj: Add one more commented out usb-id
       gspca_sonixb: Fix mirrored image with ov7630

  drivers/media/video/et61x251/et61x251.h        |   24 --
  drivers/media/video/gspca/gspca.c              |  208 +++++++++----------
  drivers/media/video/gspca/gspca.h              |    2 -
  drivers/media/video/gspca/sonixb.c             |  266 ++++++++++++++----------
  drivers/media/video/gspca/sonixj.c             |   63 +++---
  drivers/media/video/sn9c102/sn9c102_devtable.h |   74 +++----
  6 files changed, 311 insertions(+), 326 deletions(-)

Thanks & Regards,

Hans
