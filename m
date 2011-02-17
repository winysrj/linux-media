Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab1BQKDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 05:03:30 -0500
Message-ID: <4D5CEF80.2050807@redhat.com>
Date: Thu, 17 Feb 2011 10:50:56 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Brian Johnson <brijohn@gmail.com>
Subject: [GIT PATCHES FOR 2.6.39] gspca_sn9c20x fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Please pull from my gspca tree, for some gspca_sn9c20x fixes
I've been doing.

The following changes since commit 5ed4bbdae09d207d141759e013a0f3c24ae76ecc:

   [media] tuner-core: Don't touch at standby during tuner_lookup (2011-02-15 10:31:01 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git gspca-for_v2.6.39

Hans de Goede (5):
       gspca_sn9c20x: Fix colored borders with ov7660 sensor
       gspca_sn9c20x: Add hflip and vflip controls for the ov7660 sensor
       gspca_sn9c20x: Add LED_REVERSE flag for 0c45:62bb
       gspca_sn9c20x: Make buffers slightly larger for JPEG frames
       gspca_sn9c20x: Add another MSI laptop to the sn9c20x upside down list

  drivers/media/video/gspca/sn9c20x.c |   40 ++++++++++++++++++++++++++--------
  1 files changed, 30 insertions(+), 10 deletions(-)

Thanks,

Hans
