Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab2GaCb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 22:31:57 -0400
Message-ID: <50174370.1020502@redhat.com>
Date: Mon, 30 Jul 2012 23:31:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Tim Gardner <tim.gardner@canonical.com>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] xc5000: Add MODULE_FIRMWARE statements
References: <1343222119-82246-1-git-send-email-tim.gardner@canonical.com> <CAGoCfiziwAz0q2D_qKX=1nrAKQybeX+Ho5eu_gsERhd7QtsaDQ@mail.gmail.com> <500FF930.8020900@iki.fi>
In-Reply-To: <500FF930.8020900@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-07-2012 10:48, Antti Palosaari escreveu:
> On 07/25/2012 04:24 PM, Devin Heitmueller wrote:
>> On Wed, Jul 25, 2012 at 9:15 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
>>> This will make modinfo more useful with regard
>>> to discovering necessary firmware files.
>>>
>>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>>> Cc: Michael Krufky <mkrufky@kernellabs.com>
>>> Cc: Eddi De Pieri <eddi@depieri.net>
>>> Cc: linux-media@vger.kernel.org
>>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>>> ---
>>>   drivers/media/common/tuners/xc5000.c |    8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
>>> index dcca42c..4d33f86 100644
>>> --- a/drivers/media/common/tuners/xc5000.c
>>> +++ b/drivers/media/common/tuners/xc5000.c
>>> @@ -210,13 +210,15 @@ struct xc5000_fw_cfg {
>>>          u16 size;
>>>   };
>>>
>>> +#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
>>>   static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
>>> -       .name = "dvb-fe-xc5000-1.6.114.fw",
>>> +       .name = XC5000A_FIRMWARE,
>>>          .size = 12401,
>>>   };
>>>
>>> +#define XC5000C_FIRMWARE "dvb-fe-xc5000c-41.024.5.fw"
>>>   static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
>>> -       .name = "dvb-fe-xc5000c-41.024.5.fw",
>>> +       .name = XC5000C_FIRMWARE,
>>>          .size = 16497,
>>>   };
>>>
>>> @@ -1253,3 +1255,5 @@ EXPORT_SYMBOL(xc5000_attach);
>>>   MODULE_AUTHOR("Steven Toth");
>>>   MODULE_DESCRIPTION("Xceive xc5000 silicon tuner driver");
>>>   MODULE_LICENSE("GPL");
>>> +MODULE_FIRMWARE(XC5000A_FIRMWARE);
>>> +MODULE_FIRMWARE(XC5000C_FIRMWARE);
>>> -- 
>>
>> Hi Tim,
>>
>> I'm just eyeballing the patch and I'm not familiar with this new
>> functionality, but where are the new macros you're specifying actually
>> defined?  You're swapping out the filename for XC5000A_FIRMWARE, but
>> where is the actual reference to "dvb-fe-xc5000-1.6.114.fw"?
>>
>> Also, Mauro, can I merge this into my tree first rather than you
>> pulling it direct?  I've got a whole patch series for xc5000 that I'm
>> slated to issue a PULL for this weekend, and I *really* don't want to
>> rebase the series for a four line change (which will definitely cause
>> a conflict).

Devin,

As you didn't send your pull request in time for 3.6, I'll add this one,
as otherwise it will miss the 3.6 bus. 

You don't need to rebase your pull request due to that anyway, as, if a
merge conflict happens, I'll fix it, as it should be trivial.

I'm fixing trivial merge conflicts like that all the time. Just today, I
fixed maybe dozens of similar ones.

The conflicts that I ask developers to rework are the ones where the complex
logic is modified by two different patches.

>>
>> Devin
> 
> Also this issue has been spoken earlier and nacked. It was 2009 when Ben Hutchings sends large patch serie adding MODULE_FIRMWARE for every Linux-Media driver. I am not sure if arguments are changed after that to allow it now.
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg11373.html

On Ben's patchset, firmwares were added to the bridge driver. That's wrong.

Adding it to the driver that actually uses the firmware looks OK on my eyes.

> regards
> Antti

Regards,
Mauro

