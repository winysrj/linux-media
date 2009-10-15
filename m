Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:58640 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934983AbZJOI7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 04:59:00 -0400
Message-ID: <4AD6E428.1060006@onelan.com>
Date: Thu, 15 Oct 2009 09:58:16 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: linux-media@vger.kernel.org
Subject: Re: Poor reception with Hauppauge HVR-1600 on a ClearQAM cable feed
References: <4AD591BB.80607@onelan.com>	 <1255516547.3848.10.camel@palomino.walls.org> <4AD5AFA6.8080401@onelan.com> <1255576352.5829.16.camel@palomino.walls.org>
In-Reply-To: <1255576352.5829.16.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Right, the windows driver code for the mxl5005s is better.  Inform him
> that the linux driver for the mxl5005s could be better.  If he has any
> contacts at MaxLinear to get the datasheet and programming manual
> released to me, I can make the linux driver better.
> 
We don't have contacts that we know of, but we're happy to chase after a
datasheet for you if Devin's copy isn't enough - just let me know.
> 
> The MXL5005s is the silicon tuner chip on the Digital TV side of the
> HVR-1600.  A simple picture for you:
> 
>  Cable ---| MXL5005s |----| CX24227 |----| CX23418 |--- PCI bus
> 
> ---- Analog Waveform-----------|--------Digital Data--------------
> 
That's nice and clear, and explains things to me perfectly. Thank you.
> 
> Here's my HVR-1600 related entries from dmesg on startup.  I have the
> MXL5005S showing up at 9.510:
> 
> [    9.510767] MXL5005S: Attached at address 0x63
So basically, I was being blind and/or stupid - with this to hand, I've
found the equivalent message in my dmesg.
-- 
Simon Farnsworth

