Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45981 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab3ABKov (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jan 2013 05:44:51 -0500
Message-ID: <50E40F7E.6050707@iki.fi>
Date: Wed, 02 Jan 2013 12:44:14 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: linux-media@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: [PATCH RFC 07/11] it913x: make remote controller optional
References: <1355100335-2123-1-git-send-email-crope@iki.fi> <1355100335-2123-7-git-send-email-crope@iki.fi> <CAOMZO5Ac_EAjzYkLec6ZOxvm4fpvvFr7pLyKYNz=8EhAFM+6Pw@mail.gmail.com>
In-Reply-To: <CAOMZO5Ac_EAjzYkLec6ZOxvm4fpvvFr7pLyKYNz=8EhAFM+6Pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2013 05:24 AM, Fabio Estevam wrote:
> On Sun, Dec 9, 2012 at 10:45 PM, Antti Palosaari <crope@iki.fi> wrote:
>> Do not compile remote controller when RC-core is disabled by Kconfig.
>>
>> Cc: Malcolm Priestley <tvboxspy@gmail.com>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/usb/dvb-usb-v2/it913x.c | 36 +++++++++++++++++++----------------
>>   1 file changed, 20 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
>> index 4720428..5dc352b 100644
>> --- a/drivers/media/usb/dvb-usb-v2/it913x.c
>> +++ b/drivers/media/usb/dvb-usb-v2/it913x.c
>> @@ -308,6 +308,7 @@ static struct i2c_algorithm it913x_i2c_algo = {
>>   };
>>
>>   /* Callbacks for DVB USB */
>> +#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
>
> Maybe you could use:
>
> #if IS_ENABLED(CONFIG_RC_CORE)
>
> Regards,
>
> Fabio Estevam

Thanks for the pointing that macro. I will sent new patch top of that 
serie which replaces all "defined(CONFIG_RC_CORE) || 
defined(CONFIG_RC_CORE_MODULE)" with "IS_ENABLED(CONFIG_RC_CORE)" what I 
added.

regards
Antti

-- 
http://palosaari.fi/
