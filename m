Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47571 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbcEEQJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2016 12:09:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 8542820869
	for <linux-media@vger.kernel.org>; Thu,  5 May 2016 12:09:46 -0400 (EDT)
Message-Id: <1462464586.3004166.599182921.0162873F@webmail.messagingengine.com>
From: Will Manley <will@williammanley.net>
To: linux-media@vger.kernel.org
Cc: amy.zhou@magewell.net
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Subject: Driver for Magewell PCIe capture cards
Reply-To: will@williammanley.net
Date: Thu, 05 May 2016 17:09:46 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi There

Magewell are a manufacturer of video-capture devices.  They have both
USB and PCIe devices.  The USB devices use the upstream uvcvideo driver
and Magewell currently provide proprietary drivers for their PCIe
products.

http://www.magewell.com/

I've approached Magewell about having upstream Linux drivers for these
PCIe devices and they are open to sharing hardware documentation and the
sources to their proprietary drivers under an NDA for the purpose of
developing an upstream Linux driver.  This is where I'm hoping that the
linux driver project can help out.

My interest in this is that I want to be using Magewell PCIe capture
cards in my company's products ( https://stb-tester.com/ ), but I don't
want to be stuck with proprietary drivers.  I'm hoping I can facilitate
because I have some limited kernel developer experience, but I wouldn't
be confident enough to write an entire v4l driver myself.

I'd originally posted this to the linux driver project mailing list[1]. 
Greg KH suggested I repost here as there aren't many v4l developers on
that list.

[1]:
http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/88218

Please let me know what additional information I can provide to get this
process started.

Thanks

Will
---
William Manley
stb-tester.com
