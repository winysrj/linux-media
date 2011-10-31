Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328Ab1JaL2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 07:28:32 -0400
Received: by iaby12 with SMTP id y12so7079170iab.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 04:28:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbxTLAtQFa3s5FMUKp2MgX6FCmheN930xWp2xYTD8oApzw@mail.gmail.com>
References: <CAOcJUbxTLAtQFa3s5FMUKp2MgX6FCmheN930xWp2xYTD8oApzw@mail.gmail.com>
Date: Mon, 31 Oct 2011 07:28:32 -0400
Message-ID: <CAOcJUbxpgpYtFs+=4_ZsH36KczUeeTeoQ0n4bAcY+dvcu3QwLQ@mail.gmail.com>
Subject: [PULL] au8522/s4h1409/s4h1411: Calculate signal strength shown as
 percentage from SNR up to 35dB
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(resent with missing [PULL] tag in subject line)

Mauro,

Please pull from my atscdemod branch at
git://linuxtv.org/mkrufky/tuners .  These changesets bring au8522,
s5h1409, and s5h1411 up to speed with the other ATSC demodulator
drivers to all report signal strength in a single conforming way.  We
all agreed on this at the LPC over two years ago, and these patches
have been sitting in my hg tree since then, I've just completely
forgotten to issue this pull request. LGDT3305 and LGDT330X drivers
already report signal strength this way. Userspace developers have
been patiently waiting for this merge - I apologize to them for
sitting on it for so long.  Please merge this :-)

The following changes since commit a63366b935456dd0984f237642f6d4001dcf8017:

  [media] mxl111sf: update demod_ops.info.name to "MaxLinear MxL111SF
DVB-T demodulator" (2011-10-24 03:20:09 +0200)

are available in the git repository at:
  git://linuxtv.org/mkrufky/tuners atscdemod

Michael Krufky (3):
      au8522: Calculate signal strength shown as percentage from SNR up to 35dB
      s5h1409: Calculate signal strength shown as percentage from SNR up to 35dB
      s5h1411: Calculate signal strength shown as percentage from SNR up to 35dB

 drivers/media/dvb/frontends/au8522_dig.c |   31 +++++++++++++++++++++++++++++-
 drivers/media/dvb/frontends/s5h1409.c    |   31 +++++++++++++++++++++++++++++-
 drivers/media/dvb/frontends/s5h1411.c    |   31 +++++++++++++++++++++++++++++-
 3 files changed, 90 insertions(+), 3 deletions(-)

Best regards,
Michael Krufky
