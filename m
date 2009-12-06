Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZLFMC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 07:02:26 -0500
Date: 06 Dec 2009 12:59:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: dmitry.torokhov@gmail.com
Cc: awalls@radix.net
Cc: hermann-pitton@arcor.de
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BENgzeZHqgB@lirc>
In-Reply-To: <20091206065512.GA14651@core.coreip.homeip.net>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

on 05 Dec 09 at 22:55, Dmitry Torokhov wrote:
[...]
> I do not believe you are being realistic. Sometimes we just need to say
> that the device is a POS and is just not worth it. Remember, there is
> still "lirc hole" for the hard core people still using solder to produce
> something out of the spare electronic components that may be made to
> work (never mind that it causes the CPU constantly poll the device, not
> letting it sleep and wasting electricity as a result - just hypotetical
> example here).

The still seems to be is a persistent misconception that the home-brewn  
receivers need polling or cause heavy CPU load. No they don't. All of them  
are IRQ based.
It's the commercial solutions like gpio based IR that need polling.
For transmitters it's a different story, but you don't transmit 24h/7.

Christoph
