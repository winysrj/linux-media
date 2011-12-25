Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49567 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1LYUMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Dec 2011 15:12:08 -0500
Received: by eaad14 with SMTP id d14so3866217eaa.19
        for <linux-media@vger.kernel.org>; Sun, 25 Dec 2011 12:12:06 -0800 (PST)
Message-ID: <4EF78393.5010004@gmail.com>
Date: Sun, 25 Dec 2011 21:12:03 +0100
From: Dennis Sperlich <dsperlich@googlemail.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Hans Petter Selasky <hselasky@c2i.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: em28xx_isoc_dvb_max_packetsize for EM2884 (Terratec Cinergy HTC
 Stick)
References: <4EF64AF4.2040705@gmail.com> <4EF70077.5040907@redhat.com>  <4EF72D61.9090001@gmail.com> <201112251511.54080.hselasky@c2i.net> <1324842167.3134.4.camel@tvbox>
In-Reply-To: <1324842167.3134.4.camel@tvbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25.12.2011 20:42, Malcolm Priestley wrote:
> On Sun, 2011-12-25 at 15:11 +0100, Hans Petter Selasky wrote:
>> On Sunday 25 December 2011 15:04:17 Dennis Sperlich wrote:
>>> On 25.12.2011 11:52, Mauro Carvalho Chehab wrote:
>>>> On 24-12-2011 19:58, Dennis Sperlich wrote:
>>>>> Hi,
>>>>>
>>>>> I have a Terratec Cinergy HTC Stick an tried the new support for the
>>>>> DVB-C part. It works for SD material (at least for free receivable
>>>>> stations, I tried afair only QAM64), but did not for HD stations
>>>>> (QAM256). I have only access to unencrypted ARD HD, ZDF HD and arte HD
>>>>> (via KabelDeutschland). The HD material was just digital artefacts, as
>>>>> far as mplayer could decode it. When I did a dumpstream and looked at
>>>>> the resulting file size I got something about 1MB/s which seems a
>>>>> little too low, because SD was already about 870kB/s. After looking
>>>>> around I found a solution in increasing the isoc_dvb_max_packetsize
>>>>> from 752 to 940 (multiple of 188). Then an HD stream was about 1.4MB/s
>>>>> and looked good. I'm not sure, whether this is the correct fix, but it
>>>>> works for me.
>>>>>
> Would not increasing EM28XX_DVB_NUM_BUFS currently set at 5 to say 10
> have a better effect?
This does not work, I just tried it.

Regards,
Dennis
