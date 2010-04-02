Return-path: <linux-media-owner@vger.kernel.org>
Received: from drm03.Deuromedia.ro ([194.176.161.3]:33677 "HELO deuromedia.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757565Ab0DBKHE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 06:07:04 -0400
Message-ID: <4BB5C0D1.9090000@Deuromedia.ro>
Date: Fri, 02 Apr 2010 13:02:57 +0300
From: Doru Marin <Doru.Marin@Deuromedia.ro>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: CX88 TS overflows too often
References: <4B0FE7AC.3000002@Deuromedia.ro>
In-Reply-To: <4B0FE7AC.3000002@Deuromedia.ro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a system with two Hauppauge Nova-S-Plus cards and a HVR4000Lite.
Very often I'm getting errors like:

cx88[0]/2-mpeg: general errors: 0x00000100
cx88[2]/2-mpeg: general errors: 0x00000100

Digging in the code, I found that is DMA related, meaning TS overflow.

Looking further, I found that for TS handling, FIFO queue size is really
small, only 4K, of available 32K.
As long as the DVB-S2 streams are running up to 80Mbps, isn't this value
too small a fluent running ?
I presume that these overflows are caused by larger PCI latencies,
causing delays in buffer transfers.

As long as these cards are used most of the time for TS handling, isn't
there any chance to increase the TS FIFO size ?
Or optionally allocating more for this purpose ? The HVR4000Lite has no
video or audio inputs, but there are allocated resources for them,
wasted resources.

Regards,

Doru Marin

