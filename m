Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56230 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1GVQIn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 12:08:43 -0400
Message-ID: <4E29A087.4090507@iki.fi>
Date: Fri, 22 Jul 2011 19:08:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v3
References: <201106070205.08118.jareguero@telefonica.net> <4E260E4A.2020707@iki.fi> <4E295FE5.7040905@iki.fi> <201107221802.34505.jareguero@telefonica.net>
In-Reply-To: <201107221802.34505.jareguero@telefonica.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2011 07:02 PM, Jose Alberto Reguero wrote:
> On Viernes, 22 de Julio de 2011 13:32:53 Antti Palosaari escribió:
>> Have you had to time test these?
>>
>> And about I2C adapter, I don't see why changes are needed. As far as I
>> understand it is already working with TDA10023 and you have done changes
>> for TDA10048 support. I compared TDA10048 and TDA10023 I2C functions and
>> those are ~similar. Both uses most typical access, for reg write {u8
>> REG, u8 VAL} and for reg read {u8 REG}/{u8 VAL}.
>>
>> regards
>> Antti
>
> I just finish the testing. The changes to I2C are for the tuner tda827x. The
> MFE fork fine. I need to change the code in tda10048 and ttusb2. Attached is
> the patch for CT-3650 with your MFE patch.

You still pass tda10023 fe pointer to tda10048 for I2C-gate control 
which is wrong. Could you send USB sniff I can look what there really 
happens. If you have raw SniffUSB2 logs I wish to check those, other 
logs are welcome too if no raw SniffUSB2 available.

regards
Antti

-- 
http://palosaari.fi/
