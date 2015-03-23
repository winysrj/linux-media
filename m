Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57523 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbbCWWwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 18:52:30 -0400
Message-ID: <5510992C.8060608@iki.fi>
Date: Tue, 24 Mar 2015 00:52:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ole Ernst <olebowle@gmx.com>, Nibble Max <nibble.max@gmail.com>
CC: "olli.salonen" <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: cx23885: DVBSky S952 dvb_register failed err = -22
References: <5504920C.7080806@gmx.com>, <55055E66.6040600@gmx.com>, <550563B2.9010306@iki.fi>, <201503170953368436904@gmail.com> <201503180940386096906@gmail.com> <55093FFC.9050602@gmx.com> <55105683.40809@iki.fi> <551081CF.3080901@gmx.com>
In-Reply-To: <551081CF.3080901@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/2015 11:12 PM, Ole Ernst wrote:
> Very much appreciated, thanks Antti! Let me know, if you need someone to
> test your patches.

Could you test that tree?
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=ts2020

git clone -b ts2020 git://linuxtv.org/anttip/media_tree.git

then compile and install whole kernel

regards
Antti


>
> Am 23.03.2015 um 19:08 schrieb Antti Palosaari:
>> On 03/18/2015 11:06 AM, Ole Ernst wrote:
>>> Hi Max,
>>>
>>> I'm afraid I'm not experienced enough to adapt the ts2020 driver to
>>> interwork with the current kernel driver for the S952. I'd be more than
>>> happy to test patches though!
>>
>> I will migrate M88TS2022 to TS2020 and it will start working after that.
>>
>> regards
>> Antti
>>
>>>
>>> Thanks,
>>> Ole
>>>
>>> Am 18.03.2015 um 02:40 schrieb Nibble Max:
>>>> Hello Ole,
>>>>
>>>> If it is m88ts2020, there is a tuner driver "ts2020" in
>>>> "dvb-frontends" directory.
>>>> If fail to load m88ts2022 driver, then try to load ts2020 driver.
>>>> m88ts2022 driver is an i2c driver, but ts2020 is traditional
>>>> dvb-attach driver.
>>>> Please check the other code using ts2020 for reference.
>>>>
>>>> Best Regards,
>>>> Max
>>

-- 
http://palosaari.fi/
