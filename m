Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:54711
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZH0ROK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 13:14:10 -0400
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Message-Id: <29D7CA0B-C3C6-4053-AD14-434C590DDC0A@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Peter Brouwer <pb.maillists@googlemail.com>
In-Reply-To: <4A96BD05.1080205@googlemail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [RFC] Infrared Keycode standardization
Date: Thu, 27 Aug 2009 13:12:21 -0400
References: <20090827045710.2d8a7010@pedra.chehab.org> <4A96BD05.1080205@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Aug 27, 2009, at 1:06 PM, Peter Brouwer wrote:

> Mauro Carvalho Chehab wrote:
>
> Hi Mauro, All
>
> Would it be an alternative to let lirc do the mapping and just let  
> the driver pass the codes of the remote to the event port.
> That way you do not need to patch the kernel for each new card/ 
> remote that comes out.
> Just release a different map file for lirc for the remote of choice.

But even if lirc is opening the event device, its worth standardizing  
what keys send which event code. I still need to read over the entire  
proposal, as well as some earlier related threads, been busy with  
other things.

Sidenote: someone (me) also needs to stop sloughing and submit lirc  
drivers upstream again...


>> After years of analyzing the existing code and receiving/merging  
>> patches
>> related to IR, and taking a looking at the current scenario, it is  
>> clear to me
>> that something need to be done, in order to have some standard way  
>> to map and
>> to give precise key meanings for each used media keycode found on
>> include/linux/input.h.

...

-- 
Jarod Wilson
jarod@wilsonet.com



