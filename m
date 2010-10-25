Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48435 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab0JYWpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 18:45:34 -0400
Received: by qwk3 with SMTP id 3so1903394qwk.19
        for <linux-media@vger.kernel.org>; Mon, 25 Oct 2010 15:45:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimQAu-76tv6MWQhfT5L1fDJrnK0uTYobQXBi8vQ@mail.gmail.com>
References: <AANLkTimQAu-76tv6MWQhfT5L1fDJrnK0uTYobQXBi8vQ@mail.gmail.com>
Date: Mon, 25 Oct 2010 18:45:33 -0400
Message-ID: <AANLkTimnDSBSr8+b3HoGmORrsd3+Q2v=p-nuSJfs5vw6@mail.gmail.com>
Subject: Re: Pinnacle PCTV HD 800i troubles
From: Tugrul Galatali <tugrul@galatali.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 18, 2010 at 11:05 PM, Tugrul Galatali <tugrul@galatali.com> wrote:
> After a variable amount of time recording, the card stops functioning
> and starts filling my disk with error messages. It usually starts with
> something like this:

This happened again after the longest spell of not occurring, about 6.5 days.

This time when I removed the cx88_dvb module it stopped the error
stream, which previously wouldn't happen until I removed more modules
like s5h1409 and lgdt3305. When I tried reloading it, I got:

[589132.812877] cx88/2: unregistering cx8802 driver, type: dvb access: shared
[589132.812881] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV
HD 800i [card=58]
[589141.517555] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[589141.517558] cx88/2: registering cx8802 driver, type: dvb access: shared
[589141.517561] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV
HD 800i [card=58]
[589141.517563] cx88[0]/2: cx2388x based DVB/ATSC card
[589141.517564] cx8802_alloc_frontends() allocating 1 frontend(s)
[589141.518266] s5h1409_readreg: readreg error (ret == -6)
[589141.518311] cx88[0]/2: frontend initialization failed
[589141.518313] cx88[0]/2: dvb_register failed (err = -22)
[589141.518314] cx88[0]/2: cx8802 probe failed, err = -22

This was the beginning of the errors from syslog:

[572105.888680] s5h1409_readreg: readreg error (ret == -6)
[572105.889326] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[572105.889989] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[572105.890632] s5h1409_writereg: error (reg == 0xf4, val == 0x0001, ret == -6)
[572105.891273] s5h1409_writereg: error (reg == 0x85, val == 0x0110, ret == -6)
[572105.891915] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[572105.892573] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[572105.893229] s5h1409_writereg: error (reg == 0xf3, val == 0x0001, ret == -6)
[572105.893897] xc5000: I2C read failed
[572105.894540] xc5000: I2C read failed
[572105.894542] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.6.114.fw)...
[572105.969198] xc5000: firmware read 12401 bytes.
[572105.969199] xc5000: firmware uploading...
[572105.969201] cx88[0]: Calling XC5000 callback
[572105.969869] xc5000: I2C write failed (len=3)
[572105.969870] xc5000: firmware upload complete...
[572105.970516] s5h1409_writereg: error (reg == 0xf3, val == 0x0000, ret == -6)
[572105.971158] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[572105.971800] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[572105.972454] s5h1409_readreg: readreg error (ret == -6)
[572105.973110] s5h1409_writereg: error (reg == 0x96, val == 0x0008, ret == -6)
[572105.973774] s5h1409_writereg: error (reg == 0x93, val == 0x3332, ret == -6)
[572105.974417] s5h1409_writereg: error (reg == 0x9e, val == 0x2c37, ret == -6)
[572105.975058] s5h1409_readreg: readreg error (ret == -6)
[572105.975701] s5h1409_writereg: error (reg == 0x96, val == 0x0008, ret == -6)
[572105.976355] s5h1409_readreg: readreg error (ret == -6)
[572105.977006] s5h1409_writereg: error (reg == 0xab, val == 0x1001, ret == -6)
[572106.078183] lgdt3305_read_reg: error (addr 0e reg 0003 error (ret == -5)
[572106.078185] lgdt3305_read_status: error -5 on line 819
[572106.080329] tda18271_write_regs: [2-0060|M] ERROR: idx = 0x5, len
= 1, i2c_transfer returned: -5
[572106.080331] tda18271_init: [2-0060|M] error -5 on line 830
[572106.080333] tda18271_tune: [2-0060|M] error -5 on line 908
[572106.080335] tda18271_set_params: [2-0060|M] error -5 on line 989
[572106.080336] lgdt3305_set_parameters: error -5 on line 655
[572106.582179] lgdt3305_read_reg: error (addr 0e reg 0003 error (ret == -5)
[572106.582182] lgdt3305_read_status: error -5 on line 819
[572106.976682] s5h1409_readreg: readreg error (ret == -6)
[572106.977343] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[572106.977997] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[572106.978639] s5h1409_writereg: error (reg == 0xf4, val == 0x0001, ret == -6)
[572106.979280] s5h1409_writereg: error (reg == 0x85, val == 0x0110, ret == -6)
[572106.979923] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[572106.980593] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[572106.981256] s5h1409_writereg: error (reg == 0xf3, val == 0x0001, ret == -6)
[572106.981898] xc5000: I2C read failed
[572106.982540] xc5000: I2C read failed
[572106.982542] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.6.114.fw)...
[572106.984838] xc5000: firmware read 12401 bytes.
[572106.984839] xc5000: firmware uploading...
[572106.984841] cx88[0]: Calling XC5000 callback
[572106.985544] xc5000: I2C write failed (len=3)
[572106.985546] xc5000: firmware upload complete...

Tugrul Galatali
