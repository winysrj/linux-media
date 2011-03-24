Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:35826 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab1CXMhy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 08:37:54 -0400
Message-ID: <4D8B3B18.1050208@maxwell.research.nokia.com>
Date: Thu, 24 Mar 2011 14:37:44 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Daniel Lundborg <Daniel.Lundborg@prevas.se>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: SV: SV: OMAP3 isp single-shot
References: <loom.20110323T141429-496@post.gmane.org> <4D8B00FA.1090008@maxwell.research.nokia.com> <CA7B7D6C54015B459601D68441548157C5A3AE@prevas1.prevas.se> <201103241135.06025.laurent.pinchart@ideasonboard.com> <CA7B7D6C54015B459601D68441548157C5A3AF@prevas1.prevas.se>
In-Reply-To: <CA7B7D6C54015B459601D68441548157C5A3AF@prevas1.prevas.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Daniel Lundborg wrote:
> Hi Laurent,

Hi all,

>>> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
>>> Video format set: width: 752 height: 480 buffer size: 721920 Video 
>>> format: BA10 (30314142) 752x480
>>> 1 buffers requested.
>>> length: 721920 offset: 0
>>> Buffer 0 mapped at address 0x4014d000.
>>>
>>> And it freezes. I can stop yavta with CTRL+C.
>>
>> Have you tried to trigger the sensor multiple times in a row ?
> 
> No. I will test that.

Besides the two things what were proposed, it'd be good to check which
interrupts does the ISP produce.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
