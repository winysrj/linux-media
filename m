Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:55908 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751412Ab1EHKBd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 06:01:33 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Pinnacle PCTV Dual DVB-T Pro PCI 2000i
Date: Sun, 8 May 2011 12:01:23 +0200
Cc: "pigeonskiller@libero.it" <pigeonskiller@libero.it>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <15656328.2482791302255317486.JavaMail.defaultUser@defaultHost> <BANLkTikfZDqyEhb83fwv5BArb8qH6xHxew@mail.gmail.com>
In-Reply-To: <BANLkTikfZDqyEhb83fwv5BArb8qH6xHxew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105081201.23621.hfvogt@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am Samstag, 9. April 2011 schrieb Devin Heitmueller:
> On Fri, Apr 8, 2011 at 5:35 AM, pigeonskiller@libero.it
> 
> <pigeonskiller@libero.it> wrote:
> > Pinnacle PCTV Dual DVB-T Pro PCI 2000i
> > (http://linuxtv.org/wiki/index.php/DVB- T_PCI_Cards#Pinnacle) was
> > introduced in 2006 and after 5 years it is still unsupported in linux!
> > Unbelievable!
> > Yet its chips Zarlink ZL10353 (http://linuxtv.org/wiki/index.
> > php/Zarlink_ZL10353) and Microtune MT2060 (http://linuxtv.org/wiki/index.
> > php/Microtune_MT2060) are supported (http://www.linuxtv.
> > org/downloads/drivers/linux-media-LATEST.tar.bz2)!
> > So, what is missing?
> > Probably this is the reason why Linux is not so widespread: LACK OF
> > DRIVERS! And this is the reason why a lot of users cannot migrate to
> > Linux and are forced to use that stupid O.S. called Win****!
> > If anyone wants to have a look at Windows' drivers and is able to develop
> > drivers (I'm not), here are the drivers:
> > ftp://ftp.pctvsystems.com/TV/driver/PCTV%202000i/PCTV%20250i%202000i.zip
> > 
> > Sorry for the outburst.
> > A user wishing to migrate to Linux.
> 
> Just a quick followup.  I talked to my engineering contact over at
> PCTV and got some more information about the product.  The PCI bridge
> in question is proprietary to Pinnacle and only used in four of their
> products.  By contrast, most of the bridges we add support for are
> used by dozens of products by multiple vendors (and in most cases at
> least somebody working on the Linux driver has documentation from the
> chipset vendor under NDA).
> 
> Adding support for a new bridge often takes weeks or even months of
> development (and that's when the developer has supporting
> documentation).  It doesn't make sense for a LinuxTV developer to make
> that sort of investment in time unless there is a good level of
> confidence that the work would apply to a large number of products.
> 
> In other words, out of dumb lucked you happened to have bought a
> device that will likely *never* be supported because of the components
> used.  Your best bet is to spend a few bucks and buy a recent product
> (five years is an eternity in the computer business).
> 
> Devin

Some years ago I started writing a driver for this card (which should have 
covered as well the single tuner version and the DVB-S versions of that card).
I found out quite a lot of the register set of the DTV bridge (e.g. I2C 
communication, talking to the tuners and demodulators), but was stuck when it 
came to DMA transfers (probably because I haven't written a driver for such a 
complex piece of hardware before).
Finally I lost interest because I switched to a PCIe based solution (DVICO 
DVB-T Dual express, which worked practically "out of the box").

If anybody is interested I am happy to share my notes and the pieces of the 
driver that I put together.

Hans-Frieder

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
