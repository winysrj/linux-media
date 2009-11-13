Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42786 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbZKMRBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 12:01:07 -0500
Received: by yxe17 with SMTP id 17so3088975yxe.33
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 09:01:13 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Nov 2009 12:01:13 -0500
Message-ID: <18b102300911130901g3ad57ec4x99c78e7803ec773f@mail.gmail.com>
Subject: Help with Sabrent TV-USBHD (Syntek Teledongle) on Ubuntu Karmic
From: James Klaas <jklaas@appalachian.dyndns.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently updated my play/work/fiddle with workstation and I wanted
to see if my USB card still worked (OK, it never really worked).

Previously, I was running Ubuntu 9.04 with a version retrieved from
mercurial with the patch from
http://linuxtv.org/hg/~mkrufky/teledongle/raw-rev/676e2f4475ed.  It
patched without error, compiled without error and installed against
the stock kernel without error.  When I loaded it, it complained about
not being the right kind of firmware (which was noted in the
discussion on the device) but otherwise it seemed to load fine
(unfortunately, I don't seem to have a dmesg from that).  When I tried
using it to tune anything, it would tune a couple things, but put them
on channels that were far different than the ones found by other dvb
cards.  It did however manage to pick up the SCTE-65 data using the
scte65scan utility.

Now that I've upgraded to 9.10, it no longer seems to find the tuner.
I retrieved v4l-dvb via mercurial yesterday (12 Nov, 2009) applied the
patch (which applied with a couple of offsets but no errors) and built
the source.  I had to disable the FireDTV driver, but other than that,
it compiled with some warnings but no errors.  It installed fine over
the stock kernel.  However, when I load it, I now get the following
errors in dmesg:

[   93.770329] au0828 driver loaded
[   94.160154] au0828: i2c bus registered
[   94.201922] tveeprom 1-0050: Huh, no eeprom present (err=-5)?
[   94.204976] tuner 1-0000: chip found @ 0x0 (au0828)
[   94.271442] tuner-simple 1-0000: unable to probe Temic PAL (4002
FH5), proceeding anyway.
[   94.271452] tuner-simple 1-0000: creating new instance
[   94.271459] tuner-simple 1-0000: type set to 0 (Temic PAL (4002 FH5))
[   94.313325] tuner-simple 1-0000: i2c i/o error: rc == -5 (should be 4)
[   94.340407] au8522 1-0047: creating new instance
[   94.383357] au8522_writereg: writereg error (reg == 0xa4, val ==
0x0020, ret == -5)
[   94.424364] au8522_writereg: writereg error (reg == 0x106, val ==
0x0001, ret == -5)
[   94.465503] au8522_writereg: writereg error (reg == 0x106, val ==
0x0001, ret == -5)
[   94.501336] tda18271 1-0060: creating new instance
[   94.543412] au8522_writereg: writereg error (reg == 0x106, val ==
0x0001, ret == -5)
[   94.666327] au8522_writereg: writereg error (reg == 0x106, val ==
0x0000, ret == -5)
[   94.666339] tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer returned: -5
[   94.666347] Unknown device detected @ 1-0060, device not supported.
[   94.707712] au8522_writereg: writereg error (reg == 0x106, val ==
0x0001, ret == -5)
[   94.789369] au8522_writereg: writereg error (reg == 0x106, val ==
0x0000, ret == -5)
[   94.789376] tda18271_read_regs: [1-0060|M] ERROR: i2c_transfer returned: -5
[   94.789381] Unknown device detected @ 1-0060, device not supported.
[   94.789387] tda18271_attach: [1-0060|M] error -22 on line 1272
[   94.789393] tda18271 1-0060: destroying instance
[   94.853137] mt2131 I2C read failed
[   94.853350] DVB: registering new adapter (au0828)
[   94.853359] DVB: registering adapter 1 frontend 0 (Auvitek AU8522
QAM/8VSB Frontend)...
[   94.853943] Registered device AU0828 [Syntek Teledongle [EXPERIMENTAL]]

Did something not patch correctly?  The patch from mkrufky is now
nearly a year old.  I'd really like to contribute somehow, but I have
no idea where I should start.

Thank you for taking a look at this.

James
