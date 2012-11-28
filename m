Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51462 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2K1UrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 15:47:11 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so5946491bkw.19
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 12:47:10 -0800 (PST)
Message-ID: <50B67851.2010808@googlemail.com>
Date: Wed, 28 Nov 2012 21:47:13 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net>
In-Reply-To: <50B5779A.9090807@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthew,

thank you for reporting this device and your investigations !

Am 28.11.2012 03:31, schrieb Matthew Gyurgyik:
> Hi,
>
> I recently acquired a msi Digivox ATSC tuner. I believe this card has
> an em28xx chip (the windows driver included is em28xx). Looking at the
> em28xx wiki page and digging around in the code it does not seem like
> the em28xx driver has support for this card. Based on my limit
> (extremely) amount of knowledge, it doesn't look like it would be
> terribly difficult to add support for this card.
>
> I am a complete hardware newbie (looking and willing to learn) and I
> hoping someone will be willing to help me out.
>
> Following the bus snooping guide I was able to snoop the usb tuner
> (using usbsnoop 2.0) and collect some data from this card (Windows XP,
> using the ArcSoft TotalMedia software the card shipped with).
>
> $ php parse-usbsnoop.php UsbSnoop.log > parsed-usbsnoop.txt
> http://pyther.net/a/digivox_atsc/parsed-usbsnoop.txt
>
> $ perl contrib_em28xx_parse_em28xx.pl parsed-usbsnoop.txt >
> parse_em28xx.txt
> http://pyther.net/a/digivox_atsc/parse_em28xx.txt
>
> $ lsusb -vvv (snippet)
> http://pyther.net/a/digivox_atsc/lsusb.txt
>
> Note: If necessary I can provide the entire UsbSnoop.log (however its
> ~350MB)
>
> At this point I'm not really sure how to use the above information to
> add support for my tuner. For starters I have non-existent C skills.
> From what I've looked at, I figure I have to add the vendor id and
> product id and it looks like I need to create a struct defining the
> input devices on the tuner (just astc/dvb on this card). It also looks
> like I need to find out the reset codes?

Your device seems to use a EM2874 bridge.
Any chance to open the device and find out which demodulator it uses ?
Are you able to compile a kernel on your own to test patches ? It's not
that hard... ;)

Regards,
Frank


>
> Any help would be greatly appreciated.
>
> Model: msi Digivox ATSC
> Vendor / Product Id: [0db0:8810]
> URL: http://www.msi.com/product/mm/DIGIVOX-ATSC.html
>
> Thanks
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

