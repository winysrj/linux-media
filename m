Return-path: <mchehab@pedra>
Received: from mx1.polytechnique.org ([129.104.30.34]:55880 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935075Ab0KQTdf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:33:35 -0500
Message-ID: <4CE42E0D.6030903@free.fr>
Date: Wed, 17 Nov 2010 20:33:33 +0100
From: Massis Sirapian <msirapian@free.fr>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Richard Zidlicky <rz@linux-m68k.org>, linux-media@vger.kernel.org
Subject: Re: HVR900H : IR Remote Control
References: <4CDFF446.2000403@free.fr> <4CE0047D.8060401@arcor.de> <4CE03704.4070300@free.fr> <20101115091544.GA23490@linux-m68k.org> <4CE1715B.2070403@arcor.de> <4CE19F86.3010901@free.fr> <4CE1A13C.9000707@arcor.de> <4CE2E8FE.2030004@free.fr> <4CE2EA70.3060306@arcor.de> <4CE2ECB2.2010004@free.fr> <4CE2EF14.40007@arcor.de>
In-Reply-To: <4CE2EF14.40007@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


>>> load the tm6000 module with the parameter "ir_debug=1". (not the
>>> tm6000_dvb), and check dmsg after you pressed a button. Have the
>>> received code the same from the map?
>>>
>> I have only
>> [ 5232.133592] tm5600/60x0 IR (tm6000 #0)/ir: ir->get_key result
>> data=0000
>> endlessly, and nothing seems to change when I press a button.
> can you test a little change in tm6000-input.c. The dprintk line "this
> line" move to "here", and then testing it.
>
> return;
> }
>
> dprintk("ir->get_key result data=%04x\n", poll_result.rc_data); // this
> line
>
> if (ir->key) {
> // here
> ir_keydown(ir->rc, poll_result.rc_data, 0);
> ir->key = 0;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
I've just tested the new kernel compiled with the modifie tm6000-cards.c

Nothing happens when I press a button :

[  227.643920] input: tm5600/60x0 IR (tm6000 #0) as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc0/input7
[  227.643965] rc0: tm5600/60x0 IR (tm6000 #0) as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/rc/rc0
[  227.759492] usbcore: registered new interface driver tm6000
[  229.015963] tm6000: open called (dev=video1)

are the last lines of dmesg, and my pressing any button doesn't change 
anything.

Massis

