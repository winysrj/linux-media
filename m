Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590AbbFWJyE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 05:54:04 -0400
Message-ID: <55892CBA.2070609@redhat.com>
Date: Tue, 23 Jun 2015 11:54:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PULL fixes for 4.3]: gspca minor fixes
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are 2 minor fixes for gspca for 4.3.

The following changes since commit 77a3c6fd90c94f635edb00d4a65f485687538791:

   [media] vb2: Don't WARN when v4l2_buffer.bytesused is 0 for multiplanar buffers (2015-06-22 09:52:58 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v4.3

for you to fetch changes up to 08cf79c93ec8568738b8e7db5e63278e43721850:

   gscpa_m5602: use msecs_to_jiffies for conversions (2015-06-23 11:50:27 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
       gspca: sn9c2028: remove an unneeded condition

Nicholas Mc Guire (1):
       gscpa_m5602: use msecs_to_jiffies for conversions

  drivers/media/usb/gspca/m5602/m5602_s5k83a.c | 2 +-
  drivers/media/usb/gspca/sn9c2028.c           | 2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

Thanks & Regards,

Hans
