Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaIAObg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Sep 2014 10:31:36 -0400
Message-ID: <54048342.4070104@redhat.com>
Date: Mon, 01 Sep 2014 16:31:30 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Antonio Ospite <ao2@ao2.it>
Subject: [PULL patches for 3.18]: 2 gspca cleanup patches
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 2 minor gspca cleanup patches:

The following changes since commit b250392f7b5062cf026b1423e27265e278fd6b30:

  [media] media: ttpci: fix av7110 build to be compatible with CONFIG_INPUT_EVDEV (2014-08-21 15:25:38 -0500)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.18

for you to fetch changes up to 9f1b73b7a113e7b6d01d6cfe1cb5146be9b04088:

  trivial: drivers/media/usb/gspca/gspca.h: indent with TABs, not spaces (2014-09-01 16:14:25 +0200)

----------------------------------------------------------------
Antonio Ospite (2):
      trivial: drivers/media/usb/gspca/gspca.c: fix the indentation of a comment
      trivial: drivers/media/usb/gspca/gspca.h: indent with TABs, not spaces

 drivers/media/usb/gspca/gspca.c | 5 ++---
 drivers/media/usb/gspca/gspca.h | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

Thanks & Regards,

Hans
