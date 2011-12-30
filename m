Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1L3J2z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 04:28:55 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBU9StTP027690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 04:28:55 -0500
Received: from shalem.localdomain (vpn1-4-84.ams2.redhat.com [10.36.4.84])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pBU9SrjO008915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 04:28:54 -0500
Message-ID: <4EFD8494.4050506@redhat.com>
Date: Fri, 30 Dec 2011 10:29:56 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.3] gspca patches and new jl2005bcd driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro et all,

Please pull from my tree, for a few small gspca fixes
(including the bulk mode fix I send earlier for 3.2) and a
new gspca subdriver for jl2005bcd based cameras by
Theodore Kilgore.

The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:

   [media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git media-for_v3.3

Hans de Goede (3):
       gspca: Fix bulk mode cameras no longer working (regression fix)
       gspca_pac207: Raise max exposure + various autogain setting tweaks
       gscpa_vicam: Fix oops if unplugged while streaming

Theodore Kilgore (1):
       gspca: add jl2005bcd sub driver

  Documentation/video4linux/gspca.txt   |    1 +
  drivers/media/video/gspca/Kconfig     |   10 +
  drivers/media/video/gspca/Makefile    |    2 +
  drivers/media/video/gspca/gspca.c     |    4 +-
  drivers/media/video/gspca/gspca.h     |    2 +
  drivers/media/video/gspca/jl2005bcd.c |  571 +++++++++++++++++++++++++++++++++
  drivers/media/video/gspca/pac207.c    |   10 +-
  drivers/media/video/gspca/vicam.c     |    3 +-
  include/linux/videodev2.h             |    1 +
  9 files changed, 596 insertions(+), 8 deletions(-)
  create mode 100644 drivers/media/video/gspca/jl2005bcd.c

Thanks & Regards,

Hans
