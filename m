Return-path: <linux-media-owner@vger.kernel.org>
Received: from beta.phas.ubc.ca ([142.103.236.75]:46297 "EHLO beta.phas.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaJETZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Oct 2014 15:25:54 -0400
Date: Sun, 5 Oct 2014 12:03:57 -0700 (PDT)
From: Carl Michal <michal@phas.ubc.ca>
To: linux-media@vger.kernel.org
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: spurious remote control events
Message-ID: <alpine.LNX.2.00.1410051147280.26572@tristan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm using a cubox-i, which has a gpio remote receiver built in. The remote 
I'm using is a universal remote, using an RC-6 protocol. This is using 
kernel 3.14.14 (from geexbox)

What happens is that if you press key1, key1, key2 with spaces between the 
presses that are larger than IR_KEYPRESS_TIMEOUT but shorter than the 
repeat delay, then the driver often delivers four down/up pairs of events: 
key1, key1, key1, key2.

Similarly, key1, key2, key2 gives key1, key2, key2, key2
and key1, key2, key1 gives key1, key2, key2, key1
Strangely, key1, key1, key1 gives only the three expected events.

If I set the repeat delay to be equal to the IR_KEYPRESS_TIMEOUT 
(using ir-keytable --delay) then the problem goes away (or is hidden).

I've been looking though the relevant kernel code, and while I don't think 
I fully understand all the subtleties, one thing I noticed that seems
odd is that in ir_raw_event_store_edge in ir-raw.c, the repeat delay is 
used to determine if an edge is part of a new event or not. It seems to me 
that this might be way too long. Shouldn't it be something more like 
IR_KEYPRESS_TIMEOUT ? Or even shorter - like just longer than the longest 
possible gap between edges in a code?

I tried changing the "delay" value in ir_raw_event_store_edge to match the 
IR_KEYPRESS_TIMEOUT, and it does seem to resolve the problem for me.

Carl



