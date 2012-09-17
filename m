Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:55938 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab2IQUnP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 16:43:15 -0400
Message-ID: <50578B61.1040700@schinagl.nl>
Date: Mon, 17 Sep 2012 22:43:13 +0200
From: Oliver Schinagl <oliver@schinagl.nl>
Reply-To: oliver+list@schinagl.nl
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl> <504D00BC.4040109@schinagl.nl> <504D0F44.6030706@iki.fi> <504D17AA.8020807@schinagl.nl> <504D1859.5050201@iki.fi> <504DB9D4.6020502@schinagl.nl> <504DD311.7060408@iki.fi> <504DF950.8060006@schinagl.nl> <504E2345.5090800@schinagl.nl> <5055DD27.7080501@schinagl.nl> <505601B6.2010103@iki.fi> <5055EA30.8000200@schinagl.nl> <50560B82.7000205@iki.fi> <50564E58.20004@schinagl.nl> <50566260.1090108@iki.fi> <5056DE5C.70003@schinagl.nl> <50571F83.10708@schinagl.nl> <50572290.8090308@iki.fi> <505724F0.20502@schinagl.nl> <50572B1D.3080807@iki.fi> <50573FC5.40307@schinagl.nl>
In-Reply-To: <50573FC5.40307@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/17/12 17:20, Oliver Schinagl wrote:

>>>> If tuner communication is really working and it says chip id is 0x5a
>>>> then it is different than driver knows. It could be new revision of
>>>> tuner. Change chip_id to match 0x5a
>>>>
>>> Ah, so it's called chip_id on one end, but tuner_id on the other end.
>>> If/when I got this link working properly, I'll write a patch to fix some
>>> naming consistencies.
>>
>> No, you are totally wrong now. Chip ID is value inside chip register.
>> Almost every chip has some chip id value which driver could detect it
>> is speaking with correct chip. In that case value is stored inside
>> fc2580.
>>
>> Tuner ID is value stored inside AF9035 chip / eeprom. It is
>> configuration value for AF9035 hardware design. It says "that AF9035
>> device uses FC2580 RF-tuner". AF9035 (FC2580) tuner ID and FC2580 chip
>> ID are different values having different meaning.
> Ok, I understand the difference between Chip ID and Tuner ID I guess,
> and with my new knowledge about dynamic debug I know also understand my
> findings and where it goes wrong. I also know understand the chipID is
> stored in fc2580.c under the fc2580_attach, where it checks for 0x56.
> Appearantly my chipID is 0x5a. I wasn't triggered by this as none of the
> other fc2580 or af9035 devices had such a change so it wasn't obvious.
> Tuner ID is actively being chechked/set in the source, so that seemed
> more obvious.
It can't be 0x5a as chipid. I actually found that the vendor driver also 
reads from 0x01 once to test the chip.

This function is a generic function which tests I2C interface's 
availability by reading out it's I2C id data from reg. address '0x01'.

int fc2580_i2c_test( void ) {
	return ( fc2580_i2c_read( 0x01 ) == 0x56 )? 0x01 : 0x00;
}

So something else is going weird. chipid being 0x56 is good though; same 
chip revision. However I now got my system to hang, got some soft-hang 
errors and the driver only reported failure on loading. No other debug 
that I saw from dmesg before the crash. Will investigate more.
