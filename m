Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1KXT6o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 14:58:44 -0500
Message-ID: <4ECEA1E9.2000107@redhat.com>
Date: Thu, 24 Nov 2011 17:58:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [GIT PULL FOR 3.2] misc small changes, mostly get/set IF related
References: <4EC016B9.1080306@iki.fi> <4EC01892.3090307@iki.fi>
In-Reply-To: <4EC01892.3090307@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-11-2011 17:20, Antti Palosaari escreveu:
> Mauro,
> and these too for 3.3. Sorry about mistakes.

In fact, those 3 patches seemed to be good for 3.2:

576b849 [media] mxl5007t: fix reg read
d7d89dc [media] tda18218: fix 6 MHz default IF frequency
ff83bd8 [media] af9015: limit I2C access to keep FW happy

So, I've backported d7d89dc to 3.2, and applied there. the others,
I've added for 3.3.

> 
> regards
> Antti
> 
> On 11/13/2011 09:12 PM, Antti Palosaari wrote:
>> Moro
>>
>> These patches are rather small enchantments and should not have any
>> visible effect.
>>
>> mxl5007t change is that register read fix I have mentioned earlier. Reg
>> read is used only for checking chip ID and even if ID is not detected
>> correctly it will still work. So no functional changes.
>>
>> Antti
>>
>> The following changes since commit
>> df5f76dfef9bfaec1ff27d0a60a57a773bf87f0f:
>>
>> af9015: limit I2C access to keep FW happy (2011-11-13 03:33:30 +0200)
>>
>> are available in the git repository at:
>> git://linuxtv.org/anttip/media_tree.git af9015
>>
>> Antti Palosaari (12):
>> tda18218: implement .get_if_frequency()
>> tda18218: fix 6 MHz default IF frequency
>> af9013: use .get_if_frequency() when possible
>> mt2060: implement .get_if_frequency()
>> qt1010: implement .get_if_frequency()
>> tda18212: implement .get_if_frequency()
>> tda18212: round IF frequency to close hardware value
>> cxd2820r: switch to .get_if_frequency()
>> cxd2820r: check bandwidth earlier for DVB-T/T2
>> mxl5007t: fix reg read
>> ce6230: remove experimental from Kconfig
>> ce168: remove experimental from Kconfig
>>
>> drivers/media/common/tuners/mt2060.c | 9 +++-
>> drivers/media/common/tuners/mxl5007t.c | 3 +-
>> drivers/media/common/tuners/qt1010.c | 9 +++-
>> drivers/media/common/tuners/tda18212.c | 17 +++++++-
>> drivers/media/common/tuners/tda18218.c | 18 ++++++-
>> drivers/media/common/tuners/tda18218_priv.h | 2 +
>> drivers/media/dvb/dvb-usb/Kconfig | 4 +-
>> drivers/media/dvb/dvb-usb/anysee.c | 7 ---
>> drivers/media/dvb/frontends/af9013.c | 43 ++++--------------
>> drivers/media/dvb/frontends/cxd2820r.h | 13 ------
>> drivers/media/dvb/frontends/cxd2820r_c.c | 13 +++++-
>> drivers/media/dvb/frontends/cxd2820r_t.c | 55 +++++++++++++----------
>> drivers/media/dvb/frontends/cxd2820r_t2.c | 62 +++++++++++++++------------
>> drivers/media/video/em28xx/em28xx-dvb.c | 7 ---
>> 14 files changed, 140 insertions(+), 122 deletions(-)
>>
>>
> 
> 

