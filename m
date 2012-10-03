Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33835 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2JCMSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 08:18:50 -0400
Received: by wgbdr13 with SMTP id dr13so6076907wgb.1
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 05:18:49 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL] for 3.7 (technisat-usb2)
Date: Wed, 03 Oct 2012 14:18:45 +0200
Message-ID: <1889603.SWYgrEojeU@dibcom294>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4:

  em28xx: regression fix: use DRX-K sync firmware requests on em28xx 

are available in the git repository at:

  http://linuxtv.org/git/pb/media_tree.git staging/for_v3.7

for you to fetch changes up to e196a346d5d2e4695a587ca2f99da5e5491d4e95:

  [media]: add MODULE_DEVICE_TABLE to technisat-usb2 

----------------------------------------------------------------
Patrick Boettcher (1):
      [media]: add MODULE_DEVICE_TABLE to technisat-usb2

 drivers/media/usb/dvb-usb/technisat-usb2.c |    1 +
 1 file changed, 1 insertion(+)

regards,

--
Patrick.
