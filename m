Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45064 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZLYM3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 07:29:45 -0500
Received: by ewy19 with SMTP id 19so158363ewy.21
        for <linux-media@vger.kernel.org>; Fri, 25 Dec 2009 04:29:43 -0800 (PST)
Date: Fri, 25 Dec 2009 13:29:40 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: TAXI <taxi@a-city.de>
cc: linux-media@vger.kernel.org
Subject: Re: Bad image/sound quality with Medion MD 95700
In-Reply-To: <4B34961D.6060207@a-city.de>
Message-ID: <alpine.DEB.2.01.0912251246540.5481@ybpnyubfg.ybpnyqbznva>
References: <4B33F4CA.7060607@a-city.de> <alpine.DEB.2.01.0912251021210.5481@ybpnyubfg.ybpnyqbznva> <4B34961D.6060207@a-city.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moin moin, TAXI...

On Fri, 25 Dec 2009, TAXI wrote:

> BOUWSMA Barry schrieb:
> > The other thing to note is that this device delivers a full
> > unfiltered Transport Stream, which with the 13,27Mbit/sec typical
> > bandwidth per channel used in your country (apart from some local
> > exceptions of greater values), will require a USB2 interface.

> it is a USB2 interface:
> [    3.965425] usb 1-3.1: new high speed USB device using ehci_hcd and
> address 6 (it's the USB hub in the box)

Na gut -- so habe ich erwartet.  Aber sicher ist sicher, vertrauen 
ist gut, usw.

Or in english, I expected that, but it is always good to be sure, 
as it is one of the problems or bottlenecks which I regularly
experience.


> > around line 620 in my reference code, there is a line that sets
> > the alternate interface to 6.  This is expected to be bulk, but
> > on my boxes is isoc.
> > 
> > You can change this to interface 0, on which my boxes delivers
> > bulk data flawlessly.

> I think isoc would be okay on 2.6.32, so no need to change that, right?

Das Problem ist, der Treiber erwartet BULK Datei, nicht ISOC, aber
das Kistchen liefert ISOC (isochronous) Datei.  Deswegen kommt es
zu Probleme.

Or, the thing is, Linux is expecting to be seeing bulk data on 
this particular alternate interface (6).  If the receiver is not
delivering this, but is instead delivering isochronous data, it's
not in the same format and isn't properly handled by the driver.

Changing it so that the driver reads from alternate interface 0
results in all my hacked versions being able to read the data
properly.  Even before reading isoc data through hubs was fixed
sometime around or before 2.6.18-ish.



> > but when
> > I have my machine operating fully again (yeahright), I can send
> > you some of these alternative patches to try -- running 
> > successfully on 2.6.14 and 2.6.27-rc4.

> That would be nice.
> 
> P.S. my english is not the best so I don't understand all you wrote but
> why don't you put the patches upstream?

Mein deutsch ist noch schlimmer, wie Du siehst  :-)  Verzeihung 
wegen meine Muttersprache -- gerne schreibe ich, falls moeglich,
einfacher und verstaendlich.

Es gibt zwei moegliche Loesungen, entweder einen anderen Dateityp
aus'm `Endpunkt' zu lesen, oder aus ein anderem `Endpunkt' lesen.
Mein Kode ist leider nicht sauber.  Es laeuft bei mir, aber 
koennte Probleme bei anderen verursachen.  Ich kann keine 
Unterschiede zwischen `bulk' und `isoc' Datei auch mit 'nem 
200MHz Server feststellen, und kann deswegen keine gute Wahl 
zwischen die beiden entscheiden.  Ich bin auch mit meiner Loesung 
nicht ganz zufrieden.

Or, I hope you see from my dreadful sentences above that you need
not be ashamed of your english, but I will be happy to re-phrase
and try to clarify anything I have written.

My work-in-progress patches try to use the two possible solutions,
without affecting anyone whose receivers work, but I have not 
found a clear reason to favour one solution over the other.  The
solution which I think stomps less on the existing code is not
perfect (first tuning fails), and after getting my receivers to
work with both possibilities, I have not tried to clean up the
two solutions for submissions as possible patches.


Hast Du die 2.6.32 Quellkode?  Kannst Du aus `patches' etwas 
schaffen, und dabei die beide Moeglichkeiten testen?

(Are you able to build a new kernel to test my patches to see
if they solve your problem?)


barry bouwsma
('tschuldigung, wegen moi' Tastatur, Grammatik, Woerterschatz,
und allgemein Bloedheit)
