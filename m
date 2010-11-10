Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab0KJLBb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 06:01:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAAB1V2u014514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 06:01:31 -0500
Received: from shalem.localdomain (vpn1-5-48.ams2.redhat.com [10.36.5.48])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAAB1TNR006470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 06:01:31 -0500
Message-ID: <4CDA7BC5.30803@redhat.com>
Date: Wed, 10 Nov 2010 12:02:29 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] gspca-stv06xx: support bandwidth changing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Here is a pull request the one patch which did not merge properly in my
previous pull request.

I based this on staging/for_v2.6.38, as that is where the patches from the
previous pull request ended up. But these are all bug-fixes intended for
2.6.37. Do I need to do anything special (like a branch based on
staging/for_v2.6.37-rc1 with all of them and a separate pull request) for
this, or will you cherry pick them over later?

The following changes since commit af9f14f7fc31f0d7b7cdf8f7f7f15a3c3794aea3:

   [media] IR: add tv power scancode to rc6 mce keymap (2010-11-10 00:58:49 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca gspca-for_v2.6.38

Hans de Goede (1):
       gspca-stv06xx: support bandwidth changing

  drivers/media/video/gspca/stv06xx/stv06xx.c        |   55 +++++++++++++++++++-
  drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |   11 ++++-
  drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c |   18 +++++--
  drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h |    3 +
  drivers/media/video/gspca/stv06xx/stv06xx_sensor.h |    4 ++
  drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |   17 +------
  drivers/media/video/gspca/stv06xx/stv06xx_st6422.h |    3 +
  drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    9 ++--
  8 files changed, 93 insertions(+), 27 deletions(-)

Regards,

Hans
