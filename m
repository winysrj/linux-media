Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58493 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab1EEPe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 11:34:56 -0400
Received: by eyx24 with SMTP id 24so712858eyx.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 08:34:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC2A2D8.9060507@redhat.com>
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
	<4DC2A2D8.9060507@redhat.com>
Date: Thu, 5 May 2011 11:34:54 -0400
Message-ID: <BANLkTimDy7Z3Y6ZWR_GjCNZmxAzRaKveoA@mail.gmail.com>
Subject: Re: CX24116 i2c patch
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, May 5, 2011 at 9:15 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> So, the I2C adapter xfer code will end by being something like:
>
> switch(i2c_device) {
>        case FOO:
>                use_split_code_foo();
>                break;
>        case BAR:
>                use_splic_code_bar();
>                break;
>        ...
> }
>
>
> (if you want to see one example of the above, take a look at drivers/media/video/cx231xx/cx231xx-i2c.c).

The cx231xx is actually an example of a poor implementation rather
than a deficiency in the chip.  The device does support sending
arbitrarily long sequences, but because of a lack of support for i2c
clock stretching they hacked in their own GPIO based bitbang
implementation which only gets used in certain cases.  If somebody
wanted to clean it up I believe it could be done much more cleanly.
That said, it hasn't happened because the code as-is "works" and in
reality I don't think there are any shipping products which use
cx231xx and xc5000 (they are all Conexant reference designs).

If somebody really wants to clean this up, they should have a board
profile field which indicates whether to create an i2c adapter which
uses the onboard i2c controller, or alternatively to setup an i2c
adapter which uses the real Linux i2c-bitbang implementation.  That
would make the implementation much easier to understand as well as
eliminating all the crap code which makes decisions based on the
destination i2c address.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
