Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44775 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaG2Tpn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 15:45:43 -0400
Message-ID: <53D7F9DD.7080308@iki.fi>
Date: Tue, 29 Jul 2014 22:45:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, Antonio Ospite <ao2@ao2.it>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/8] get_dvb_firmware: Add firmware extractor for si2165
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>	<1406059938-21141-2-git-send-email-zzam@gentoo.org>	<53CF7E6D.20406@iki.fi>	<53D006F2.10300@gentoo.org>	<20140723221012.3c9e8f26aa1ddac47b48cb9e@ao2.it>	<53D73328.6040802@gentoo.org> <20140729105315.e04521b28fe7d27c49bb0665@ao2.it> <53D786BE.3050803@iki.fi> <53D7F465.7030905@gentoo.org>
In-Reply-To: <53D7F465.7030905@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/29/2014 10:22 PM, Matthias Schwarzott wrote:
> On 29.07.2014 13:34, Antti Palosaari wrote:
>>
>>
>> On 07/29/2014 11:53 AM, Antonio Ospite wrote:
>>> On Tue, 29 Jul 2014 07:37:44 +0200
>>> Matthias Schwarzott <zzam@gentoo.org> wrote:
>>>
>>>> On 23.07.2014 22:10, Antonio Ospite wrote:
>>>>> On Wed, 23 Jul 2014 21:03:14 +0200
>>>>> Matthias Schwarzott <zzam@gentoo.org> wrote:
>>>>>
>>>>> [...]
>>>>>> The crc value:
>>>>>> It protects the content of the file until it is in the demod - so
>>>>>> calculating it on my own would only check if the data is correctly
>>>>>> transferred from the driver into the chip.
>>>>>> But for this I needed to know the algorithm and which data is
>>>>>> checksummed exactly.
>>>>>>
>>>>>> Are the different algorithms for CRC values that give 16 bit of
>>>>>> output?
>>>>>>
>>>>>
>>>>> You could try jacksum[1] and see if any algorithm it supports
>>>>> gives you the expected result, there is a handful of 16 bits ones:
>>>>>
>>>>>     jacksum -a all -F "#ALGONAME{i} = #CHECKSUM{i}" payload.bin
>>>>>
>>>> Hi Antonio,
>>>>
>>>> I tried jacksum on the complete firmware and on parts - but it never
>>>> matched the results from the chip.
>>>>
>>>> I now found out, that the crc register changes after every 32bit write
>>>> to the data register - the fw control registers do not affect it.
>>>>
>>>> So I can try what crc results from writing 32bit portions of data.
>>>> But even that did not help in guessing the algorithm, because I do not
>>>> want to do 100s of experiments.
>>>>
>>>> some of my experiments:
>>>> crc=0x0000, data=0x00000000 -> crc=0x0000
>>>> crc=0x0000, data=0x00000001 -> crc=0x1021
>>>> crc=0x0000, data=0x00000002 -> crc=0x2042
>>>> crc=0x0000, data=0x00000004 -> crc=0x4084
>>>> crc=0x0000, data=0x00000008 -> crc=0x8108
>>>> crc=0x0000, data=0x00000010 -> crc=0x1231
>>>>
>>>> Is there some systematic way to get the formula?
>>>
>>> I don't know much about crc, but the values you are getting look like
>>> the entries in the table in lib/crc-itu-t.c so maybe compare the crc
>>> you are getting with the ones calculated with crc_itu_t() from
>>> include/linux/crc-itu-t.h
>>>
>>> I just did a quick test with jacksum, the crc-itu-t parameters can
>>> be expressed like this:
>>>
>>>      jacksum -x -a crc:16,1021,0,false,false,0 -q 00000010
>>>
>>> and the output is the expected 0x1231 for the 0x00000010 sequence.
>>
>> maybe crc = crc + crc(val)
>>
> It worked to apply crc_itu_t to the written data in 32bit blocks,
> but starting with the last byte:
>
> 			crc = crc_itu_t_byte(crc, *(data+offset+3));
> 			crc = crc_itu_t_byte(crc, *(data+offset+2));
> 			crc = crc_itu_t_byte(crc, *(data+offset+1));
> 			crc = crc_itu_t_byte(crc, *(data+offset+0));
>
> It would also have worked without knowing the crc because it is only
> actively read and compared in the driver - but better to know if upload
> did work.
>
> Now I am still not sure if it is worth to change the firmware file to
> now have the crc explicitly.
> Counting blocks is also easy todo.
> But the firmware version is not inside the data I think.
>
> So there will still remain something to be added to the raw data.

Do you need to know whole firmware version? How did you obtain it, from 
sniff? What happens if you don't tell fw version to chip at all?

Usually, almost 100%, firmware version as well all the other needed 
information, is included to firmware image itself. I don't remember many 
cases where special handling is needed. One (only one?) of such case is 
af9013, where I resolved issues by calculating fw checksum by the 
driver. IIRC chip didn't boot if there was wrong checksum for fw.

Own headers and checksums causes troubles if I someone would like to 
extract different firmwares from various windows binaries to test.

If windows driver needs to know that kind of things, those are usually 
found very near firmware image from the driver binary. Most often just 
dump 32 bytes after firmware image and it is somewhere there. Or before 
firmware image. That is because those are values are stored to same 
source code file => compiler puts that stuff ~same location.

static const unsigned char firmware[] = {
   0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77,
   0x88,0x99,0xaa,0xbb,0xcc,0xdd,0xee,0xff,
};

static const unsigned int firmware_checksum = 0x01234567;
static const unsigned int firmware_version = 0x0000002b;

regards
Antti
-- 
http://palosaari.fi/
