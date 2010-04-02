Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:65289 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab0DBNsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 09:48:05 -0400
Received: by ywh2 with SMTP id 2so1383021ywh.33
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 06:48:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 2 Apr 2010 21:48:01 +0800
Message-ID: <i2s6e8e83e21004020648n21b07894ma8ad2bf6757e83ff@mail.gmail.com>
Subject: how does v4l2 driver communicate a frequency lock to mythtv
From: Bee Hock Goh <beehock@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

i have been doing some usb snoop and making some changes to the
existing staging tm6000 to get my tm5600/xc2028 usb stick to work.
Thanks to a lot of help from Stefan, I have some limited success and
is able to get mythtv to do channel scan. However, mythtv is not able
to logon to the channel even though usbmon shown the same in/out using
usbmon and snoop on the stick windows application.

Where should I be looking at to inform that a channel is to be locked?

here's small snapshot of the dmesg when mythtv is scanning. its
basically calling on the  VIDIOC_S_FREQUENCY and  VIDIOC_G_FREQUENCY.
If  VIDIOC_G_FREQUENCY use in some form to inform that the correct
freq has been selected? on the tm6000 code, it only return the
frequency value.

Hope that some of the you expert can offer me a advice.

[ 3759.600038] tm6000: VIDIOC_G_FREQUENCY
[ 3759.600046] xc2028 5-0061: xc2028_get_frequency called
[ 3759.600108] tm6000: VIDIOC_G_TUNER
[ 3759.625446] tm6000: VIDIOC_G_MODULATOR
[ 3759.625454] tm6000: VIDIOC_S_FREQUENCY
[ 3759.625461] xc2028 5-0061: xc2028_set_analog_freq called
[ 3759.625466] xc2028 5-0061: generic_set_freq called
[ 3759.625470] xc2028 5-0061: should set frequency 224250 kHz
[ 3759.625473] xc2028 5-0061: check_firmware called
[ 3759.625477] xc2028 5-0061: checking firmware, user requested
type=F8MHZ (2), id 0000000000000010, scode_tbl (0), scode_nr 0
[ 3759.625487] xc2028 5-0061: BASE firmware not changed.
[ 3759.625490] xc2028 5-0061: Std-specific firmware already loaded.
[ 3759.625494] xc2028 5-0061: SCODE firmware already loaded.
[ 3759.625498] xc2028 5-0061: xc2028_get_reg 0004 called
[ 3759.660023] xc2028 5-0061: xc2028_get_reg 0008 called
[ 3759.700027] xc2028 5-0061: Device is Xceive 3028 version 1.0,
firmware version 2.4
[ 3760.070039] xc2028 5-0061: divisor= 00 00 38 10 (freq=224.250)
[ 3760.070053] tm6000: VIDIOC_G_FREQUENCY
[ 3760.070061] xc2028 5-0061: xc2028_get_frequency called
[ 3760.070124] tm6000: VIDIOC_G_TUNER
[ 3760.095457] tm6000: VIDIOC_G_MODULATOR
[ 3760.095465] tm6000: VIDIOC_S_FREQUENCY
[ 3760.095472] xc2028 5-0061: xc2028_set_analog_freq called
[ 3760.095476] xc2028 5-0061: generic_set_freq called
[ 3760.095480] xc2028 5-0061: should set frequency 487250 kHz
[ 3760.095484] xc2028 5-0061: check_firmware called
[ 3760.095487] xc2028 5-0061: checking firmware, user requested
type=F8MHZ (2), id 0000000000000010, scode_tbl (0), scode_nr 0
[ 3760.095497] xc2028 5-0061: BASE firmware not changed.
[ 3760.095501] xc2028 5-0061: Std-specific firmware already loaded.
[ 3760.095504] xc2028 5-0061: SCODE firmware already loaded.
[ 3760.095508] xc2028 5-0061: xc2028_get_reg 0004 called
[ 3760.130027] xc2028 5-0061: xc2028_get_reg 0008 called
[ 3760.170040] xc2028 5-0061: Device is Xceive 3028 version 1.0,
firmware version 2.4
[ 3760.540035] xc2028 5-0061: divisor= 00 00 79 d0 (freq=487.250)
[ 3760.540048] tm6000: VIDIOC_G_FREQUENCY
[ 3760.540056] xc2028 5-0061: xc2028_get_frequency called
[ 3760.540118] tm6000: VIDIOC_G_TUNER
[ 3760.565446] tm6000: VIDIOC_G_MODULATOR
[ 3760.565455] tm6000: VIDIOC_S_FREQUENCY
[ 3760.565462] xc2028 5-0061: xc2028_set_analog_freq called
[ 3760.565467] xc2028 5-0061: generic_set_freq called
[ 3760.565471] xc2028 5-0061: should set frequency 495250 kHz
[ 3760.565474] xc2028 5-0061: check_firmware called
[ 3760.565478] xc2028 5-0061: checking firmware, user requested
type=F8MHZ (2), id 0000000000000010, scode_tbl (0), scode_nr 0
[ 3760.565488] xc2028 5-0061: BASE firmware not changed.
[ 3760.565491] xc2028 5-0061: Std-specific firmware already loaded.
[ 3760.565495] xc2028 5-0061: SCODE firmware already loaded.
[ 3760.565499] xc2028 5-0061: xc2028_get_reg 0004 called
[ 3760.600031] xc2028 5-0061: xc2028_get_reg 0008 called
[ 3760.640030] xc2028 5-0061: Device is Xceive 3028 version 1.0,
firmware version 2.4
[ 3761.010032] xc2028 5-0061: divisor= 00 00 7b d0 (freq=495.250)
[ 3761.010047] tm6000: VIDIOC_G_FREQUENCY
[ 3761.010055] xc2028 5-0061: xc2028_get_frequency called

thanks,
 Hock.
