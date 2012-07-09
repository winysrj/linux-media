Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57854 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2GISuC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jul 2012 14:50:02 -0400
Message-ID: <4FFB27D1.9070204@iki.fi>
Date: Mon, 09 Jul 2012 21:49:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.6] DVB USB v2
References: <4FF19D3C.6070506@iki.fi> <4FF36865.1090808@iki.fi> <4FF7651A.7020907@redhat.com>
In-Reply-To: <4FF7651A.7020907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2012 01:22 AM, Mauro Carvalho Chehab wrote:
> Em 03-07-2012 18:47, Antti Palosaari escreveu:
>> On 07/02/2012 04:08 PM, Antti Palosaari wrote:
>>> Here it is finally - quite totally rewritten DVB-USB-framework. I
>>> haven't got almost any feedback so far...
>>
>> I rebased it in order to fix compilation issues coming from Kconfig.
>>
>>
>>> regards
>>> Antti
>>>
>>>
>>> The following changes since commit
>>> 6887a4131da3adaab011613776d865f4bcfb5678:
>>>
>>>     Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
>>>
>>> are available in the git repository at:
>>>
>>>     git://linuxtv.org/anttip/media_tree.git dvb_usb_pull
>>>
>>> for you to fetch changes up to 747abaa1e0ee4415e67026c119cb73e6277f4898:
>>>
>>>     dvb_usb_v2: remove usb_clear_halt() from stream (2012-07-02 15:54:29
>>> +0300)
>>>
>>> ----------------------------------------------------------------
>>> Antti Palosaari (103):
>>>         dvb_usb_v2: copy current dvb_usb as a starting point
>
> Naming the DVB USB v2 as dvb_usb, instead of dvb-usb is very very ugly.
> It took me some time to discover what happened.
>
> You should have named it as dvb-usb-v2 instead, or to store it into
> a separate directory.
>
> This is even worse as it seems that this series doesn't change all
> drivers to use dvb usb v2. So, it will be harder to discover what
> drivers are at V1 and what are at V2.
>
> I won't merge it as-is at staging/for_v3.6. I may eventually create
> a separate topic branch and add them there, while the namespace mess
> is not corrected, if I still have some time today. Otherwise, I'll only
> handle that after returning from vacations.

I moved it to the dvb-usb-v2 directory. Same location only added patch 
top of that.

Surely I can convert all drivers and use old directory, but IMHO it is 
simply too risky. We have already too much problems coming from that 
kind of big changes.

And what goes to file naming hyphen (-) vs. underscore (_), underscore 
seems to be much more common inside Kernel. Anyhow, I keep directory 
name as dvb-usb-v2 to follow old naming.

$ find ./ -type f -printf "%f\n" | grep "_" | wc -l
21465
$ find ./ -type f -printf "%f\n" | grep "-" | wc -l
13927


regards
Antti


-- 
http://palosaari.fi/


