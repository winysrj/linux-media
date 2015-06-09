Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp38.i.mail.ru ([94.100.177.98]:55065 "EHLO smtp38.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbbFIDvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 23:51:06 -0400
Message-ID: <BC1A91CB0D8C404E92B23111DCF17DDD@unknown>
From: "Unembossed Name" <severe.siberian.man@mail.ru>
To: <linux-media@vger.kernel.org>, "Antti Palosaari" <crope@iki.fi>
References: <A9A450C95D0047DA969F1F370ED24FE4@unknown> <5575B32D.8050809@iki.fi> <143B25D372A842478792E29914320459@unknown> <55762957.1060403@iki.fi>
Subject: Re: About Si2168 Part, Revision and ROM detection.
Date: Tue, 9 Jun 2015 10:50:59 +0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=response
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Antti Palosaari"
To: "Unembossed Name" <severe.siberian.man@mail.ru>; <linux-media@vger.kernel.org>
Sent: Tuesday, June 09, 2015 6:46 AM
Subject: Re: About Si2168 Part, Revision and ROM detection.


>>>> Also, I would like to suggest a following naming method for files
>>>> containing firmware patches. It's self explaining:
>>>> dvb-demod-si2168-a30-rom3_0_2-patch-build3_0_20.fw
>>>> dvb-demod-si2168-b40-rom4_0_2-patch-build4_0_19.fw.tar.gz
>>>> dvb-demod-si2168-b40-rom4_0_2-startup-without-patch-stub.fw
>>>
>>> There is very little idea to add firmware version number to name as
>>> then you cannot update firmware without driver update. Also, it is not
>>> possible to change names as it is regression after kernel update.
>>
>> I'm sure, that demodulator will accept firmware patch only if that patch
>> will be
>> matched with ROM version it's designed for. In all other cases patch
>> will be
>> rejected by IC. This is because this patches is not a completely new ROM
>> code
>> containing firmware update. Probably, for Si2168 such kind of updates
>> has never
>> existed and never will be.
>>
>> One user has reported, that with his A30 revision of demodulator, he was
>> unable
>> to upload firmware patch, wich was taken from
>> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-A30/3f2bc2c63285ef9323cce8689ef8a6cb/dvb-demod-si2168-a30-01.fw
>>
>> And at the same time, he was able to successfully upload firmware patch,
>> that
>> designed for A30 ROM 3.0.2 and makes version 3.0.2 => 3.0.20 after patching
>> completes. Here it is: http://beholder.ru/bb/download/file.php?id=732
>>
>> What can be cause of that? Probably it's either broken or corrupted
>> firmware
>> (I doubt in it), or possibly it's designed for A30 revision, but with
>> another ROM
>> version?
>
> I expected dvb-demod-si2168-a30-01.fw to be update for 3.0.2 ROM. But not sure. Olli surely has sniffs to check which ROM and 
> PBUILD device has replied. If it appears to be some other than 3.0.2 it explains some things (why firmware is incompatible).

I've just been contacted by this user again.

It seems, he is also reading linux-media list and saw our conversation.

He downloaded that firmware again: 
http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-A30/3f2bc2c63285ef9323cce8689ef8a6cb/dvb-demod-si2168-a30-01.fw and retried 
to upload it to demodulator.

He reported, that on this time, there was no any errors, and demod Si2168 A30 3.0.2 accepted it and version of demod's firmware 
became 3.0.16
Here is a part of his dmesg log:

si2168 10-0064: found a 'Silicon Labs Si2168-A30 build 2 id 0'
si2168 10-0064: firmware download took 35976 ms
si2168 10-0064: firmware version: 3.0.16

He believes, that since his last attempt it's something has been changed in the fw download code of the driver.

So. It is confirmed now, that it is absolutely enough to detect only revision of the chip,
and is no need to track fw patch build or ROM build of the chip.

I was wrong. Apologize for wasted your time.

Best regards. 

