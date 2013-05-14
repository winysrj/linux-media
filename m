Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:40706 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222Ab3ENUzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 16:55:20 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/3] bttv: convert to generic TEA575x interface
Date: Tue, 14 May 2013 22:54:42 +0200
Message-Id: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,
this patch series removes the tea575x code from bttv and uses the common
tea575x driver instead. Only set_frequency is implemented (signal/stereo
detection or seek would require more changes to bttv).

It works fine on Video Highway Xtreme but I don't have the Miro/Pinnacle or
Terratec Active Radio Upgrade to test.

Miro/Pinnacle seems to be simple and should work.

However, I don't understand the Terratec Active Radio Upgrade code. The HW
seems to need IOR, IOW and CSEL signals that were taken from ISA bus on
older cards (IOR and IOW directly and CSEL from some address decoder) and
are emulated here using GPIOs. But the code manipulating these signals in
bttv seems to be broken - it never asserts the IOR signal. If anyone has
this HW, please test if I got that right.

-- 
Ondrej Zary
