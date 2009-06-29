Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:45615 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZF2NnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 09:43:06 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KM000GZA63RP6D0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 29 Jun 2009 09:43:04 -0400 (EDT)
Date: Mon, 29 Jun 2009 09:43:04 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: cx23885, new hardware revision found
In-reply-to: <3833b9400906290548wd8b2ba1s22266f0152e83f40@mail.gmail.com>
To: linux-media@vger.kernel.org
Cc: Michael Kutyna <mkutyna@gmail.com>
Message-id: <4A48C4E8.6010107@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <3833b9400906201508w14f15b96i41e0963186a0a2cb@mail.gmail.com>
 <3833b9400906290548wd8b2ba1s22266f0152e83f40@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> cx23885_dev_checkrevision() New hardware revision found 0x0
>> cx23885_dev_checkrevision() Hardware revision unknown 0x0
>> cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 17, latency: 0,
>> mmio: 0xfd800000
>> cx23885 0000:02:00.0: setting latency timer to 64
>>
>> I'm pretty sure that is the problem but I don't know how to fix it.  I

The new revision isn't the problem, the above code is for information purposes 
so we can track new revs of the silicon in this mailing list. Most likely the 
demodulators / tuners are not configured correctly. DViCO probably changed 
something.

Double check that the silicon and gpios / settings inside the cx23885 driver for 
the existing card definition match the silicon and configuration for this new 
card you have.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
