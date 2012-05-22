Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab2EVJxU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 05:53:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4M9rKWa005359
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 May 2012 05:53:20 -0400
Received: from shalem.localdomain (vpn1-4-86.ams2.redhat.com [10.36.4.86])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q4M9rIou004409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 22 May 2012 05:53:20 -0400
Message-ID: <4FBB6213.2050705@redhat.com>
Date: Tue, 22 May 2012 11:53:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FIXES FOR 3.5]: gspca & radio fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro et al,

Here is a bunch of fixes for gspca and a couple of fixes for
good old radio support :)

The following changes since commit abed623ca59a7d1abed6c4e7459be03e25a90a1e:

   [media] radio-sf16fmi: add support for SF16-FMD (2012-05-20 16:10:05 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.5

for you to fetch changes up to fd27a1221e9e01d221d255f9159c7006fb2308b6:

   gspca_ov534: make AGC and AWB controls independent (2012-05-22 09:23:58 +0200)

----------------------------------------------------------------
Antonio Ospite (1):
       gspca_ov534: make AGC and AWB controls independent

Hans de Goede (9):
       radio/si470x: Add support for the Axentia ALERT FM USB Receiver
       snd_tea575x: Report correct frequency range for EU/US versus JA models
       snd_tea575x: Make the module using snd_tea575x the fops owner
       snd_tea575x: set_freq: update cached freq to the actual achieved frequency
       bttv: Use btv->has_radio rather then the card info when registering the tuner
       bttv: Remove unused needs_tvaudio card variable
       bttv: The Hauppauge 61334 needs the msp3410 to do radio demodulation
       gspca_pac7311: Correct number of controls
       gscpa_sn9c20x: Move clustering of controls to after error checking

  drivers/hid/hid-core.c                        |    1 +
  drivers/hid/hid-ids.h                         |    3 +
  drivers/media/radio/radio-maxiradio.c         |    2 +-
  drivers/media/radio/radio-sf16fmr2.c          |    2 +-
  drivers/media/radio/si470x/radio-si470x-usb.c |    2 +
  drivers/media/video/bt8xx/bttv-cards.c        |   84 ++-----------------------
  drivers/media/video/bt8xx/bttv-driver.c       |    5 ++
  drivers/media/video/bt8xx/bttv.h              |    1 -
  drivers/media/video/bt8xx/bttvp.h             |    1 +
  drivers/media/video/gspca/ov534.c             |   31 +--------
  drivers/media/video/gspca/pac7311.c           |    2 +-
  drivers/media/video/gspca/sn9c20x.c           |   24 ++++---
  include/sound/tea575x-tuner.h                 |    3 +-
  sound/i2c/other/tea575x-tuner.c               |   21 ++++---
  sound/pci/es1968.c                            |    2 +-
  sound/pci/fm801.c                             |    4 +-
  16 files changed, 56 insertions(+), 132 deletions(-)

Regards,

Hans
