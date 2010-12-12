Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:14622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab0LLTH0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 14:07:26 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBCJ7P8b030931
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 14:07:25 -0500
Received: from shalem.localdomain (vpn1-4-125.ams2.redhat.com [10.36.4.125])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBCJ7N0v025002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 14:07:25 -0500
Message-ID: <4D051E7F.1080802@redhat.com>
Date: Sun, 12 Dec 2010 20:11:59 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] gspca_sonixb: Various updates / fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro et al,

Some bugfixes and support for a new sensor in the sonixb driver.

The following changes since commit dedb94adebe0fbdd9cafdbb170337810d8638bc9:

   [media] timblogiw: Fix a merge conflict with v4l2_i2c_new_subdev_board changes (2010-12-11 09:07:52 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git gspca-for_v2.6.38

Hans de Goede (3):
       gspca_sonixb: Make sonixb handle 0c45:6007 instead of sn9c102
       gspca_sonixb: Rewrite start of frame detection
       gspca_sonixb: Add support for 0c45:602a

  drivers/media/video/gspca/sonixb.c             |  232 +++++++++++++++++-------
  drivers/media/video/sn9c102/sn9c102_devtable.h |    4 +-
  2 files changed, 166 insertions(+), 70 deletions(-)

Thanks & Regards,

Hans
