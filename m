Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45480 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab1DIQ1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2011 12:27:34 -0400
Received: by eyx24 with SMTP id 24so1363583eyx.19
        for <linux-media@vger.kernel.org>; Sat, 09 Apr 2011 09:27:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <15656328.2482791302255317486.JavaMail.defaultUser@defaultHost>
References: <15656328.2482791302255317486.JavaMail.defaultUser@defaultHost>
Date: Sat, 9 Apr 2011 12:27:30 -0400
Message-ID: <BANLkTikfZDqyEhb83fwv5BArb8qH6xHxew@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle PCTV Dual DVB-T Pro PCI 2000i
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org,
	"pigeonskiller@libero.it" <pigeonskiller@libero.it>
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Apr 8, 2011 at 5:35 AM, pigeonskiller@libero.it
<pigeonskiller@libero.it> wrote:
> Pinnacle PCTV Dual DVB-T Pro PCI 2000i (http://linuxtv.org/wiki/index.php/DVB-
> T_PCI_Cards#Pinnacle) was introduced in 2006 and after 5 years it is still
> unsupported in linux!
> Unbelievable!
> Yet its chips Zarlink ZL10353 (http://linuxtv.org/wiki/index.
> php/Zarlink_ZL10353) and Microtune MT2060 (http://linuxtv.org/wiki/index.
> php/Microtune_MT2060) are supported (http://www.linuxtv.
> org/downloads/drivers/linux-media-LATEST.tar.bz2)!
> So, what is missing?
> Probably this is the reason why Linux is not so widespread: LACK OF DRIVERS!
> And this is the reason why a lot of users cannot migrate to Linux and are
> forced to use that stupid O.S. called Win****!
> If anyone wants to have a look at Windows' drivers and is able to develop
> drivers (I'm not), here are the drivers:
> ftp://ftp.pctvsystems.com/TV/driver/PCTV%202000i/PCTV%20250i%202000i.zip
>
> Sorry for the outburst.
> A user wishing to migrate to Linux.

Just a quick followup.  I talked to my engineering contact over at
PCTV and got some more information about the product.  The PCI bridge
in question is proprietary to Pinnacle and only used in four of their
products.  By contrast, most of the bridges we add support for are
used by dozens of products by multiple vendors (and in most cases at
least somebody working on the Linux driver has documentation from the
chipset vendor under NDA).

Adding support for a new bridge often takes weeks or even months of
development (and that's when the developer has supporting
documentation).  It doesn't make sense for a LinuxTV developer to make
that sort of investment in time unless there is a good level of
confidence that the work would apply to a large number of products.

In other words, out of dumb lucked you happened to have bought a
device that will likely *never* be supported because of the components
used.  Your best bet is to spend a few bucks and buy a recent product
(five years is an eternity in the computer business).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
