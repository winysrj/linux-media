Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab2KUO5L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 09:57:11 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qALEvBjB004846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 21 Nov 2012 09:57:11 -0500
Received: from shalem.localdomain (vpn1-6-145.ams2.redhat.com [10.36.6.145])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qALEv9L1031210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 21 Nov 2012 09:57:10 -0500
Message-ID: <50ACEC40.3080504@redhat.com>
Date: Wed, 21 Nov 2012 15:59:12 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.8] <resend> Miscellaneous fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for a bunch of miscellaneous fixes for 3.8 .

The following changes since commit 8f7e91a31fb95c50880c76505b416630c0326d93:

   [media] smiapp-pll: Constify limits argument to smiapp_pll_calculate() (2012-10-29 09:51:38 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.8

for you to fetch changes up to e103a482eb63e89a749bab5b6cd645e2c7146346:

   gspca-sonixb: Add USB-id for Genius Eye 310 (2012-11-04 22:33:10 +0100)

----------------------------------------------------------------
Frank Schäfer (2):
       gspca_pac7302: correct register documentation
       gspca_pac7302: use registers 0x01 and 0x03 for red and blue balance controls

Hans de Goede (4):
       pwc: Fix codec1 cameras no longer working
       MAINTAINERS: Add entries for the radioShark and radioShark2 drivers
       MAINTAINERS: Add an entry for the pwc webcam driver
       gspca-sonixb: Add USB-id for Genius Eye 310

  MAINTAINERS                       | 22 ++++++++++++++
  drivers/media/usb/gspca/pac7302.c | 62 ++++++++++++++++++++++++++++-----------
  drivers/media/usb/gspca/sonixb.c  |  1 +
  drivers/media/usb/pwc/pwc-ctrl.c  |  2 ++
  4 files changed, 70 insertions(+), 17 deletions(-)

Thanks & Regards,

Hans
