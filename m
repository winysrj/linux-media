Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab2IIVyV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 17:54:21 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q89LsK5r015329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 9 Sep 2012 17:54:20 -0400
Received: from shalem.localdomain (vpn1-5-140.ams2.redhat.com [10.36.5.140])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q89LsJJX025456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 Sep 2012 17:54:20 -0400
Message-ID: <504D1054.1080305@redhat.com>
Date: Sun, 09 Sep 2012 23:55:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.7]: shark 1 & 2 / tea575x & tea5777 AM support +
 misc gspca fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my media-for_v3.7 branch for AM frequency band support
for the shark 1 & 2 / tea575x & tea5777 AM support, as well as various
gspca and 2 pwc fixes.

The following changes since commit 79e8c7bebb467bbc3f2514d75bba669a3f354324:

   Merge tag 'v3.6-rc3' into staging/for_v3.7 (2012-08-24 11:25:10 -0300)

are available in the git repository at:


   git://linuxtv.org/hgoede/gspca.git media-for_v3.7

for you to fetch changes up to f16eef4206a3b155451d3fde19c5f4411ba5516e:

   gspca_pac7302: extend register documentation (2012-09-09 23:14:04 +0200)

----------------------------------------------------------------
Emil Goode (1):
       gspca: dubious one-bit signed bitfield

Ezequiel Garcia (2):
       pwc: Use vb2 queue mutex through a single name
       pwc: Remove unneeded struct vb2_queue clearing

Frank Schäfer (6):
       gspca_pac7302: add support for device 1ae7:2001 Speedlink Snappy Microphone SL-6825-SBK
       gspca_pac7302: make red balance and blue balance controls work again
       gspca_pac7302: add sharpness control
       gspca_pac7302: increase default value for white balance temperature
       gspca_pac7302: avoid duplicate calls of the image quality adjustment functions on capturing start
       gspca_pac7302: extend register documentation

Hans de Goede (10):
       media-api-docs: Documented V4L2_TUNER_CAP_HWSEEK_PROG_LIM in G_TUNER docs
       snd_tea575x: Add support for tuning AM
       radio-tea5777.c: Get rid of do_div usage
       radio-tea5777: Add support for tuning AM
       radio-shark2: Add support for suspend & resume
       radio-shark: Add support for suspend & resume
       gspca: Don't set gspca_dev->dev to NULL before stop0
       gspca_finepix: Remove unnecessary lock/unlock call
       gspca: Update / fix various comments wrt workqueue usb_lock usage
       gspca: Fix input urb creation / destruction surrounding suspend resume

Peter Senna Tschudin (1):
       drivers/media/usb/gspca/cpia1.c: fix error return code

  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   6 +
  drivers/media/radio/radio-shark.c                  |  44 ++++-
  drivers/media/radio/radio-shark2.c                 |  39 ++++
  drivers/media/radio/radio-tea5777.c                | 197 +++++++++++++++-----
  drivers/media/radio/radio-tea5777.h                |   3 +
  drivers/media/usb/gspca/cpia1.c                    |   2 +-
  drivers/media/usb/gspca/finepix.c                  |  18 +-
  drivers/media/usb/gspca/gspca.c                    |  12 +-
  drivers/media/usb/gspca/jl2005bcd.c                |  18 +-
  drivers/media/usb/gspca/ov519.c                    |  16 +-
  drivers/media/usb/gspca/pac7302.c                  |  47 +++--
  drivers/media/usb/gspca/sn9c20x.c                  |   2 +
  drivers/media/usb/gspca/sonixj.c                   |   2 +
  drivers/media/usb/gspca/sq905.c                    |  19 +-
  drivers/media/usb/gspca/sq905c.c                   |  18 +-
  drivers/media/usb/gspca/vicam.c                    |  17 +-
  drivers/media/usb/gspca/xirlink_cit.c              |   4 +-
  drivers/media/usb/gspca/zc3xx.c                    |   8 +-
  drivers/media/usb/pwc/pwc-if.c                     |   3 +-
  include/sound/tea575x-tuner.h                      |   4 +
  sound/i2c/other/tea575x-tuner.c                    | 200 +++++++++++++++++----
  21 files changed, 519 insertions(+), 160 deletions(-)

Thanks & Regards,

Hans
