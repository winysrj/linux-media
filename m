Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48534 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab1DHU0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 16:26:18 -0400
Received: by ewy4 with SMTP id 4so1211868ewy.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 13:26:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15656328.2482791302255317486.JavaMail.defaultUser@defaultHost>
References: <15656328.2482791302255317486.JavaMail.defaultUser@defaultHost>
Date: Fri, 8 Apr 2011 16:26:16 -0400
Message-ID: <BANLkTinC8h232CkvmQ1UPRDKTZgybLp_Lg@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle PCTV Dual DVB-T Pro PCI 2000i
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org,
	"pigeonskiller@libero.it" <pigeonskiller@libero.it>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Apr 8, 2011 at 5:35 AM, pigeonskiller@libero.it
<pigeonskiller@libero.it> wrote:
> Pinnacle PCTV Dual DVB-T Pro PCI 2000i (http://linuxtv.org/wiki/index.php/DVB-
> T_PCI_Cards#Pinnacle) was introduced in 2006 and after 5 years it is still
> unsupported in linux!
> Unbelievable!

I'm not sure why you find it so unbelievable.  This is a project
largely composed of volunteers who are working on products in their
own time.  If it still isn't supported, then it means that no
developer owns a board and cares enough to spend a couple dozen hours
to make it work.

> Yet its chips Zarlink ZL10353 (http://linuxtv.org/wiki/index.
> php/Zarlink_ZL10353) and Microtune MT2060 (http://linuxtv.org/wiki/index.
> php/Microtune_MT2060) are supported (http://www.linuxtv.
> org/downloads/drivers/linux-media-LATEST.tar.bz2)!
> So, what is missing?

A developer who cares enough to do the work for free, or a corporate
entity willing to pay fair market prices to pay to have it supported?

> Probably this is the reason why Linux is not so widespread: LACK OF DRIVERS!
> And this is the reason why a lot of users cannot migrate to Linux and are
> forced to use that stupid O.S. called Win****!
> If anyone wants to have a look at Windows' drivers and is able to develop
> drivers (I'm not), here are the drivers:
> ftp://ftp.pctvsystems.com/TV/driver/PCTV%202000i/PCTV%20250i%202000i.zip

There are very few developers actively contributing to LinuxTV.  With
limited developer resources, they have to make decisions about what
they are going to work on.  if those decisions aren't aligned with
what *you* want them working on, then your only option really is to
learn to become a developer and add the support yourself.

You just have to look at motivation:  if a developer doesn't benefit
personally from having the card working, doesn't think it's fun to
make it work, and isn't being paid, then why invest ten or twenty
hours of his/her valuable time?

Welcome to a community of volunteers.  We'll be happy to refund 100%
of the money that you've paid to seeing this device work under Linux.
:-)

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
