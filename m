Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:40268 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LAN41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 08:56:27 -0500
Received: by mail-bk0-f50.google.com with SMTP id e11so4833599bkh.23
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 05:56:25 -0800 (PST)
Message-ID: <529B4007.3060603@gmail.com>
Date: Sun, 01 Dec 2013 15:56:23 +0200
From: Adrian Minta <adrian.minta@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: update scan file for ro-DigiTV
References: <529AEB29.90205@gmail.com> <529B2F30.1020509@iki.fi>
In-Reply-To: <529B2F30.1020509@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I took the .scm file from my Samsung TV and I use SamyGO-ChanEdit-v54 to 
look inside.
The values where tested with kaffeine and w_scan. All the TV and Radio 
Channel where detected successfully.

This is the channels.conf file obtained with w_scan version 20120605 
(compiled for DVB API 5.5):
http://pastebin.com/pXtnFq9T

This is the w_scan log:
http://pastebin.com/HG0zy1hJ



On 01.12.2013 14:44, Antti Palosaari wrote:
> Hello Adrian
>
> On 01.12.2013 09:54, Adrian Minta wrote:
>> Hello,
>> this is a scan file data for Romanian DigiTV
>> http://www.rcs-rds.ro/personal-tv?t=cablu&pachet=digital
>>
>> Please add this to the list so other people can use.
>>
>>
>> [dvb-c/ro-DigiTV]
>> C 306000000 6900000 NONE QAM64
>
> How you obtained these values?
> Almost all muxes are QAM64 which is quite weird. Usually that table 
> looks just like table where is QAM128 instead of QAM64, or even QAM256.
>
> regards
> Antti
>
>

-- 
Best regards,
Adrian Minta    MA3173-RIPE


