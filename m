Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0I3TQr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 15:16:47 -0400
Message-ID: <4CA4E21A.8090402@redhat.com>
Date: Thu, 30 Sep 2010 16:16:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] V4L/DVB: tda18271: Add debug message with frequency
 divisor
References: <cover.1285699057.git.mchehab@redhat.com>	<20100928154700.59362453@pedra> <AANLkTi=8xbFTz5edMjJRXGD7UD6j4jzyOJibgZomKCCB@mail.gmail.com>
In-Reply-To: <AANLkTi=8xbFTz5edMjJRXGD7UD6j4jzyOJibgZomKCCB@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-09-2010 16:03, Michael Krufky escreveu:
> On Tue, Sep 28, 2010 at 2:47 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
>> index 195b30e..7ba3ba3 100644
>> --- a/drivers/media/common/tuners/tda18271-common.c
>> +++ b/drivers/media/common/tuners/tda18271-common.c
>> @@ -549,6 +549,13 @@ int tda18271_calc_main_pll(struct dvb_frontend *fe, u32 freq)
>>        regs[R_MD1]   = 0x7f & (div >> 16);
>>        regs[R_MD2]   = 0xff & (div >> 8);
>>        regs[R_MD3]   = 0xff & div;
>> +
>> +       if (tda18271_debug & DBG_REG) {
>> +               tda_reg("MAIN_DIV_BYTE_1    = 0x%02x\n", 0xff & regs[R_MD1]);
>> +               tda_reg("MAIN_DIV_BYTE_2    = 0x%02x\n", 0xff & regs[R_MD2]);
>> +               tda_reg("MAIN_DIV_BYTE_3    = 0x%02x\n", 0xff & regs[R_MD3]);
>> +       }
>> +
>>  fail:
>>        return ret;
>>  }
> 
> 
> I would actually prefer NOT to merge this - it is redundant.  When
> DBG_REG is enabled, the driver will dump the contents of all
> registers, including MD1, MD2 and MD3.  With this patch applied, it
> would dump this data twice.  I do not believe this is useful at all.

Ok.

> 
> Regards,
> 
> Mike Krufky

