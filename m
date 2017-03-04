Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59617 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbdCDBYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 20:24:11 -0500
Subject: Re: [PATCH v3 0/3] Add support for MyGica T230C DVB-T2 stick
To: =?UTF-8?Q?Br=c3=bcns=2c_Stefan?= <Stefan.Bruens@rwth-aachen.de>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20170217005533.22424-1-stefan.bruens@rwth-aachen.de>
 <1488566145.30993.5.camel@rwth-aachen.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <2b3bb92a-4024-7a82-c86d-2e5893786daf@iki.fi>
Date: Sat, 4 Mar 2017 03:23:42 +0200
MIME-Version: 1.0
In-Reply-To: <1488566145.30993.5.camel@rwth-aachen.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2017 08:35 PM, Brüns, Stefan wrote:
> On Fr, 2017-02-17 at 01:55 +0100, Stefan Brüns wrote:
>> The required command sequence for the new tuner (Si2141) was traced
>> from the
>> current Windows driver and verified with a small python
>> script/libusb.
>> The changes to the Si2168 and dvbsky driver are mostly additions of
>> the
>> required IDs and some glue code.
>>
>> Stefan Brüns (3):
>>   [media] si2157: Add support for Si2141-A10
>>   [media] si2168: add support for Si2168-D60
>>   [media] dvbsky: MyGica T230C support
>>
>>  drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
>>  drivers/media/dvb-frontends/si2168.c      |  4 ++
>>  drivers/media/dvb-frontends/si2168_priv.h |  2 +
>>  drivers/media/tuners/si2157.c             | 23 +++++++-
>>  drivers/media/tuners/si2157_priv.h        |  2 +
>>  drivers/media/usb/dvb-usb-v2/dvbsky.c     | 88
>> +++++++++++++++++++++++++++++++
>>  6 files changed, 118 insertions(+), 2 deletions(-)
>
> Instead of this series, a different patchset was accepted, although
> Antti raised concerns about at least 2 of the 3 patches accpeted, more
> specifically the si2157 patch contains some bogus initialization code,
> and the T230C support were better added to the dvbsky driver instead of
>  cxusb.

Patch set looks good. I ordered that device and it arrived yesterday. I 
will handle that during 2 weeks - it is now skiing holiday and I am at 
France alps whole next week. So just wait :)

regards
Antti

-- 
http://palosaari.fi/
