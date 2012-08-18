Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2HRPlH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 11:41:07 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7IFf7t6021692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 18 Aug 2012 11:41:07 -0400
Received: from shalem.localdomain (vpn1-7-51.ams2.redhat.com [10.36.7.51])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q7IFf5YR012629
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 18 Aug 2012 11:41:07 -0400
Message-ID: <502FB7D4.1090200@redhat.com>
Date: Sat, 18 Aug 2012 17:42:12 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.7] Misc. fixes + shark improvements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for a bunch of assorted fixes, as well
as AM tuning and suspend/resume for the radio-shark and radio-shark2
drivers.

The following changes since commit 9b78c5a3007e10a172d4e83bea18509fdff2e8e3:

   [media] b2c2: export b2c2_flexcop_debug symbol (2012-08-17 11:09:19 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.7-wip

for you to fetch changes up to 7fd59dce24e2c57d2537ec827e0c7e09c7c1e77b:

   media-api-docs: Documented V4L2_TUNER_CAP_HWSEEK_PROG_LIM in G_TUNER docs (2012-08-18 17:35:48 +0200)

----------------------------------------------------------------
Emil Goode (1):
       gspca: dubious one-bit signed bitfield

Ezequiel Garcia (1):
       pwc: Use vb2 queue mutex through a single name

Hans de Goede (10):
       radio-shark*: Remove work-around for dangling pointer in usb intfdata
       radio-shark*: Call cancel_work_sync from disconnect rather then release
       radio-shark: Only compile led support when CONFIG_LED_CLASS is set
       radio-shark2: Only compile led support when CONFIG_LED_CLASS is set
       snd_tea575x: Add support for tuning AM
       radio-tea5777.c: Get rid of do_div usage
       radio-tea5777: Add support for tuning AM
       radio-shark2: Add support for suspend & resume
       radio-shark: Add support for suspend & resume
       media-api-docs: Documented V4L2_TUNER_CAP_HWSEEK_PROG_LIM in G_TUNER docs

  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   6 +
  drivers/media/radio/radio-shark.c                  | 195 ++++++++++++--------
  drivers/media/radio/radio-shark2.c                 | 176 +++++++++++-------
  drivers/media/radio/radio-tea5777.c                | 197 +++++++++++++++-----
  drivers/media/radio/radio-tea5777.h                |   3 +
  drivers/media/usb/gspca/ov519.c                    |  16 +-
  drivers/media/usb/pwc/pwc-if.c                     |   2 +-
  include/sound/tea575x-tuner.h                      |   4 +
  sound/i2c/other/tea575x-tuner.c                    | 200 +++++++++++++++++----
  9 files changed, 570 insertions(+), 229 deletions(-)

Thanks,

Hans
