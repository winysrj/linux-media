Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:48722 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1EEWED (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 18:04:03 -0400
Message-ID: <a6e35b69eae798d57e1fe24bac7c824c.squirrel@webmail.kapsi.fi>
In-Reply-To: <4DC2D669.9020000@redhat.com>
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
    <BANLkTimiA1k-pbwuri1vAFgsfSwkdTJWAA@mail.gmail.com>
    <4DC2D669.9020000@redhat.com>
Date: Fri, 6 May 2011 01:03:59 +0300
Subject: Re: CX24116 i2c patch
From: "Antti Palosaari" <crope@iki.fi>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Steven Toth" <stoth@kernellabs.com>,
	"Linux-Media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

to 5.5.2011 19:55 Mauro Carvalho Chehab kirjoitti:
> Em 05-05-2011 12:25, Devin Heitmueller escreveu:
>> Do we know this to be the case with the anysee bridge?  Is this a
>> reverse engineered device?  Is there documentation/datasheets to
>> reference?
>
>>
>> Do we know if this is an issue with the i2c master driver not being
>> fully baked, or if it's a hardware limitation?
>
> I can't tell you how Antti is working, but, since this is a USB device,
> and cx24116 is trying to send a 32KB message via one single I2C transfer,
> I can tell you for sure that that this won't work.
>
> USB control messages can have, at maximum, 80 bytes of data on it. So,
> the message needs to be broken into 80-byte payloads (assuming that
> Anysee accepts the maximum size).

Anysee have Cypress 'FX2' -bridge running their own custom firmware. It
uses BULK messages for data transfer - so there is no such small limit as
control messages have.

But the API FW implements limits that size, it is just max I configured to
DVB-S/S2 driver in question. Thats since there is static meaning bytes
before and after I2C data. Something like (as example near real, I cannot
check now easily since I am on weekend trip):

~bytes:
1-10 len, I2C addr, command, etc...
11-58 I2C data
59 packet sequence number
60 some other value
61 some other value

Whole message size is around 60 bytes.

Anyhow, the point is that used message size is static and there is static
bytes at the end of each message which does have some meaning.

Antti

