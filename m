Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33374 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1JKWsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 18:48:52 -0400
Received: by gyb13 with SMTP id 13so82921gyb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 15:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E94C4EA.5080309@mlbassoc.com>
References: <1318345735-16778-1-git-send-email-ebutera@users.berlios.de>
	<4E94BD75.5040403@mlbassoc.com>
	<CA+2YH7vx27qNeOO33NmR4SaqrSrhdu=17p468cSbLxDKfDAQqQ@mail.gmail.com>
	<4E94C465.9090901@mlbassoc.com>
	<4E94C4EA.5080309@mlbassoc.com>
Date: Wed, 12 Oct 2011 00:48:51 +0200
Message-ID: <CA+2YH7tF5=wYuC7Q-Mspc=NbX08SwR3+uOTiAHzuirqS=1gfZw@mail.gmail.com>
Subject: Re: [RFC 0/3] omap3isp: add BT656 support
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 12, 2011 at 12:36 AM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2011-10-11 16:34, Gary Thomas wrote:
>>
>> On 2011-10-11 16:25, Enrico wrote:
>>>
>>> On Wed, Oct 12, 2011 at 12:04 AM, Gary Thomas<gary@mlbassoc.com> wrote:
>>>>
>>>> Sorry, this just locks up on boot for me, immediately after finding the
>>>> TVP5150.
>>>> I applied your changes to the above tree
>>>> commit 658d5e03dc1a7283e5119cd0e9504759dbd3d912
>>>> Author: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>>>> Date: Wed Aug 31 16:03:53 2011 +0200
>>>
>>> Did you add Javier patches for the tvp5150?
>>
>> No, I thought your set was self-contained. I'll add them now.
>
> That said, it's not clear the current/final state of them.  I don't see any
> repost
> after the very long discussion with Laurent.


Me too, and i don't remeber if Javier is going/was requested to send a v2.


> Maybe you could just send that file to me directly?

I'm not at work now but you can find the patches here:

https://github.com/ebutera/meta-igep/tree/testing-v2/recipes-kernel/linux/linux-3.0+3.1rc/tvp5150

They should apply cleanly.

Enrico
