Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58343 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbZEALDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2009 07:03:24 -0400
Received: by fxm2 with SMTP id 2so2273234fxm.37
        for <linux-media@vger.kernel.org>; Fri, 01 May 2009 04:03:22 -0700 (PDT)
Message-ID: <49FAD6F4.1060201@gmail.com>
Date: Fri, 01 May 2009 13:03:16 +0200
From: David Lister <foceni@gmail.com>
MIME-Version: 1.0
To: Bob Ingraham <bobi@brin.com>
CC: linux-media@vger.kernel.org
Subject: Re: Support for Skystar S2 and Twinhan AD-SP200/VP-1027
References: <206145978.15701241154500283.JavaMail.root@email>
In-Reply-To: <206145978.15701241154500283.JavaMail.root@email>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bob Ingraham wrote:
> Hi All,
> 
> Running Fedora Core 10 (2.6.27) and have looked through the wiki for support for:
> 
> - Skystar S2 (DVB-S2) PCI
> - Twinhan AD-SP200/VP-1027 (DVB-S) PCI
> 
> I'm guessing the wiki is out of date with regards to current status.
> 
> Are there patches or a snapshot I can pull that has stable support for either of these cards?
>

I went though all this like a 7-14 days ago. Everything is on the list,
all repositories, all results.

I had SkyStar HD2, but the driver is the same. AFAIK these are two very
different cards and SkyStar S2 is probably working. I think it is used
more frequently than my HD2, which, alas, was a total CRAP.

I had 3 SkyStar HD2 cards in total and had to return them all. Why? Low
quality HW (interference, no shielding...), Linux driver support exists
(some, mainly the author, claim full support), but: DVB-S2 not working
at all (unless you want to reboot every few minutes), zero HW
sensitivity (90-95% signal strength -> broken picture), MythTV cannot
cope with it and breaks down all the time, little things like
PWR/SNR/BER reporting not working, etc.

Look up my mails and reports. There are even links to all the
repositories. The newest one:

hg clone http://jusst.de/hg/mantis-v4l

As for my story: I exchanged the cards for TeVii S640 DVB-S2. After
inserting the new cards and booting, my whole setup started to work -
out of the box, with the setup I had for SkyStar, which was unusable
previously. It was the HW/mantis driver after all. Just issuing my
WARNING against TWINHAN chipsets generally. :)


-- 
David

