Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61999 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbANTXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2015 14:23:45 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so30387915wiv.5
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2015 11:23:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEt6MXkDPcZ47gnH9FFmYGkw1-ZFt8JAN1qKsBGBKXLTdQauzw@mail.gmail.com>
References: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
	<CAEt6MX=f-kkemgmAUNsEdZQzH2tRgtPDacbCn4hwH27uY-upDA@mail.gmail.com>
	<CAPx3zdSLb8gzcGTUcWrktc9icJBCCJ0FbPecxeUJRot3ztHwSA@mail.gmail.com>
	<CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
	<CAPx3zdQK+wM1YHfzWfvzQ9ZgWgQb4WEY+6AW=cSb_YOwAKKr4Q@mail.gmail.com>
	<CAEt6MXkDPcZ47gnH9FFmYGkw1-ZFt8JAN1qKsBGBKXLTdQauzw@mail.gmail.com>
Date: Wed, 14 Jan 2015 20:23:44 +0100
Message-ID: <CAPx3zdT+mCujtCvJSKO=npFDKGaFcyhqSrg0jTuUY9cgafBKVQ@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
From: Francesco Other <francesco.other@gmail.com>
To: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Roberto,

It doesn't record anything, the file is blank (0 bytes) :-(

$ dd if=/dev/dvb/adapter0/dvr0 of=test.ts

0+0 records in
0+0 records out
0 bytes (0 B) copied, 13,4642 s, 0,0 kB/s

Francesco


2015-01-14 16:58 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
> Francesco,
>
> Seems very strange not work once you have lock (1f) and ber 0. not a
> real problem signal report.
>
> After tzap -r open another console and:
>
> dd if=/dev/dvb/adapter0/dvr0 of=test.ts
>
> Wait 10 seconds and stop it. Please check file size (try to open on
> vlc too if big enough...).
>
> Cheers,
>  - Roberto
>
> On Tue, Jan 13, 2015 at 6:56 PM, Francesco Other
> <francesco.other@gmail.com> wrote:
>>
>>
>> So, this is the output for tzap with the NOT-working-device:
>>
>> $ tzap -r -c ~/.tzap/channels.conf Italia1
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> reading channels from file '/home/ionic/.tzap/channels.conf'
>> Version: 5.10   FE_CAN { DVB-T }
>> tuning to 698000000 Hz
>> video pid 0x0654, audio pid 0x0655
>> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>
>
>
>
>  - Roberto
