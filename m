Return-path: <mchehab@pedra>
Received: from gateway06.websitewelcome.com ([67.18.144.9]:33377 "HELO
	gateway06.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758365Ab0JUVfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 17:35:07 -0400
Received: from [209.85.214.174] (port=47506 helo=mail-iw0-f174.google.com)
	by gator1121.hostgator.com with esmtpsa (TLSv1:RC4-MD5:128)
	(Exim 4.69)
	(envelope-from <demiurg@femtolinux.com>)
	id 1P92dc-0006Rr-81
	for linux-media@vger.kernel.org; Thu, 21 Oct 2010 16:25:28 -0500
Received: by iwn34 with SMTP id 34so52727iwn.19
        for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 14:25:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 23:25:29 +0200
Message-ID: <AANLkTint2Xw3bJuGh2voUpncWderrbUgbeOaPdp1-yNm@mail.gmail.com>
Subject: Wintv-HVR-1120 woes
From: Sasha Sirotkin <demiurg@femtolinux.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm having all sorts of troubles with Wintv-HVR-1120 on Ubuntu 10.10
(kernel 2.6.35-22). Judging from what I've seen on the net, including
this mailing list, I'm not the only one not being able to use this
card and no solution seem to exist.

Problems:
1. The driver yells various cryptic error messages
("tda18271_write_regs: [1-0060|M] ERROR: idx = 0x5, len = 1,
i2c_transfer returned: -5", "tda18271_set_analog_params: [1-0060|M]
error -5 on line 1045", etc)
2. DVB-T scan (using w_scan) produces no results
3. Analog seems to work, but with very poor quality

Any suggestions would be greatly appreciated.
