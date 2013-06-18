Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:52428 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3FRBNP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 21:13:15 -0400
Received: by mail-qe0-f44.google.com with SMTP id 5so2151524qeb.3
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 18:13:14 -0700 (PDT)
Date: Mon, 17 Jun 2013 21:13:29 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [GIT PULL] git://linuxtv.org/mkrufky/tuners mxl111sf
Message-ID: <20130617211329.6b62cb78@vujade>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
e049ca5e854263c821a15c0e25fe2ae202c365e1:

  [media] staging/media: lirc_imon: fix leaks in imon_probe()
  (2013-06-17 15:52:20 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners mxl111sf

for you to fetch changes up to 0fca4f2af6a176bf4c980643e70c99d11d002094:

  mxl111sf: don't redefine pr_err/info/debug (2013-06-17 19:56:40 -0400)

----------------------------------------------------------------
Hans Verkuil (1):
      mxl111sf: don't redefine pr_err/info/debug

 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |  8 +++-----
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       | 90
 ++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 2 files changed, 45 insertions(+), 53 deletions(-)
