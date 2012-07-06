Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab2GFWW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 18:22:29 -0400
Message-ID: <4FF7651A.7020907@redhat.com>
Date: Fri, 06 Jul 2012 19:22:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.6] DVB USB v2
References: <4FF19D3C.6070506@iki.fi> <4FF36865.1090808@iki.fi>
In-Reply-To: <4FF36865.1090808@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-07-2012 18:47, Antti Palosaari escreveu:
> On 07/02/2012 04:08 PM, Antti Palosaari wrote:
>> Here it is finally - quite totally rewritten DVB-USB-framework. I
>> haven't got almost any feedback so far...
> 
> I rebased it in order to fix compilation issues coming from Kconfig.
> 
> 
>> regards
>> Antti
>>
>>
>> The following changes since commit
>> 6887a4131da3adaab011613776d865f4bcfb5678:
>>
>>    Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
>>
>> are available in the git repository at:
>>
>>    git://linuxtv.org/anttip/media_tree.git dvb_usb_pull
>>
>> for you to fetch changes up to 747abaa1e0ee4415e67026c119cb73e6277f4898:
>>
>>    dvb_usb_v2: remove usb_clear_halt() from stream (2012-07-02 15:54:29
>> +0300)
>>
>> ----------------------------------------------------------------
>> Antti Palosaari (103):
>>        dvb_usb_v2: copy current dvb_usb as a starting point

Naming the DVB USB v2 as dvb_usb, instead of dvb-usb is very very ugly.
It took me some time to discover what happened.

You should have named it as dvb-usb-v2 instead, or to store it into
a separate directory.

This is even worse as it seems that this series doesn't change all
drivers to use dvb usb v2. So, it will be harder to discover what
drivers are at V1 and what are at V2.

I won't merge it as-is at staging/for_v3.6. I may eventually create
a separate topic branch and add them there, while the namespace mess
is not corrected, if I still have some time today. Otherwise, I'll only
handle that after returning from vacations.

Regards,
Mauro
