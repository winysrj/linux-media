Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33453 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbbCRVNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 17:13:17 -0400
Message-ID: <5509EA6B.9080805@iki.fi>
Date: Wed, 18 Mar 2015 23:13:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/10] mn88473: implement lock for all delivery systems
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se> <1426460275-3766-10-git-send-email-benjamin@southpole.se> <55074F74.2080000@iki.fi> <55075CD2.6060908@iki.fi> <55076302.807@southpole.se>
In-Reply-To: <55076302.807@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/17/2015 01:10 AM, Benjamin Larsson wrote:
> On 03/16/2015 11:44 PM, Antti Palosaari wrote:
>> On 03/16/2015 11:47 PM, Antti Palosaari wrote:
>>> On 03/16/2015 12:57 AM, Benjamin Larsson wrote:
>>>> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
>>>
>>> Applied.
>>
>> I found this does not work at least for DVB-C. After playing with
>> modulator I find reg 0x85 on bank 1 is likely AGC. Its value is changed
>> according to RF level even modulation itself is turned off.
>>
>> I will likely remove that patch... It is a bit hard to find out lock
>> bits and it comes even harder without a modulator. Using typical tricks
>> to plug and unplug antenna, while dumping register values out is error
>> prone as you could not adjust signal strength nor change modulation
>> parameters causing wrong decision easily.
>>
>> regards
>> Antti
>>
>
> Indeed the logic was inverted. Will respin the patch.

Any ETA for the new patch?

regards
Antti

-- 
http://palosaari.fi/
