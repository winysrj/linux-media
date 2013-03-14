Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53490 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3CNUzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 16:55:38 -0400
Received: by mail-vc0-f169.google.com with SMTP id kw10so751517vcb.28
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2013 13:55:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de>
References: <20121228102928.4103390e@redhat.com>
	<CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com>
	<63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de>
Date: Fri, 15 Mar 2013 00:55:36 +0400
Message-ID: <CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: "Dirk E. Wagner" <linux@wagner-budenheim.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media <linux-media@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 14, 2013 at 2:20 PM, Dirk E. Wagner
<linux@wagner-budenheim.de> wrote:
> Hi Alexey,

Hi Dirk, Mauro, Jiri

> indeed your patch breaks Atmega applications which using V-USB
> (http://www.obdev.at/products/vusb/index.html), because 0x16c0, 0x05df are
> the default Ids of V-USB.
>
> Have a look at this FAQ
>
> https://github.com/obdev/v-usb/blob/master/usbdrv/USB-ID-FAQ.txt
>
> It seems that the Masterkit M901 also uses V-USB.
>
> I'm using an IR remote control receiver based on Atmega8 with V-USB. Since
> Kernel 3.8.2 there is no more hidraw device for my receiver, so I had to
> change the Device-ID to 0x27d9. I think there are a lot of other V-USB
> applications with similar problems.
>
> Dirk

Exactly. That's why i tried to point it out. Thanks for explaining
this in simplier words.

It's difficult to answer on top posting emails.

I don't understand one thing about your letter. Did you put
linux-media kernel list in bcc (hide copy)? Is there any reason for
this? http://www.mail-archive.com/linux-media@vger.kernel.org/msg59714.html

Mauro, Jiri,
can we revert this patch? If you need any ack or sign from me i'm
ready to send it.

I can contact people who cares about stable trees and ask them to
revert this patch from stable trees.

During 3.9-rcX cycle i can try to figure out some fix or additional
checks for radio-ma901.c driver.
-- 
Thanks & best regards, Klimov Alexey
