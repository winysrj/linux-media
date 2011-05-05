Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab1EEQiW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 12:38:22 -0400
Message-ID: <4DC2D26B.5050108@redhat.com>
Date: Thu, 05 May 2011 13:38:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: CX24116 i2c patch
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>	<4DC2A2D8.9060507@redhat.com> <BANLkTimDy7Z3Y6ZWR_GjCNZmxAzRaKveoA@mail.gmail.com>
In-Reply-To: <BANLkTimDy7Z3Y6ZWR_GjCNZmxAzRaKveoA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 12:34, Devin Heitmueller escreveu:
> On Thu, May 5, 2011 at 9:15 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> So, the I2C adapter xfer code will end by being something like:
>>
>> switch(i2c_device) {
>>        case FOO:
>>                use_split_code_foo();
>>                break;
>>        case BAR:
>>                use_splic_code_bar();
>>                break;
>>        ...
>> }
>>
>>
>> (if you want to see one example of the above, take a look at drivers/media/video/cx231xx/cx231xx-i2c.c).
> 
> The cx231xx is actually an example of a poor implementation

Yes.

> rather
> than a deficiency in the chip.  The device does support sending
> arbitrarily long sequences, but because of a lack of support for i2c
> clock stretching they hacked in their own GPIO based bitbang
> implementation which only gets used in certain cases. 

No. There are two different situations here: they use GPIO bitbang for
one device type, due to clock stretching, but also the hardware doesn't accept
long I2C messages. I've double-checked this with the vendor developers, and
double-checked the sniffed messages from the original driver.

The case I detected troubles were with tda18271 device (that doesn't use
clock stretching), and using the direct hardware support for I2C, at the
I2C bus 2. The Hauppauge devices that you've worked have the tuner connected
to the I2C bus 1. Perhaps bus 2 has a smaller hardware buffer, or perhaps
the chip revision present on the device I tested is more limited.

In any case, every time more than 4 data bytes were sent to tda18271, the
hardware returned an error.

If you take a look at cx231xx-core, you'll see that other types of non-GPIO
messages with more than 4 bytes are broken into smaller messages there.

> If somebody
> wanted to clean it up I believe it could be done much more cleanly.
> That said, it hasn't happened because the code as-is "works" and in
> reality I don't think there are any shipping products which use
> cx231xx and xc5000 (they are all Conexant reference designs).
> 
> If somebody really wants to clean this up, they should have a board
> profile field which indicates whether to create an i2c adapter which
> uses the onboard i2c controller, or alternatively to setup an i2c
> adapter which uses the real Linux i2c-bitbang implementation.  That
> would make the implementation much easier to understand as well as
> eliminating all the crap code which makes decisions based on the
> destination i2c address.

Yes, the code can be cleaned, but this won't solve the issue: messages still
need to be broken to be used by (some) I2C buses on it. 

Also, cx231xx is not an exception: there are very few hardware that would 
accept a 32 KB message to be sent directly via I2C. The hardware were this
is done via bit-bang will support. Also a few other devices like saa7134,
where data is sent byte by byte and kernel waits for the I2C device to indicate
that one byte were sent, and it can then forward the next byte. Yet, on
both cases, I don't think it is a good idea to send a 32 KB data into just
one I2C transaction.

However, on the devices where you pass a buffer to the hardware/firmware
(like all USB devices), the size of the I2C message is limited. The upper
limit is 80 bytes for an I2C control message, but several devices have
a lower limit for it.

Mauro.

