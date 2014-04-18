Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRJ7t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 05:59:49 -0400
Message-ID: <5350F792.4010903@redhat.com>
Date: Fri, 18 Apr 2014 11:59:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Robert Butora <robert.butora.fi@gmail.com>
Subject: [GIT PULL patches for 3.16] media:gspca:dtcs033 Clean sparse check
 warnings on endianess
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my gspca git tree for a gspca fix for some sparse errors.

The following changes since commit 701b57ee3387b8e3749845b02310b5625fbd8da0:

  [media] vb2: Add videobuf2-dvb support (2014-04-16 18:59:29 -0300)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.16

for you to fetch changes up to f1262be04ca6bfc57d13b21b247c3d9f6818caff:

  media:gspca:dtcs033 Clean sparse check warnings on endianess (2014-04-18 11:31:50 +0200)

----------------------------------------------------------------
Robert Butora (1):
      media:gspca:dtcs033 Clean sparse check warnings on endianess

 drivers/media/usb/gspca/dtcs033.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)
Thanks & Regards,

Hans
