Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53825 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbbKYXNp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 18:13:45 -0500
Subject: Re: [DVBT USB dongle] problem with Zolid Mini DVB-T Stick on linux
 mint 17.2
To: Mark Croft <mark.croft.lug@gmail.com>, linux-media@vger.kernel.org,
	Robert Treen <robert@radioshare.co.uk>
References: <CAL9Js5Kn1d9-1_LOQ09J_cp743S1dyksRDpWB2RMtbpWABTGFg@mail.gmail.com>
 <56563CC7.4050305@iki.fi>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <565640A8.1030207@iki.fi>
Date: Thu, 26 Nov 2015 01:13:44 +0200
MIME-Version: 1.0
In-Reply-To: <56563CC7.4050305@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2015 12:57 AM, Antti Palosaari wrote:
> On 11/26/2015 12:53 AM, Mark Croft wrote:
>> hi
>>
>> hope this is the correct list about trying to get linux to talk to
>> dvb-t usb stick?
>>
>> check out all the logs etc here http://pastebin.com/V3RQ17hz
>
> and antenna is plugged and it is good antenna with strong signal? Test
> it first using windows. Logs says all is OK.

I started looking that initial tuning file and noticed I don't even have 
those old dvbv3 tuning files you are using.

You probably want use dvbv5 scan instead:
$ dvbv5-scan /usr/share/dvbv5/dvb-t/uk-BeaconHill

w_scan is also very good blind scanning app - no need for initial tuning 
files.
$ w_scan -c GB

regards
Antti
-- 
http://palosaari.fi/
