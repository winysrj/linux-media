Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42432 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbbAOJZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 04:25:37 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so16378228wiv.1
        for <linux-media@vger.kernel.org>; Thu, 15 Jan 2015 01:25:36 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Jan 2015 10:25:36 +0100
Message-ID: <CAPx3zdQGfJ2EkrR6zcirw3a0nY+y1qG051qzhZs9YDk3DRbr7g@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
From: Francesco Other <francesco.other@gmail.com>
To: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, many thanks.

I used this guide:
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

and Ubuntu 14.04.1 LTS with kernel version 3.13.0-44.generic.

I'm not afraid using the terminal if you want to help me :-)

Regards

Francesco

2015-01-15 2:27 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
> Ok Francesco, just to confirm that buffer is empty.
>
> Well I'm not expert but seems the driver has some bug on state
> machine. I do not know details about Siano state machine for DVB but
> MSG_SMS_DAB_CHANNEL seems not be the right message expected. I will
> try to look deeply on this code.
>
> Are you able to test driver last version from linux-media tree? What
> kernel are you using?
>
> As I can't test DVB system here I only can suppose some scenario (some
> of them just a try) and do some blind patch for your tests.
>
> Mauro Chehab surely know a lot more about this, but as he do not sent
> message on this thread I suppose he is really busy.
>
> Cheers,
>   - Roberto
>
>
>
>
>
>
>
>
>  - Roberto
>
>
> On Wed, Jan 14, 2015 at 4:23 PM, Francesco Other
> <francesco.other@gmail.com> wrote:
>> Hi Roberto,
>>
>> It doesn't record anything, the file is blank (0 bytes) :-(
>>
>> $ dd if=/dev/dvb/adapter0/dvr0 of=test.ts
>>
>> 0+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 13,4642 s, 0,0 kB/s
>>
>> Francesco
>>
>>
>> 2015-01-14 16:58 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
>>> Francesco,
>>>
>>> Seems very strange not work once you have lock (1f) and ber 0. not a
>>> real problem signal report.
>>>
>>> After tzap -r open another console and:
>>>
>>> dd if=/dev/dvb/adapter0/dvr0 of=test.ts
>>>
>>> Wait 10 seconds and stop it. Please check file size (try to open on
>>> vlc too if big enough...).
>>>
>>> Cheers,
>>>  - Roberto
>>>
>>> On Tue, Jan 13, 2015 at 6:56 PM, Francesco Other
>>> <francesco.other@gmail.com> wrote:
>>>>
>>>>
>>>> So, this is the output for tzap with the NOT-working-device:
>>>>
>>>> $ tzap -r -c ~/.tzap/channels.conf Italia1
>>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> reading channels from file '/home/ionic/.tzap/channels.conf'
>>>> Version: 5.10   FE_CAN { DVB-T }
>>>> tuning to 698000000 Hz
>>>> video pid 0x0654, audio pid 0x0655
>>>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>>>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>>>
>>>
>>>
>>>
>>>  - Roberto
