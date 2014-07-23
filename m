Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:52367 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578AbaGWTDW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 15:03:22 -0400
Message-ID: <53D006F2.10300@gentoo.org>
Date: Wed, 23 Jul 2014 21:03:14 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org> <1406059938-21141-2-git-send-email-zzam@gentoo.org> <53CF7E6D.20406@iki.fi>
In-Reply-To: <53CF7E6D.20406@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23.07.2014 11:20, Antti Palosaari wrote:
> Moikka Matthias
> 
Moikka Antti,

> On 07/22/2014 11:12 PM, Matthias Schwarzott wrote:
>> +
>> +    my $CRC="\x0A\xCC";
>> +    my $BLOCKS_MAIN="\x27";
>> +    open FW,">$fwfile";
>> +    print FW "\x01\x00"; # just a version id for the driver itself
>> +    print FW "\x9A"; # fw version
>> +    print FW "\x00"; # padding
>> +    print FW "$BLOCKS_MAIN"; # number of blocks of main part
>> +    print FW "\x00"; # padding
>> +    print FW "$CRC"; # 16bit crc value of main part
>> +    appendfile(FW,"$tmpdir/fw1");
> 
> I have to say I little bit dislike that kind of own headers. There is no
> way to read firmware version from binary itself (very often there is)?
> Whats is benefit of telling how many blocks there is? Isn't it possible
> to detect somehow by examining firmware image itself runtime?
> 
> Anyhow, you are the author of that driver and even I don't personally
> like those, I think it is up to your decision as a author.
> 
I thought a bit about the need for the header.
And yes, some fields I can get rid of.

firmware version:
I guess that the exact version number is not really needed - it is just
written to a seperate register - and later only read to check if
firmware was already downloaded (but for documentation it might be
interesting). I have no clue where it could be in the raw block - it
looks like it is writing to just some memory addresses.

But for the pure process it would also work to write a random number !=
0x00.

For $BLOCKS_MAIN:
The firmware is downloaded like this:
* write 1 block
* reset crc logic
* write $BLOCKS_MAIN
* read out crc and compare against $CRC in header
* write last 5 blocks

so the number of blocks in $BLOCKS_MAIN could be checked by iterating
over all blocks counting them and then substracting 6.

The crc value:
It protects the content of the file until it is in the demod - so
calculating it on my own would only check if the data is correctly
transferred from the driver into the chip.
But for this I needed to know the algorithm and which data is
checksummed exactly.

Are the different algorithms for CRC values that give 16 bit of output?

Matthias

