Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41630 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932102AbdC1JlZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 05:41:25 -0400
Subject: Re: [PATCH 2/8] [media] staging: st-cec: Use cec_get_drvdata()
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
 <4630ddce3d8ca27e4f6addeda17e11b08f345a1a.1490373499.git.joabreu@synopsys.com>
 <CA+M3ks4a=tg3SuE-OiotB_w7ijhvOiBSVfE32kVAx_WCOoMB1g@mail.gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        hans.verkuil@cisco.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f2f395bf-e562-3c8a-a3f9-458b4e0e62a1@xs4all.nl>
Date: Tue, 28 Mar 2017 11:41:14 +0200
MIME-Version: 1.0
In-Reply-To: <CA+M3ks4a=tg3SuE-OiotB_w7ijhvOiBSVfE32kVAx_WCOoMB1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/03/17 11:17, Benjamin Gaignard wrote:
> 2017-03-24 17:47 GMT+01:00 Jose Abreu <Jose.Abreu@synopsys.com>:
>> Use helper function to get driver private data from CEC
>> adapter.
> 
> That looks good for me but does it make sense to merge that now ? or
> should we wait until
> cec drivers as move out of staging ?
> Hans what is your view on that ?

Why not merge this? It makes no sense not to update staging drivers.
Just because they are in staging doesn't mean you can't improve them :-)

Regards,

	Hans

> 
>>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>> ---
>>  drivers/staging/media/st-cec/stih-cec.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/media/st-cec/stih-cec.c
>> index 3c25638..521206d 100644
>> --- a/drivers/staging/media/st-cec/stih-cec.c
>> +++ b/drivers/staging/media/st-cec/stih-cec.c
>> @@ -133,7 +133,7 @@ struct stih_cec {
>>
>>  static int stih_cec_adap_enable(struct cec_adapter *adap, bool enable)
>>  {
>> -       struct stih_cec *cec = adap->priv;
>> +       struct stih_cec *cec = cec_get_drvdata(adap);
>>
>>         if (enable) {
>>                 /* The doc says (input TCLK_PERIOD * CEC_CLK_DIV) = 0.1ms */
>> @@ -189,7 +189,7 @@ static int stih_cec_adap_enable(struct cec_adapter *adap, bool enable)
>>
>>  static int stih_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
>>  {
>> -       struct stih_cec *cec = adap->priv;
>> +       struct stih_cec *cec = cec_get_drvdata(adap);
>>         u32 reg = readl(cec->regs + CEC_ADDR_TABLE);
>>
>>         reg |= 1 << logical_addr;
>> @@ -205,7 +205,7 @@ static int stih_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
>>  static int stih_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>>                                   u32 signal_free_time, struct cec_msg *msg)
>>  {
>> -       struct stih_cec *cec = adap->priv;
>> +       struct stih_cec *cec = cec_get_drvdata(adap);
>>         int i;
>>
>>         /* Copy message into registers */
>> --
>> 1.9.1
>>
>>
