Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55317 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab1KILBD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 06:01:03 -0500
Message-ID: <4EBA5D6A.4040300@iki.fi>
Date: Wed, 09 Nov 2011 13:00:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [RFC 1/2] dvb-core: add generic helper function for I2C register
References: <4EB9C13A.2060707@iki.fi>	<4EBA4E3D.80105@redhat.com> <20111109113740.4b345130@endymion.delvare>
In-Reply-To: <20111109113740.4b345130@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/09/2011 12:37 PM, Jean Delvare wrote:
> On Wed, 09 Nov 2011 07:56:13 -0200, Mauro Carvalho Chehab wrote:
>>      ret = i2c_transfer(i2c_cfg->adapter, msg, 2);
>>
>> Produces a different result. In the latter case, I2C core avoids having any other
>> transaction in the middle of the 2 messages.
>
> This is correct, but this isn't the only difference. The second
> difference is that, with the code above, a repeated-start condition is
> used between both messages, instead of a stop condition followed by a
> start condition. While ideally all controllers, all controller drivers
> and all slaves would support that, I don't think this is true in
> practice.

I agree, as we just replied same time to that message :)

> I agree that it makes some sense. We recently added helper functions for
> swapped word reads, to avoid code duplication amongst device drivers.
> This would follow a similar logic.
>
> However you should bear in mind that different I2C devices have
> different expectations and requirements. Some do automatic register
> address increment, some don't. Some support arbitrary read/write
> length and alignment, some don't. It is common that write constraints
> differ from read constraints. So you won't possibly come up with
> universal I2C read and write functions. There is a reason why it was
> originally decided to only provide the low-level transfer functions in
> i2c-core and leave the rest up to individual device drivers.

So true. Some chips allow even configure auto increment or not and even 
more.
But I take that most common behaviour way. It is never possible to 
support all I2C access formats chip vendors will define. But that first 
reg then values with auto increment is very common, maybe over 90% cases.

> If code is duplicated, then something should indeed be done about it.
> But preferably after analyzing properly what the helper functions
> should look like, and for this you'll have to look at "all" drivers
> that could benefit from it. At the moment only the tda18218 driver was
> reported to need it, that's not enough to generalize.

Only?, I think you missed part of my first mail I mentioned 7 cases from 
*my* drivers where splitting is needed. Actually, I just remember one 
more, it is AF9015 & AF9033. And those are for the splitting only, same 
function can be used maybe 90% of current tuner and demod drivers we have.

> You should take a look at drivers/misc/eeprom/at24.c, it contains
> fairly complete transfer functions which cover the various EEPROM
> types. Non-EEPROM devices could behave differently, but this would
> still seem to be a good start for any I2C device using block transfers.
> It was once proposed that these functions could make their way into
> i2c-core or a generic i2c helper function.
>
> Both at24 and Antti's proposal share the idea of storing information
> about the device capabilities (max block read and write lengths, but we
> could also put there alignment requirements or support for repeated
> start condition.) in a private structure. If we generalize the
> functions then this information would have to be stored in struct
> i2c_client and possibly struct i2c_adapter (or struct i2c_algorithm) so
> that the function can automatically find out the right sequence of
> commands for the adapter/slave combination.
>
> Speaking of struct i2c_client, I seem to remember that the dvb
> subsystem doesn't use it much at the moment. This might be an issue if
> you intend to get the generic code into i2c-core, as most helper
> functions rely on a valid i2c_client structure by design.

I will check those later today, have to go back lecture.

regards
Antti

-- 
http://palosaari.fi/
