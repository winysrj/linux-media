Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab3HWOMj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 10:12:39 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7NECdiF029234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 23 Aug 2013 10:12:39 -0400
Received: from shalem.localdomain (vpn1-5-68.ams2.redhat.com [10.36.5.68])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7NECbFX007488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 23 Aug 2013 10:12:38 -0400
Message-ID: <52176DD5.2090700@redhat.com>
Date: Fri, 23 Aug 2013 16:12:37 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FIXES for 3.12] One small gspca ov519 driver bugfix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is one more small bugfix for 3.12:

The following changes since commit 976f375df1730dd16aa7c101298ec47bdd338d79:

   [media] media/v4l2: VIDEO_SH_VEU should depend on HAS_DMA (2013-08-23 05:46:08 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.12

for you to fetch changes up to 6afea7c75d95e379019bbe68326b668bcca8f473:

   gspca_ov519: Fix support for the Terratec Terracam USB Pro (2013-08-23 15:56:13 +0200)

----------------------------------------------------------------
Hans de Goede (1):
       gspca_ov519: Fix support for the Terratec Terracam USB Pro

  drivers/media/usb/gspca/ov519.c | 32 +++++++++++++++++++++++++-------
  1 file changed, 25 insertions(+), 7 deletions(-)

Thanks & Regards,

Hans
