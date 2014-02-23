Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaBWWQg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 17:16:36 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1NMGaRX019470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 23 Feb 2014 17:16:36 -0500
Received: from shalem.localdomain (vpn1-7-93.ams2.redhat.com [10.36.7.93])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s1NMGYY0009198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 23 Feb 2014 17:16:35 -0500
Message-ID: <530A7342.5090300@redhat.com>
Date: Sun, 23 Feb 2014 23:16:34 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL PATCHES for 3.15] Various small gspca fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 5 small gspca fixes. Note one of them only adds a usb-id
it would be good to add this one to your 3.14-fixes tree too.

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.15

for you to fetch changes up to fe16a198c7ddd6fd198ddbbb8f4b7303e176e216:

  gspca_topro: Add a couple of missing length check in the packet parsing code (2014-02-23 23:01:58 +0100)

----------------------------------------------------------------
Antonio Ospite (2):
      gspca_kinect: fix kinect_read() error path
      gspca_kinect: fix messages about kinect_read() return value

Dan Carpenter (1):
      gspca_stv06xx: remove an unneeded check

Hans de Goede (1):
      gspca_topro: Add a couple of missing length check in the packet parsing code

Wolfram Sang (1):
      media: gspca: sn9c20x: add ID for Genius Look 1320 V2

 Documentation/video4linux/gspca.txt              |  1 +
 drivers/media/usb/gspca/kinect.c                 |  7 ++++---
 drivers/media/usb/gspca/sn9c20x.c                |  1 +
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c |  2 +-
 drivers/media/usb/gspca/topro.c                  | 10 +++++++++-
 5 files changed, 16 insertions(+), 5 deletions(-)

Thanks & Regards,

hans
