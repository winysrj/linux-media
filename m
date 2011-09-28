Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:34329 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240Ab1I1NUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 09:20:53 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.com>
To: LMML <linux-media@vger.kernel.org>
Subject: Problems tuning PAL-D with a Hauppauge HVR-1110 (TDA18271 tuner) - workaround hack included
Date: Wed, 28 Sep 2011 13:50:51 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281350.52099.simon.farnsworth@onelan.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(note - the CC list is everyone over 50% certainty from get_maintainer.pl)

I'm having problems getting a Hauppauge HVR-1110 card to successfully
tune PAL-D at 85.250 MHz vision frequency; by experimentation, I've
determined that the tda18271 is tuning to a frequency 1.25 MHz lower
than the vision frequency I've requested, so the following workaround
"fixes" it for me.

diff --git a/drivers/media/common/tuners/tda18271-fe.c 
b/drivers/media/common/tuners/tda18271-fe.c
index 63cc400..1a94e1a 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -1031,6 +1031,7 @@ static int tda18271_set_analog_params(struct 
dvb_frontend *fe,
 		mode = "I";
 	} else if (params->std & V4L2_STD_DK) {
 		map = &std_map->atv_dk;
+                freq += 1250000;
 		mode = "DK";
 	} else if (params->std & V4L2_STD_SECAM_L) {
 		map = &std_map->atv_l;

I've checked with a signal analyser, and confirmed that my signal
generator is getting the spectrum right - I am seeing vision peaking
at 85.25 MHz, with one sideband going down to 84.5 MHz, and the other
going up to 90.5MHz. I also see an audio carrier at 91.75 MHz.

I'm going to run with this hack in place, but I'd appreciate it if
someone who knew more about the TDA18271 looked at this, and either
gave me a proper fix for testing, or confirmed that what I'm doing is
right.
--
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
