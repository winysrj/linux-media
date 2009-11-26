Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:55671 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZKZGMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 01:12:47 -0500
Message-ID: <31657.64.213.30.2.1259215966.squirrel@webmail.exetel.com.au>
Date: Thu, 26 Nov 2009 17:12:46 +1100 (EST)
Subject: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1) tuning regression
From: "Robert Lowery" <rglowery@exemail.com.au>
To: mchehab@redhat.com, terrywu2009@gmail.com, awalls@radix.net
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After fixing up a hang on the DViCO FusionHDTV DVB-T Dual Digital 4 (rev
1) recently via http://linuxtv.org/hg/v4l-dvb/rev/1c11cb54f24d everything
appeared to be ok, but I have now noticed certain channels in Australia
are showing corruption which manifest themselves as blockiness and
screeching audio.

I have traced this issue down to
http://linuxtv.org/hg/v4l-dvb/rev/e6a8672631a0 (Fix offset frequencies for
DVB @ 6MHz)

In this change, the offset used by my card has been changed from 2750000
to 2250000.

That is, the old code which works used to do something like
offset = 2750000
if (((priv->cur_fw.type & DTV7) &&
    (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
    ((priv->cur_fw.type & DTV78) && freq < 470000000))



