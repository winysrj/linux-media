Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39426 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbaG3T3X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 15:29:23 -0400
Message-ID: <53D9478A.4050203@iki.fi>
Date: Wed, 30 Jul 2014 22:29:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, Antonio Ospite <ao2@ao2.it>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>	<1406059938-21141-2-git-send-email-zzam@gentoo.org>	<53CF7E6D.20406@iki.fi>	<53D006F2.10300@gentoo.org>	<20140723221012.3c9e8f26aa1ddac47b48cb9e@ao2.it>	<53D73328.6040802@gentoo.org> <20140729105315.e04521b28fe7d27c49bb0665@ao2.it> <53D786BE.3050803@iki.fi> <53D7F465.7030905@gentoo.org> <53D7F9DD.7080308@iki.fi> <53D93E64.6080907@gentoo.org>
In-Reply-To: <53D93E64.6080907@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All-in-all, did I understand correctly none of those header values are 
not required anymore?

hdr[0] own FW version. used by driver to print our own FW file version
hdr[1] --''--
hdr[2] vendor FW version. programmed to chip register but chip does not 
need it. read back in order to detect if FW is loaded or not
hdr[3] padding. not used
hdr[4] number of FW blocks. driver could calculate it.
hdr[5] padding. not used
hdr[6] crc. not mandatory & driver could calculate it. not 100% FW 
related, chip uses it for every write. verify xfer errors
hdr[7] --''--

regards
Antti



On 07/30/2014 09:50 PM, Matthias Schwarzott wrote:
> On 29.07.2014 21:45, Antti Palosaari wrote:
>>
>> Do you need to know whole firmware version?
> There is only 1 byte to be used and it is called patch version.
>> How did you obtain it, from
>> sniff?
> Yes - but it also is visible in code near crc version (see below).
>
>> What happens if you don't tell fw version to chip at all?
>>
> In other places it is read to verify a fw was uploaded (compare to be
> not equal 0x00).
> I guess the exact value is never needed (so just for information).
> But I did not try it.
>
>> Usually, almost 100%, firmware version as well all the other needed
>> information, is included to firmware image itself. I don't remember many
>> cases where special handling is needed. One (only one?) of such case is
>> af9013, where I resolved issues by calculating fw checksum by the
>> driver. IIRC chip didn't boot if there was wrong checksum for fw.
>
> The checksum is not needed to get the device working.
> The chip itself only calculates it when uploading data - and the driver
> reads out the calculated checksum and compares it to the expected value.
> It is only a verification of the correct upload.
>
>>
>> Own headers and checksums causes troubles if I someone would like to
>> extract different firmwares from various windows binaries to test.
>>
>> If windows driver needs to know that kind of things, those are usually
>> found very near firmware image from the driver binary. Most often just
>> dump 32 bytes after firmware image and it is somewhere there. Or before
>> firmware image. That is because those are values are stored to same
>> source code file => compiler puts that stuff ~same location.
>>
> I had a look at the driver - the code itself has the constants compiled
> in - they are really mixed with the assembly code.
>
> Rewritten in C it is code that has fixed values as parameters to functions.
>
> ret = load_firmware(firmware,
>    0x12, /* patch version */
>    48, /* block count */
>    0xaa0c /* crc */
> );
>
> I also would prefer your version with static const variables near the data.
>
>> static const unsigned char firmware[] = {
>>    0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,
>>    0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee,0xff,
>> };
>>
>> static const unsigned int firmware_checksum = 0x01234567;
>> static const unsigned int firmware_version = 0x0000002b;
>>
> Regards
> Matthias
>

-- 
http://palosaari.fi/
