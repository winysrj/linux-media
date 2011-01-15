Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1AOQNk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 11:13:40 -0500
Date: Sat, 15 Jan 2011 16:04:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: [PATCH 0/8] Make both analog and digital modes work with Kworld
 SBTVD
Message-ID: <20110115160425.3b82e897@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch fixes saa7134 driver to allow both analog and digital modes
to work. While here, I fixed some issues I saw at tda8290 driver and
on mb82a20s.

The biggest issue I found is a a hard to track bug between 
tda829x/tda18271/saa7134. This series adds a workaround for it, but
we'll need to do some fix at the code, for it to work better.

The issue is that tda829x wants to go to analog mode during DVB 
initialization, causing some I2C errors.
    
The analog failure doesn't cause any harm, as the device were already
properly initialized in analog mode. However, the failure at the digital
mode causes the frontend mb86a20s to not initialize. Fortunately, at
least on my tests, it was possible to detect that the device is a
mb86a20s before the failure.
    
What happens is that tda8290 is a very bad boy: during DVB setup, it
keeps insisting to call tda18271 analog_set_params, that calls
tune_agc code. The tune_agc code calls saa7134 driver, changing the
value of GPIO 27, switching from digital to analog mode and disabling
the access to mb86a20s, as, on Kworld SBTVD, the same GPIO used
to switch the hardware AGC mode seems to be used to enable the I2C
switch that allows access to the frontend (mb86a20s).

So, a call to analog_set_params ultimately disables the access to
the frontend, and causes a failure at the init frontend logic.

This patch is a workaround for this issue: it simply checks if the
frontend init had any failure. If so, it will init the frontend when
some DTV application will try to set DVB mode.

Patches that teach good behaviors to tda8290 are welcome, as this guy
should not interrrupt somebody's else talk.

Mauro Carvalho Chehab (8):
  [media] tda8290: Make all read operations atomic
  [media] tda8290: Fix a bug if no tuner is detected
  [media] tda8290: Turn tda829x on before touching at the I2C gate
  [media] mb86a20s: Fix i2c read/write error messages
  [media] mb86a20s: Be sure that device is initialized before starting
    DVB
  [media] saa7134: Fix analog mode for Kworld SBTVD
  [media] saa7134: Fix digital mode on Kworld SBTVD
  [media] saa7134: Kworld SBTVD: make both analog and digital to work

 drivers/media/common/tuners/tda8290.c       |  130 +++++++++++++++------------
 drivers/media/dvb/frontends/mb86a20s.c      |   36 ++++++--
 drivers/media/video/saa7134/saa7134-cards.c |   51 +++--------
 drivers/media/video/saa7134/saa7134-dvb.c   |   80 ++++++++---------
 4 files changed, 152 insertions(+), 145 deletions(-)

