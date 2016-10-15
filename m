Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61340 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbcJORA3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 13:00:29 -0400
Subject: Re: [PATCH 04/18] [media] RedRat3: One function call less in
 redrat3_transmit_ir() after error detection
To: Sean Young <sean@mess.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
 <7878868c-bc54-5577-b808-ed096bbf3759@users.sourceforge.net>
 <20161015133339.GB3393@gofer.mess.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5f471774-ec63-c404-6ebb-2b20c0f2a20e@users.sourceforge.net>
Date: Sat, 15 Oct 2016 19:00:14 +0200
MIME-Version: 1.0
In-Reply-To: <20161015133339.GB3393@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
>> index 7ae2ced..71e901d 100644
>> --- a/drivers/media/rc/redrat3.c
>> +++ b/drivers/media/rc/redrat3.c
>> @@ -723,10 +723,10 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>>  {
>>  	struct redrat3_dev *rr3 = rcdev->priv;
>>  	struct device *dev = rr3->dev;
>> -	struct redrat3_irdata *irdata = NULL;
>> +	struct redrat3_irdata *irdata;
>>  	int ret, ret_len;
>>  	int lencheck, cur_sample_len, pipe;
>> -	int *sample_lens = NULL;
>> +	int *sample_lens;
>>  	u8 curlencheck;
>>  	unsigned i, sendbuf_len;
>>  
>> @@ -747,7 +747,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>>  	irdata = kzalloc(sizeof(*irdata), GFP_KERNEL);
>>  	if (!irdata) {
>>  		ret = -ENOMEM;
>> -		goto out;
>> +		goto free_sample;
>>  	}
>>  
>>  	/* rr3 will disable rc detector on transmit */
>> @@ -776,7 +776,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>>  				curlencheck++;
>>  			} else {
>>  				ret = -EINVAL;
>> -				goto out;
>> +				goto reset_member;
>>  			}
>>  		}
>>  		irdata->sigdata[i] = lencheck;
>> @@ -811,14 +811,12 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
>>  		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);
>>  	else
>>  		ret = count;
>> -
>> -out:
>> -	kfree(irdata);
>> -	kfree(sample_lens);
>> -
>> +reset_member:
>>  	rr3->transmitting = false;
>>  	/* rr3 re-enables rc detector because it was enabled before */
>> -
>> +	kfree(irdata);
>> +free_sample:
>> +	kfree(sample_lens);
> 
> In this error path, rr3->transmitting is not set to false

Can it be that this reset is not needed because it should have still got this value already
in the software refactoring I proposed here?


> so now the driver will never allow you transmit again.

I have got an other impression.


> Also this patch does not apply against latest.

Do you want that I rebase my update suggestion for this software module on a published commit
that is more recent than 2016-09-22 (d6ae162bd13998a6511e5efbc7c19ab542ba1555 for example)?

Regards,
Markus
