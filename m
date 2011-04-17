Return-path: <mchehab@pedra>
Received: from mail-px0-f179.google.com ([209.85.212.179]:46379 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1DQR0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Apr 2011 13:26:30 -0400
Received: by pxi2 with SMTP id 2so2754715pxi.10
        for <linux-media@vger.kernel.org>; Sun, 17 Apr 2011 10:26:30 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Apr 2011 13:26:30 -0400
Message-ID: <BANLkTinQ19YTwsTNVGfy_OAuXw9x5fVh=w@mail.gmail.com>
Subject: [HG PULL] http://kernellabs.com/hg/~mkrufky/tda18271-fix
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Thanks for allowing me to continue sending pull requests via
mercurial.  These changes should apply cleanly against both hg and the
git tree.

Please pull from:

http://kernellabs.com/hg/~mkrufky/tda18271-fix

for the following TDA18271c2 RF Calibration fixes & updates:

- tda18271: fix calculation bug in tda18271_rf_tracking_filters_init
- tda18271: prog_cal and prog_tab variables should be s32, not u8
- tda18271: fix bad calculation of main post divider byte
- tda18271: update tda18271_rf_band as per NXP's rev.04 datasheet
- tda18271: update tda18271c2_rf_cal as per NXP's rev.04 datasheet

 tda18271-common.c |   11 +----------
 tda18271-fe.c     |   29 +++++++++++++++--------------
 tda18271-maps.c   |   12 ++++++------
 3 files changed, 22 insertions(+), 30 deletions(-)

Thanks to Stefan Sibiga for pointing out some of these driver bugs
