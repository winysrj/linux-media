Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:55141 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3FRMXV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 08:23:21 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so1710011bkh.26
        for <linux-media@vger.kernel.org>; Tue, 18 Jun 2013 05:23:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371549806.4275.6.camel@pizza.hi.pengutronix.de>
References: <CAPgLHd9hFGfuQ2Esm-7C1YdSgWojDJRADwv8_m5DnJ6UAFJtpQ@mail.gmail.com>
	<1371549806.4275.6.camel@pizza.hi.pengutronix.de>
Date: Tue, 18 Jun 2013 20:23:19 +0800
Message-ID: <CAPgLHd-NoSghhz6TnsppzTK3nP-+jFpF2eQ94z113dsigjDxSA@mail.gmail.com>
Subject: Re: [PATCH -next] [media] coda: fix missing unlock on error in coda_stop_streaming()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@redhat.com, grant.likely@linaro.org,
	rob.herring@calxeda.com, javier.martin@vista-silicon.com,
	k.debski@samsung.com, hans.verkuil@cisco.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/18/2013 06:03 PM, Philipp Zabel wrote:
> Am Dienstag, den 18.06.2013, 13:00 +0800 schrieb Wei Yongjun:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Add the missing unlock before return from function coda_stop_streaming()
>> in the error handling case.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  drivers/media/platform/coda.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
>> index df4ada88..2c3cd17 100644
>> --- a/drivers/media/platform/coda.c
>> +++ b/drivers/media/platform/coda.c
>> @@ -1347,6 +1347,7 @@ static int coda_stop_streaming(struct vb2_queue *q)
>>  	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
>>  		v4l2_err(&dev->v4l2_dev,
>>  			 "CODA_COMMAND_SEQ_END failed\n");
>> +		mutex_unlock(&dev->coda_mutex);
>>  		return -ETIMEDOUT;
>>  	}
>>  	mutex_unlock(&dev->coda_mutex);
>>
>>
> Thanks! If you don't mind, I'll integrate this change into the "[media]
> coda: add CODA7541 decoding support" for v2.

No problem. Thanks.

Yongjun Wei

