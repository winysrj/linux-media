Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64082 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1GCCri (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 22:47:38 -0400
Received: by gyh3 with SMTP id 3so1671741gyh.19
        for <linux-media@vger.kernel.org>; Sat, 02 Jul 2011 19:47:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0F7E5F.3040702@hoogenraad.net>
References: <4E0EC37F.1010201@internode.on.net> <4E0F7E5F.3040702@hoogenraad.net>
From: Joel Stanley <joel@jms.id.au>
Date: Sun, 3 Jul 2011 12:17:16 +0930
Message-ID: <CACPK8Xd5HzdVSX6=QKoNjWMWCOMTKh7s=1==j9aDki6zJcFBBw@mail.gmail.com>
Subject: Re: Fwd: 0bda:2838 Ezcap DVB USB adaptor - no device files created / RTL2831U/RTL2832U
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Jan,

On Sun, Jul 3, 2011 at 05:53, Jan Hoogenraad
<jan-conceptronic@hoogenraad.net> wrote:
> I have decided AGAINST making it runnable on newer kernels, as there are
> some people working right now on a new release.

I appreciate that you would prefer efforts to go towards a upstream
driver. In the mean time I've updated the git tree[1] on my website.
There were no real changes required; just a re-build with an updated
dvb-usb.h and dvb_frontend.h from the kernel tree. Checkout the
linux-3 branch.

> Once the status becomes more clear, I'll update
> http://www.linuxtv.org/wiki/index.php/Realtek_RTL2831U

Are you able to give us more information on this new driver? Is there
a tree somewhere we can test, or perhaps assist in writing the driver?

Cheers,

Joel

[1] A disclaimer: the git tree is a horrible hack so that I can watch
tv; I look forward to a in-tree driver.
