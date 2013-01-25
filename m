Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab3AYKhA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 05:37:00 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0PAb0px000608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 05:37:00 -0500
Received: from shalem.localdomain (vpn1-6-18.ams2.redhat.com [10.36.6.18])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0PAawqj024140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 05:37:00 -0500
Message-ID: <510260F1.5040902@redhat.com>
Date: Fri, 25 Jan 2013 11:39:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.9] gspca IS_ENABLED patches + 1 pwc fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my gspca tree for the gspca IS_ENABLED patches + 1 pwc fix

The following changes since commit a32f7d1ad3744914273c6907204c2ab3b5d496a0:

   Merge branch 'v4l_for_linus' into staging/for_v3.9 (2013-01-24 18:49:18 -0200)

are available in the git repository at:


   git://linuxtv.org/hgoede/gspca.git media-for_v3.9

for you to fetch changes up to 309ee95c1d6ec6dfee64a6c0b03789e14ac59730:

   pwc: Don't return EINVAL when an unsupported pixelformat is requested (2013-01-25 10:56:46 +0100)

----------------------------------------------------------------
Hans de Goede (1):
       pwc: Don't return EINVAL when an unsupported pixelformat is requested

Peter Senna Tschudin (17):
       radio/si470x/radio-si470x.h: use IS_ENABLED() macro
       usb/gspca/cpia1.c: use IS_ENABLED() macro
       usb/gspca: use IS_ENABLED() macro
       usb/gspca/konica.c: use IS_ENABLED() macro
       usb/gspca/ov519.c: use IS_ENABLED() macro
       usb/gspca/pac207.c: use IS_ENABLED() macro
       gspca/pac7302.c: use IS_ENABLED() macro
       usb/gspca/pac7311.c: use IS_ENABLED() macro
       usb/gspca/se401.c: use IS_ENABLED() macro
       usb/gspca/sn9c20x.c: use IS_ENABLED() macro
       usb/gspca/sonixb.c: use IS_ENABLED() macro
       usb/gspca/sonixj.c: use IS_ENABLED() macro
       usb/gspca/spca561.c: use IS_ENABLED() macro
       usb/gspca/stv06xx/stv06xx.c: use IS_ENABLED() macro
       usb/gspca/t613.c: use IS_ENABLED() macro
       usb/gspca/xirlink_cit.c: use IS_ENABLED() macro
       usb/gspca/zc3xx.c: use IS_ENABLED() macro

  drivers/media/radio/si470x/radio-si470x.h |  4 ++--
  drivers/media/usb/gspca/cpia1.c           |  6 +++---
  drivers/media/usb/gspca/gspca.c           | 10 +++++-----
  drivers/media/usb/gspca/gspca.h           |  6 +++---
  drivers/media/usb/gspca/konica.c          |  6 +++---
  drivers/media/usb/gspca/ov519.c           |  6 +++---
  drivers/media/usb/gspca/pac207.c          |  4 ++--
  drivers/media/usb/gspca/pac7302.c         |  4 ++--
  drivers/media/usb/gspca/pac7311.c         |  4 ++--
  drivers/media/usb/gspca/se401.c           |  4 ++--
  drivers/media/usb/gspca/sn9c20x.c         |  4 ++--
  drivers/media/usb/gspca/sonixb.c          |  6 +++---
  drivers/media/usb/gspca/sonixj.c          |  4 ++--
  drivers/media/usb/gspca/spca561.c         |  6 +++---
  drivers/media/usb/gspca/stv06xx/stv06xx.c |  4 ++--
  drivers/media/usb/gspca/t613.c            |  6 +++---
  drivers/media/usb/gspca/xirlink_cit.c     |  8 ++++----
  drivers/media/usb/gspca/zc3xx.c           |  4 ++--
  drivers/media/usb/pwc/pwc-v4l.c           |  7 +++----
  19 files changed, 51 insertions(+), 52 deletions(-)

Thanks,

Hans
