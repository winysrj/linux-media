Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab3IILMj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 07:12:39 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r89BCdqQ011009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 9 Sep 2013 07:12:39 -0400
Received: from shalem.localdomain (vpn1-7-169.ams2.redhat.com [10.36.7.169])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r89BCbVj032350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 9 Sep 2013 07:12:39 -0400
Message-ID: <522DAD25.2030509@redhat.com>
Date: Mon, 09 Sep 2013 13:12:37 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FIX for 3.12]: Add a new upside down latpop model to stkwebcam
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Can you please pull from my tree for a small fix for 3.12:

The following changes since commit f66b2a1c7f2ae3fb0d5b67d07ab4f5055fd3cf16:

   [media] cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0 (2013-09-03 09:24:22 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.12

for you to fetch changes up to 94d9a89a963acc1b659a2ed6cd07090d5a6443eb:

   Add HCL T12Rg-H to STK webcam upside-down table (2013-09-09 13:08:31 +0200)

----------------------------------------------------------------
Gregor Jasny (1):
       Add HCL T12Rg-H to STK webcam upside-down table

  drivers/media/usb/stkwebcam/stk-webcam.c | 7 +++++++
  1 file changed, 7 insertions(+)

Thanks & Regards,

Hans
