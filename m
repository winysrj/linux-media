Return-path: <mchehab@pedra>
Received: from smtp28.orange.fr ([80.12.242.100]:30588 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab0I3R4w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 13:56:52 -0400
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
Date: Thu, 30 Sep 2010 19:56:49 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <1285795123-11046-2-git-send-email-yann.morin.1998@anciens.enib.fr> <4CA45AFC.2080807@iki.fi>
In-Reply-To: <4CA45AFC.2080807@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009301956.50154.yann.morin.1998@anciens.enib.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Antti, All,

On Thursday 30 September 2010 11:40:12 Antti Palosaari wrote:
> >   	/* AverMedia AVerTV Volar Black HD (A850) device have bad EEPROM
> > -	   content :-( Override some wrong values here. */
> > +	   content :-( Override some wrong values here. Ditto for the
> > +	   AVerTV Red HD+ (A850T) device. */
> >   	if (le16_to_cpu(udev->descriptor.idVendor) == USB_VID_AVERMEDIA&&
> > -	    le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) {
> > +	    ((le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) ||
> > +	     (le16_to_cpu(udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850T))) {
> >   		deb_info("%s: AverMedia A850: overriding config\n", __func__);
> >   		/* disable dual mode */
> >   		af9015_config.dual_mode = 0;
> Are you sure it does also have such bad eeprom content? Is that really 
> needed? What it happens without this hack?

Well, not really sure. The fact is that it works with the kludge, and that
the device is very similar to the A850. On the Ubuntu forums, they simply
suggested replacing the A850 Product ID 0x850a with the A850T PID 0x850b
to make it work. And indeed it does work flawlessly so far.

Disabling dual mode when it is working, is better that enabling it when it
is not working. I tried to be conservative in this case.

I'll be doing some testing without the kludge later tonight, or at worst
during the WE. Unfortunately, the current v4l git tree BUGs in the USB
sub-system on my machine (even without my changes).

> >   				.name = "AverMedia AVerTV Volar Black HD " \
> > -					"(A850)",
> > -				.cold_ids = {&af9015_usb_table[20], NULL},
> > +					"(A850) / AVerTV Volar Red HD+ (A850T)",
> > +				.cold_ids = {&af9015_usb_table[20],
> > +					&af9015_usb_table[33], NULL},
> Add new entry for that device (and leave A850 as untouched).

OK. The number of supported devices is already 9 in all sections, so I guess
I'll have to add a new entry in the af9015_properties array, before I can
add a new device, right?

And what is the intrinsic difference between adding a new device section,
compared to adding a new PID to an existing device (just curious) ?

Thanks for the review. :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'


