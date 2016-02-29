Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbcB2TVD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 14:21:03 -0500
From: Hans de Goede <hdegoede@redhat.com>
Subject: [PULL fixes for 4.6]: 2 gspca and 1 bttv fix
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Wesley Post <pa4wdh@xs4all.nl>
Message-ID: <56D49A1A.3050300@redhat.com>
Date: Mon, 29 Feb 2016 20:20:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are 2 fixes for gspca and 1 bttv fix for 4.6

The following changes since commit b19581a94fb1c49afc0339a65f1ebd0e4ff80dcd:

   [media] media: au0828 video change to use v4l_enable_media_source() (2016-02-27 09:35:18 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-fixes-for_v4.6

for you to fetch changes up to 8ab527c436d380596dbb7edd503797736ba9cede:

   gspca: Remove unused ovfx2_vga_mode/ovfx2_cif_mode arrays (2016-02-29 20:13:35 +0100)

----------------------------------------------------------------
Hans de Goede (2):
       bttv: Width must be a multiple of 16 when capturing planar formats
       gspca: Remove unused ovfx2_vga_mode/ovfx2_cif_mode arrays

Wesley Post (1):
       gspca: Fix ov519 i2c r/w not working when connected to a xhci host

  drivers/media/pci/bt8xx/bttv-driver.c | 26 ++++++++++++++++-----
  drivers/media/usb/gspca/ov519.c       | 43 ++++++++---------------------------
  drivers/media/usb/gspca/w996Xcf.c     |  8 +++++++
  3 files changed, 37 insertions(+), 40 deletions(-)

Thanks & Regards,

Hans
