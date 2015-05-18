Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbbERMxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 08:53:18 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4ICrIKK007082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 18 May 2015 08:53:18 -0400
Received: from shalem.localdomain (vpn1-4-205.ams2.redhat.com [10.36.4.205])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t4ICrGhf018525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 May 2015 08:53:17 -0400
Message-ID: <5559E0BC.40407@redhat.com>
Date: Mon, 18 May 2015 14:53:16 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL patches for 4.2]: New camera support for gspca sn9c2028 driver
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for new camera support for the gspca sn9c2028 driver.

The following changes since commit 0fae1997f09796aca8ada5edc028aef587f6716c:

   [media] dib0700: avoid the risk of forgetting to add the adapter's size (2015-05-14 19:31:34 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v4.2

for you to fetch changes up to ddf065746e4dc97ffc974ceeb031825164e6f39f:

   gspca: sn9c2028: Add gain and autogain controls Genius Videocam Live v2 (2015-05-18 14:23:56 +0200)

----------------------------------------------------------------
Vasily Khoruzhick (2):
       gspca: sn9c2028: Add support for Genius Videocam Live v2
       gspca: sn9c2028: Add gain and autogain controls Genius Videocam Live v2

  drivers/media/usb/gspca/sn9c2028.c | 242 ++++++++++++++++++++++++++++++++++++-
  drivers/media/usb/gspca/sn9c2028.h |  18 ++-
  2 files changed, 256 insertions(+), 4 deletions(-)

Thanks & Regards,

Hans
