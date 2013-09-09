Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab3IILmW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 07:42:22 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r89BgMEg031665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 9 Sep 2013 07:42:22 -0400
Received: from shalem.localdomain (vpn1-7-238.ams2.redhat.com [10.36.7.238])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r89BgKa3003923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 9 Sep 2013 07:42:21 -0400
Message-ID: <522DB41B.5070406@redhat.com>
Date: Mon, 09 Sep 2013 13:42:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL PATCHES for 3.13] Misc. gspca improvements
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A bit early for 3.13, I know :)  Anways here are some misc. gspca
improvements for 3.13 :

The following changes since commit f66b2a1c7f2ae3fb0d5b67d07ab4f5055fd3cf16:

   [media] cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0 (2013-09-03 09:24:22 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.13

for you to fetch changes up to 982bf8c78821c9a8d428533801fab459ceee21e3:

   gspca: print small buffers via %*ph (2013-09-09 13:15:29 +0200)

----------------------------------------------------------------
Andy Shevchenko (1):
       gspca: print small buffers via %*ph

Gregor Jasny (1):
       Add HCL T12Rg-H to STK webcam upside-down table

Ondrej Zary (3):
       gspca: store current mode instead of individual parameters
       gspca: Support variable resolution
       gspca-stk1135: Add variable resolution support

  drivers/media/usb/gspca/conex.c                  |  3 +-
  drivers/media/usb/gspca/cpia1.c                  |  4 +-
  drivers/media/usb/gspca/gspca.c                  | 48 +++++++--------
  drivers/media/usb/gspca/gspca.h                  | 10 +++-
  drivers/media/usb/gspca/jeilinj.c                |  5 +-
  drivers/media/usb/gspca/jl2005bcd.c              |  2 +-
  drivers/media/usb/gspca/m5602/m5602_mt9m111.c    |  2 +-
  drivers/media/usb/gspca/mars.c                   |  7 ++-
  drivers/media/usb/gspca/mr97310a.c               |  6 +-
  drivers/media/usb/gspca/nw80x.c                  | 11 ++--
  drivers/media/usb/gspca/ov519.c                  | 52 +++++++++-------
  drivers/media/usb/gspca/ov534.c                  |  5 +-
  drivers/media/usb/gspca/pac207.c                 |  4 +-
  drivers/media/usb/gspca/pac7311.c                |  6 +-
  drivers/media/usb/gspca/se401.c                  |  6 +-
  drivers/media/usb/gspca/sn9c20x.c                |  6 +-
  drivers/media/usb/gspca/sonixb.c                 |  7 +--
  drivers/media/usb/gspca/sonixj.c                 |  3 +-
  drivers/media/usb/gspca/spca1528.c               |  3 +-
  drivers/media/usb/gspca/spca500.c                |  3 +-
  drivers/media/usb/gspca/sq905c.c                 |  2 +-
  drivers/media/usb/gspca/sq930x.c                 |  3 +-
  drivers/media/usb/gspca/stk014.c                 |  5 +-
  drivers/media/usb/gspca/stk1135.c                | 76 ++++++++++++------------
  drivers/media/usb/gspca/stv06xx/stv06xx.c        |  2 +-
  drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |  2 +-
  drivers/media/usb/gspca/sunplus.c                |  3 +-
  drivers/media/usb/gspca/topro.c                  | 13 ++--
  drivers/media/usb/gspca/tv8532.c                 |  7 ++-
  drivers/media/usb/gspca/vicam.c                  |  8 +--
  drivers/media/usb/gspca/w996Xcf.c                | 28 ++++-----
  drivers/media/usb/gspca/xirlink_cit.c            | 46 +++++++-------
  drivers/media/usb/gspca/zc3xx.c                  |  3 +-
  drivers/media/usb/stkwebcam/stk-webcam.c         |  7 +++
  34 files changed, 211 insertions(+), 187 deletions(-)

Thanks & Regards,

Hans
