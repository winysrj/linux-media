Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58876 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2GYNso (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 09:48:44 -0400
Message-ID: <500FF930.8020900@iki.fi>
Date: Wed, 25 Jul 2012 16:48:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Tim Gardner <tim.gardner@canonical.com>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] xc5000: Add MODULE_FIRMWARE statements
References: <1343222119-82246-1-git-send-email-tim.gardner@canonical.com> <CAGoCfiziwAz0q2D_qKX=1nrAKQybeX+Ho5eu_gsERhd7QtsaDQ@mail.gmail.com>
In-Reply-To: <CAGoCfiziwAz0q2D_qKX=1nrAKQybeX+Ho5eu_gsERhd7QtsaDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2012 04:24 PM, Devin Heitmueller wrote:
> On Wed, Jul 25, 2012 at 9:15 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
>> This will make modinfo more useful with regard
>> to discovering necessary firmware files.
>>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: Michael Krufky <mkrufky@kernellabs.com>
>> Cc: Eddi De Pieri <eddi@depieri.net>
>> Cc: linux-media@vger.kernel.org
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> ---
>>   drivers/media/common/tuners/xc5000.c |    8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
>> index dcca42c..4d33f86 100644
>> --- a/drivers/media/common/tuners/xc5000.c
>> +++ b/drivers/media/common/tuners/xc5000.c
>> @@ -210,13 +210,15 @@ struct xc5000_fw_cfg {
>>          u16 size;
>>   };
>>
>> +#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
>>   static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
>> -       .name = "dvb-fe-xc5000-1.6.114.fw",
>> +       .name = XC5000A_FIRMWARE,
>>          .size = 12401,
>>   };
>>
>> +#define XC5000C_FIRMWARE "dvb-fe-xc5000c-41.024.5.fw"
>>   static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
>> -       .name = "dvb-fe-xc5000c-41.024.5.fw",
>> +       .name = XC5000C_FIRMWARE,
>>          .size = 16497,
>>   };
>>
>> @@ -1253,3 +1255,5 @@ EXPORT_SYMBOL(xc5000_attach);
>>   MODULE_AUTHOR("Steven Toth");
>>   MODULE_DESCRIPTION("Xceive xc5000 silicon tuner driver");
>>   MODULE_LICENSE("GPL");
>> +MODULE_FIRMWARE(XC5000A_FIRMWARE);
>> +MODULE_FIRMWARE(XC5000C_FIRMWARE);
>> --
>
> Hi Tim,
>
> I'm just eyeballing the patch and I'm not familiar with this new
> functionality, but where are the new macros you're specifying actually
> defined?  You're swapping out the filename for XC5000A_FIRMWARE, but
> where is the actual reference to "dvb-fe-xc5000-1.6.114.fw"?
>
> Also, Mauro, can I merge this into my tree first rather than you
> pulling it direct?  I've got a whole patch series for xc5000 that I'm
> slated to issue a PULL for this weekend, and I *really* don't want to
> rebase the series for a four line change (which will definitely cause
> a conflict).
>
> Devin

Also this issue has been spoken earlier and nacked. It was 2009 when Ben 
Hutchings sends large patch serie adding MODULE_FIRMWARE for every 
Linux-Media driver. I am not sure if arguments are changed after that to 
allow it now.
http://www.mail-archive.com/linux-media@vger.kernel.org/msg11373.html

regards
Antti

-- 
http://palosaari.fi/
