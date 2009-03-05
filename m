Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:58589 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZCEUiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 15:38:50 -0500
Received: by ewy25 with SMTP id 25so64522ewy.37
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 12:38:47 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Mar 2009 21:38:47 +0100
Message-ID: <af2e95fa0903051238g6c0b072n4890a0461e9f0b09@mail.gmail.com>
Subject: saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
From: Henrik Beckman <henrik.list@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,
I get errors on my DVB-C card,

Mar  5 21:23:47 media kernel: [ 1489.968022] saa7146 (0)
saa7146_i2c_writeout [irq]: timed out waiting for end of xfer

Ubuntu 8.10, TT-1501-C with CI module.
There is a PVR-150 in the adjacent PCI slot, if that matters I can try
an switch them or remove the pvr board.

any ideas

/Henrik
