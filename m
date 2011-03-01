Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46323 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab1CAQOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 11:14:15 -0500
Received: by qyg14 with SMTP id 14so4488915qyg.19
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2011 08:14:14 -0800 (PST)
References: <201101091836.58104.pboettcher@kernellabs.com> <4D51EFFB.90201@users.sourceforge.net> <9C5EED67-B096-4C8C-8269-CDDCE24F92A7@wilsonet.com> <4D5D0AA0.3070505@users.sourceforge.net> <AEF55519-A61C-411D-AF9D-9E4ED269694F@wilsonet.com>
In-Reply-To: <AEF55519-A61C-411D-AF9D-9E4ED269694F@wilsonet.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <8DF79112-88D7-48DF-AEC9-BB074ABE2F7D@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Lucian Muresan <lucianm@users.sourceforge.net>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: MCEUSB: falsly claims mass storage device
Date: Tue, 1 Mar 2011 11:14:27 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 28, 2011, at 5:34 PM, Jarod Wilson wrote:

> On Feb 17, 2011, at 6:46 AM, Lucian Muresan wrote:
> 
>> On 09.02.2011 06:19, Jarod Wilson wrote:
>> [...]
>>> Looks like bInterfaceNumber == 2 on this device. The patch to handle this
>>> similar to the conexant polaris devices should be pretty trivial. I'll
>>> try to get something together tomorrow.
>> 
>> Hi,
>> 
>> any news on this one?
> 
> I suck, but I have a patch in my local tree now. Need to build and
> quickly test it to make sure it doesn't break the devices I've got,
> then I'll get it posted.

Patch is posted.

https://patchwork.kernel.org/patch/599711/

-- 
Jarod Wilson
jarod@wilsonet.com



