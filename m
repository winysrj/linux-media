Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61812 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1B1WeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 17:34:18 -0500
Received: by fxm17 with SMTP id 17so4260910fxm.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 14:34:17 -0800 (PST)
References: <201101091836.58104.pboettcher@kernellabs.com> <4D51EFFB.90201@users.sourceforge.net> <9C5EED67-B096-4C8C-8269-CDDCE24F92A7@wilsonet.com> <4D5D0AA0.3070505@users.sourceforge.net>
In-Reply-To: <4D5D0AA0.3070505@users.sourceforge.net>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <AEF55519-A61C-411D-AF9D-9E4ED269694F@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: MCEUSB: falsly claims mass storage device
Date: Mon, 28 Feb 2011 17:34:30 -0500
To: Lucian Muresan <lucianm@users.sourceforge.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 17, 2011, at 6:46 AM, Lucian Muresan wrote:

> On 09.02.2011 06:19, Jarod Wilson wrote:
> [...]
>> Looks like bInterfaceNumber == 2 on this device. The patch to handle this
>> similar to the conexant polaris devices should be pretty trivial. I'll
>> try to get something together tomorrow.
> 
> Hi,
> 
> any news on this one?

I suck, but I have a patch in my local tree now. Need to build and
quickly test it to make sure it doesn't break the devices I've got,
then I'll get it posted.

-- 
Jarod Wilson
jarod@wilsonet.com



