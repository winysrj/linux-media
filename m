Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:34876 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbZFWCli (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 22:41:38 -0400
Subject: Re: SAA7133 failure under Kernel 2.6.29
From: hermann pitton <hermann-pitton@arcor.de>
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <a413d4880906221902u6ea088abk6cecfabd0f814051@mail.gmail.com>
References: <a413d4880906221902u6ea088abk6cecfabd0f814051@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 04:37:57 +0200
Message-Id: <1245724677.12341.16.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 23.06.2009, 03:02 +0100 schrieb Another Sillyname:
> I noted from a discussion in the list back in April there were
> problems with SAA7133 devices under 2.6.29 Kernel.
> 
> I have such a device and just upgraded to Fed 11 yesterday, device now
> fails.  Under Fed 10 no problems.
> 
> I'm happy to provide dmesg and lspci and whatever else you need,
> however don't want to clutter the list with data that may not be
> needed.
> 
> The device in question is a 5168:3307 Lifeview Hybrid and I'm getting
> the "IRQF_Disabled" error previously described.
> 
> Any ideas chaps?
> 
> Thanks in Advance

thanks for your report!

We tried to track it down, but there was no good/bad on mercurial to
start on for me and kernel git stuff is pretty well off on any of it
too.

As far I can say it is not related to that "IRQF Disabled" stuff, but
that seems to be a cruft anyway and I can't tell what finally all might
come out of it.

Currently I believe (my!) that it only happens with multiple saa7134
driver devices.

Likely you are another proof for, that this is not the case.

Please provide related "dmesg" output.

If you are in the same boat, only known current cure is to try a 2.6.30
or faall back on a 2.6.28. (Likely even more in that soup)

That is of course all still very unplesant (:

Cheers,
Hermann


