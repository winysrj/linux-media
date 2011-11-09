Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1KIPvt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 10:51:49 -0500
Message-ID: <4EBAA190.30305@iki.fi>
Date: Wed, 09 Nov 2011 17:51:44 +0200
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

Hello,
I compared all I2C-client drivers I have done and here are the results:
name = name of driver module
reg = reg addr len (bytes)
val = reg val len (bytes)
auto = auto increment
other = register banks, etc.

name       reg  val auto   other
qt1010       1    1    ?
af9013       2    1    Y
ec100        1    1    ?
tda18218     1    1    Y
tua9001      1    2    ?
tda18212     1    1    Y
cxd2820r     1    1    ?   bank
tda10071     1    1    Y
a8293        not relevant, only one control byte
rtl2830      1    1    Y   bank
rtl2832      1    1    Y   bank
af9033       3*   1    Y   *bank/mailbox
<noname>     2    1    Y

As we can see I2C msg structure where is address first ans after that 
payload is quite de Facto. There was only one driver which didn't meet 
that condition, it is LNB-controller which uses only one byte.

tda10071 driver has most typical register read and write routines and 
size of those are 70 LOC, including rd_reg, rd_regs, wr_reg, wr_regs, 
excluding bit based register functions.
12 drivers, ca. 70 LOC per driver makes 840 LOC of less code. And you 
can save even more if generalize bit register access functions too 
(commonly: wr_reg_mask, rd_reg_mask, wr_reg_bits, rd_reg_bits).

More comments below.

On 11/09/2011 12:37 PM, Jean Delvare wrote:
> If code is duplicated, then something should indeed be done about it.
> But preferably after analyzing properly what the helper functions
> should look like, and for this you'll have to look at "all" drivers
> that could benefit from it. At the moment only the tda18218 driver was
> reported to need it, that's not enough to generalize.
>
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

As we have now some kind of understanding what is needed, could you 
start direct planning? I am ready to implement some basic stuff that I 
see most benefit (listed below).

The functions I see most important are:
wr_regs
rd_regs
wr_reg
rg_reg
wr_reg_mask
wr_reg_bits
rd_reg_bits


regards
Antti
-- 
http://palosaari.fi/
