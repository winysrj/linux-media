Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:24640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab0IFId3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Sep 2010 04:33:29 -0400
Message-ID: <4C84A8B1.2040702@redhat.com>
Date: Mon, 06 Sep 2010 10:39:13 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Pull request: http://linuxtv.org/hg/~hgoede/ibmcam3 : new xirlink_cit
 + konica drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

Please pull from:
http://linuxtv.org/hg/~hgoede/ibmcam3

Which is my gspca tree which features 2 new (rewritten old v4l1 drivers)
gspca subdrivers for xirlink cit and konica chipset webcams.

The complete pull consists of the following commits:
4 minutes  	Hans de Goede  	gspca_xirlink_cit: adjust ibm netcam pro framerate for available bandwidthdefault tip
12 hours 	Hans de Goede 	gspca_konica: New gspca subdriver for konica chipset using cams
22 hours 	Hans de Goede 	gspca_*: correct typo in my email address in various subdrivers
2 months 	Hans de Goede 	Mark usbvideo ibmcam driver as deprecated
22 hours 	Hans de Goede 	gspca_xirlink_cit: support bandwidth changing for devices with 1 alt setting
6 days 		Hans de Goede 	gspca_xirlink_cit: Use alt setting -> fps formula for model 1 cams too
13 hours 	Hans de Goede 	gspca_xirlink_cit: Add support for camera with a bcd version of 0.01
2 months 	Hans de Goede 	gspca_xirlink_cit: Add support for Model 1, 2 & 4 cameras
13 hours 	Hans de Goede 	gspca_xirlink_cit: New gspca subdriver replacing v4l1 usbvideo/ibmcam.c

Thanks & Regards,

Hans
