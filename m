Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:35131 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1EDUgn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 16:36:43 -0400
Message-ID: <4DC1B8D7.6020701@iki.fi>
Date: Wed, 04 May 2011 23:36:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, Steven Toth <stoth@hauppauge.com>
Subject: Re: [GIT PULL FOR 2.6.40] Anysee
References: <4DBAEFC5.8080707@iki.fi> <4DC178C8.4040603@redhat.com>
In-Reply-To: <4DC178C8.4040603@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Updated PULL requested!

Cc: Steven Toth as cx24116 driver author.

On 05/04/2011 07:03 PM, Mauro Carvalho Chehab wrote:
> Em 29-04-2011 14:05, Antti Palosaari escreveu:
>> Moikka Mauro,
>>
>> PULL following patches for the 2.6.40.
>>
>> This basically adds support for two Anysee satellite models:
>> 1. E30 S2 Plus
>> 2. E7 S2
>>
>>
>> t. Antti
>>
>> The following changes since commit f5bc5d1d4730bce69fbfdc8949ff50b49c70d934:
>>
>>    anysee: add more info about known board configs (2011-04-13 02:17:11 +0300)
>>
>> are available in the git repository at:
>>    git://linuxtv.org/anttip/media_tree.git anysee
>>
>> Antti Palosaari (3):
>>        cx24116: add config option to split firmware download
>>        anysee: add support for Anysee E30 S2 Plus
>>        anysee: add support for Anysee E7 S2
>
> As I said you on irc, at cx24116, please add a logic to explicitly check if
> I2C size is equal to zero. While your logic works, it is tricky, and having
> a more readable code at the expense of something like:
> 	if (i2c_max == 0)
> 		i2c_max = 65535;
>
> seems to be the right thing to do.

For some reason as I mentioned on IRC, this change increases binary size 
52 bytes, whilst functionality remains same. Feel free to select this 
new or old patch.

t. Antti

The following changes since commit f5bc5d1d4730bce69fbfdc8949ff50b49c70d934:

   anysee: add more info about known board configs (2011-04-13 02:17:11 
+0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git anysee

Antti Palosaari (4):
       cx24116: add config option to split firmware download
       anysee: add support for Anysee E30 S2 Plus
       anysee: add support for Anysee E7 S2
       cx24116: make FW DL split more readable

  drivers/media/dvb/dvb-usb/Kconfig     |    4 +
  drivers/media/dvb/dvb-usb/anysee.c    |  103 
+++++++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-usb/anysee.h    |    1 +
  drivers/media/dvb/frontends/cx24116.c |   19 +++++-
  drivers/media/dvb/frontends/cx24116.h |    3 +
  5 files changed, 127 insertions(+), 3 deletions(-)


-- 
http://palosaari.fi/
