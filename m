Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21585 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3APN67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:59 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGQ0022B1H4UL30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 13:58:57 +0000 (GMT)
Received: from AVDC146 ([106.116.59.211])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGQ008071I51390@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jan 2013 13:58:57 +0000 (GMT)
From: Radoslaw Moszczynski <r.moszczynsk@samsung.com>
To: linux-media@vger.kernel.org
Subject: PcTV Nanostick 290e -- DVB-C frontend only working after reconnecting
 the device
Date: Wed, 16 Jan 2013 14:58:53 +0100
Message-id: <016601cdf3f1$9e7925e0$db6b71a0$%moszczynsk@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm not sure if this has been already reported, but I was playing around
with Nanostick 290e today and I encountered some weird behavior with the
DVB-C frontend.

The DVB-C frontend only seems to work once after plugging in the device.
During subsequent uses, it fails to lock on to signal. However, you can
unplug the Nanostick, plug it back in, and it is able to lock on again. But
only once -- then you have to replug it again. 

The exact actions that I took:

1. Plug in the Nanostick.
2. Run dvbstream to record a DVB-C stream -- works OK.
3. Run dvbstream to record a DVB-C stream again -- fail to lock on signal.
4. Unplug the Nanostick. Plug it back in.
5. Run dvbstream to record a DVB-C stream -- works OK.
6. Run dvbstream to record a DVB-C stream again -- fail to lock on signal.

I'm using kernel 3.2.0 on Ubuntu x86. The DVB-T/T2 frontend doesn't display
this behavior.

If anyone's interested in debugging this, I'll be happy to provide more
information.


Regards-
  -Radek


