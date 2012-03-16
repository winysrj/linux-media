Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59778 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031171Ab2CPPjy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 11:39:54 -0400
Received: by eekc41 with SMTP id c41so2190203eek.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 08:39:53 -0700 (PDT)
Message-ID: <4F635EC7.9070700@gmail.com>
Date: Fri, 16 Mar 2012 16:39:51 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Andy Furniss <andyqos@ukfsn.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com> <4F628886.3050009@ukfsn.org> <4F6299A4.1060309@gmail.com> <4F6312F0.1010305@ukfsn.org> <4F6356C5.9010808@ukfsn.org>
In-Reply-To: <4F6356C5.9010808@ukfsn.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 16/03/2012 16:05, Andy Furniss ha scritto:
> Andy Furniss wrote:
>> Gianluca Gennari wrote:
> 
>>> Hi Andy,
>>> the patch is already in the current media_build tree and is queued for
>>> kernel 3.4.
>>
>> Ahh, I'll give that a try, thanks.
> 
> Seems to be working OK so far, I had to avoid building radio to get it
> to compile.
> 
> Are these just informational - I get five every time I tune (barring the
> first time IIRC)
> 
> Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb
> ced2d000 ep4in-iso
> Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb
> ced2d800 ep4in-iso
> Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb
> cec3f800 ep4in-iso
> Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb
> ced2c000 ep4in-iso
> Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb
> ced2c800 ep4in-iso

Looks like some innocuous logging from the ehci_hcd driver. I've never
seen it because I'm not using the ehci_hcd module on my systems.
When you tune a new channel, the USB transfer is stopped (with the URBs
still alive, so the driver "shuts down" them) and a new one is started.
Then the URBs are reused (instead of being deallocated/allocated
again/cleared as before) so they are resubmitted.

Regards,
Gianluca
