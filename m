Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60393 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1AOFxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 00:53:51 -0500
Received: by vws16 with SMTP id 16so1345584vws.19
        for <linux-media@vger.kernel.org>; Fri, 14 Jan 2011 21:53:50 -0800 (PST)
Subject: Re: [PATCH] hdpvr: enable IR part
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
Date: Sat, 15 Jan 2011 00:53:46 -0500
Cc: Jean Delvare <khali@linux-fr.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8976FA56-7582-44D7-B57B-3FA81B229F92@wilsonet.com>
References: <20110114195448.GA9849@redhat.com> <1295041480.2459.9.camel@localhost> <20110114220759.GG9849@redhat.com> <661A728F-3CF1-47F3-A650-D17429AF7DF1@wilsonet.com> <1295066141.2459.34.camel@localhost> <0EADA025-77B0-4E8B-A649-F3BE6F2E437B@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 15, 2011, at 12:37 AM, Jarod Wilson wrote:
...
>> BTW, a checkpatch and compiler tested lirc_zilog.c is here:
>> 
>> http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/z8
>> 
>> It should fix all the binding and allocation problems related to
>> ir_probe()/ir_remove().  Except I suspect it may leak the Rx poll
>> kthread.  That's possibly another bug to add to the list.
>> 
>> Anyway, $DIETY knows if the lirc_zilog module actually still works after
>> all my hacks.  Give it a test if you are adventurous.  I won't be able
>> to test until tomorrow evening.
> 
> I'll try to grab those and give them a test tomorrow, and hey, I've even got
> a baseline to test against now.

Forgot to mention: I think it was suggested that one could use ir-kbd-i2c
for receive and lirc_zilog for transmit, at the same time. With ir-kbd-i2c
already loaded, lirc_zilog currently won't bind to anything.

-- 
Jarod Wilson
jarod@wilsonet.com



