Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3KQNys (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 08:54:48 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAHDsltk025023
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 17 Nov 2013 08:54:48 -0500
Received: from shalem.localdomain (vpn1-7-44.ams2.redhat.com [10.36.7.44])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id rAHDskSQ018753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 17 Nov 2013 08:54:47 -0500
Message-ID: <5288CAA6.2010505@redhat.com>
Date: Sun, 17 Nov 2013 14:54:46 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FIXES for 3.13] 1 small gspca and 2 small radio-shark fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 3 small fixes for 3.13 :

The following changes since commit 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

   [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v3.13

for you to fetch changes up to 118696e21f90ab2d011e38b45b007655204782d9:

   radio-shark2: Mark shark_resume_leds() inline to kill compiler warning (2013-11-17 14:48:29 +0100)

----------------------------------------------------------------
Geert Uytterhoeven (1):
       radio-shark: Mark shark_resume_leds() inline to kill compiler warning

Hans de Goede (1):
       radio-shark2: Mark shark_resume_leds() inline to kill compiler warning

Ondrej Zary (1):
       gspca-stk1135: Add delay after configuring clock

  drivers/media/radio/radio-shark.c  | 2 +-
  drivers/media/radio/radio-shark2.c | 2 +-
  drivers/media/usb/gspca/stk1135.c  | 3 +++
  3 files changed, 5 insertions(+), 2 deletions(-)

Thanks & Regards,

Hans
