Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:54504 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1JKWg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 18:36:28 -0400
Message-ID: <4E94C4EA.5080309@mlbassoc.com>
Date: Tue, 11 Oct 2011 16:36:26 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC 0/3] omap3isp: add BT656 support
References: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de> <4E94BD75.5040403@mlbassoc.com> <CA+2YH7vx27qNeOO33NmR4SaqrSrhdu=17p468cSbLxDKfDAQqQ@mail.gmail.com> <4E94C465.9090901@mlbassoc.com>
In-Reply-To: <4E94C465.9090901@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-11 16:34, Gary Thomas wrote:
> On 2011-10-11 16:25, Enrico wrote:
>> On Wed, Oct 12, 2011 at 12:04 AM, Gary Thomas<gary@mlbassoc.com> wrote:
>>> Sorry, this just locks up on boot for me, immediately after finding the
>>> TVP5150.
>>> I applied your changes to the above tree
>>> commit 658d5e03dc1a7283e5119cd0e9504759dbd3d912
>>> Author: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>>> Date: Wed Aug 31 16:03:53 2011 +0200
>>
>> Did you add Javier patches for the tvp5150?
>
> No, I thought your set was self-contained. I'll add them now.

That said, it's not clear the current/final state of them.  I don't see any repost
after the very long discussion with Laurent.

Maybe you could just send that file to me directly?

>
>>
>>> However, it does not build for my OMAP3530 without the attached patches.
>>
>> I can't remember now if i had omap vout enabled in my kernel config
>> but that one in ispccdc.c is strange, tomorrow i will do again a clean
>> rebuild.
>
> I can't see how to turn off omap_vout
>

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
