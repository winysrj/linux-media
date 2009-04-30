Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:47328 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762459AbZD3PJD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 11:09:03 -0400
Received: from [134.32.138.73] (unknown [134.32.138.73])
	by mail.youplala.net (Postfix) with ESMTPSA id 56B12D880AC
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 17:08:45 +0200 (CEST)
Subject: Re: Nova-T 500 does not survive reboot
From: Nicolas Will <nico@youplala.net>
To: linux-media@vger.kernel.org
In-Reply-To: <20090430135641.91441beqhfo80o4k@www.stud.uni-hannover.de>
References: <20090430135641.91441beqhfo80o4k@www.stud.uni-hannover.de>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 16:08:44 +0100
Message-Id: <1241104124.5168.46.camel@acropora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-04-30 at 13:56 +0200, Soeren.Moch@stud.uni-hannover.de
wrote:
> > Apr 29 22:42:41 favia kernel: [   72.272045] ehci_hcd
> 0000:07:01.2:  
> > force halt; handhake ffffc20000666814 00004000 00000000 -> -110
> > [...]
> > Do you know if the issue is the same with a Nova-TD stick? If it is,
> > then I could be able to use debugging as an excuse to buy one, and
> then
> > add 2 tuners to the system when all is done :o)
> 
> I had the same "ehci_hcd force halt" error when I was debugging the
> Nova-TD dual-stream-switchon-problem:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg04643.html
> 
> Reducing the urb count to 1 (as included in the patch) solved the
> "ehci_hcd force halt" issue for me.

I mention that the URB part is a quick hack.

You were asking for opinions on that, and apparently did not get any
feedback.

Time for another call?

Nico

