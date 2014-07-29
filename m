Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52512 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbaG2Leb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 07:34:31 -0400
Message-ID: <53D786BE.3050803@iki.fi>
Date: Tue, 29 Jul 2014 14:34:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>, Matthias Schwarzott <zzam@gentoo.org>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>	<1406059938-21141-2-git-send-email-zzam@gentoo.org>	<53CF7E6D.20406@iki.fi>	<53D006F2.10300@gentoo.org>	<20140723221012.3c9e8f26aa1ddac47b48cb9e@ao2.it>	<53D73328.6040802@gentoo.org> <20140729105315.e04521b28fe7d27c49bb0665@ao2.it>
In-Reply-To: <20140729105315.e04521b28fe7d27c49bb0665@ao2.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/29/2014 11:53 AM, Antonio Ospite wrote:
> On Tue, 29 Jul 2014 07:37:44 +0200
> Matthias Schwarzott <zzam@gentoo.org> wrote:
>
>> On 23.07.2014 22:10, Antonio Ospite wrote:
>>> On Wed, 23 Jul 2014 21:03:14 +0200
>>> Matthias Schwarzott <zzam@gentoo.org> wrote:
>>>
>>> [...]
>>>> The crc value:
>>>> It protects the content of the file until it is in the demod - so
>>>> calculating it on my own would only check if the data is correctly
>>>> transferred from the driver into the chip.
>>>> But for this I needed to know the algorithm and which data is
>>>> checksummed exactly.
>>>>
>>>> Are the different algorithms for CRC values that give 16 bit of output?
>>>>
>>>
>>> You could try jacksum[1] and see if any algorithm it supports
>>> gives you the expected result, there is a handful of 16 bits ones:
>>>
>>>    jacksum -a all -F "#ALGONAME{i} = #CHECKSUM{i}" payload.bin
>>>
>> Hi Antonio,
>>
>> I tried jacksum on the complete firmware and on parts - but it never
>> matched the results from the chip.
>>
>> I now found out, that the crc register changes after every 32bit write
>> to the data register - the fw control registers do not affect it.
>>
>> So I can try what crc results from writing 32bit portions of data.
>> But even that did not help in guessing the algorithm, because I do not
>> want to do 100s of experiments.
>>
>> some of my experiments:
>> crc=0x0000, data=0x00000000 -> crc=0x0000
>> crc=0x0000, data=0x00000001 -> crc=0x1021
>> crc=0x0000, data=0x00000002 -> crc=0x2042
>> crc=0x0000, data=0x00000004 -> crc=0x4084
>> crc=0x0000, data=0x00000008 -> crc=0x8108
>> crc=0x0000, data=0x00000010 -> crc=0x1231
>>
>> Is there some systematic way to get the formula?
>
> I don't know much about crc, but the values you are getting look like
> the entries in the table in lib/crc-itu-t.c so maybe compare the crc
> you are getting with the ones calculated with crc_itu_t() from
> include/linux/crc-itu-t.h
>
> I just did a quick test with jacksum, the crc-itu-t parameters can
> be expressed like this:
>
> 	jacksum -x -a crc:16,1021,0,false,false,0 -q 00000010
>
> and the output is the expected 0x1231 for the 0x00000010 sequence.

maybe crc = crc + crc(val)


Antti


-- 
http://palosaari.fi/
