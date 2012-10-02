Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63066 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2JBQxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 12:53:23 -0400
Received: by lbon3 with SMTP id n3so5330851lbo.19
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2012 09:53:22 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Oct 2012 12:53:22 -0400
Message-ID: <CAOcJUbxb8su5dKbYf-hBX8iT7zzLh9B9+PXjdhwxkovxDFUV4g@mail.gmail.com>
Subject: [GIT PULL] defer calibration until init() & properly report read
 errors in tda18271_get_id() | git://git.linuxtv.org/mkrufky/tuners tda18271
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit d48ecc46fa9340bdefa654912093ccfe11886639:

  tda18271: make 'low-power standby mode after attach' multi-instance
safe (2012-09-29 15:06:23 -0400)

are available in the git repository at:

  git://git.linuxtv.org/mkrufky/tuners tda18271

for you to fetch changes up to ccf5a7e347bf800025db0cf391c138c130720760:

  tda18271: properly report read errors in tda18271_get_id (2012-10-02
10:04:36 -0400)

----------------------------------------------------------------
Michael Krufky (2):
      tda18271: delay IR & RF calibration until init() if delay_cal is set
      tda18271: properly report read errors in tda18271_get_id

 drivers/media/tuners/tda18271-fe.c |   15 ++++++++++++++-
 drivers/media/tuners/tda18271.h    |    5 +++++
 2 files changed, 19 insertions(+), 1 deletion(-)
