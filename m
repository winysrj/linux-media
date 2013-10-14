Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab3JNTle (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 15:41:34 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9EJfYrR008305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Oct 2013 15:41:34 -0400
Received: from shalem.localdomain (vpn1-4-95.ams2.redhat.com [10.36.4.95])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9EJfWE3031227
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 14 Oct 2013 15:41:33 -0400
Message-ID: <525C48EC.50005@redhat.com>
Date: Mon, 14 Oct 2013 21:41:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL PATCHES for 3.13] gscpa_ov534_9: Add support for ov3610
 sensor
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for an update to the gscpa_ov534_9
driver which adds support for a new model camera / sensor.

The following changes since commit 4699b5f34a09e6fcc006567876b0c3d35a188c62:

   [media] cx24117: prevent mutex to be stuck on locked state if FE init fails (2013-10-14 06:38:56 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.13

for you to fetch changes up to e27c7d4ddbe2727604998ffa99b369885c1aa0ae:

   gscpa_ov534_9: Add support for ov3610 sensor (2013-10-14 17:22:34 +0200)

----------------------------------------------------------------
Vladik Aranov (1):
       gscpa_ov534_9: Add support for ov3610 sensor

  drivers/media/usb/gspca/ov534_9.c | 334 +++++++++++++++++++++++++++++++++++++-
  1 file changed, 333 insertions(+), 1 deletion(-)

Thanks & Regards,

Hans
