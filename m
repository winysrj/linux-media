Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab2D1NvR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 09:51:17 -0400
Message-ID: <4F9BF665.9000909@redhat.com>
Date: Sat, 28 Apr 2012 15:53:41 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>
Subject: [GIT PULL FOR 3.5] gspca_pac73XX improvements + misc fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro et al,

Please pull from my tree for a bunch of gspca_pac73XX
improvements and 1 other webcam driver fix.

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

   [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.5

for you to fetch changes up to c9b5378afdfc2fa3eecae2cf8d2e20c40e60496c:

   gspca_pac7302: Improve the gain control (2012-04-28 15:37:59 +0200)

----------------------------------------------------------------
Hans de Goede (12):
       stk-webcam: Don't flip the image by default
       gspca/autogain_functions.h: Allow users to declare what they want
       gspca_pac73xx: Remove comments from before the 7302 / 7311 separation
       gspca_pac7311: Make sure exposure changes get applied immediately
       gspca_pac7311: Adjust control scales to match registers
       gspca_pac7311: Switch to new gspca control mechanism
       gspca_pac7311: Switch to coarse expo autogain algorithm
       gspca_pac7311: Convert multi-line comments to standard kernel style
       gspca_pac7311: Properly set the compression balance
       gspca_pac7302: Convert multi-line comments to standard kernel style
       gspca_pac7302: Document some more registers
       gspca_pac7302: Improve the gain control

  drivers/media/video/gspca/autogain_functions.h |    6 +-
  drivers/media/video/gspca/nw80x.c              |    2 +
  drivers/media/video/gspca/pac7302.c            |  184 +++++++-----
  drivers/media/video/gspca/pac7311.c            |  380 +++++++-----------------
  drivers/media/video/gspca/sonixb.c             |    2 +
  drivers/media/video/gspca/sonixj.c             |    5 +-
  drivers/media/video/gspca/topro.c              |    6 +-
  drivers/media/video/stk-webcam.c               |    8 +-
  8 files changed, 239 insertions(+), 354 deletions(-)

Thanks & Regards,

Hans
