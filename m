Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbbETRuM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 13:50:12 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4KHoCZU011844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 20 May 2015 13:50:12 -0400
Received: from shalem.localdomain (vpn1-5-76.ams2.redhat.com [10.36.5.76])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t4KHoANh015812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 20 May 2015 13:50:12 -0400
Message-ID: <555CC952.6010609@redhat.com>
Date: Wed, 20 May 2015 19:50:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL patches for 4.2]: New camera support for gspca sn9c2028 driver
 (v2)
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a new pull-req for the new camera support for the gspca sn9c2028 driver, now with
my S-o-b added and the copyright change dropped.

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

   [media] dvb-core: fix 32-bit overflow during bandwidth calculation (2015-05-20 14:01:46 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v4.2

for you to fetch changes up to b4ede115fd1a37714e05e1180c399169e0e8d680:

   gspca: sn9c2028: Add gain and autogain controls Genius Videocam Live v2 (2015-05-20 19:47:11 +0200)

----------------------------------------------------------------
Vasily Khoruzhick (2):
       gspca: sn9c2028: Add support for Genius Videocam Live v2
       gspca: sn9c2028: Add gain and autogain controls Genius Videocam Live v2

  drivers/media/usb/gspca/sn9c2028.c | 241 ++++++++++++++++++++++++++++++++++++-
  drivers/media/usb/gspca/sn9c2028.h |  18 ++-
  2 files changed, 255 insertions(+), 4 deletions(-)

Thanks & Regards,

Hans
