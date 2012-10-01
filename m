Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53575 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2JAMkL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 08:40:11 -0400
Received: by lbon3 with SMTP id n3so3955086lbo.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 05:40:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Oct 2012 08:40:09 -0400
Message-ID: <CAOcJUbwv=0oPAbmcpf4gFY9uEXVqjP1annFaoQorBzYH9TXBiQ@mail.gmail.com>
Subject: [PULL] enter low-power standby mode at the end of tda18271_attach()
 on first instance git://linuxtv.org/mkrufky/tuners tda18271
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:

  [media] media: mx2_camera: use managed functions to clean up code
(2012-09-27 15:56:47 -0300)

are available in the git repository at:

  git://linuxtv.org/mkrufky/tuners tda18271

for you to fetch changes up to d48ecc46fa9340bdefa654912093ccfe11886639:

  tda18271: make 'low-power standby mode after attach' multi-instance
safe (2012-09-29 15:06:23 -0400)

----------------------------------------------------------------
Michael Krufky (2):
      tda18271: enter low-power standby mode at the end of tda18271_attach()
      tda18271: make 'low-power standby mode after attach' multi-instance safe

 drivers/media/tuners/tda18271-fe.c |    4 ++++
 1 file changed, 4 insertions(+)
