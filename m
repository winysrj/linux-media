Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38805 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934Ab1CBWaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 17:30:16 -0500
Received: by qyg14 with SMTP id 14so504522qyg.19
        for <linux-media@vger.kernel.org>; Wed, 02 Mar 2011 14:30:15 -0800 (PST)
References: <20110302181404.6406a3d2@realh.co.uk> <3A464BCE-1E30-48D3-B275-99815E1A8983@wilsonet.com> <20110302204610.464785f5@toddler>
In-Reply-To: <20110302204610.464785f5@toddler>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <CC82695C-F23E-4569-AAF8-091372D2FFE9@wilsonet.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-media@vger.kernel.org>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Hauppauge "grey" remote not working in recent kernels
Date: Wed, 2 Mar 2011 17:30:29 -0500
To: Tony Houghton <h@realh.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 2, 2011, at 3:46 PM, Tony Houghton wrote:

> On Wed, 2 Mar 2011 13:39:32 -0500
> Jarod Wilson <jarod@wilsonet.com> wrote:
> 
>> On Mar 2, 2011, at 1:14 PM, Tony Houghton wrote:
>> 
>>> Since upgrading my kernel from 2.6.32 to 2.6.37 in Debian my DVB
>>> remote control no longer works. The card is a Hauppauge Nova-T PCI
>>> with the "grey" remote. It uses the saa7146, tda1004x, budget_ci
>>> and budget_core modules (but it doesn't actually have a CI).
>> 
>> There's a pending patchset for ir-kbd-i2c and the hauppauge key tables
>> that should get you back in working order.
> 
> OK, thanks. Is it possible to download the patch(es) and apply it to a
> current kernel or is that a bit complicated?

Not sure how doable it is, don't recall if they're dependent on other
changes going into 2.6.38 or not. The patches are still in the
linux-media patchwork db (I'm actually merging and testing them in my
own tree tonight or tomorrow).

https://patchwork.kernel.org/project/linux-media/list/

-- 
Jarod Wilson
jarod@wilsonet.com



