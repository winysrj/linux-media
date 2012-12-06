Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64099 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab2LFVwB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 16:52:01 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2677196eaa.19
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2012 13:52:00 -0800 (PST)
Message-ID: <50C11387.3010805@googlemail.com>
Date: Thu, 06 Dec 2012 22:52:07 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Matthew Gyurgyik <matthew@pyther.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B67851.2010808@googlemail.com> <50B69037.3080205@pyther.net> <50B6967C.9070801@iki.fi> <50B6C2DF.4020509@pyther.net> <50B6C530.4010701@iki.fi> <50B7B768.5070008@googlemail.com> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50C003A3.7050208@pyther.net>
In-Reply-To: <50C003A3.7050208@pyther.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.12.2012 03:32, schrieb Matthew Gyurgyik:
> On 12/04/2012 04:06 PM, Frank Schäfer wrote:
>>
>> I double-checked the log and it is indeed set to LGDT3305_MPEG_SERIAL,
>> but LGDT3305_TPCLK_FALLING_EDGE is used instead of
>> LGDT3305_TPCLK_RISING_EDGE.
>> OTOH, the KWorld A340 bord sets this to LGDT3305_MPEG_PARALLEL...
>>
>> Matthew, could you please test V3 of the patch ? It is written against
>> the media_tree staging/for_v3.8 (see
>> http://git.linuxtv.org/media_tree.git).
>> You could also already test the remote control key map (e.g. with
>> evtest)
> I tested the remote using evtest. However, no events are generated in
> evtest. I verified the remote works in windows.

Ok :(
I'm not sure if it makes sense to test other maps at the moment.

>> Regards,
>> Frank
>>
>

