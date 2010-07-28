Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32297 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0G1KZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 06:25:48 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L690030XJMXG3@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Jul 2010 11:25:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6900JH6JMXQJ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Jul 2010 11:25:45 +0100 (BST)
Date: Wed, 28 Jul 2010 12:24:12 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: JPEG hw decoder
In-reply-to: <AANLkTikuj0K+a0w6UsZ=2DkD=vtyqQReriNsXG2=5=p=@mail.gmail.com>
To: 'rd bairva' <rbairva@gmail.com>, linux-media@vger.kernel.org
Message-id: <000b01cb2e3f$05ccb430$11661c90$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
 <AANLkTikuj0K+a0w6UsZ=2DkD=vtyqQReriNsXG2=5=p=@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> rd bairva wrote:
>     My board has a hardware JPEG decoder. I want to write a driver
>for this in Linux kernel, But it seems there that no Framework exists
>in kernel. Can somebody provide me some pointers?
>
>Can V4l2 be used?
>Thanks in advance.

please take a look at the mem2mem (memory-to-memory) framework, it has
been designed just for such hardware, i.e. hardware that takes a source
buffer, processes the data and returns the result in another buffer.

You can find a short introduction in an LWN article at:
http://lwn.net/Articles/389081/

More info in the original threads:
http://www.spinics.net/lists/linux-media/msg14063.html
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/10668


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



