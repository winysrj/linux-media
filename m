Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3CRNvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 09:51:38 -0400
Date: Mon, 18 Mar 2013 14:51:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: "Dirk E. Wagner" <linux@wagner-budenheim.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb
 radio
In-Reply-To: <CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1303181449140.9529@pobox.suse.cz>
References: <20121228102928.4103390e@redhat.com> <CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com> <63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de> <CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Mar 2013, Alexey Klimov wrote:

> > indeed your patch breaks Atmega applications which using V-USB
> > (http://www.obdev.at/products/vusb/index.html), because 0x16c0, 0x05df are
> > the default Ids of V-USB.
> >
> > Have a look at this FAQ
> >
> > https://github.com/obdev/v-usb/blob/master/usbdrv/USB-ID-FAQ.txt
> >
> > It seems that the Masterkit M901 also uses V-USB.
> >
> > I'm using an IR remote control receiver based on Atmega8 with V-USB. Since
> > Kernel 3.8.2 there is no more hidraw device for my receiver, so I had to
> > change the Device-ID to 0x27d9. I think there are a lot of other V-USB
> > applications with similar problems.
> >
> > Dirk
> 
> Exactly. That's why i tried to point it out. Thanks for explaining
> this in simplier words.
> 
> It's difficult to answer on top posting emails.
> 
> I don't understand one thing about your letter. Did you put
> linux-media kernel list in bcc (hide copy)? Is there any reason for
> this? http://www.mail-archive.com/linux-media@vger.kernel.org/msg59714.html
> 
> Mauro, Jiri,
> can we revert this patch? If you need any ack or sign from me i'm
> ready to send it.
> 
> I can contact people who cares about stable trees and ask them to
> revert this patch from stable trees.
> 
> During 3.9-rcX cycle i can try to figure out some fix or additional
> checks for radio-ma901.c driver.

I can revert 0322bd3980 and push it out to Linus for 3.9 still, Ccing 
stable.

Or Mauro, as the original patch went in through your tree, are you 
handling that?

Also additional work will be needed later to properly detect the 
underlying device ... the best thing to do here is to put an entry into 
hid_ignore(), similar to what we do for example for Keene FM vs. Logitech 
AudioHub.

-- 
Jiri Kosina
SUSE Labs
