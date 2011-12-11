Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64836 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1LKWhg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 17:37:36 -0500
Received: by iaeh11 with SMTP id h11so2204186iae.19
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 14:37:36 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 11 Dec 2011 17:37:36 -0500
Message-ID: <CAOcJUbwuCg+_OHwy16Bpcv5b9P0hPHRbqiNSA-J+bCAwud-hcw@mail.gmail.com>
Subject: [GIT PULL] git://linuxtv.org/mkrufky/mxl111sf.git aero-m
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull from the 'aero-m' branch of my mxl111sf tree for a small
driver cleanup.

The following changes since commit 806e23e95f94a27ee445022d724060b9b45cb64a:
  Haogang Chen (1):
        [media] uvcvideo: Fix integer overflow in uvc_ioctl_ctrl_map()

are available in the git repository at:

  git://linuxtv.org/mkrufky/mxl111sf.git aero-m

Michael Krufky (1):
      mxl111sf: absorb size_of_priv into *_STREAMING_CONFIG macros

 drivers/media/dvb/dvb-usb/mxl111sf.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

Cheers,

Mike
