Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57874 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaBCWos (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Feb 2014 17:44:48 -0500
Message-ID: <52F01BDE.7020102@iki.fi>
Date: Tue, 04 Feb 2014 00:44:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: divenal+catchall@plus.com, linux-media@vger.kernel.org
Subject: Re: report success with USB DVB-T device - "August DVB-T205"
References: <c70f317fd3025425b4dc17d41fe3fa04.squirrel@webmail.plus.net>
In-Reply-To: <c70f317fd3025425b4dc17d41fe3fa04.squirrel@webmail.plus.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka

On 03.02.2014 20:37, divenal+catchall@plus.com wrote:
> Hi,
>     I tried to add this directly to the wiki list of devices, but failed.
> Either I'm too thick to follow the instructions, or there's a
> permission problem trying to edit the template area. Perhaps someone
> can do the honours. Apologies if this is an inappropriate use of the
> mailing list, or if it is already on the wiki and I just overlooked it.

I am not sure what is wrong with the wiki, but it is very often people 
are complaining they have no permission to edit.

> The "August DVB-T205" is a low-cost device available on Amazon-uk. I got
> it about 6 months ago, and didn't have much success initially, so I
> resigned myself to using it on windows. Gave it another go this weekend,
> having read a note that it works with kernel 3.10 and above. I upgraded a
> debian system to 3.12 and managed to get it working, successfully
> recording some freeview via   tzap -o ...

According to my notes, support has gone 3.11
3.11    1f4d:a803 Crypto ReDi PC 50 A

I see nowadays quite often these ID patches to back-ported to older 
stable kernels, so it may be supported 3.10 or elder.

> It does come with a remote control, but I've not tried that yet.

RTL2832U remote controller support was added 3.11. There is no default 
keytable defined for that device, so you have to download it manually. I 
have feeling that same device ID is used for multiple models so it is 
not likely even possible (or wise) to add default keytable.


regards
Antti

>
>
> Details:
>
>   "August DVB-T205"
>    http://www.amazon.co.uk/August-DVB-T205-Freeview-Tuner-Stick/dp/B002EHVP9C/ref=cm_cr_pr_product_top
>
>    USB 2.0 ID 1f4d:a803 G-Tek Electronics Group
>
> dmesg reports
>
> [   55.344057] usb 4-5: new high-speed USB device number 2 using ehci-pci
> [   55.487947] usb 4-5: New USB device found, idVendor=1f4d, idProduct=a803
> [   55.487955] usb 4-5: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> [   55.487960] usb 4-5: Product: RTL2838UHIDIR
> [   55.487964] usb 4-5: Manufacturer: Realtek
> [   55.487967] usb 4-5: SerialNumber: 000000041
> [   55.658996] usb 4-5: dvb_usb_v2: found a 'Crypto ReDi PC 50 A' in warm
> state
> [   55.700691] usb 4-5: dvb_usb_v2: will pass the complete MPEG2 transport
> stream to the software demuxer
> [   55.700739] DVB: registering new adapter (Crypto ReDi PC 50 A)
> [   55.746061] usb 4-5: DVB: registering adapter 0 frontend 0 (Realtek
> RTL2832 (DVB-T))...
> [   55.794313] fc0013: Fitipower FC0013 successfully attached.
> [   55.801291] Registered IR keymap rc-empty
> [   55.801464] input: Crypto ReDi PC 50 A as
> /devices/pci0000:00/0000:00:1d.7/usb4/4-5/rc/rc0/input6
> [   55.803358] rc0: Crypto ReDi PC 50 A as
> /devices/pci0000:00/0000:00:1d.7/usb4/4-5/rc/rc0
> [   55.829012] IR RC5(x) protocol handler initialized
> [   55.836156] IR NEC protocol handler initialized
> [   55.837017] IR RC6 protocol handler initialized
> [   55.839978] IR JVC protocol handler initialized
> [   55.842955] IR Sony protocol handler initialized
> [   55.849256] IR SANYO protocol handler initialized
> [   55.852814] usb 4-5: dvb_usb_v2: schedule remote query interval to 400
> msecs
> [   55.856952] input: MCE IR Keyboard/Mouse (dvb_usb_rtl28xxu) as
> /devices/virtual/input/input7
> [   55.857919] IR MCE Keyboard/mouse protocol handler initialized
> [   55.863233] lirc_dev: IR Remote Control driver registered, major 251
> [   55.866471] usb 4-5: dvb_usb_v2: 'Crypto ReDi PC 50 A' successfully
> initialized and connected
> [   55.866577] usbcore: registered new interface driver dvb_usb_rtl28xxu
> [   55.871792] rc rc0: lirc_dev: driver ir-lirc-codec (dvb_usb_rtl28xxu)
> registered at minor = 0
> [   55.871803] IR LIRC bridge handler initialized
>
>
> Dave
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
http://palosaari.fi/
