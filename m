Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:48066 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965332Ab2CPPvK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 11:51:10 -0400
Message-ID: <4F63616D.5040808@ukfsn.org>
Date: Fri, 16 Mar 2012 15:51:09 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com> <4F628886.3050009@ukfsn.org> <4F6299A4.1060309@gmail.com> <4F6312F0.1010305@ukfsn.org> <4F6356C5.9010808@ukfsn.org> <4F635EC7.9070700@gmail.com>
In-Reply-To: <4F635EC7.9070700@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gianluca Gennari wrote:
>> Andy Furniss wrote:
>> Mar 16 14:56:58 noki kernel: ehci_hcd 0000:01:0a.2: shutdown urb
>> ced2c800 ep4in-iso
>
> Looks like some innocuous logging from the ehci_hcd driver. I've never
> seen it because I'm not using the ehci_hcd module on my systems.
> When you tune a new channel, the USB transfer is stopped (with the URBs
> still alive, so the driver "shuts down" them) and a new one is started.
> Then the URBs are reused (instead of being deallocated/allocated
> again/cleared as before) so they are resubmitted.

Ok, I don't have any problems so far - I also probably have some 
verbose/debugging usb options enabled in my kernel so I suppose others 
may never see these.


