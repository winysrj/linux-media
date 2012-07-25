Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4105 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2GYOFE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 10:05:04 -0400
Message-ID: <500FF804.9050308@canonical.com>
Date: Wed, 25 Jul 2012 07:43:32 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] xc5000: Add MODULE_FIRMWARE statements
References: <1343222119-82246-1-git-send-email-tim.gardner@canonical.com> <CAGoCfiziwAz0q2D_qKX=1nrAKQybeX+Ho5eu_gsERhd7QtsaDQ@mail.gmail.com>
In-Reply-To: <CAGoCfiziwAz0q2D_qKX=1nrAKQybeX+Ho5eu_gsERhd7QtsaDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2012 07:24 AM, Devin Heitmueller wrote:
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
>>  drivers/media/common/tuners/xc5000.c |    8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
>> index dcca42c..4d33f86 100644
>> --- a/drivers/media/common/tuners/xc5000.c
>> +++ b/drivers/media/common/tuners/xc5000.c
>> @@ -210,13 +210,15 @@ struct xc5000_fw_cfg {
>>         u16 size;
>>  };
>>
>> +#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
>>  static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
>> -       .name = "dvb-fe-xc5000-1.6.114.fw",
>> +       .name = XC5000A_FIRMWARE,
>>         .size = 12401,
>>  };
>>
>> +#define XC5000C_FIRMWARE "dvb-fe-xc5000c-41.024.5.fw"
>>  static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
>> -       .name = "dvb-fe-xc5000c-41.024.5.fw",
>> +       .name = XC5000C_FIRMWARE,
>>         .size = 16497,
>>  };
>>
>> @@ -1253,3 +1255,5 @@ EXPORT_SYMBOL(xc5000_attach);
>>  MODULE_AUTHOR("Steven Toth");
>>  MODULE_DESCRIPTION("Xceive xc5000 silicon tuner driver");
>>  MODULE_LICENSE("GPL");
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

Devin - Please have a closer look. XC5000A_FIRMWARE and XC5000C_FIRMWARE
are defined in the patch.

MODULE_FIRMWARE() is defined in linux/module.h. It creates a firmware
section such that modinfo can print the names of the firmware files that
may possibly be in use by this module.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
