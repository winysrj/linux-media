Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50144 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1F3Dye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 23:54:34 -0400
Received: by qyk29 with SMTP id 29so2877533qyk.19
        for <linux-media@vger.kernel.org>; Wed, 29 Jun 2011 20:54:33 -0700 (PDT)
Subject: Re: [PATCH] Revert "V4L/DVB: cx23885: Enable Message Signaled Interrupts(MSI)"
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1309390504.3110.40.camel@morgan.silverblock.net>
Date: Wed, 29 Jun 2011 23:54:30 -0400
Cc: Jarod Wilson <jarod@redhat.com>, stoth@kernellabs.com,
	linux-media@vger.kernel.org,
	Kusanagi Kouichi <slash@ac.auone-net.jp>
Content-Transfer-Encoding: 7bit
Message-Id: <15F0A40B-3787-4D65-A503-4F324B8D12FB@wilsonet.com>
References: <1309384173-12933-1-git-send-email-jarod@redhat.com> <1309390504.3110.40.camel@morgan.silverblock.net>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 29, 2011, at 7:35 PM, Andy Walls wrote:

> On Wed, 2011-06-29 at 17:49 -0400, Jarod Wilson wrote:
>> This reverts commit e38030f3ff02684eb9e25e983a03ad318a10a2ea.
>> 
>> MSI flat-out doesn't work right on cx2388x devices yet. There are now
>> multiple reports of cards that hard-lock systems when MSI is enabled,
>> including my own HVR-1250 when trying to use its built-in IR receiver.
>> Disable MSI and it works just fine. Similar for another user's HVR-1270.
>> Issues have also been reported with the HVR-1850 when MSI is enabled,
>> and the 1850 behavior sounds similar to an as-yet-undiagnosed issue I've
>> seen with an 1800.
>> 
>> References:
>> 
>> http://www.spinics.net/lists/linux-media/msg25956.html
>> http://www.spinics.net/lists/linux-media/msg33676.html
>> http://www.spinics.net/lists/linux-media/msg34734.html
>> 
>> CC: Andy Walls <awalls@md.metrocast.net>
> 
> Fine by me.
> 
> Acked-by: Andy Walls <awalls@md.metrocast.net>
> 
> but you should really
> 
> Cc: Steven Toth <stoth@kernellabs.com>

Crud, yeah, Steven was listed in the commit being reverted. Apologies,
rushed to get it out the door, heading out on vacation for a week
starting tomorrow. (Of course, I'm bringing a laptop and a few usb
devices with me...). :)

-- 
Jarod Wilson
jarod@wilsonet.com



