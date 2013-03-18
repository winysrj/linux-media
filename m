Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:59656 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3CRXtk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 19:49:40 -0400
Received: by mail-ve0-f169.google.com with SMTP id 15so5023395vea.0
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2013 16:49:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303181449140.9529@pobox.suse.cz>
References: <20121228102928.4103390e@redhat.com>
	<CALW4P+KzhmzAeQUQDRxEyfiHNSkCeua81p=xzukp0k3tF7JEEg@mail.gmail.com>
	<63b74db2773903666ea02810e1e6c047@mail.mx6-sysproserver.de>
	<CALW4P+LtcO_=c9a30xgFvQ+61r8=BxNifsn6x_8bbtceNkJ-jA@mail.gmail.com>
	<alpine.LNX.2.00.1303181449140.9529@pobox.suse.cz>
Date: Tue, 19 Mar 2013 03:49:39 +0400
Message-ID: <CALW4P+L1QKe=1wNkr90LsZY89OFnGBKB2N6yVeDhnyab_rSsnA@mail.gmail.com>
Subject: Re: Fw: [patch 02/03 v2] usb hid quirks for Masterkit MA901 usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Dirk E. Wagner" <linux@wagner-budenheim.de>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 18, 2013 at 5:51 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 15 Mar 2013, Alexey Klimov wrote:
>
>> > indeed your patch breaks Atmega applications which using V-USB
>> > (http://www.obdev.at/products/vusb/index.html), because 0x16c0, 0x05df are
>> > the default Ids of V-USB.
>> >
>> > Have a look at this FAQ
>> >
>> > https://github.com/obdev/v-usb/blob/master/usbdrv/USB-ID-FAQ.txt
>> >
>> > It seems that the Masterkit M901 also uses V-USB.
>> >
>> > I'm using an IR remote control receiver based on Atmega8 with V-USB. Since
>> > Kernel 3.8.2 there is no more hidraw device for my receiver, so I had to
>> > change the Device-ID to 0x27d9. I think there are a lot of other V-USB
>> > applications with similar problems.
>> >
>> > Dirk
>>
>> Exactly. That's why i tried to point it out. Thanks for explaining
>> this in simplier words.
>>
>> It's difficult to answer on top posting emails.
>>
>> I don't understand one thing about your letter. Did you put
>> linux-media kernel list in bcc (hide copy)? Is there any reason for
>> this? http://www.mail-archive.com/linux-media@vger.kernel.org/msg59714.html
>>
>> Mauro, Jiri,
>> can we revert this patch? If you need any ack or sign from me i'm
>> ready to send it.
>>
>> I can contact people who cares about stable trees and ask them to
>> revert this patch from stable trees.
>>
>> During 3.9-rcX cycle i can try to figure out some fix or additional
>> checks for radio-ma901.c driver.
>
> I can revert 0322bd3980 and push it out to Linus for 3.9 still, Ccing
> stable.
>
> Or Mauro, as the original patch went in through your tree, are you
> handling that?

I think we really need to revert it before final release. It's already -rc3.

> Also additional work will be needed later to properly detect the
> underlying device ... the best thing to do here is to put an entry into
> hid_ignore(), similar to what we do for example for Keene FM vs. Logitech
> AudioHub.

Yes, i just checked how hid_ignore() works and prepared dirty fix to
test in almost the same way like it's done for Keene usb driver. I
will send correct fix in next few days.

Thanks.
Best regards, Klimov Alexey
