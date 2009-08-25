Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:63153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbZHYPIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 11:08:11 -0400
Message-ID: <4A93FE64.9060002@nildram.co.uk>
Date: Tue, 25 Aug 2009 16:08:20 +0100
From: Lou Otway <lotway@nildram.co.uk>
Reply-To: lotway@nildram.co.uk
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: PVR-150, NMI causes reboot in expansion chassis
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been running Hauppauge PVR-150 cards in an expansion chassis and 
seeing this kind of thing:

kernel: Uhhuh. NMI received for unknown reason 30 on CPU 0.
kernel: Do you have a strange power saving mode enabled?
kernel: Dazed and confused, but trying to continue

Or, on a different hardware type:

kernel: Uhhuh. NMI received for unknown reason b1 on CPU 0.
kernel: You have some hardware problem, likely on the PCI bus.
kernel: Dazed and confused, but trying to continue

When the cards are installed on a motherboard slot they're fine, but in 
expansion chassis they really don't work well.

The theory is that the DMA controller has some problems.

Is there anyone seeing similar issues? Suggestions for things to try to 
fix it would be most welcome.

Thanks,

Lou

