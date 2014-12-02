Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64602 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaLBJrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 04:47:17 -0500
Received: by mail-pa0-f50.google.com with SMTP id bj1so13105971pad.37
        for <linux-media@vger.kernel.org>; Tue, 02 Dec 2014 01:47:17 -0800 (PST)
Message-ID: <547D8AA0.4000403@gmail.com>
Date: Tue, 02 Dec 2014 18:47:12 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: Random memory corruption of fe[1]->dvb pointer
References: <547BAC79.50702@southpole.se> <547CF9FC.5010101@southpole.se>
In-Reply-To: <547CF9FC.5010101@southpole.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> So at first it would be nice if someone could confirm my findings.
> Applying the same kind of code like my patch and unplug something that
> uses the affected frontend should be enough.

I tried that for tc90522, and I could remove earth-pt3
(which uses tc90522), tc90522 and tuner modules without any problem,
although earth-pt3 is a pci driver and does not use dvb-usb-v2.

>From your log(?) output, 
I guess that rtl28xxu_exit() removed the attached demod module
(mn88472) and thus free'ed fe BEFORE calling dvb_usbv2_exit(),
from where dvb_unregister_frontend(fe) is called.
I think that the demod i2c device is removed automatically by
dvb_usbv2_i2c_exit() in dvb_usbv2_exit(), if you registered
the demod i2c device, and your adapter/bridge driver
should not try to remove it.

regards,
Akihiro
