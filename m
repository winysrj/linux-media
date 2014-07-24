Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.inunum.li ([83.169.19.93]:56855 "EHLO
	lvps83-169-19-93.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759114AbaGXPlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 11:41:11 -0400
Message-ID: <53D12786.5050906@InUnum.com>
Date: Thu, 24 Jul 2014 17:34:30 +0200
From: Michael Dietschi <michael.dietschi@InUnum.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: omap3isp with DM3730 not working?!
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have built a Poky image for Gumstix Overo and added support for a 
TVP5151 module like described here http://www.sleepyrobot.com/?p=253.
It does work well with an Overo board which hosts an OMAP3530 SoC. But 
when I try with an Overo hosting a DM3730 it does not work: yavta just 
seems to wait forever :(

I did track it down to the point that IRQ0STATUS_CCDC_VD0_IRQ seems 
never be set but always IRQ0STATUS_CCDC_VD1_IRQ

Can someone please give me a hint?

Kind regards,
Michael

