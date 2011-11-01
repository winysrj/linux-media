Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39275 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1KADWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 23:22:05 -0400
Received: by iaby12 with SMTP id y12so7852412iab.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 20:22:04 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 31 Oct 2011 23:22:04 -0400
Message-ID: <CAOcJUbyBHU=z9uNkF8_wLRaS1aMOvFjETfZBkwviGqYve1s5gw@mail.gmail.com>
Subject: [PULL] mxl111sf bug-fix for v3.2
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull the following from the bug-fix branch of my mxl111sf tree.
 I thank Hans' scripts for finding these build warnings for me.  One
of them was a typo, causing the wrong return value in a function....
In the end, this fixes a real error - not just build warnings.  Please
get these over to Linus for v3.2.

The following changes since commit a63366b935456dd0984f237642f6d4001dcf8017:
  Michael Krufky (1):
        [media] mxl111sf: update demod_ops.info.name to "MaxLinear
MxL111SF DVB-T demodulator"

are available in the git repository at:

  git://linuxtv.org/mkrufky/mxl111sf bug-fix

Michael Krufky (4):
      mxl111sf: fix return value of mxl111sf_idac_config
      mxl111sf: check for errors after mxl111sf_write_reg in
mxl111sf_idac_config
      mxl111sf: remove pointless if condition in mxl111sf_config_spi
      mxl111sf: fix build warning: variable ‘ret’ set but not used in
function ‘mxl111sf_i2c_readagain’

 drivers/media/dvb/dvb-usb/mxl111sf-i2c.c |    3 +--
 drivers/media/dvb/dvb-usb/mxl111sf-phy.c |    7 ++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

Thanks & regards,

Michael Krufky
