Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48272 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DPWQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 18:16:16 -0400
Received: by vcqp1 with SMTP id p1so3673554vcq.19
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2012 15:16:15 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 16 Apr 2012 18:16:15 -0400
Message-ID: <CAOcJUbx4smLBOGptNPv8ZitGOJQRPw=7ERhZjGCNZSx5-8KbkQ@mail.gmail.com>
Subject: [GIT PULL v3.4] git://git.linuxtv.org/mkrufky/tuners.git xc5000
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please merge the following into the v3.4-rc tree -- this alters the
driver to use the official firmware image for the XC5000C, rather than
one modified for a specific xtal frequency.  The modified firmware
will never be released, so we're better off merging this now rather
than waiting for v3.5.

Regards,

Mike


The following changes since commit 296da3cd14db9eb5606924962b2956c9c656dbb0:

  [media] pwc: poll(): Check that the device has not beem claimed for
streaming already (2012-03-27 11:42:04 -0300)

are available in the git repository at:
  git://git.linuxtv.org/mkrufky/tuners.git xc5000

Michael Krufky (3):
      xc5000: support 32MHz & 31.875MHz xtal using the 41.024.5 firmware
      xc5000: log firmware upload failures in xc5000_fwupload
      xc5000: xtal_khz should be a u16 rather than a u32

 drivers/media/common/tuners/xc5000.c |   44 ++++++++++++++++++++++++++++++----
 drivers/media/common/tuners/xc5000.h |    1 +
 2 files changed, 40 insertions(+), 5 deletions(-)
