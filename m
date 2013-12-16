Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm37.bullet.mail.ne1.yahoo.com ([98.138.229.30]:48474 "HELO
	nm37.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751969Ab3LPBnd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 20:43:33 -0500
Message-ID: <1387158047.1563.YahooMailNeo@web120606.mail.ne1.yahoo.com>
Date: Sun, 15 Dec 2013 17:40:47 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: [3.12.5] Regression with PCTV 290e DVB-T2 adapter.
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

I have just tested my PCTV 290e DVB-T2 adapter with 3.12.5 and discovered that it fails with logs of messages like these:

[11720.780975] __tda18271_write_regs: [7-0060|M] ERROR: idx = 0x5, len = 1, i2c_transfer returned: -19
[11720.788726] tda18271_init: [7-0060|M] error -19 on line 832
[11720.793001] tda18271_tune: [7-0060|M] error -19 on line 910
[11720.797279] tda18271_set_params: [7-0060|M] error -19 on line 985 

Reverting to 3.11.10 fixes this problem. I have raised https://bugzilla.kernel.org/show_bug.cgi?id=67041

Cheers,
Chris

