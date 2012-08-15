Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab2HOKJ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 06:09:57 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FA9vin030612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 06:09:57 -0400
Received: from shalem.localdomain (vpn1-6-45.ams2.redhat.com [10.36.6.45])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q7FA9tPa004526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 06:09:56 -0400
Message-ID: <502B75B3.2090808@redhat.com>
Date: Wed, 15 Aug 2012 12:10:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT-PULL FIXES for 3.6] radio-shark*: Only compile led support when
 CONFIG_LED_CLASS is set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please pull the shark build fixes from my tree for 3.6:

The following changes since commit f9cd49033b349b8be3bb1f01b39eed837853d880:

   Merge tag 'v3.6-rc1' into staging/for_v3.6 (2012-08-03 22:41:33 -0300)

are available in the git repository at:


   git://linuxtv.org/hgoede/gspca.git media-for_v3.6

for you to fetch changes up to 74e8155de5331ef7f707ed22432a79f1477a7d22:

   radio-shark2: Only compile led support when CONFIG_LED_CLASS is set (2012-08-15 12:05:49 +0200)

----------------------------------------------------------------
Hans de Goede (4):
       radio-shark*: Remove work-around for dangling pointer in usb intfdata
       radio-shark*: Call cancel_work_sync from disconnect rather then release
       radio-shark: Only compile led support when CONFIG_LED_CLASS is set
       radio-shark2: Only compile led support when CONFIG_LED_CLASS is set

  drivers/media/radio/radio-shark.c  | 151 +++++++++++++++++++------------------
  drivers/media/radio/radio-shark2.c | 137 +++++++++++++++++----------------
  2 files changed, 150 insertions(+), 138 deletions(-)

Thanks & Regards,

Hans
