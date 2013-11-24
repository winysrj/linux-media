Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3KXNPh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 08:15:37 -0500
Message-ID: <5291FBF3.8060003@redhat.com>
Date: Sun, 24 Nov 2013 14:15:31 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Geert Stappers <stappers@stappers.nl>, mjs <mjstork@gmail.com>
Subject: [GIT PULL FIXES for 3.13] 2 small gspca and 2 small radio-shark fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is a resend of my pull-req from a few minutes ago. I had
made an error in the Cc: stable (I used linux.org instead of kernel.org),
this pull-req is for the fixed commit (up to commit id changed).

This pull-req supersedes my previous GIT PULL FIXES for 3.13, new
in this pull-req is an additional usb-id for the gspca_sunplus
driver.

Please pull from my tree for 4 small fixes for 3.13 :

The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

   [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.13

for you to fetch changes up to da7e5a168b689da740d7c63cb26cbb8a05a4fc5d:

   gspca_sunplus: Add new usb-id for 06d6:0041 (2013-11-24 14:12:18 +0100)

----------------------------------------------------------------
Geert Uytterhoeven (1):
       radio-shark: Mark shark_resume_leds() inline to kill compiler warning

Hans de Goede (2):
       radio-shark2: Mark shark_resume_leds() inline to kill compiler warning
       gspca_sunplus: Add new usb-id for 06d6:0041

Ondrej Zary (1):
       gspca-stk1135: Add delay after configuring clock

  drivers/media/radio/radio-shark.c  | 2 +-
  drivers/media/radio/radio-shark2.c | 2 +-
  drivers/media/usb/gspca/stk1135.c  | 3 +++
  drivers/media/usb/gspca/sunplus.c  | 1 +
  4 files changed, 6 insertions(+), 2 deletions(-)

Thanks & Regards,

Hans
