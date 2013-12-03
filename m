Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:35364 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab3LCJhj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 04:37:39 -0500
Message-ID: <529DA612.2050704@schinagl.nl>
Date: Tue, 03 Dec 2013 10:36:18 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Adrian Minta <adrian.minta@gmail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: update scan file for ro-DigiTV
References: <529AEB29.90205@gmail.com> <529B2F30.1020509@iki.fi> <529B4007.3060603@gmail.com>
In-Reply-To: <529B4007.3060603@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01-12-13 14:56, Adrian Minta wrote:
> I took the .scm file from my Samsung TV and I use SamyGO-ChanEdit-v54 to
> look inside.
> The values where tested with kaffeine and w_scan. All the TV and Radio
> Channel where detected successfully.
Thanks, I have pushed it to the repo's.

Oliver
>
> This is the channels.conf file obtained with w_scan version 20120605
> (compiled for DVB API 5.5):
> http://pastebin.com/pXtnFq9T
>
> This is the w_scan log:
> http://pastebin.com/HG0zy1hJ
>
>
>
> On 01.12.2013 14:44, Antti Palosaari wrote:
>> Hello Adrian
>>
>> On 01.12.2013 09:54, Adrian Minta wrote:
>>> Hello,
>>> this is a scan file data for Romanian DigiTV
>>> http://www.rcs-rds.ro/personal-tv?t=cablu&pachet=digital
>>>
>>> Please add this to the list so other people can use.
>>>
>>>
>>> [dvb-c/ro-DigiTV]
>>> C 306000000 6900000 NONE QAM64
>>
>> How you obtained these values?
>> Almost all muxes are QAM64 which is quite weird. Usually that table
>> looks just like table where is QAM128 instead of QAM64, or even QAM256.
>>
>> regards
>> Antti
>>
>>
>

