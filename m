Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:54145 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbcGDNaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:30:00 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Update MAINTAINERS and two gspca fixes
Message-ID: <923e697a-b1f3-0d11-ca11-4b154c4cd1e8@xs4all.nl>
Date: Mon, 4 Jul 2016 15:29:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 80aa26593e3eb48f16c4222aa27ff40806f57c45:

  [media] media: rcar-vin: add DV timings support (2016-06-28 09:06:40 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8g

for you to fetch changes up to d36187f2af7da74592d614d429bbabd170be3656:

  gspca: avoid unused variable warnings (2016-07-04 15:28:43 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      gspca: avoid unused variable warnings

Hans Verkuil (1):
      MAINTAINERS: change maintainer for gscpa/pwc/radio-shark

Oliver Neukum (1):
      gspca: correct speed testing

 MAINTAINERS                      | 16 ++++++++--------
 drivers/media/usb/gspca/cpia1.c  |  2 +-
 drivers/media/usb/gspca/gspca.c  |  2 +-
 drivers/media/usb/gspca/konica.c |  2 +-
 drivers/media/usb/gspca/t613.c   |  2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)
