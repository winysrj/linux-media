Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57048 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZK0HWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 02:22:08 -0500
Message-ID: <4B0F7E21.3020703@s5r6.in-berlin.de>
Date: Fri, 27 Nov 2009 08:22:09 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Jon Smirl <jonsmirl@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [IR-RFC PATCH v4 0/6] In-kernel IR support using evdev
References: <20091127013217.7671.32355.stgit@terra> <4B0F43B3.4090804@wilsonet.com>
In-Reply-To: <4B0F43B3.4090804@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> On 11/26/2009 08:34 PM, Jon Smirl wrote:
>> Raw mode. There are three sysfs attributes - ir_raw, ir_carrier,
>> ir_xmitter. Read from ir_raw to get the raw timing data from the IR
>> device. Set carrier and active xmitters and then copy raw data to
>> ir_raw to send. These attributes may be better on a debug switch. You
>> would use raw mode when decoding a new protocol. After you figure out
>> the new protocol, write an in-kernel encoder/decoder for it.
> 
> Also neglected to recall there was raw IR data access too. However, a
> few things... One, this is, in some sense, cheating, as its not an input
> layer interface being used. :) Granted though, it *is* an existing
> kernel interface being used, instead of adding a new one. Two, there's
> no userspace to do anything with it at this time.

No; it is a new interface, just using an existing mechanism (sysfs). Not
all of sysfs in itself is an interface really; rather there is a number
of interfaces which are implemented by means of sysfs.

sysfs is primarily meant for simple textual attributes though, not for
I/O streams.
-- 
Stefan Richter
-=====-==--= =-== ==-==
http://arcgraph.de/sr/
