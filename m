Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbaGIJaP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 05:30:15 -0400
Message-ID: <53BD0B9E.6060901@redhat.com>
Date: Wed, 09 Jul 2014 11:30:06 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, yullaw <yullaw@mageia.cz>
Subject: [PULL patches for 3.17]: New usb-id for gspca_pac7302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for a new usb-id for gspca_pac7302

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks (2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.17

for you to fetch changes up to d2cfd7d0ce530928dfacd5cca0a544e1b071e925:

  gspca_pac7302: Add new usb-id for Genius i-Look 317 (2014-07-09 11:20:44 +0200)

----------------------------------------------------------------
Hans de Goede (1):
      gspca_pac7302: Add new usb-id for Genius i-Look 317

 drivers/media/usb/gspca/pac7302.c | 1 +
 1 file changed, 1 insertion(+)

Thanks & Regards,

Hans
